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

| Class                | Role                                             |
|---------------------|--------------------------------------------------|
| `Logger`            | Main fluent logger                               |
| `LoggerQueueable`   | Async-safe persister for `FlowExecutionLog__c`   |
| `ILogger`           | Interface for `Logger` and `LoggerMock`          |
| `LoggerMock`        | In-memory stub for test contexts                 |
| `FlowExecutionLog__c` | Custom object that stores logs persistently    |

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

> ✅ Always set `.setClass()`, `.setMethod()`, and `.setCategory()`  
> ✅ Use `.error(message, ex, data)` to capture the full exception and context

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

> ✅ Use `LoggerMock` to intercept logs during unit tests  
> ❌ Never assert on real `FlowExecutionLog__c` records

---

## 🚀 Using Async Logging

```apex
new Logger()
    .setClass('SyncService')
    .setAsync(true)
    .info('Async mode enabled', JSON.serializePretty(obj));
```

> When `.setAsync(true)` is used, logs are handled by `LoggerQueueable`,  
> avoiding DML inside Flows, Triggers, or `before` contexts.

---

## 📄 FlowExecutionLog__c Overview

Logs are persisted in `FlowExecutionLog__c`.

Key fields include:

- `Log_Level__c`, `Class__c`, `Origin_Method__c`  
- `Trigger_Type__c`, `Log_Category__c`  
- `Serialized_Data__c`, `Debug_Information__c`  
- `Stack_Trace__c`, `Error_Message__c`  
- `Execution_Timestamp__c`, `Is_Critical__c`

👉 Full schema: [→ flow-execution-log.md](./flow-execution-log.md)

---

## ✅ Logging Best Practices

- [x] Always use `.setClass()` and `.setMethod()`  
- [x] Use `.setCategory()` for grouping  
- [x] Log exceptions via `.error(message, ex, data)`  
- [x] Use `.setAsync(true)` inside Flow or batch contexts  
- [x] Avoid logging PII or sensitive data in production  
- [x] Use `JSON.serializePretty()` for clean, readable logs

---

## ⚠️ Exception – TestDataSetup Classes

> `System.debug()` is prohibited in all Apex — **except inside `*TestDataSetup.cls` classes**.

These classes are used for bulk setup and **must avoid log pollution**.  
They can use `System.debug()` for diagnostic output only.

✅ Use:

```apex
System.debug('Lead created for test setup: ' + lead.Id);
```

❌ Never use `Logger` in test data setup classes.

---

## 📚 Related Guides

- [FlowExecutionLog__c](./flow-execution-log.md)  
- [Exception Handling](./exception-handling.md)  
- [LoggerMock (Validation Patterns)](./validation-patterns.md#🔁-testing-with-loggermock)  
- [Testing Patterns](./testing-patterns.md)

---

## 📎 Aligned Fundamentals

- [`MambaDev Coding Style`](../fundamentals/mambadev-coding-style.md)  
- [`Apex Style Guide`](../fundamentals/apex-style-guide.md)  
- [`Architecture Principles`](../fundamentals/architecture-principles.md)  
- [`Review Checklist`](../fundamentals/apex-review-checklist.md)

---

> **MambaDev doesn't log noise.**  
> We log signal — structured, contextual, actionable. 🧠🔥
