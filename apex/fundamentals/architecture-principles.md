<p align="center">
  <img src="https://raw.githubusercontent.com/leogbo/mambadev-guides/main/static/img/github_banner_mambadev.png" alt="MambaDev Banner" width="100%" />
</p>

> 🧱 @status:core | This document defines official MambaDev coding fundamentals.  
> Changes must be versioned and approved by architecture leads.  
> Applied guides (e.g. `/apex/`) may evolve beyond this for future-proofing.

# 🧱 Mamba Modular Architecture para Apex

> "Modularize para testar. Separe para manter. Minimize para evoluir."  
> — Mentalidade Mamba

---

## 🧠 Princípios Fundamentais

| Princípio                  | Aplicação concreta em Apex                                  |
|----------------------------|--------------------------------------------------------------|
| SRP – Single Responsibility Principle | Cada método deve fazer **uma coisa só**, muito bem |
| DDD – Domínio explícito    | Separar controller, lógica, filtros e serviços auxiliares    |
| Test-Driven Thinking       | Métodos recebem/pronunciam **valores primitivos**           |
| Rastreabilidade total      | Métodos sempre têm `className`, `logLevel`, `triggerType`   |
| Testabilidade absoluta     | **100% de lógica pode ser testada sem callout ou SOQL**     |

---

## 🔧 Estrutura ideal de classe Apex

```apex
public class ClasseCentral {

    @TestVisible private static final String className = 'ClasseCentral';
    @TestVisible private static final String logLevel = Label.LOG_LEVEL;
    @TestVisible private static IEmailService emailService = new DefaultEmailService();

    // 🔹 1. Método público ou agendador
    public static void executarProcesso(Id registroId) {
        try {
            SObject registro = getRegistroPorId(registroId); // delega
            validarRegistro(registro);                       // valida
            String payload = construirPayload(registro);     // transforma
            HttpResponse resposta = executarCallout(payload); // integra
            processarResposta(resposta);                     // trata retorno
            registrarLogSucesso(registroId);                 // loga
        } catch (Exception e) {
            registrarErro(e, registroId);
            throw new CustomException('Falha no processo: ' + e.getMessage());
        }
    }

    // 🔹 2. Separar cada passo como método testável e primitivo
    @TestVisible
    private static SObject getRegistroPorId(Id id) {
        return [SELECT Id, Campo__c FROM Objeto__c WHERE Id = :id LIMIT 1];
    }

    @TestVisible
    private static void validarRegistro(SObject registro) {
        if (registro == null) throw new CustomException('Registro não encontrado');
    }

    @TestVisible
    private static String construirPayload(SObject registro) {
        Map<String, Object> mapPayload = new Map<String, Object>{
            'campo' => registro.get('Campo__c')
        };
        return JSON.serialize(mapPayload);
    }

    @TestVisible
    private static HttpResponse executarCallout(String payload) {
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint('https://api.exemplo.com/processar');
        req.setHeader('Content-Type', 'application/json');
        req.setBody(payload);

        Http http = new Http();
        HttpResponse res = http.send(req);
        if (res.getStatusCode() != 200) throw new CustomException('Erro HTTP: ' + res.getBody());
        return res;
    }

    @TestVisible
    private static void processarResposta(HttpResponse res) {
        // parse, salvar, atualizar campos etc.
    }

    @TestVisible
    private static void registrarLogSucesso(Id id) {
        LoggerContext.getLogger().logSuccess(className, 'Sucesso', id);
    }

    @TestVisible
    private static void registrarErro(Exception e, Id id) {
        LoggerContext.getLogger().logError(className, e.getMessage(), id);
    }
}
```

---

## ✅ Características dessa arquitetura

| Pilar                            | Como se aplica                                          |
|----------------------------------|----------------------------------------------------------|
| 🔹 Cada método faz 1 coisa       | Isolável em teste sem mock desnecessário                |
| 🔒 Métodos `@TestVisible`        | Garantem testabilidade sem expor via API externa        |
| 🔧 Inputs e outputs primitivos   | Strings, Maps, Blobs, Integers — nunca SObject cru      |
| 📦 Organização lógica            | Delegação clara por responsabilidade                    |
| 🧪 Mock simplificado             | Pode usar `Test.setMock()` com foco específico          |
| 🧱 Rastreabilidade completa      | Toda exceção, erro ou passo pode ser logado com contexto|

---

## 🧪 Padrão de teste por método

```apex
@isTest
static void testConstruirPayload() {
    SObject registro = new Objeto__c(Campo__c = 'valor');
    String json = ClasseCentral.construirPayload(registro);
    System.assert(json.contains('valor'), 'JSON deve conter o valor do campo');
}
```

---

## 📦 Onde aplicar este padrão?

| Cenário                      | Adotar padrão? |
|-----------------------------|----------------|
| Controller REST             | ✅              |
| Schedulable                 | ✅              |
| Queueable                   | ✅              |
| Trigger Handler             | ✅              |
| Batch                       | ✅              |
| Test Class Helpers          | ✅              |

---

## 📌 Regra Mamba Final:

> Toda lógica com 2 ou mais responsabilidades **deve ser modularizada** em métodos privados `@TestVisible`, com entradas e saídas claras e testáveis.

---

Se quiser, posso aplicar essa estrutura agora em uma classe da sua org.

Só dizer qual.  
#MambaArquiteturaTestável 🧠🔥

