<p align="center">
  <img src="https://raw.githubusercontent.com/leogbo/mambadev-guides/main/static/img/github_banner_mambadev.png" alt="MambaDev Banner" width="100%" />
</p>

> 🧱 @status:core | This guide defines structured logging standards for MambaDev using `Logger`, `FlowExecutionLog__c`, and `LoggerMock`.

# 📊 Structured Logging – MambaDev

📎 [Shortlink: mambadev.io/logger](https://mambadev.io/logger)

> MambaDev doesn’t log noise.  
> We log signal — structured, contextual, and actionable. 🧠🔥

---

## 🎯 Why Structured Logging

In complex Salesforce architectures, knowing **what ran**, **why it ran**, and **what failed** is critical.

The MambaDev `Logger` stack provides:

- 📎 **Context-aware logging** (`class`, `method`, `triggerType`, `recordId`)  
- 🧱 **Structured fields** for dashboards, audits, and observability  
- 🔁 **Async-safe execution** with `LoggerQueueable`  
- 🧪 **Mock-ready via `LoggerMock`**  
- 🔍 **Full JSON payload visibility** via `Serialized_Data__c` and `Debug_Information__c`

---

## 🧱 The Logging Stack

| Component                    | Role                                                  |
|-----------------------------|-------------------------------------------------------|
| [`Logger.cls`](https://github.com/leogbo/mambadev-guides/blob/main/src/classes/logger.cls)              | Main fluent log builder                            |
| [`LoggerQueueable.cls`](https://github.com/leogbo/mambadev-guides/blob/main/src/classes/logger-queueable.cls) | DML-safe async log processor                        |
| [`ILogger.cls`](https://github.com/leogbo/mambadev-guides/blob/main/src/classes/ilogger.cls)            | Common interface for test and prod loggers         |
| [`LoggerMock.cls`](https://github.com/leogbo/mambadev-guides/blob/main/src/classes/logger-mock.cls)     | In-memory stub for use in test methods             |
| [`FlowExecutionLog__c`](/docs/apex/logging/flow-execution-log.md) | Persisted custom object log target                |

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

✅ Always `.setClass()`, `.setMethod()`, and `.setCategory()` before logging.

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

> Use `.error(message, ex, context)` for full exception coverage.

---

## 🚫 Logging Restrictions by Context

| Context               | Logger Usage                   |
|-----------------------|---------------------------------|
| Flow / REST methods   | ❌ Only log on `catch` or `success()` |
| Utility classes       | ❌ Never log internally         |
| Callouts (HTTP APIs)  | ❌ Use `System.debug()` only   |
| Trigger `before/after`| ✅ Only post-validation/catch  |
| Queueable & Batch     | ✅ Use Logger safely or in `.finish()` |

✅ Logger should never interrupt a flow, callout, or LWC-exposed method. Use `System.debug()` or `throw` inside core runtime logic.

---

## 🧪 Testing with `LoggerMock`

```apex
LoggerMock mock = new LoggerMock()
    .withClass('MyService')
    .withMethod('runTest')
    .withTriggerType('Test')
    .withCategory('Unit');

mock.info('Executed successfully', 'mocked');

System.assert(
    mock.getCaptured().contains('[INFO] Executed successfully'),
    'LoggerMock should capture expected log'
);
```

> ✅ Use `LoggerMock` for all test assertions  
> ❌ Never assert `FlowExecutionLog__c` records in tests

---

## 🚀 Async Logging with `LoggerQueueable`

```apex
new Logger()
    .setClass('SyncService')
    .setAsync(true)
    .info('Async log queued', JSON.serializePretty(obj));
```

✅ Use `.setAsync(true)` to:

- Avoid DML inside Flows and `before` triggers  
- Offload logs into a `Queueable` context  
- Comply with platform-safe logging constraints

---

## 📄 FlowExecutionLog__c Overview

Logs are stored in `FlowExecutionLog__c` with:

- `Class__c`, `Origin_Method__c`, `Trigger_Type__c`  
- `Log_Level__c`, `Log_Category__c`  
- `Serialized_Data__c`, `Debug_Information__c`  
- `Error_Message__c`, `Stack_Trace__c`  
- `Execution_Timestamp__c`, `Is_Critical__c`  

🔗 See full schema: [FlowExecutionLog__c](/docs/apex/logging/flow-execution-log.md)

---

## ✅ Logging Best Practices

- ✅ Always `.setClass()`, `.setMethod()`, `.setCategory()`  
- ✅ Use `.error(...)` with stack trace when applicable  
- ✅ Use `.setAsync(true)` inside Flow, Trigger, Queueable  
- ✅ Truncate large payloads with `EnvironmentUtils.getMaxDebugLength()`  
- ✅ Avoid sensitive data — log by reference, not PII  
- ✅ Prefer `serializePretty()` for readability

---

## ⚠️ Exception – Test Data Setup Classes

> `System.debug()` is **only allowed inside `*TestDataSetup.cls` classes**  
> These classes must avoid persistence side effects (Logger writes)

✅ Allowed:

```apex
System.debug('Created test Contact: ' + contact.Id);
```

❌ Not allowed:

```apex
new Logger().info('Test setup').save(); // 🚫 No
```

---

## 📚 Related Guides

- [FlowExecutionLog__c](/docs/apex/logging/flow-execution-log.md)  
- [Exception Handling](/docs/apex/logging/exception-handling.md)  
- [Validation Patterns](/docs/apex/testing/validation-patterns.md)  
- [Testing Patterns](/docs/apex/testing/testing-patterns.md)

---

## 📎 Aligned Fundamentals

- [MambaDev Coding Style](/docs/apex/fundamentals/mamba-coding-style.md)  
- [Apex Core Guide](/docs/apex/fundamentals/mamba-apex-core-guide.md)  
- [Architecture Principles](/docs/apex/fundamentals/architecture-principles.md)  
- [Review Checklist](/docs/apex/fundamentals/apex-review-checklist.md)

---

> **In MambaDev, if it’s not logged, it didn’t happen.**  
> Logs are the contract of execution — and the root of trust.

**#LogWithStructure #LoggerOnCatch #NoNoiseOnlySignal**

