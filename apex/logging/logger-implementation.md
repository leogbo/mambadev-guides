<p align="center">
  <img src="https://raw.githubusercontent.com/leogbo/mambadev-guides/main/static/img/github_banner_mambadev.png" alt="MambaDev Banner" width="100%" />
</p>

# 🦥 Apex Logger Guide (v2025) | MambaDev

> *"Logging is not optional. It's your single source of truth in production."* – Mamba Mentality 🧠🔥

---

## 🔖 Shortlink

Official: [mambadev.io/logger-implementation](https://mambadev.io/logger-implementation)

---

## 📘 Purpose

This guide defines the **standard for structured, traceable, and persistent logging** across any Salesforce org. Every critical process — triggers, APIs, batches, callouts — **must** follow this architecture.

> Related Guides:
> - [Core Standards](https://mambadev.io/apex-core-guide)
> - [Apex Architecture](https://mambadev.io/layered-architecture)
> - [Testing](https://mambadev.io/apex-testing-guide)
> - [Review Checklist](https://mambadev.io/apex-review-checklist)
> - [FlowExecutionLog__c Example](https://mambadev.io/logger-implementation#flowexecutionlogc)

---

## ✅ Mamba Logger Principles

- ❌ Never use `System.debug()` outside tests
- ✅ Always log:
  - Class, method, category, and execution type
  - Serialized input/output
  - Record ID or user context
  - Exceptions and stack traces
  - Persisted logs via `FlowExecutionLog__c`

---

## ⚖️ Components

| Component             | Purpose                                                   |
|----------------------|-----------------------------------------------------------|
| `Logger`             | Fluent interface logger class                             |
| `FlowExecutionLog__c`| Persistent log storage                                    |
| `LoggerQueueable`    | Async log insertion                                       |
| `ILogger`            | Interface for Logger and mocks                            |
| `LoggerMock`         | Prevents actual persistence in tests                      |

---

## ✅ Usage Example

```apex
new Logger()
    .setClass('MyService')
    .setMethod('execute')
    .setCategory('REST')
    .setRecordId(obj.Id)
    .error('Error while processing', ex, JSON.serializePretty(obj));
```

---

## 🚧 Usage in Triggers

```apex
Logger.fromTrigger(triggerNew[0])
    .setMethod('beforeInsert')
    .warn('Attempt to create record without reference', null);
```

---

## ⚙️ Supported Methods

| Method       | Purpose                                  |
|--------------|-------------------------------------------|
| `.info()`    | Normal execution                          |
| `.warn()`    | Recoverable issue                         |
| `.error()`   | Captured exception                        |
| `.success()` | Successful outcome (e.g. trigger finish)  |

---

## 📂 Context-Based Examples

### REST Context
```apex
new Logger()
    .setClass('AccountService')
    .setMethod('getAccount')
    .setCategory('REST')
    .setTriggerType('REST')
    .info('Received request', JSON.serializePretty(params));
```

### Batch Context
```apex
new Logger()
    .setClass('DataSyncBatch')
    .setMethod('execute')
    .setCategory('Batch')
    .setTriggerType('Batch')
    .success('Batch completed', JSON.serializePretty(result));
```

### Trigger Context
```apex
Logger.fromTrigger(newRecord)
    .setMethod('afterInsert')
    .setCategory('Trigger')
    .warn('Missing mandatory field on creation', null);
```

---

## 🧼 Logger in Unit Tests

```apex
Logger.overrideLogger(new LoggerMock());
Logger.isEnabled = false;
```

Never assert on `FlowExecutionLog__c`. Use mocks only for validation.

---

## 📊 FlowExecutionLog__c Fields

| Field                    | Description                                 |
|-------------------------|---------------------------------------------|
| `Class__c`              | Originating class                           |
| `Origin_Method__c`      | Method inside class                         |
| `Log_Level__c`          | Severity: INFO, WARN, ERROR, SUCCESS        |
| `Log_Category__c`       | Context domain: REST, Trigger, etc.         |
| `Serialized_Data__c`    | Pretty JSON payload                         |
| `Trigger_Type__c`       | Execution type: REST, Batch, etc.           |
| `Error_Message__c`      | Message of the exception                    |
| `Stack_Trace__c`        | Stack trace (if error)                      |
| `Execution_Timestamp__c`| Execution timestamp                        |

---

## 🔢 Unit Test Example

```apex
@IsTest
static void should_use_logger_mock_correctly() {
    Logger.overrideLogger(new LoggerMock());
    Logger.isEnabled = false;

    new MyService().run();
    System.assert(true, 'Logger mock executed');
}
```

---

## 📄 Pull Request Logging Summary Template

```markdown
### 🦥 Logging Validation

- `.setClass()`, `.setMethod()`, `.setCategory()` applied
- `.error(...)` with full trace and data
- Pretty serialization confirmed
- Async queue via `LoggerQueueable`
- Log persistence through `FlowExecutionLog__c`
- All test methods use `LoggerMock`
```

---

## ✅ Mamba Logging Checklist

| Item                                             | Done? |
|--------------------------------------------------|-------|
| `.setMethod(...)` used                           | [ ]   |
| `.setRecordId(...)` included (if applicable)     | [ ]   |
| `.error(...)` logs with stack trace              | [ ]   |
| `.success(...)` for REST/Trigger conclusions     | [ ]   |
| `LoggerMock` used in test methods                | [ ]   |
| `FlowExecutionLog__c` used for persistence       | [ ]   |
| Categories & types correctly set                 | [ ]   |
| JSON via `serializePretty()`                     | [ ]   |

---

🧠🖤  
**MambaDev**  
_Logging is soul-traceable. You either log it, or lose it._  
#NoDebug #MambaLogger #VisibilityIsPower

