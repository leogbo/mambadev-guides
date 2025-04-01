<p align="center">
  <img src="https://raw.githubusercontent.com/leogbo/mambadev-guides/main/static/img/github_banner_mambadev.png" alt="MambaDev Banner" width="100%" />
</p>

# Exception Handling – MambaDev Pattern

> This guide defines the official MambaDev strategy for handling exceptions in Apex.
> It focuses on semantic clarity, structured logging, and testable outcomes.

---

## 🎯 Purpose

In Apex, exceptions should not be used as generic control flow.  
They should **represent clear and distinct categories of failure**, and trigger appropriate responses such as logging, user feedback, or halting execution.

---

## 🧱 Custom Exception Types

All exceptions must inherit from `CustomException`.  
This base class is declared as `virtual` and extends `Exception`, allowing your own functional exception types.

### ✅ Standard MambaDev Exceptions

| Class                         | Description                                                 |
|------------------------------|-------------------------------------------------------------|
| `CustomException`            | Abstract base for all custom exceptions                    |
| `AppValidationException`     | Input validation or business rule not met                  |
| `AppIntegrationException`    | Callout or system integration error                        |
| `AppAuthenticationException` | Token/auth failure, user not authorized                    |
| `AppConfigurationException`  | Missing or invalid system configuration                    |

All of them are lightweight, semantic, and follow the same docstring and naming convention.

---

## 🧠 Throwing Semantic Exceptions

### 🔴 Incorrect

```apex
throw new Exception('Name is required');
```

### ✅ Correct

```apex
throw new AppValidationException('Account Name is required.');
```

---

## 🔁 Structured Try/Catch with Logger

```apex
try {
    new AccountService().execute(input);
} 
catch (AppValidationException ve) {
    new Logger()
        .setClass('AccountService')
        .setMethod('execute')
        .setCategory('Validation')
        .warn('Validation failed: ' + ve.getMessage(), JSON.serialize(input));
}
catch (AppIntegrationException ie) {
    new Logger().setClass('AccountService')
        .error('Integration error occurred', ie, null);
}
catch (Exception ex) {
    new Logger().setClass('AccountService')
        .error('Unexpected error', ex, null);
}
```

---

## ✅ Exception Handling Checklist

- [x] Use specific exception types — avoid generic `Exception`
- [x] Always log failures if they're caught (unless in test context)
- [x] Use `Logger.error(message, ex, context)` to track failures properly
- [x] Use `JSON.serializePretty()` when logging context objects
- [x] Consider rethrowing with enriched message if needed

---

## 🔐 Flow Map

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
  Declarative validation rules using `ExceptionUtil` and guard clauses.

- [Structured Logging](./structured-logging.md)  
  Logging best practices using the `Logger` class.

- [ExceptionUtil](./exceptionutil.md)  
  Utility for asserting conditions and throwing exceptions consistently.

## 📎 Aligned Fundamentals

These operational guides are built on:

- [`MambaDev Coding Style`](../fundamentals/mambadev-coding-style.md)
- [`Apex Style Guide`](../fundamentals/apex-style-guide.md)
- [`Architecture Principles`](../fundamentals/architecture-principles.md)
- [`Review Checklist`](../fundamentals/apex-review-checklist.md)

---

> MambaDev handles exceptions with clarity, not just catching errors — but revealing truth.
