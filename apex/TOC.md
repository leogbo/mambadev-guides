# 📚 MambaDev Apex – Table of Contents

> This is the official guide index for the MambaDev Apex module.  
> Organized for readability, progression, and fast lookup.

---

## 📘 Fundamentals (Required Reading)

- [MambaDev Coding Style](../fundamentals/mambadev-coding-style.md)
- [Apex Style Guide](../fundamentals/apex-style-guide.md)
- [Architecture Principles](../fundamentals/architecture-principles.md)
- [Apex Review Checklist](../fundamentals/apex-review-checklist.md)

---

## 🧱 Core Architecture

- [Layered Architecture](./layered-architecture.md)
- [Naming Standards](./naming-standards.md)

---

## 🧪 Testing & Validation

- [Validation Patterns](./validation-patterns.md)
- [ExceptionUtil Guide](./exceptionutil.md)
- [Testing Patterns](./testing-patterns.md)

---

## 🔁 Error & Logging Strategy

- [Exception Handling](./exception-handling.md)
- [Structured Logging](./structured-logging.md)
- [FlowExecutionLog__c Schema](./flow-execution-log.md)

---

## 📦 Utilities

- [Logger (Structured Logging Stack)](./structured-logging.md#🧱-the-logging-stack)
- [LoggerMock – for test log suppression](./structured-logging.md#🧪-testing-with-loggermock)
- RecordHelper *(WIP – not yet documented)*

---

## 🧬 Class Reference – `/examples/classes/`

> These are live examples of MambaDev-compliant Apex classes.  
> All follow strict naming, exception, logging, and architecture conventions.

| Class                                 | Purpose                                                              |
|--------------------------------------|----------------------------------------------------------------------|
| [`app-authentication-exception.cls`](./examples/classes/app-authentication-exception.cls) | Semantic exception for access violations                  |
| [`app-configuration-exception.cls`](./examples/classes/app-configuration-exception.cls)   | Thrown when expected config/metadata is missing             |
| [`app-integration-exception.cls`](./examples/classes/app-integration-exception.cls)       | Encapsulates errors from external systems                   |
| [`app-validation-exception.cls`](./examples/classes/app-validation-exception.cls)         | Used when validation/business rules fail                    |
| [`async-logger-job.cls`](./examples/classes/async-logger-job.cls)                         | Queueable job to persist logs without blocking main thread  |
| [`authentication-exception.cls`](./examples/classes/authentication-exception.cls)         | ❌ Deprecated naming — use `app-authentication-exception`   |
| [`auto-convert-leads.cls`](./examples/classes/auto-convert-leads.cls)                     | Batch Apex for converting leads via `InvocableMethod`       |
| [`configuration-exception.cls`](./examples/classes/configuration-exception.cls)           | ❌ Deprecated naming — use `app-configuration-exception`    |
| [`custom-exception.cls`](./examples/classes/custom-exception.cls)                         | Base virtual exception to extend                            |
| [`exception-util.cls`](./examples/classes/exception-util.cls)                             | Guard clause helper — `throwIfNull`, `require`, `fail`      |
| [`ilogger.cls`](./examples/classes/ilogger.cls)                                            | Interface for `Logger` and `LoggerMock`                     |
| [`logger-mock.cls`](./examples/classes/logger-mock.cls)                                   | Logger stub to neutralize side effects during tests         |
| [`logger.cls`](./examples/classes/logger.cls)                                             | Structured logger with async and context metadata support   |
| [`record-helper.cls`](./examples/classes/record-helper.cls)                               | Lightweight utility to dynamically query records by Id      |
| [`rest-service-helper.cls`](./examples/classes/rest-service-helper.cls)                   | Abstraction for REST response handling and token validation |
| [`test-helper.cls`](./examples/classes/test-helper.cls)                                   | Utility for random data, ID generation, and test assertions |

---

> Every layer. Every pattern. Every detail — is designed for scale.  
> **Because quality isn’t optional. It’s the standard.** 🧱🔥
