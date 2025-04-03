<p align="center">
  <img src="https://raw.githubusercontent.com/leogbo/mambadev-guides/main/static/img/github_banner_mambadev.png" alt="MambaDev Banner" width="100%" />
</p>

> 🧱 @status:core | This guide defines the official MambaDev strategy for semantic exception handling with full logging and traceability.

# 🚨 Exception Handling – MambaDev Pattern

📎 [Shortlink: mambadev.io/exception-handling](https://mambadev.io/exception-handling)

> We don’t just catch errors.  
> **We reveal truth. With structure.** 🧱🔥

---

## 🎯 Purpose

In MambaDev, exceptions are **contracts** — not just errors.  
They exist to:

- ✅ Signal invalid state  
- ✅ Halt untrusted execution  
- ✅ Expose system configuration failures  
- ✅ Route diagnostics via logging  
- ✅ Enforce testable, traceable logic

---

## 🧱 Custom Exception Types

All thrown exceptions must extend [`CustomException.cls`](https://github.com/leogbo/mambadev-guides/blob/main/src/classes/custom-exception.cls).

### ✅ Mamba-Standard Exception Classes

| Class | Purpose |
|-------|---------|
| [`CustomException`](https://github.com/leogbo/mambadev-guides/blob/main/src/classes/custom-exception.cls) | Abstract base for all semantic errors |
| [`AppValidationException`](https://github.com/leogbo/mambadev-guides/blob/main/src/classes/app-validation-exception.cls) | Business rule or input validation failure |
| [`AppIntegrationException`](https://github.com/leogbo/mambadev-guides/blob/main/src/classes/app-integration-exception.cls) | External service or API failure |
| [`AppAuthenticationException`](https://github.com/leogbo/mambadev-guides/blob/main/src/classes/app-authentication-exception.cls) | Token or credential invalidity |
| [`AppConfigurationException`](https://github.com/leogbo/mambadev-guides/blob/main/src/classes/app-configuration-exception.cls) | Missing or invalid system setup |

> 🧠 These classes enforce clarity, hierarchy, and recovery rules.

---

## ❌ Bad Exception Usage

```apex
throw new Exception('Name is required');
```

✅ Preferred:

```apex
throw new AppValidationException('Name is required');
```

---

## 🧭 Structured Try/Catch with Logger

```apex
try {
    new AccountService().execute(input);

} catch (AppValidationException ve) {
    new Logger()
        .setClass('AccountService')
        .setMethod('execute')
        .setCategory('Validation')
        .warn(ve.getMessage(), JSON.serializePretty(input));

} catch (AppIntegrationException ie) {
    new Logger()
        .setClass('AccountService')
        .setMethod('execute')
        .setCategory('Callout')
        .error('Integration failure', ie, JSON.serializePretty(input));

} catch (Exception ex) {
    new Logger()
        .setClass('AccountService')
        .setMethod('execute')
        .setCategory('System')
        .error('Unexpected error', ex, null);
}
```

✅ Always include:

- `.setClass()`  
- `.setMethod()`  
- `.setCategory()`  
- Full exception + optional payload serialization

---

## 📄 Flow Execution Chain

```plaintext
Trigger / Flow / REST Controller
         ↓
     Service Layer
         ↓
 AppValidationException / AppIntegrationException
         ↓
Logger + FlowExecutionLog__c
         ↓
Dashboards / Audit / Alerting
```

---

## 🧪 Test for Thrown Exception

```apex
@IsTest
static void test_should_throw_validation_exception() {
    try {
        MyService.execute(null);
        System.assert(false, 'Expected validation error');
    } catch (AppValidationException ex) {
        System.assertEquals('Name required', ex.getMessage());
    }
}
```

---

## ✅ Exception Handling Checklist

- [x] Use specific, semantic exception types  
- [x] Avoid generic `Exception` unless rethrowing  
- [x] Log all exceptions using `Logger.error(...)`  
- [x] Use `JSON.serializePretty(...)` in logs  
- [x] FlowExceptions must include context, not just status  
- [x] Never silently suppress errors in catch blocks

---

## 📚 Related Guides

- [Validation Patterns](/docs/apex/testing/validation-patterns.md) – for guard logic  
- [Structured Logging](/docs/apex/logging/structured-logging.md) – for logging strategy  
- [ExceptionUtil](/docs/apex/logging/exception-util.md) – declarative validation guard methods  
- [FlowExecutionLog__c](/docs/apex/logging/flow-execution-log.md) – storage of structured log traces

---

## 📎 Aligned Fundamentals

- [MambaDev Coding Style](/docs/apex/fundamentals/mamba-coding-style.md)  
- [Architecture Principles](/docs/apex/fundamentals/architecture-principles.md)  
- [Review Checklist](/docs/apex/fundamentals/apex-review-checklist.md)  
- [Apex Core Guide](/docs/apex/fundamentals/mamba-apex-core-guide.md)

---

> Exceptions in MambaDev don’t crash silently.  
> They speak. They explain. They teach.  
> **Log with clarity. Throw with purpose. Test with context.**

**#NoRawThrow #SemanticFailure #LoggedAndRethrown** 🧠🔥🧱