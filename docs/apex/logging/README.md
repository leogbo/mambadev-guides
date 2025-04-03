<p align="center">
  <img src="https://raw.githubusercontent.com/leogbo/mambadev-guides/main/static/img/github_banner_mambadev.png" alt="MambaDev Banner" width="100%" />
</p>

> 🧱 @status:core | This module defines the official standards for logging, observability, and exception handling in MambaDev.

# 🪵 Logging Module – MambaDev

📎 [Shortlink: mambadev.io/logging](https://mambadev.io/logging)

This folder contains all resources related to **structured logging**, **exception traceability**, and **observability architecture** within the MambaDev Apex framework.

---

## 📚 Included Guides

- [Structured Logging](/docs/apex/logging/structured-logging.md): Fluent logging design, async-safe operations, and context-based behavior  
- [Logger Implementation](/docs/apex/logging/logger-implementation.md): How the `Logger` works under the hood (sync/async)  
- [FlowExecutionLog Schema](/docs/apex/logging/flow-execution-log.md): Persistent logging schema with field mapping  
- [ExceptionUtil Helper](/docs/apex/logging/exception-util.md): Declarative fail-fast guards with semantic exceptions  
- [Config System Reference](/docs/apex/logging/config-system.md): Global log toggles and environment-sensitive controls  
- [LoggerMock](/docs/apex/logging/logger-mock.md): Unit test logger stub for validation without persistence  
- [`LoggerQueueable.cls`](https://github.com/leogbo/mambadev-guides/blob/main/src/classes/logger-queueable.cls): Queueable handler for async log offloading

---

## 🎯 Purpose

Logging is not debug output — it’s an architectural pillar of MambaDev.

This module ensures:

- ✅ Logs follow a consistent, queryable JSON schema  
- ✅ Errors are captured with full trace and payload snapshot  
- ✅ Logger usage is semantic, testable, and async-safe  
- ✅ Logging is usable by developers, support teams, and observability platforms  
- ✅ Exception handling routes into `FlowExecutionLog__c` for centralized auditing

> `System.debug()` is not enough.  
> **Mamba logs with context, contracts, and clarity.**

---

## 🔁 Related Docs & Modules

- [ExceptionUtil Helper](/docs/apex/logging/exception-util.md) – Declarative `throwIfNull`, `require(...)`  
- [REST API Guide](/docs/apex/integrations/rest-api-guide.md) – Logs all API behavior  
- [Apex Review Checklist](/docs/apex/fundamentals/apex-review-checklist.md) – Logging is enforced during PRs  
- [TestDataSetup](/docs/apex/testing/test-data-setup.md) – Sets config for mock logging in tests

---

📎 See also the [Class Reference](/docs/_sidebar.md#-class-reference) section in the global sidebar  
For direct access to:  
- [`Logger.cls`](https://github.com/leogbo/mambadev-guides/blob/main/src/classes/logger.cls)  
- [`LoggerMock.cls`](https://github.com/leogbo/mambadev-guides/blob/main/src/classes/logger-mock.cls)  
- [`LoggerQueueable.cls`](https://github.com/leogbo/mambadev-guides/blob/main/src/classes/logger-queueable.cls)

---

**Logging is not optional. It’s your trace to excellence.**  
Welcome to the observability layer of MambaDev.

**#TraceEveryLayer #NoDebugOnlyLogger #AuditWithoutGuesswork**