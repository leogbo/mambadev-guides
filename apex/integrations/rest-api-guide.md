# 🌐 Guia Oficial de APIs REST em Apex (v2025) – Mentalidade Mamba

📎 **Shortlink oficial:** [bit.ly/Guia_APIs_REST](https://bit.ly/Guia_APIs_REST)

> “Toda API carrega a reputação da sua plataforma. Ela deve ser clara, previsível e rastreável.”  
> — Leo Mamba Garcia 🧠🔥

Este guia define os **padrões obrigatórios** para criar, testar e versionar APIs REST internas na sua org Salesforce.

---

## 📚 Referências complementares obrigatórias

- 📘 [Guia Master de Arquitetura](https://bit.ly/GuiaApexMamba)
- 🔍 [Guia de Revisão Apex](https://bit.ly/GuiaApexRevisao)
- 🪵 [Guia de Logging](https://bit.ly/GuiaLoggerApex)
- 🧪 [Guia de Testes](https://bit.ly/GuiaTestsApex)
- 🧱 [Guia de TestData Setup](https://bit.ly/TestDataSetup)
- ✅ [Guia de Equivalência Funcional](https://bit.ly/ConfirmacaoApex)

---

## ✅ Estrutura de uma classe REST Apex
```apex
@RestResource(urlMapping='/lead/v1')
global with sharing class LeadRestController {

    @HttpPost
    global static void createLead() {
        try {
            Map<String, Object> payload = RestServiceHelper.getRequestBody();
            Lead newLead = new Lead();
            newLead = applyFields(payload, newLead); // método interno da própria classe
            insert newLead;
            RestServiceHelper.sendResponse(201, 'Lead criado com sucesso', newLead);
        } catch (Exception ex) {
            RestServiceHelper.internalServerError('Erro ao criar Lead', ex);
        }
    }

    @TestVisbile private static Lead applyFields(Map<String, Object> payload, Lead newLead) {
        // método interno da própria classe em funcao do payload recebido ....
        return newLead; // newLead com carga adicional do payload recebido.
    }
}
```

---

## 🧩 O que é `RestServiceHelper`?

Classe utilitária padrão com os seguintes propósitos:

- ✅ Valida token de autenticação
- ✅ Faz parse seguro do corpo da requisição
- ✅ Gera respostas com status HTTP + mensagem padronizada
- ✅ Gera logs estruturados via `Logger`
- ✅ Aplica JSON nos campos do objeto com `mapFieldsFromRequest(...)`

> 🧠 Todas APIs REST devem depender desse helper. Nunca crie tratamento de request/response manual.

---

## ✅ Formato padrão de resposta REST
```json
{
  "message": "Lead criado com sucesso",
  "details": {
    "Id": "00Q...",
    "Name": "Nome Teste"
  }
}
```

---

## ✅ Métodos de resposta prontos

| Método                          | Status | Uso                                                   |
|----------------------------------|--------|--------------------------------------------------------|
| `ok(data)`                       | 200    | Sucesso com dados                                      |
| `created(msg, data)`            | 201    | Recurso criado com sucesso                            |
| `badRequest(msg)`               | 400    | Erro de validação de entrada                          |
| `unauthorized(msg)`             | 401    | Token ausente ou inválido                             |
| `notFound(msg)`                 | 404    | Recurso não encontrado                                 |
| `internalServerError(msg, ex)`  | 500    | Erro inesperado com log                                |

---

## ❌ Erros comuns a evitar

| Erro                         | Correto                                                   |
|------------------------------|------------------------------------------------------------|
| `JSON.deserializeUntyped()` | ❌ Use `RestServiceHelper.getRequestBody()`                |
| `throw new Exception(...)`  | ❌ Use `RestServiceHelper.internalServerError(...)`        |
| `return 'ok';`              | ❌ Sempre use DTO completo com statusCode                  |
| `System.debug(...)`         | ❌ Proibido. Use `Logger` estruturado                     |

---

## 🧪 Testes obrigatórios para APIs REST

- ✅ `@IsTest` com `@TestSetup` que cria registros reais
- ✅ `LoggerMock` aplicado:
```apex
Logger.overrideLogger(new LoggerMock());
```
- ✅ Testes obrigatórios:
  - Happy path (200 ou 201)
  - Bad request (400)
  - Token ausente ou inválido (401)
  - Recurso não encontrado (404)
  - Erro interno (500) com rastreabilidade

---

## 🧪 Exemplo – Teste para erro 400
```apex
@IsTest
static void test_invalid_payload_returns_400() {
    RestContext.request = new RestRequest();
    RestContext.response = new RestResponse();
    RestContext.request.httpMethod = 'POST';
    RestContext.request.requestBody = Blob.valueOf('{ "email": "" }');
    RestContext.request.addHeader('Access_token', 'Bearer INVALID');

    Test.startTest();
    MinhaClasseREST.receivePost();
    Test.stopTest();

    System.assertEquals(400, RestContext.response.statusCode);
    System.assert(RestContext.response.responseBody.toString().contains('email'));
}
```

---

## ✅ Checklist Mamba para APIs REST

| Item                                                        | Verificado? |
|-------------------------------------------------------------|-------------|
| Classe REST com `@RestResource`                            | [ ]         |
| Uso exclusivo de `RestServiceHelper`                       | [ ]         |
| Logs estruturados com `Logger`                             | [ ]         |
| JSON serializado com `serializePretty()`                   | [ ]         |
| `FlowExecutionLog__c` presente se for crítico              | [ ]         |
| `LoggerMock` ativado em testes                             | [ ]         |
| Testes REST validam `response.statusCode`                  | [ ]         |
| Testes lógicos capturam `BadRequestException` corretamente | [ ]         |
| Nenhum `System.debug(...)` no código produtivo             | [ ]         |

---

🧠🧱🧪 #APIMamba #RESTSemSurpresas #ErroComStatus #NadaEscapa #TestaOuVoltaPraBase

🧠🖤  
**Leo Mamba Garcia**  

# FlowExecutionLog__c - Estrutura e Finalidade de Campos

> Este documento define a estrutura atual do objeto `FlowExecutionLog__c`, com finalidade de logging persistente para:
> - Rastreabilidade de execução de flows, Apex, REST e callouts
> - Armazenamento de entradas/saídas (JSON)
> - Diagnóstico por ambiente, trigger type e log level

---

## Campos principais

| Campo API Name             | Label                    | Tipo              | Descrição                                                                 |
|---------------------------|--------------------------|-------------------|---------------------------------------------------------------------------|
| `Class__c`                | Class                    | string (255)      | Nome da classe responsável pelo log                                       |
| `Origin_Method__c`        | Origin Method            | string (255)      | Método de origem do log                                                   |
| `Method__c`               | Method                   | string (255)      | (redundante com Origin_Method__c - considerar unificar)                   |
| `Log_Level__c`            | Log Level                | string (255)      | Nível do log (DEBUG, INFO, WARNING, ERROR)                                |
| `Log_Category__c`         | Log Category             | picklist (255)    | Agrupamento lógico (ex: Apex, Validation, Flow, Callout)                  |
| `Status__c`               | Status                   | picklist (255)    | Resultado geral (Completed, Failed, Cancelled, etc.)                      |
| `Trigger_Type__c`         | Trigger Type             | picklist (255)    | Tipo de invocação: REST, Batch, Queueable, Trigger, etc                   |
| `Trigger_Record_ID__c`    | Trigger Record ID        | string (255)      | ID do registro relacionado (Account, UC, Lead, etc.)                      |
| `Execution_Timestamp__c`  | Execution Timestamp      | datetime          | Timestamp da execução                                                     |
| `Duration__c`             | Duration                 | double (14,4)     | Duração em segundos                                                       |
| `Error_Message__c`        | Error Message            | textarea (32k)    | Mensagem principal de erro                                                |
| `Stack_Trace__c`          | Stack Trace              | textarea (32k)    | Stack trace completo de exceção                                           |
| `Serialized_Data__c`      | Serialized Data          | textarea (32k)    | JSON de entrada, payload ou contexto relevante                            |
| `Debug_Information__c`    | Debug Information        | textarea (32k)    | JSON de resposta, saída ou trace complementar                             |
| `ValidationErros__c`      | Validation Errors        | string (255)      | Lista de erros de validação internos                                      |
| `Flow_Name__c`            | Flow Name                | string (255)      | Nome do flow (quando aplicável)                                           |
| `Flow_Outcome__c`         | Flow Outcome             | string (255)      | Resultado esperado ou calculado                                           |
| `Execution_ID__c`         | Execution ID             | string (255)      | ID de execução externo (flow interview, external call)                    |
| `Execution_Order__c`      | Execution Order          | double (18,0)     | Sequência (para execuções paralelas ou múltiplas)                         |
| `Related_Flow_Version__c` | Related Flow Version     | double (18,0)     | Versão do flow executado                                                  |
| `Step_Name__c`            | Step Name                | string (255)      | Etapa do flow declarativo                                                 |
| `Environment__c`          | Environment              | picklist (255)    | Ambiente de execução (Production, Sandbox, etc.)                          |
| `FlowExecutionLink__c`    | Flow Execution Link      | string (1300, html)| Link direto para execução do flow                                         |
| `User_ID__c`              | User ID                  | User lookup        | Usuário que iniciou a execução                                            |
| `Integration_Ref__c`      | Integration Ref          | string (255)      | ID da transação externa, externalId, ou trace ref                         |
| `Integration_Direction__c`| Integration Direction    | picklist (255)    | Direção da integração (Inbound, Outbound, Internal)                       |
| `Is_Critical__c`          | Is Critical              | boolean            | Flag para identificar logs sensíveis mesmo sem erro                       |

---

## Considerações adicionais

- Campos `Method__c` e `Origin_Method__c` podem ser unificados
- `Execution_ID__c` + `Integration_Ref__c` permitem rastrear chamadas entre sistemas
- `Integration_Direction__c` será essencial para dashboards de integrações externas
- `Is_Critical__c` permite priorização no suporte e monitoramento por CDI
- Todos os JSONs devem ser serializados com `JSON.serializePretty`

---

> Estrutura pronta para suportar rastreabilidade empresarial de logs e integrações com auditoria e painéis avançados.


**classe .cls**

/**
 * Classe `RestServiceHelper` fornece suporte para a implementação de endpoints REST, incluindo 
 * validação de tokens de acesso, mapeamento de campos de requisições, e envio de respostas padronizadas.
 * 
 * ### Métodos:
 * - **unauthorized**: Retorna resposta HTTP 401 com mensagem de erro.
 * - **badRequest**: Retorna resposta HTTP 400 com mensagem de erro.
 * - **notFound**: Retorna resposta HTTP 404 com mensagem de erro.
 * - **notAcceptable**: Retorna resposta HTTP 406 com mensagem de erro.
 * - **internalServerError**: Retorna resposta HTTP 500 com mensagem de erro.
 * - **accepted**: Retorna resposta HTTP 202 com mensagem.
 * - **sendResponse**: Envia resposta HTTP com status, mensagem e detalhes opcionais.
 * - **validateAccessToken**: Valida o token de acesso nas requisições.
 * - **getRequestBody**: Obtém o corpo da requisição, com validação de dados.
 * - **mapFieldsFromRequest**: Mapeia os campos do corpo da requisição para o SObject.
 *
 * @since 2025-03-29
 * @author Leo Mamba Garcia
 */
public abstract class RestServiceHelper {

    // ============= METADADOS E SUPORTE A LOGGING OPCIONAL =============    
    @TestVisible private static final String environment = Label.ENVIRONMENT;
    @TestVisible private static final String log_level = Label.LOG_LEVEL;
    private static final String className = 'RestServiceHelper';
    private static final String logCategory = 'REST';

    // ============= SUPORTE A TESTES =============    
    @TestVisible private static String lastExceptionMessage;

    // ============= EXCEÇÕES PERSONALIZADAS =============    
    public class AccessException extends Exception {}
    public class BadRequestException extends Exception {}
    public class NotFoundException extends Exception {}
    public class ConflictException extends Exception {}

    // ============= MÉTODOS DE RESPOSTA SIMPLIFICADOS =============    
    @TestVisible
    public static void unauthorized(String message) {
        sendResponse(401, message);
    }

    @TestVisible
    public static void unauthorized(String message, Object details) {
        sendResponse(401, message, details);
    }

    @TestVisible
    public static void badRequest(String message) {
        sendResponse(400, message);
    }

    @TestVisible
    public static void badRequest(String message, Object details) {
        sendResponse(400, message, details);
    }

    @TestVisible
    public static void notFound(String message) {
        sendResponse(404, message);
    }

    @TestVisible
    public static void notFound(String message, Object details) {
        sendResponse(404, message, details);
    }

    @TestVisible
    public static void notAcceptable(String message) {
        sendResponse(406, message);
    }

    @TestVisible
    public static void notAcceptable(String message, Object details) {
        sendResponse(406, message, details);
    }

    @TestVisible
    public static void internalServerError(String message) {
        sendResponse(500, message);
    }

    @TestVisible
    public static void internalServerError(String message, Object details) {
        sendResponse(500, message, details);
    }

    @TestVisible
    public static void accepted(String message) {
        sendResponse(202, message);
    }

    @TestVisible
    public static void accepted(String message, Object details) {
        sendResponse(202, message, details);
    }

    // ============= MÉTODOS DE RESPOSTA DETALHADOS =============    
    @TestVisible
    public static void sendResponse(Integer statusCode, String message) {
        sendResponse(statusCode, message, null);
    }

    @TestVisible
    public static void sendResponse(Integer statusCode, String message, Object details) {
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.statusCode = statusCode;

        Map<String, Object> response = new Map<String, Object> {
            // 'status' => (statusCode >= 200 && statusCode < 300) ? 'success' : 'error', // Aguardando OK do time de API para incluir essa chave padronizada
            'message' => message
        };

        if (details != null) {
            response.put('details', details);
        }

        RestContext.response.responseBody = Blob.valueOf(JSON.serializePretty(response));

        // Log da resposta
        logResponse(statusCode, message, response);
    }

    @TestVisible
    private static void logResponse(Integer statusCode, String message, Map<String, Object> response) {
        Logger logger = new Logger()
            .setClass(className)
            .setMethod('sendResponse')
            .setCategory(logCategory);
        logger.info('Resposta enviada: ' + message, JSON.serializePretty(response));
    }

    // ============= MÉTODOS DE VALIDAÇÃO =============    
    @TestVisible
    public static void validateAccessToken(String headerName, String expectedTokenPrefix) {
        String accessToken = RestContext.request.headers.get(headerName);
        if (accessToken == null || !accessToken.startsWith(expectedTokenPrefix)) {
            throw new AccessException('Token de acesso inválido ou ausente.');
        }
    }

    @TestVisible
    public static Map<String, Object> getRequestBody() {
        RestRequest req = RestContext.request;
        if (req.requestBody == null || String.isBlank(req.requestBody.toString())) {
            lastExceptionMessage = 'O corpo da requisição está vazio.';
            throw new BadRequestException(lastExceptionMessage);
        }
        try {
            return (Map<String, Object>) JSON.deserializeUntyped(req.requestBody.toString());
        } catch (Exception e) {
            throw new BadRequestException('Erro ao processar o corpo da requisição.');
        }
    }

    // ============= UTILITÁRIO DE MAPEAMENTO SOBJECT =============    
    @TestVisible
    public static void mapFieldsFromRequest(Map<String, Object> requestBody, SObject record, String objectName) {
        Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();
        Schema.SObjectType objectType = globalDescribe.get(objectName.toLowerCase());

        if (objectType == null) {
            throw new IllegalArgumentException('Objeto inválido: ' + objectName);
        }

        Map<String, Schema.SObjectField> fieldMap = objectType.getDescribe().fields.getMap();

        for (String fieldName : requestBody.keySet()) {
            if (fieldMap.containsKey(fieldName)) {
                Object fieldValue = requestBody.get(fieldName);
                if (fieldValue != null) {
                    record.put(fieldName, fieldValue);
                }
            } else {
                // Utilizando Logger para rastrear campos ignorados
                logIgnoredField(fieldName, objectName);
            }
        }
    }

    @TestVisible
    private static void logIgnoredField(String fieldName, String objectName) {
        Logger logger = new Logger()
            .setClass(className)
            .setMethod('mapFieldsFromRequest')
            .setCategory(logCategory);
        logger.warn('Campo ignorado: ' + fieldName + ' (não encontrado no objeto ' + objectName + ')', null);
    }
}
_Estilo não é vaidade. É previsibilidade em APIs sob pressão._  
#APIMamba #RESTSemSurpresas #ErroComStatus #NadaEscapa #TestaOuVoltaPraBase 🚀

