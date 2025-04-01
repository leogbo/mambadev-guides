# 🪵 Guia Oficial de Logger Apex (v2025) – Mentalidade Mamba

📎 **Shortlink oficial:** [bit.ly/GuiaLoggerApex](https://bit.ly/GuiaLoggerApex)

> “Logar não é opcional. É sua única fonte de verdade em produção.” – Mentalidade Mamba 🧠🔥

Este guia define o padrão de **log estruturado, rastreável e persistente** da sua org Salesforce.  
Todo sistema crítico, API, trigger, batch ou callout **deve seguir esta arquitetura**.

---

## 📚 Referência cruzada com guias complementares

- 📘 [Guia Master de Arquitetura](https://bit.ly/GuiaApexMamba)
- 🔍 [Guia de Revisão Apex](https://bit.ly/GuiaApexRevisao)
- 🧪 [Guia de Testes](https://bit.ly/GuiaTestsApex)
- 🧱 [Guia de TestData Setup](https://bit.ly/TestDataSetup)
- 🔁 [Comparações de Refatoração](https://bit.ly/ComparacaoApex)
- ✅ [Equivalência Funcional](https://bit.ly/ConfirmacaoApex)

---

## ✅ Fundamentos do Logger Mamba

- ❌ Nunca usar `System.debug()` fora de testes
- ✅ Logger deve:
  - Identificar a classe/método
  - Registrar input/output
  - Ser rastreável por usuário, registro e execução
  - Ser serializado e persistido (via `FlowExecutionLog__c` ou fila)

---

## ✅ Componentes Padrão

| Componente               | Função                                                                 |
|--------------------------|------------------------------------------------------------------------|
| `Logger`                 | Classe principal de logging (fluent interface)                         |
| `FlowExecutionLog__c`    | Objeto de persistência auditável de logs                              |
| `LoggerQueueable`        | Persistência assíncrona via fila                                       |
| `ILogger`                | Interface para Logger e LoggerMock                                    |
| `LoggerMock`             | Evita persistência real durante testes                                |

---

## ✅ Exemplo padrão de uso
```apex
new Logger()
    .setClass('MinhaClasse')
    .setMethod('executar')
    .setCategory('REST')
    .setRecordId(obj.Id)
    .error('Erro ao processar entrada', ex, JSON.serializePretty(obj));
```

---

## ✅ Logger em Trigger
```apex
Logger.fromTrigger(triggerNew[0])
    .setMethod('beforeInsert')
    .warn('Tentativa de criar UC sem proposta vinculada', null);
```

---

## ✅ Métodos suportados

| Método         | Quando usar                                         |
|----------------|-----------------------------------------------------|
| `.info()`      | Evento normal, execução padrão                     |
| `.warn()`      | Evento incompleto, mas não erro                     |
| `.error()`     | Falha crítica, exceção capturada                    |
| `.success()`   | Fim bem-sucedido de processo relevante              |

---

## ✅ Exemplo de Logging por contexto

### 🧩 Em serviço REST
```apex
new Logger()
    .setClass('ClienteService')
    .setMethod('getCliente')
    .setCategory('REST')
    .setTriggerType('REST')
    .info('Requisição recebida', JSON.serializePretty(params));
```

### ⚙️ Em batch
```apex
new Logger()
    .setClass('AtualizadorBatch')
    .setMethod('execute')
    .setCategory('Batch')
    .setTriggerType('Batch')
    .success('Processamento finalizado com sucesso', JSON.serializePretty(logData));
```

### 🔄 Em trigger
```apex
Logger.fromTrigger(newRecord)
    .setMethod('afterInsert')
    .setCategory('Trigger')
    .warn('Registro criado sem campo obrigatório', null);
```

---

## ✅ Logger em Testes

- Nunca valide persistência de log real
- Use `LoggerMock` para bloquear persistência:
```apex
Logger.isEnabled = false;
LoggerContext.overrideLogger(new LoggerMock());
```

- Nunca valide `FlowExecutionLog__c` diretamente
- Use `LoggerMock.getCaptured()` apenas para inspeção local (debug)

---

## 🧩 Integração com `FlowExecutionLog__c`

| Campo                  | Função                                         |
|------------------------|------------------------------------------------|
| `Class__c`             | Nome da classe de origem                      |
| `Origin_Method__c`     | Método responsável pelo log                   |
| `Log_Level__c`         | Nível do log: INFO, WARN, ERROR, SUCCESS     |
| `Log_Category__c`      | Domínio: Proposta, REST, Trigger, etc        |
| `Serialized_Data__c`   | JSON serializado do payload                  |
| `Trigger_Type__c`      | Tipo de execução: REST, Trigger, Batch       |
| `Error_Message__c`     | Mensagem da exceção                          |
| `Stack_Trace__c`       | Stack trace serializado                      |
| `Execution_Timestamp__c`| Timestamp da execução                       |

> 📎 Ver também: [bit.ly/FlowExecutionLog](https://bit.ly/FlowExecutionLog)

---

## 🧪 Exemplo de Teste
```apex
@IsTest
static void test_logger_mock_aplicado() {
    LoggerContext.overrideLogger(new LoggerMock());
    Logger.isEnabled = false;

    new MinhaClasse().executar();
    System.assert(true, 'Logger mock executado');
}
```

---

## 📄 Exemplo de Pull Request com Logger
```markdown
### 🪵 Logging Validado

- `Logger` aplicado com `.setClass()`, `.setMethod()` e `.setCategory()`
- Log gerado com `.error(...)` e `LoggerQueueable`
- Serialização JSON confirmada com `serializePretty()`
- `FlowExecutionLog__c` validado com categoria `Service`
- Log rastreável por ID e stack trace
- `LoggerMock` ativado em todos os testes unitários
```

---

## ✅ Checklist Mamba de Logging

> 📌 Padrões de categoria mais comuns:
> - `REST`, `Trigger`, `Batch`, `Service`, `Validation`, `Proposta`, `UC`, `Login`
>
> 📌 Padrões de triggerType mais comuns:
> - `REST`, `Trigger`, `Batch`, `Queueable`, `Schedule`, `Future`

| Item                                             | Verificado? |
|--------------------------------------------------|-------------|
| `.setMethod(...)` aplicado                       | [ ]         |
| `.setRecordId(...)` incluído (se aplicável)      | [ ]         |
| `.error(...)` com stack trace                    | [ ]         |
| `.success(...)` em REST/Trigger                  | [ ]         |
| `LoggerMock` aplicado em teste                   | [ ]         |
| `FlowExecutionLog__c` presente (se aplicável)    | [ ]         |
| Categorias e dados serializados usados           | [ ]         |
| JSON via `serializePretty()`                    | [ ]         |

---

🧠🧱🧪 #LoggerMamba #SemDebug #LogPersistente #ErroComRastro



**classes .cls**

/**
 * @since 2025-03-28
 * @author Leo Mamba Garcia
 * 
 * Classe `Logger`
 * 
 * Responsável por registrar logs de execução, erros e dados de auditoria com rastreabilidade completa.
 * A classe também oferece controle sobre o armazenamento de logs em produção ou testes.
 * 
 * ### Funcionalidade:
 * - **Logger** permite criar entradas de log com níveis de severidade (INFO, WARN, ERROR, SUCCESS).
 * - Os logs podem ser armazenados de forma síncrona ou assíncrona, conforme a configuração.
 * - Todos os dados de log são serializados para fácil análise.
 */
public class Logger {

    public enum LogLevel { INFO, WARN, ERROR, SUCCESS }

    @TestVisible public static String environment       = Label.ENVIRONMENT;
    @TestVisible public static String logLevelDefault   = 'INFO';
    @TestVisible public static Integer MAX_DEBUG_LENGTH = 3000;
    @TestVisible public static String className;
    @TestVisible public static String triggerType;
    @TestVisible public static String logCategory;
    @TestVisible public static Boolean isEnabled        = true;

    private String methodName;
    private String triggerRecordId;
    private String stackTrace;
    private String serializedData;
    private String instanceEnvironment;
    private String instanceClassName;
    private String instanceTriggerType;
    private String instanceLogCategory;
    private Boolean async = false;

    // Construtor padrão, que inicializa a classe com informações de contexto
    public Logger() {
        this.instanceClassName   = Logger.className;
        this.instanceTriggerType = Logger.triggerType;
        this.instanceLogCategory = Logger.logCategory;
        this.instanceEnvironment = Logger.environment;
    }

    // Métodos setters com @TestVisible para permitir a configuração e validação dos dados
    @TestVisible public Logger setMethod(String methodName) { this.methodName = methodName; return this; }
    @TestVisible public Logger setRecordId(String recordId) { this.triggerRecordId = recordId; return this; }
    @TestVisible public Logger setCategory(String category) { this.instanceLogCategory = category; return this; }
    @TestVisible public Logger setTriggerType(String triggerType) { this.instanceTriggerType = triggerType; return this; }
    @TestVisible public Logger setEnvironment(String environment) { this.instanceEnvironment = environment; return this; }
    @TestVisible public Logger setClass(String className) { this.instanceClassName = className; return this; }
    @TestVisible public Logger setAsync(Boolean value) { this.async = value; return this; }

    // Método de log para SUCCESS, com controle de dados e contexto
    @TestVisible public void success(String message, String data) {
        log(LogLevel.SUCCESS, message, null, data);
    }

    // Método de log para INFO, com controle de dados e contexto
    @TestVisible public void info(String message, String data) {
        log(LogLevel.INFO, message, null, data);
    }

    // Método de log para WARN, com controle de dados e contexto
    @TestVisible public void warn(String message, String data) {
        log(LogLevel.WARN, message, null, data);
    }

    // Método de log para ERROR, incluindo stack trace e dados do erro
    @TestVisible public void error(String message, Exception ex, String data) {
        String stack = (ex != null) ? ex.getStackTraceString() : null;
        log(LogLevel.ERROR, message, stack, data);
    }

    // Método privado para gerenciar o registro dos logs
    @TestVisible private void log(LogLevel level, String message, String stack, String data) {
        if (!isEnabled && !Test.isRunningTest()) return;

        FlowExecutionLog__c logEntry = new FlowExecutionLog__c(
            Log_Level__c           = level.name(),
            Class__c               = safeLeft(instanceClassName, 255),
            Origin_Method__c       = safeLeft(methodName, 255),
            Trigger_Record_ID__c   = triggerRecordId,
            Error_Message__c       = safeLeft(message, 255),
            Debug_Information__c   = safeLeft(message, MAX_DEBUG_LENGTH),
            Stack_Trace__c         = safeLeft(stack, 30000),
            Serialized_Data__c     = safeLeft(data, 30000),
            Trigger_Type__c        = instanceTriggerType,
            Log_Category__c        = instanceLogCategory,
            Environment__c         = instanceEnvironment,
            Execution_Timestamp__c = System.now()
        );

        // Registra o log de forma assíncrona ou síncrona conforme configuração
        if (async) {
            System.enqueueJob(new LoggerQueueable(logEntry));
        } else {
            insert logEntry;
        }
    }

    // Método privado para garantir que os valores não ultrapassem o limite de comprimento
    @TestVisible private String safeLeft(String value, Integer max) {
        return (value == null) ? null : value.left(max);
    }

    // Método para inicializar o Logger a partir de um registro SObject
    @TestVisible public static Logger fromTrigger(SObject record) {
        Logger logger = new Logger();
        if (record != null && record.Id != null) {
            logger.setRecordId(record.Id);
        }
        return logger;
    }
}

public interface ILogger {

    // ===== CONFIGURAÇÃO FLUENTE =====
    ILogger withMethod(String methodName);
    ILogger withRecordId(String recordId);
    ILogger withCategory(String category);
    ILogger withTriggerType(String triggerType);
    ILogger withEnvironment(String environment);
    ILogger withClass(String className);
    ILogger withAsync(Boolean value);

    // ===== MÉTODOS DE LOG =====
    void success(String message, String serializedData);
    void info(String message, String serializedData);
    void warn(String message, String serializedData);
    void error(String message, Exception ex, String serializedData);

    // ===== OPCIONAIS PARA MOCKS/VALIDAÇÃO =====
    void logRaw(String message);
    Map<String, Object> debugSnapshot();
}


public class LoggerMock implements ILogger {
    public List<String> capturedMessages = new List<String>();
    private Map<String, Object> context = new Map<String, Object>();
    
    @TestVisible
    public ILogger withMethod(String methodName) {
        context.put('method', methodName);
        return this;
    }
    
    @TestVisible
    public ILogger withRecordId(String recordId) {
        context.put('recordId', recordId);
        return this;
    }

    @TestVisible
    public ILogger withCategory(String category) {
        context.put('category', category);
        return this;
    }

    @TestVisible
    public ILogger withTriggerType(String triggerType) {
        context.put('triggerType', triggerType);
        return this;
    }

    @TestVisible
    public ILogger withEnvironment(String environment) {
        context.put('environment', environment);
        return this;
    }

    @TestVisible
    public ILogger withClass(String className) {
        context.put('class', className);
        return this;
    }

    @TestVisible
    public ILogger withAsync(Boolean value) {
        context.put('async', value);
        return this;
    }

    @TestVisible
    public void success(String message, String serializedData) {
        capturedMessages.add('[SUCCESS] ' + message + ' | ' + serializedData);
    }

    @TestVisible
    public void info(String message, String serializedData) {
        capturedMessages.add('[INFO] ' + message + ' | ' + serializedData);
    }

    @TestVisible
    public void warn(String message, String serializedData) {
        capturedMessages.add('[WARN] ' + message + ' | ' + serializedData);
    }

    @TestVisible
    public void error(String message, Exception ex, String serializedData) {
        String msg = message + (ex != null ? ' | ' + ex.getMessage() : '');
        capturedMessages.add('[ERROR] ' + msg + ' | ' + serializedData);
    }

    @TestVisible
    public void logRaw(String message) {
        capturedMessages.add('[RAW] ' + message);
    }

    @TestVisible
    public Map<String, Object> debugSnapshot() {
        return context.clone();
    }

    @TestVisible
    public List<String> getCaptured() {
        return capturedMessages;
    }
}


