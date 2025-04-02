<p align="center">
  <img src="https://raw.githubusercontent.com/leogbo/mambadev-guides/main/static/img/github_banner_mambadev.png" alt="MambaDev Banner" width="100%" />
</p>

# Exception Handling – MambaDev Pattern

> This guide defines the **official MambaDev strategy** for handling exceptions in Apex.  
> It focuses on **semantic clarity**, **structured logging**, and **testable outcomes**.

---

## 🎯 Purpose

In Apex, exceptions are **not control flow tools**.  
They represent **clear categories of failure** and must trigger **explicit consequences**:  
logging, user feedback, or controlled halting.

---

## 🧱 Custom Exception Types

All exceptions must extend from `CustomException` — a virtual base for consistent semantic hierarchy.

### ✅ Standard MambaDev Exceptions

| Class                         | Description                                                 |
|------------------------------|-------------------------------------------------------------|
| `CustomException`            | Abstract base for all custom exceptions                    |
| `AppValidationException`     | Input validation or business rule violation                |
| `AppIntegrationException`    | System or external callout failure                         |
| `AppAuthenticationException` | Token or authorization error                               |
| `AppConfigurationException`  | Missing or invalid configuration                           |

> 🔄 These exceptions are lightweight, expressive, and fully traceable.

---

## 🧠 Throwing Semantic Exceptions

### 🔴 **Don’t:**

```apex
throw new Exception('Name is required');
```

### ✅ **Do:**

```apex
throw new AppValidationException('Account Name is required.');
```

---

## 🧭 Structured Try/Catch with Logger

```apex
try {
    new AccountService().execute(input);
} 
catch (AppValidationException ve) {
    new Logger()
        .setClass('AccountService')
        .setMethod('execute')
        .setCategory('Validation')
        .warn('Validation failed: ' + ve.getMessage(), JSON.serializePretty(input));
}
catch (AppIntegrationException ie) {
    new Logger()
        .setClass('AccountService')
        .error('Integration error occurred', ie, JSON.serializePretty(input));
}
catch (Exception ex) {
    new Logger()
        .setClass('AccountService')
        .error('Unexpected error', ex, null);
}
```

> ⚠️ Always log with full context and class/method metadata.

---

## ✅ Exception Handling Checklist

- [x] Use specific, semantic exception types
- [x] Never silently swallow exceptions
- [x] Always log via `Logger.error(...)`, not `System.debug`
- [x] Use `JSON.serializePretty()` for logs — never truncate
- [x] Consider enriching the exception before rethrowing

---

## 🔐 Flow Execution Map

```plaintext
[ Trigger / Flow / Controller ]
            ↓
     [ Service Layer ]
            ↓
     [ throw AppValidationException ]
            ↓
 [ Logger + FlowExecutionLog__c ]
            ↓
 [ Monitoring / Debug Dashboards ]
```

---

## 📚 Related Guides

- [Validation Patterns](./validation-patterns.md)  
  Use `ExceptionUtil` for guard clauses and expressive fail-fast rules.

- [Structured Logging](./structured-logging.md)  
  Log every exception via `Logger` with category, method, and context.

- [ExceptionUtil](./exceptionutil.md)  
  Centralized utility for `throwIfNull`, `require`, and fluent conditions.

---

## 📎 Aligned Fundamentals

- [`MambaDev Coding Style`](../fundamentals/mambadev-coding-style.md)
- [`Apex Style Guide`](../fundamentals/apex-style-guide.md)
- [`Architecture Principles`](../fundamentals/architecture-principles.md)
- [`Review Checklist`](../fundamentals/apex-review-checklist.md)

---

> **MambaDev handles exceptions with clarity.**  
> We don’t just catch errors — **we reveal truth, with structure.** 🧱🔥
