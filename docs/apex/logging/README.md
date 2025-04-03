<p align="center">
  <img src="https://raw.githubusercontent.com/leogbo/mambadev-guides/main/static/img/github_banner_mambadev.png" alt="MambaDev Banner" width="100%" />
</p>

# 🪵 Logging Module – MambaDev

This folder contains all resources related to **structured logging**, **exception traceability**, and **observability architecture** within the MambaDev Apex framework.

---

## 📚 Included Guides

- [Structured Logging](/docs/apex/logging/structured-logging.md): Centralized logging principles, usage, and fluent Logger syntax  
- [Logger Implementation](/docs/apex/logging/logger-implementation.md): Implementation and lifecycle of the custom `Logger` class  
- [FlowExecutionLog Schema](/docs/apex/logging/flow-execution-log.md): Persistent logging object + field mapping for traceability  
- [ExceptionUtil Helper](/docs/apex/logging/exception-util.md): Fail-fast guards and exception throw helpers  
- [Config System Reference](/docs/apex/logging/config-system.md): Environment-based logging toggles and flags  
- [LoggerMock](/docs/apex/logging/logger-mock.md): Mock logger class for unit tests  
- [`LoggerQueueable.cls`](/src/classes/logger-queueable.cls): Async persistence job for offloading logs

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

- [ExceptionUtil Helper](/docs/apex/logging/exception-util.md)  
- [REST API Guide](/docs/apex/integrations/rest-api-guide.md)  
- [Apex Review Checklist](/docs/apex/fundamentals/apex-review-checklist.md)  
- [TestDataSetup](/docs/apex/testing/test-data-setup.md)

---

📎 See also the [Class Reference](/docs/_sidebar.md#-class-reference) in the global sidebar for direct access to `Logger`, `LoggerMock`, and `LoggerQueueable` `.cls` files.

---

**Logging is not optional. It’s your trace to excellence.**  
Welcome to the observability layer of MambaDev.
