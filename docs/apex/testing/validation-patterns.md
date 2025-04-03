<p align="center">
  <img src="https://raw.githubusercontent.com/leogbo/mambadev-guides/main/static/img/github_banner_mambadev.png" alt="MambaDev Banner" width="100%" />
</p>

> 🧱 @status:core | This guide defines standard patterns for validation in Apex — using expressive guard clauses, semantic exceptions, and Logger integration.

# ✅ Validation Patterns – MambaDev

📎 [Shortlink: mambadev.io/validation-patterns](https://mambadev.io/validation-patterns)

> Validation in MambaDev isn’t defensive.  
> It’s **proactive. Semantic. Intentional. Auditable.**

---

## 🎯 Validation Philosophy

Apex validations must:

- ✅ Fail fast, fail clearly  
- ✅ Express meaning (not just control)  
- ✅ Use `ExceptionUtil` for readability  
- ✅ Log all failures where needed  
- ✅ Be testable and isolated

---

## 🔁 Guard Clauses with `ExceptionUtil`

### 1. Required Field

```apex
ExceptionUtil.throwIfBlank(account.Name, 'Account Name is required.');
```

### 2. Required Reference

```apex
ExceptionUtil.throwIfNull(opportunity.AccountId, 'Opportunity must have an Account.');
```

### 3. Rule Assertion

```apex
ExceptionUtil.require(user.Email.endsWith('@company.com'), 'Only corporate emails allowed.');
```

### 4. Logged + Thrown (Hybrid Pattern)

```apex
if (!isEligible(account)) {
    new Logger()
        .setClass('AccountService')
        .setMethod('checkEligibility')
        .warn('Account not eligible', JSON.serializePretty(account));

    ExceptionUtil.fail('Account is not eligible for onboarding.');
}
```

> ⚠️ Always `Logger.warn(...)` before `fail()` inside services, APIs, and integrations.

---

## 🧪 Validations in Triggers

```apex
for (Opportunity opp : Trigger.new) {
    ExceptionUtil.throwIfBlank(opp.StageName, 'Stage is required');
    ExceptionUtil.throwIfNull(opp.CloseDate, 'Close Date required');
    ExceptionUtil.throwIf(opp.Amount < 0, 'Amount must be non-negative');
}
```

✅ Keep trigger validations flat and declarative  
❌ Never log or call services in Trigger context

---

## 📋 Validation Checklist (Service Layer)

| Validation Scenario      | Pattern                                             |
|--------------------------|-----------------------------------------------------|
| Missing String           | `throwIfBlank(value, 'Field is required')`         |
| Null Object              | `throwIfNull(obj, 'Missing object')`               |
| Boolean Rule             | `require(condition, 'Must satisfy rule')`          |
| Logged Failure           | `logger.warn(...) + ExceptionUtil.fail(...)`       |
| Config Required          | `throwIfBlank(Label.XYZ, 'Missing label XYZ')`     |

---

## 🧠 Best Practices

- ✅ Perform validations in Services or Domain Logic  
- ✅ Throw only semantic exceptions (e.g. `AppValidationException`)  
- ✅ Never suppress or ignore errors silently  
- ✅ Tests must assert both happy and error paths  
- ✅ Use `LoggerMock` in tests to inspect logs

---

## ❌ Anti-Patterns

| 🚫 Pattern                      | ⚠️ Why Not                               |
|--------------------------------|------------------------------------------|
| `throw new Exception()`        | Lacks semantic intent                    |
| `if (x) { throw ... }`         | Use declarative `ExceptionUtil` instead  |
| No logging before fail         | Missed diagnostics                       |
| Logging inside domain rule     | Violates DDD boundaries                  |

---

## 📚 Related Guides

- [ExceptionUtil](/docs/apex/logging/exception-util.md)  
- [Exception Handling](/docs/apex/logging/exception-handling.md)  
- [Structured Logging](/docs/apex/logging/structured-logging.md)  
- [Testing Patterns](/docs/apex/testing/testing-patterns.md)

---

## 📎 Aligned Fundamentals

- [MambaDev Coding Style](/docs/apex/fundamentals/mamba-coding-style.md)  
- [Architecture Principles](/docs/apex/fundamentals/architecture-principles.md)  
- [Review Checklist](/docs/apex/fundamentals/apex-review-checklist.md)

---

> MambaDev doesn’t validate with `if` statements.  
> We validate with intent.  
> We log failures.  
> We guard truth.

**#ValidateWithPurpose #FailFastWithClarity #SemanticGuardsOnly** 🧱🧠🔥