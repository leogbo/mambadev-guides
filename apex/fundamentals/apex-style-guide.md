# 🧱 Guia Oficial Mamba Apex - Revisado (2025)

> **"Excelência não é uma opção. É o único caminho." – Mamba Mentality**

## 🎯 Missão

Promover **rastreabilidade absoluta**, **qualidade intransigente**, e **clareza funcional** no desenvolvimento em Apex, com foco em:

- Arquitetura padronizada
- Testes com rastreabilidade e asserts sem margem
- Logs estruturados para diagnóstico proativo
- Separação clara entre código de produção, teste e mocking

---

## 🛠️ Fundamentos Inquebráveis

### ✅ 1. **Classe com @TestVisible**
Cada método lógico deve:
- Ser marcado com `@TestVisible`
- Ser **coberto isoladamente** por testes com asserts explícitos

```apex
@TestVisible private static void executarCalculo() {
    // ...
}
```

---

### ✅ 2. **Logs com `Logger` simplificado**
- Evite `System.debug()`
- Utilize o `Logger` padrão

```apex
new Logger()
  .setClass('MinhaClasse')
  .setMethod('meuMetodo')
  .error('Erro ao calcular proposta', e, JSON.serializePretty(proposta));
```

Use `LoggerMock` em testes para rastrear chamadas sem afetar persistência.

---

### ✅ 3. **Respostas REST com `RestServiceHelper`**

Centralize tudo com `RestServiceHelper`:

```apex
RestServiceHelper.badRequest('Campo obrigatório ausente.');
RestServiceHelper.sendResponse(200, 'Sucesso', retorno);
```

Ele já adiciona:
- Status code
- Content-Type
- Corpo com:
```json
{
  "status": "error",
  "message": "Token de acesso inválido",
  "details": null
}
```

---

### ✅ 4. **Uso de `TestHelper` para dados de teste**

Crie IDs falsos e seguros:
```apex
TestHelper.fakeIdForSafe(Proposta__c.SObjectType);
```

Crie dados dinâmicos para e-mail, telefone, CNPJ, etc.:
```apex
TestHelper.randomEmail();
TestHelper.fakePhone();
```

---

## 🧪 Testes de Alta Qualidade

### 🔒 Rastreabilidade
- Não valide logs em teste
- Utilize `LoggerMock` para capturar chamadas

### 🔁 Setup padrão
```apex
@TestSetup
static void setup() {
    TestDataSetup.setupCompleteEnvironment();
}
```

### 🧠 Cada assert importa
```apex
System.assertEquals('update_uc', res.get('action'));
System.assertEquals(recordId, res.get('record_id'));
```

---

## 📌 Comparações e Confirmações

Antes e Depois da Refatoração:
- [ComparacaoApex](https://bit.ly/ComparacaoApex)

Confirmação Funcional:
- [ConfirmacaoApex](https://bit.ly/ConfirmacaoApex)

---

## 🚫 Antipadrões Eliminados

| Antipadrão           | Correto                           |
|----------------------|------------------------------------|
| `System.debug()`     | `Logger().info()/error()`          |
| Logs em teste        | `LoggerMock` para rastreamento     |
| Ifs por tipo de SObject | Prefixo de ID (`recordId.startsWith(...)`) |

---

## 🚀 Finalidade do Guia

Este guia existe para garantir que seu código seja:
- 🔐 Seguro
- 🧠 Claro
- 🧪 Testável
- 🧱 Rastreável
- 🐍 Mamba.

Nada menos que isso.

> **"A única falha que você pode ter é a falta de vontade de ser excelente."**

