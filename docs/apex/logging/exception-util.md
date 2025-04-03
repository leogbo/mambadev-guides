<p align="center">
  <img src="https://raw.githubusercontent.com/leogbo/mambadev-guides/main/static/img/github_banner_mambadev.png" alt="MambaDev Banner" width="100%" />
</p>

> 🧱 @status:core | This document defines MambaDev’s official strategy for declarative validations via `ExceptionUtil`.

# ❗ ExceptionUtil – Declarative Guard Utility

📎 [Shortlink: mambadev.io/exceptionutil](https://mambadev.io/exceptionutil)

> MambaDev doesn't throw to crash — we throw to enforce truth.  
> Every exception is a contract that was violated.

---

## 🎯 Purpose

`ExceptionUtil` simplifies validation logic using expressive, testable **guard clauses**.  
It replaces repeated `if/throw` patterns with single-line declarations for:

- ✅ Required fields  
- ✅ Required conditions  
- ✅ Business rule enforcement  
- ✅ Test assertions

---

## 🧠 Why Use It?

```apex
// ❌ Imperative
if (account.Name == null || account.Name.trim() == '') {
    throw new AppValidationException('Account Name is required.');
}

// ✅ Declarative
ExceptionUtil.throwIfBlank(account.Name, 'Account Name is required.');
```

---

## ⚙️ Available Methods

| Method                        | Description                                 |
|-------------------------------|---------------------------------------------|
| `throwIfNull(obj, msg)`      | Throws if `obj == null`                     |
| `throwIfBlank(str, msg)`     | Throws if `str == null || str.trim() == ''` |
| `throwIf(condition, msg)`    | Throws if condition is true                 |
| `require(condition, msg)`    | Throws if condition is false                |
| `fail(msg)`                  | Unconditionally throws an exception         |

---

## 🧾 Common Use Patterns

### ✅ Field Required

```apex
ExceptionUtil.throwIfBlank(contact.Email, 'Email is required');
```

### ✅ Reference Required

```apex
ExceptionUtil.throwIfNull(opp.AccountId, 'Opportunity must have Account');
```

### ✅ Rule Enforcement

```apex
ExceptionUtil.require(invoice.Total > 0, 'Invoice total must be greater than 0');
```

### ✅ Fail Early

```apex
if (!isAccountEligible(acc)) {
    ExceptionUtil.fail('Account not eligible for onboarding');
}
```

---

## 🔁 Trigger Usage

```apex
for (Lead lead : Trigger.new) {
    ExceptionUtil.throwIfBlank(lead.LastName, 'LastName required');
    ExceptionUtil.throwIfBlank(lead.Company, 'Company required');
}
```

---

## 🧪 Unit Test Assertion Example

```apex
@IsTest
static void test_throw_if_blank() {
    try {
        ExceptionUtil.throwIfBlank('', 'Email required');
        System.assert(false, 'Expected AppValidationException');
    } catch (AppValidationException ex) {
        System.assertEquals('Email required', ex.getMessage());
    }
}
```

---

## 🔄 Logging + Rethrow Pattern

```apex
try {
    ExceptionUtil.throwIfNull(config.TemplateId, 'Missing Template ID');
} catch (AppValidationException ex) {
    new Logger()
        .setClass('ConfigValidator')
        .setMethod('validate')
        .warn(ex.getMessage(), null);
    throw ex;
}
```

> ✅ Rethrow after logging for full observability without silent skips.

---

## 🧬 Optional Extensions

You may extend `ExceptionUtil.cls` to support:

- `requireAll(Map<String, Object>)` for multi-field checks  
- `throwIfInvalidMapKey(...)`  
- Fieldset-driven validation for dynamic rules

---

## 📚 Related Guides

- [Validation Patterns](/docs/apex/testing/validation-patterns.md)  
- [Exception Handling](/docs/apex/logging/exception-handling.md)  
- [Structured Logging](/docs/apex/logging/structured-logging.md)  

---

## 📎 Aligned Fundamentals

- [MambaDev Coding Style](/docs/apex/fundamentals/mamba-coding-style.md)  
- [Apex Style Guide](/docs/apex/fundamentals/apex-style-guide.md)  
- [Architecture Principles](/docs/apex/fundamentals/architecture-principles.md)  
- [Review Checklist](/docs/apex/fundamentals/apex-review-checklist.md)

---

> Every `throw` is a line in your contract with the system.  
> In MambaDev, that contract is not optional — it’s enforced.

**#FailFastWithClarity #GuardWithIntent #MambaExceptionsAreArchitectural**