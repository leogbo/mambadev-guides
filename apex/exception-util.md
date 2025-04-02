<p align="center">
  <img src="https://raw.githubusercontent.com/leogbo/mambadev-guides/main/static/img/github_banner_mambadev.png" alt="MambaDev Banner" width="100%" />
</p>

# ExceptionUtil – Declarative Guard Utility

> This guide documents the use of `ExceptionUtil`, MambaDev’s utility class for declaring **semantic, defensive validations**.  
> It replaces imperative `if/throw` checks with **expressive, testable guard clauses** using `AppValidationException`.

---

## 🎯 Purpose

`ExceptionUtil` allows developers to:

- ✅ Eliminate repetitive `if/throw` blocks
- ✅ Express preconditions in a single line
- ✅ Enforce business rules with clarity and traceability
- ✅ Keep services and controllers focused on **logic, not boilerplate**

---

## 🧠 Why Use It?

```apex
// Instead of:
if (account.Name == null || account.Name.trim() == '') {
    throw new AppValidationException('Account Name is required.');
}

// Use:
ExceptionUtil.throwIfBlank(account.Name, 'Account Name is required.');
```

---

## ⚙️ Available Methods

| Method                            | Purpose                                                               |
|----------------------------------|-----------------------------------------------------------------------|
| `throwIfNull(obj, msg)`          | Throws if the object is `null`                                       |
| `throwIfBlank(str, msg)`         | Throws if the string is `null` or whitespace                         |
| `throwIf(condition, msg)`        | Throws if the condition evaluates to `true`                          |
| `require(condition, msg)`        | Throws if the condition evaluates to `false`                         |
| `fail(msg)`                      | Always throws — useful for explicit rejection points                 |

---

## 🔁 Guard Examples

### ✅ Required Field

```apex
ExceptionUtil.throwIfBlank(contact.Email, 'Email is required.');
```

### ✅ Required Reference

```apex
ExceptionUtil.throwIfNull(opportunity.AccountId, 'Opportunity must have an Account.');
```

### ✅ Rule Validation

```apex
ExceptionUtil.require(invoice.Amount > 0, 'Invoice amount must be greater than zero.');
```

### ✅ Explicit Fail

```apex
if (!isAccountEligible(account)) {
    ExceptionUtil.fail('Account is not eligible for onboarding.');
}
```

---

## 🔀 Trigger Usage

```apex
for (Lead lead : Trigger.new) {
    ExceptionUtil.throwIfBlank(lead.LastName, 'LastName is required');
    ExceptionUtil.throwIfBlank(lead.Company, 'Company is required');
}
```

---

## 🧪 Testing Validations

```apex
@IsTest
static void testShouldThrowIfBlank() {
    try {
        ExceptionUtil.throwIfBlank('', 'Should throw');
        System.assert(false, 'Expected exception');
    } catch (AppValidationException ex) {
        System.assertEquals('Should throw', ex.getMessage());
    }
}
```

---

## 📈 Logging + Exception Pattern

```apex
try {
    ExceptionUtil.throwIfNull(config.DefaultTemplateId, 'Missing template config');
} catch (AppValidationException ex) {
    new Logger()
        .setClass('ConfigValidator')
        .setMethod('validateTemplate')
        .warn(ex.getMessage(), null);

    throw ex;
}
```

> 🧱 Logging + rethrow guarantees traceability without breaking flow.

---

## 🧬 Optional Extensions (Advanced)

You may extend `ExceptionUtil` to support:

- Field masking & redaction on logs
- Declarative `requireAll(...)`, `validateMap(...)` patterns
- Dynamic field rule evaluation using FieldSet metadata

---

## 📚 Related Guides

- [Validation Patterns](./validation-patterns.md)  
  Declarative, auditable validation logic in Apex.

- [Exception Handling](./exception-handling.md)  
  Strategy for try/catch with semantic exception types.

- [Structured Logging](./structured-logging.md)  
  Best practices for logging using `Logger`.

---

## 📎 Aligned Fundamentals

These operational guides support the `ExceptionUtil` standard:

- [`MambaDev Coding Style`](../fundamentals/mambadev-coding-style.md)
- [`Apex Style Guide`](../fundamentals/apex-style-guide.md)
- [`Architecture Principles`](../fundamentals/architecture-principles.md)
- [`Review Checklist`](../fundamentals/apex-review-checklist.md)

---

> **MambaDev doesn't throw exceptions to crash code — we throw to enforce what must never be violated.**
