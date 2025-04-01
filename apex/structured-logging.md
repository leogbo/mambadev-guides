<p align="center">
  <img src="https://raw.githubusercontent.com/leogbo/mambadev-guides/main/static/img/github_banner_mambadev.png" alt="MambaDev Banner" width="100%" />
</p>

# Structured Logging – MambaDev

> This guide defines the MambaDev pattern for logging execution across Apex services, flows, triggers, and integrations.  
> It is designed to support full traceability, debuggability, and advanced monitoring through `FlowExecutionLog__c`.

---

## 🎯 Why Structured Logging

In complex Salesforce systems, understanding **what ran**, **why**, and **what failed** is critical.  
The `Logger` class in MambaDev is designed to offer:

- 📎 **Context-aware logging** (class, method, trigger, user, record ID)
- 🧱 **Structured fields** for dashboards, analytics and audit
- 🧪 **Compatibility with both sync and async flows**
- 🔍 **Full payload visibility** for input/output JSON
- 🔄 **Optional mocks** for testing with `LoggerMock`

---

## 🧱 The Logging Stack

### Core Components

| Class             | Purpose                                 |
|------------------|------------------------------------------|
| `Logger`         | Main logger with fluent configuration    |
| `LoggerQueueable`| Async log persister via Queueable        |
| `ILogger`        | Interface for Logger + LoggerMock        |
| `LoggerMock`     | In-memory logger for test scenarios      |
| `FlowExecutionLog__c` | Custom object for log persistence   |

---

## 🧪 Basic Usage in Services

```apex
Logger logger = new Logger()
    .setClass('AccountService')
    .setMethod('validateAccount')
    .setTriggerType('Flow')
    .setCategory('Validation');

logger.info('Validation passed', JSON.serializePretty(account));
```

---

## 🔐 Logging Exceptions

```apex
try {
    service.execute();

} catch (AppValidationException ex) {
    new Logger()
        .setClass('AccountService')
        .setMethod('execute')
        .setCategory('Validation')
        .warn('Validation failed: ' + ex.getMessage(), null);

} catch (Exception ex) {
    new Logger()
        .setClass('AccountService')
        .setMethod('execute')
        .setCategory('System')
        .error('Unexpected error', ex, null);
}
```

---

## 🧪 Testing with LoggerMock

```apex
LoggerMock mock = new LoggerMock()
    .withClass('MyService')
    .withMethod('runTest')
    .withTriggerType('Test')
    .withCategory('Unit');

mock.info('Executed successfully', 'mocked');

System.assert(mock.capturedMessages.contains('[INFO] Executed successfully | mocked'));
```

---

## 🚀 Enabling Async Logging

```apex
new Logger()
    .setClass('SyncService')
    .setAsync(true)
    .info('Async mode enabled', JSON.serializePretty(obj));
```

When `.setAsync(true)` is used, the log is pushed via `LoggerQueueable` to avoid DML during sensitive contexts (e.g., triggers or flows).

---

## 📄 FlowExecutionLog__c Fields

All logs are stored in `FlowExecutionLog__c`. See full documentation:  
[→ flow-execution-log.md](./flow-execution-log.md)

Key fields include:

- `Log_Level__c`
- `Class__c`, `Origin_Method__c`
- `Serialized_Data__c`, `Debug_Information__c`
- `Stack_Trace__c`
- `Trigger_Type__c`, `Log_Category__c`
- `Execution_Timestamp__c`
- `Is_Critical__c`

---

## ✅ Best Practices

- [x] Always set `.setClass()` and `.setMethod()` for traceability
- [x] Use `.setCategory()` to group logs logically
- [x] Log errors with full exception stack using `.error(...)`
- [x] Use `.setAsync(true)` when logging inside flows or bulk operations
- [x] Avoid logging sensitive data in production — use masked or filtered payloads if needed

---

## 📚 Related Guides

- [FlowExecutionLog__c](./flow-execution-log.md)  
  Object reference for all logged fields and integration points.

- [Exception Handling](./exception-handling.md)  
  Structured use of exceptions with logging and classification.

- [LoggerMock for Testing](./validation-patterns.md#🔁-testing-with-loggermock)  
  Clean testing of logs without inserting anything.

- [Validation Patterns](./validation-patterns.md)  
  Examples of validations that integrate with logger.

## 📎 Aligned Fundamentals

These operational guides are built on:

- [`MambaDev Coding Style`](../fundamentals/mambadev-coding-style.md)
- [`Apex Style Guide`](../fundamentals/apex-style-guide.md)
- [`Architecture Principles`](../fundamentals/architecture-principles.md)
- [`Review Checklist`](../fundamentals/apex-review-checklist.md)

---

> MambaDev doesn't log noise.  
> It logs signal — structured, contextual, actionable.
