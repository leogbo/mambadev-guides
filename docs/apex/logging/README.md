<p align="center">
  <img src="https://raw.githubusercontent.com/leogbo/mambadev-guides/main/static/img/github_banner_mambadev.png" alt="MambaDev Banner" width="100%" />
</p>

# 🪵 Logging Module – MambaDev

This folder contains all resources related to **structured logging**, **exception traceability**, and **observability architecture** within the MambaDev Apex framework.

---

## 📚 Included Guides

- [Structured Logging](structured-logging.md): Centralized logging principles, usage, and fluent Logger syntax  
- [Logger Implementation](logger-implementation.md): Implementation and lifecycle of the custom `Logger` class  
- [FlowExecutionLog Schema](flow-execution-log.md): Persistent logging object + field mapping for traceability  
- [ExceptionUtil Helper](exception-util.md): Fail-fast guards and exception throw helpers  
- [Config System Reference](config-system.md): Environment-based logging toggles and flags  
- [LoggerMock](logger-mock.md): Mock logger class for unit tests  
- [LoggerQueueable](../examples/classes/logger-queueable.cls): Async persistence job for offloading logs

---

## 🎯 Purpose

Logging is not just debug output — it’s a **pillar of operational discipline**.

This content ensures that:

- Logs follow a consistent, queryable JSON structure  
- Errors are traceable across layers and services  
- Logger usage is semantic and testable  
- Logs are usable by developers, support, and integrations

> `System.debug()` is not enough.  
> **Mamba logs to win.**

---

## 🔁 Related Docs & Modules

- [ExceptionUtil Helper](exception-util.md)  
- [REST API Guide](../integrations/rest-api-guide.md)  
- [Apex Review Checklist](../fundamentals/apex-review-checklist.md)  
- [TestDataSetup](../testing/test-data-setup.md)

---

📎 See also the [Class Reference](../../_sidebar.md#-class-reference) section in the global sidebar for direct access to Logger, LoggerMock, and LoggerQueueable `.cls` files.

---

**Logging is not optional. It’s your trace to excellence.**  
Welcome to the observability layer of MambaDev.
```

---

## ✅ Resulting Benefits

| Upgrade                        | Impact |
|-------------------------------|--------|
| 🔗 Cross-linked all local docs | ✅    |
| 🔁 Removed hardcoded URLs      | ✅    |
| 📦 Expanded with `LoggerMock`, `LoggerQueueable` | ✅ Full stack |
| 📘 Docsify + GitHub compatible | ✅ Zero breakage |
