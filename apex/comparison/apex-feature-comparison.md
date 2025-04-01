<p align="center">
  <img src="https://raw.githubusercontent.com/leogbo/mambadev-guides/main/static/img/github_banner_mambadev.png" alt="MambaDev Banner" width="100%" />
</p>

# 🔁 Guia de Comparações Apex – v2025 (Mentalidade Mamba)

📎 **Shortlink oficial:** [bit.ly/ComparacaoApex](https://bit.ly/ComparacaoApex)

> “Nenhuma refatoração é legítima sem comparação explícita, revisão formal e equivalência comprovada.” – Mentalidade Mamba 🧠🔥

Este guia define como documentar, revisar e validar refatorações em Apex com segurança, clareza e rastreabilidade.

---

## 📚 Guias obrigatórios relacionados

- 📘 [Guia Master de Arquitetura](https://bit.ly/GuiaApexMamba)
- 🔍 [Guia de Revisão](https://bit.ly/GuiaApexRevisao)
- 🧪 [Guia de Testes](https://bit.ly/GuiaTestsApex)
- ✅ [Guia de Equivalência Funcional](https://bit.ly/ConfirmacaoApex)

---

## ✅ O que deve ser comparado

🧠 Toda refatoração deve manter compatibilidade com código legado funcional. Mamba não quebra, Mamba evolui com responsabilidade.

Sempre que possível:
- Mantenha o nome original do método
- Adicione sobrecargas (novas assinaturas)
- Use parâmetros opcionais ou helpers para simplificar sem remover comportamento anterior

- Refatorações de qualquer método público ou `@TestVisible`
- Alterações de estrutura interna
- Mudança de fallback (ex: `null` → `Optional`, `LIMIT 1` → `RecordHelper`)
- Substituições de bloco de lógica por helper externo
- Renomeações de variáveis visíveis (exceto `private` sem impacto externo)
- Conversão de blocos `System.debug()` para `Logger.info()` ou `Logger.error()`

---

## ✅ Estrutura mínima de uma comparação

### ❌ Antes
```apex
Account acc = [SELECT Id, Name FROM Account WHERE Id = :id LIMIT 1];
```

### ✅ Depois
```apex
Account acc = (Account) RecordHelper.getById(Account.SObjectType, id, 'Id, Name');
```

> Toda comparação deve estar em comentário, PR, ou markdown dentro do branch.

---

## 📝 Template sugerido para Pull Requests

```markdown
### 🔄 Refatoração proposta

- Refatorado método `buscarConta()` para usar `RecordHelper.getById(...)`
- Adicionado fallback para `null`
- `@TestVisible` mantido para cobertura

### ✅ Antes
```apex
Account acc = [SELECT Id FROM Account WHERE Id = :id LIMIT 1];
```

### ✅ Depois
```apex
Account acc = (Account) RecordHelper.getById(Account.SObjectType, id, 'Id');
```

### 🧪 Testes
- Testes atualizados com `@TestSetup` e cobertura específica
- Adicionado caso para `id == null`

### 🔒 Equivalência funcional mantida
✔️ Confirmado via [bit.ly/ConfirmacaoApex](https://bit.ly/ConfirmacaoApex)
```

---

## ✅ Quando uma comparação é obrigatória?

| Situação                             | Obrigatório? |
|--------------------------------------|--------------|
| Alteração em método público          | ✅            |
| Troca de SELECT direto por helper    | ✅            |
| Refatoração em builder de teste      | ✅            |
| Alteração em lógica de log (`Logger`) | ✅            |
| Apenas mudança de espaçamento        | ❌            |
| Mudança em variável `private`        | ⚠️ contextual |
| Inclusão de assert em teste          | ⚠️ contextual |

---

## 📌 Dicas avançadas de comparação

- Use `git diff --word-diff` para destacar mudanças sutis
- Use `Side-by-Side` no VS Code para analisar refatorações longas
- Compare logs se alterou chamadas a `Logger` ou `RestServiceHelper`
- Mantenha os blocos separados por tipo:
  - `SELECT`
  - `Logger`
  - `Branch / if`
  - `Serialização`

---

## 🔗 Integrações úteis

| Guia                           | Contribuição                                  |
|--------------------------------|-----------------------------------------------|
| [GuiaLoggerApex](https://bit.ly/GuiaLoggerApex)   | Alvo comum de refatoração                     |
| [GuiaTestsApex](https://bit.ly/GuiaTestsApex)     | Validação de equivalência após mudanças       |
| [GuiaRestAPI](https://bit.ly/Guia_APIs_REST)      | Mudanças nos handlers precisam ser comparadas |

---

## 🧠 Final

> Toda melhoria precisa de prova.  
> Toda prova precisa de contexto.  
> Toda mudança precisa passar pela lupa da comparação.

📌 Refatoração sem comparação é improviso.  
🧱🧠🧪 #RefatoraComRaiz #AntesVsDepois #NadaMudaSemRastreabilidade

** classes .cls**

public class RecordHelper {
    public static SObject getById(Schema.SObjectType sobjectType, Id recordId, String queryFields) {
        if (recordId == null || String.isBlank(queryFields) || sobjectType == null) {
            return null;
        }

        String objectName = sobjectType.getDescribe().getName();
        String query = 'SELECT ' + queryFields + ' FROM ' + objectName + ' WHERE Id = :recordId LIMIT 1';

        List<SObject> records = Database.query(query);
        return records.isEmpty() ? null : records[0];
    }
}


**exemplo de classe refatorada com metodos simplificados**

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

