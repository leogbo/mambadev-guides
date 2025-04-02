<p align="center">
  <img src="https://raw.githubusercontent.com/leogbo/mambadev-guides/main/static/img/github_banner_mambadev.png" alt="MambaDev Banner" width="100%" />
</p>

# 📊 Structured Logging – MambaDev

> This guide defines the **MambaDev pattern** for structured logging across Apex services, flows, triggers, and integrations.  
> Designed for **full traceability**, **debuggability**, and **analytics-ready observability** using `FlowExecutionLog__c`.

---

## 🎯 Why Structured Logging

In complex Salesforce architectures, knowing **what ran**, **why it ran**, and **what failed** is critical.

The MambaDev `Logger` stack offers:

- 📎 **Context-aware logging** (`class`, `method`, `trigger`, `record`, `user`)  
- 🧱 **Structured fields** for dashboards, audits, and monitoring  
- 🔁 **Async-safe execution** with `LoggerQueueable`  
- 🧪 **Test support via `LoggerMock`**  
- 🔍 **Full JSON visibility** for inputs, outputs, and context

---

## 🧱 The Logging Stack

| Class              | Role                                           |
|-------------------|------------------------------------------------|
| `Logger`          | Main fluent logger                             |
| `LoggerQueueable` | Async-safe persister for FlowExecutionLog__c   |
| `ILogger`         | Interface for `Logger` and `LoggerMock`        |
| `LoggerMock`      | In-memory stub for testing                     |
| `FlowExecutionLog__c` | Custom object that stores logs persistently|

---

## ⚙️ Logging in a Service

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

> Always set `Class`, `Method`, and `Category`.  
> Use `error(..., ex, ...)` to capture the full stack trace.

---

## 🧪 Testing with `LoggerMock`

```apex
LoggerMock mock = new LoggerMock()
    .withClass('MyService')
    .withMethod('runTest')
    .withTriggerType('Test')
    .withCategory('Unit');

mock.info('Executed successfully', 'mocked');

System.assert(mock.getCaptured().contains('[INFO] Executed successfully | mocked'));
```

> Use `LoggerMock` to avoid DML during tests. Never test by inspecting actual `FlowExecutionLog__c` records.

---

## 🚀 Using Async Logging

```apex
new Logger()
    .setClass('SyncService')
    .setAsync(true)
    .info('Async mode enabled', JSON.serializePretty(obj));
```

> When `.setAsync(true)` is used, the logger enqueues a `LoggerQueueable` job to safely insert logs **outside** sensitive contexts like Flows or Triggers.

---

## 📄 FlowExecutionLog__c Overview

All logs are stored in `FlowExecutionLog__c`.  
See full documentation: [→ flow-execution-log.md](./flow-execution-log.md)

Key fields:

- `Log_Level__c`, `Class__c`, `Origin_Method__c`
- `Trigger_Type__c`, `Log_Category__c`
- `Serialized_Data__c`, `Debug_Information__c`
- `Stack_Trace__c`, `Error_Message__c`
- `Execution_Timestamp__c`, `Is_Critical__c`

---

## ✅ Logging Best Practices

- [x] Always use `.setClass()` and `.setMethod()`  
- [x] Group logs with `.setCategory()`  
- [x] Log exceptions using `.error()` with `Exception ex`  
- [x] Use `.setAsync(true)` inside flows or bulk triggers  
- [x] Avoid logging sensitive production data (mask if needed)  
- [x] Serialize context with `JSON.serializePretty()` (not `toString()`)

---

## 📚 Related Guides

- [FlowExecutionLog__c](./flow-execution-log.md)  
  Field breakdown for log object and queryable analytics.

- [Exception Handling](./exception-handling.md)  
  Using try/catch with structured logging via `Logger`.

- [LoggerMock](./validation-patterns.md#🔁-testing-with-loggermock)  
  Clean test isolation with no persisted logs.

- [Validation Patterns](./validation-patterns.md)  
  Declarative business rules integrated with logging.

---

## 📎 Aligned Fundamentals

- [`MambaDev Coding Style`](../fundamentals/mambadev-coding-style.md)  
- [`Apex Style Guide`](../fundamentals/apex-style-guide.md)  
- [`Architecture Principles`](../fundamentals/architecture-principles.md)  
- [`Review Checklist`](../fundamentals/apex-review-checklist.md)

---

> **MambaDev doesn't log noise.**  
> We log signal — structured, contextual, actionable. 🧠🔥
