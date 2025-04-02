<p align="center">
  <img src="https://raw.githubusercontent.com/leogbo/mambadev-guides/main/static/img/github_banner_mambadev.png" alt="MambaDev Banner" width="100%" />
</p>

# ✅ Validation Patterns – MambaDev

> This guide defines standard patterns for input and business rule validation in Apex.  
> Designed to be **declarative**, **semantic**, and aligned with MambaDev’s logging and exception architecture.

---

## 🎯 Validation Philosophy

- ✅ Fail fast, fail clearly  
- ✅ Use **exceptions** to represent functional issues — not control flow  
- ✅ Prefer `ExceptionUtil` over inline `if/throw`  
- ✅ Always log **before throwing** on integration or trigger boundaries  
- ✅ Keep logic **clean**, **auditable**, and **testable**

---

## 🔁 Guard Clauses with `ExceptionUtil`

### 1. Required Field

```apex
ExceptionUtil.throwIfBlank(account.Name, 'Account Name is required.');
```

### 2. Required Reference

```apex
ExceptionUtil.throwIfNull(opportunity.AccountId, 'Opportunity must be linked to an Account.');
```

### 3. Rule Assertion

```apex
ExceptionUtil.require(user.Email.endsWith('@company.com'), 'Only corporate emails are allowed.');
```

### 4. Logged + Thrown (Hybrid Pattern)

```apex
if (!isAccountEligible(account)) {
    new Logger()
        .setClass('AccountService')
        .setMethod('checkEligibility')
        .warn('Account not eligible', JSON.serializePretty(account));

    ExceptionUtil.fail('Account is not eligible for conversion.');
}
```

> 🚨 Always log before `fail()` if you're inside a controller, service, or REST class.

---

## 🧪 Validations in Triggers (Before Insert/Update)

```apex
for (Opportunity opp : Trigger.new) {
    ExceptionUtil.throwIfBlank(opp.StageName, 'Stage is required.');
    ExceptionUtil.throwIfNull(opp.CloseDate, 'Close Date is required.');
    ExceptionUtil.throwIf(opp.Amount < 0, 'Amount must be non-negative.');
}
```

> ✅ Keep trigger validations short and expressive.  
> ❌ Never include `Logger` or domain logic in triggers.

---

## 📋 Validation Checklist (Service Layer)

| Validation Type         | Pattern                                                                |
|-------------------------|------------------------------------------------------------------------|
| Required String         | `ExceptionUtil.throwIfBlank(value, msg)`                              |
| Required Object         | `ExceptionUtil.throwIfNull(obj, msg)`                                 |
| Rule Evaluation         | `ExceptionUtil.require(condition, msg)`                               |
| Logged Failure          | `logger.warn(...)` + `ExceptionUtil.fail(msg)`                        |
| Config / Label Missing  | `ExceptionUtil.throwIfBlank(Label.MY_LABEL, 'Label MY_LABEL missing')`|

---

## 🧠 Pro Tips

- Use validations **only in Service layer or Domain logic**
- Always log **before** throwing when at integration or user-entry boundaries
- Prefer semantic exceptions: `AppValidationException` instead of `Exception`
- Keep `ExceptionUtil` usage fluent and expressive
- Always test both **happy** and **fail** paths in unit tests

---

## ❌ Anti-Patterns to Avoid

| Pattern                                | Why it's bad                                             |
|----------------------------------------|----------------------------------------------------------|
| `if (...) throw new Exception()`       | Breaks consistency — use `ExceptionUtil` instead         |
| `throw new Exception('validation')`    | Use `AppValidationException` for clarity and handling    |
| Silent fails (no log)                  | Hides root causes from logs and dashboards               |
| Logging inside domain rules            | Domain must not know infrastructure                      |

---

## 📚 Related Guides

- [ExceptionUtil](./exceptionutil.md)  
  Full reference of guard methods and validation helpers.

- [Exception Handling](./exception-handling.md)  
  How to classify, throw and catch exceptions in Mamba-style.

- [Structured Logging](./structured-logging.md)  
  When and how to log validation failures via `Logger`.

---

## 📎 Aligned Fundamentals

- [`MambaDev Coding Style`](../fundamentals/mambadev-coding-style.md)  
- [`Apex Style Guide`](../fundamentals/apex-style-guide.md)  
- [`Architecture Principles`](../fundamentals/architecture-principles.md)  
- [`Review Checklist`](../fundamentals/apex-review-checklist.md)

---

> In MambaDev, validation isn't defensive.  
> **It's proactive. Semantic. Intentional. And part of the architecture.** 🧱🔥
