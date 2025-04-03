<p align="center">
  <img src="https://raw.githubusercontent.com/leogbo/mambadev-guides/main/static/img/github_banner_mambadev.png" alt="MambaDev Banner" width="100%" />
</p>

> 🧱 @status:core | This document defines the official MambaDev logging stack for Apex, including Logger, LoggerMock, and FlowExecutionLog__c.

# 🦥 Apex Logger Guide (v2025) | MambaDev

📎 [Shortlink: mambadev.io/logger-implementation](https://mambadev.io/logger-implementation)

> _"Logging is not optional. It's your single source of truth in production."_ – Mamba Mentality 🧠🔥

---

## 📘 Purpose

This guide defines the **standard for structured, traceable, and persistent logging** across any Salesforce org.  
Every critical process — Triggers, REST, Flows, Batches, Callouts — **must** log to `FlowExecutionLog__c` using this architecture.

---

## ✅ Mamba Logger Principles

- ❌ Never use `System.debug()` outside test-only setup classes  
- ✅ Always log:
  - Class, method, category, and execution type
  - Serialized input/output (via `serializePretty()`)
  - Record ID or user context (if applicable)
  - Exceptions and stack traces
  - Persisted logs via `FlowExecutionLog__c`

---

## ⚖️ Components

| Component | Purpose |
|----------|---------|
| [`Logger.cls`](https://github.com/leogbo/mambadev-guides/blob/main/src/classes/logger.cls) | Fluent interface for logging |
| [`LoggerQueueable.cls`](https://github.com/leogbo/mambadev-guides/blob/main/src/classes/logger-queueable.cls) | Async-safe persister for logs |
| [`ILogger.cls`](https://github.com/leogbo/mambadev-guides/blob/main/src/classes/ilogger.cls) | Interface used in prod/test contexts |
| [`LoggerMock.cls`](https://github.com/leogbo/mambadev-guides/blob/main/src/classes/logger-mock.cls) | Test-safe logger with no side effects |
| [`FlowExecutionLog__c`](/docs/apex/logging/flow-execution-log.md) | Persistent structured log object |

---

## ✅ Logger Usage Example

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

## ⚙️ Logger Methods

| Method       | Purpose                          |
|--------------|----------------------------------|
| `.info()`    | Informational messages           |
| `.warn()`    | Recoverable warning              |
| `.error()`   | Exception logging with context   |
| `.success()` | Outcome confirmation (REST, Flow)|

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

## 🧪 Logger in Unit Tests

```apex
Logger.overrideLogger(new LoggerMock());
Logger.isEnabled = false;
```

- ✅ Always use `LoggerMock` to stub persistence  
- ❌ Never assert on `FlowExecutionLog__c` in test classes

---

## 📊 FlowExecutionLog__c Key Fields

| Field                | Description |
|---------------------|-------------|
| `Class__c`          | Originating class |
| `Origin_Method__c`  | Method within class |
| `Trigger_Type__c`   | Batch, Flow, REST, Trigger |
| `Log_Category__c`   | Domain grouping |
| `Log_Level__c`      | INFO, WARN, ERROR, SUCCESS |
| `Serialized_Data__c`| Input JSON snapshot |
| `Debug_Information__c` | Output or trace context |
| `Error_Message__c`  | Exception message |
| `Stack_Trace__c`    | Full error trace |
| `Is_Critical__c`    | Elevation flag |

📎 See full schema: [FlowExecutionLog__c](/docs/apex/logging/flow-execution-log.md)

---

## 🔢 Test Assertion Example

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

## 📄 PR Checklist for Logging (Markdown)

```markdown
### 🦥 Logging Validation

- `.setClass()`, `.setMethod()`, `.setCategory()` applied
- `.error(...)` with full trace and data
- JSON serialized via `serializePretty()`
- LoggerQueueable used if async
- LoggerMock used in tests
- FlowExecutionLog__c populated for all flows
```

---

## ✅ Mamba Logging Checklist

| Item                                       | Done? |
|--------------------------------------------|-------|
| `.setClass()` + `.setMethod()`             | [ ]   |
| `.setCategory()` set appropriately         | [ ]   |
| `.error(...)` includes exception + data    | [ ]   |
| `.success(...)` used where relevant        | [ ]   |
| `LoggerMock` replaces logger in tests      | [ ]   |
| `FlowExecutionLog__c` records created      | [ ]   |
| `serializePretty()` used for JSON payloads | [ ]   |

---

🧠🖤  
**MambaDev**  
_"Logging is soul-traceable. You either log it, or you lose it."_

**#NoDebug #MambaLogger #TraceToAudit #StructuredOrNothing**
