<p align="center">
  <img src="https://raw.githubusercontent.com/leogbo/mambadev-guides/main/static/img/github_banner_mambadev.png" alt="MambaDev Banner" width="100%" />
</p>

# ExceptionUtil – Declarative Guard Utility

> This guide documents the use of `ExceptionUtil`, MambaDev’s utility class for declaring defensive and semantic validations.  
> It replaces low-level `if` checks with expressive, testable guard clauses using `AppValidationException`.

---

## 🎯 Purpose

`ExceptionUtil` allows developers to:

- ✅ Eliminate repetitive `if/throw` blocks
- ✅ Express preconditions in a single line
- ✅ Enforce business logic with clarity and traceability
- ✅ Keep service and controller logic focused on behavior, not boilerplate

---

## 🧠 Why Use It?

```apex
// Instead of this:
if (account.Name == null || account.Name.trim() == '') {
    throw new AppValidationException('Account Name is required.');
}

// Use this:
ExceptionUtil.throwIfBlank(account.Name, 'Account Name is required.');
```

---

## ⚙️ Available Methods

| Method                            | Purpose                                                               |
|----------------------------------|-----------------------------------------------------------------------|
| `throwIfNull(obj, msg)`          | Throws if the object is null                                         |
| `throwIfBlank(str, msg)`         | Throws if the string is null or whitespace                           |
| `throwIf(condition, msg)`        | Throws if the condition is true                                      |
| `require(condition, msg)`        | Throws if the condition is false                                     |
| `fail(msg)`                      | Always throws (useful for explicit failure points)                   |

---

## 🔁 Examples

### ✅ Required Field

```apex
ExceptionUtil.throwIfBlank(contact.Email, 'Email is required.');
```

### ✅ Required Reference

```apex
ExceptionUtil.throwIfNull(opportunity.AccountId, 'Opportunity must have an Account.');
```

### ✅ Conditional Validation

```apex
ExceptionUtil.require(invoice.Amount > 0, 'Invoice amount must be greater than zero.');
```

### ✅ Fallback Rule

```apex
if (!isAccountEligible(account)) {
    ExceptionUtil.fail('Account is not eligible for onboarding.');
}
```

---

## 🔬 Usage in Triggers

```apex
for (Lead lead : Trigger.new) {
    ExceptionUtil.throwIfBlank(lead.LastName, 'LastName is required');
    ExceptionUtil.throwIfBlank(lead.Company, 'Company is required');
}
```

---

## 🧪 Unit Testing Validations

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

## ✅ Integration with Logger

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

---

## 🔁 Optional Extensions (Advanced)

You may extend `ExceptionUtil` to support:

- Masked field validation
- Declarative field-by-field builders (`requireAll`, `validateMap`)
- FieldSet-aware rules for dynamic objects

---

## 📚 Related Guides

- [Validation Patterns](./validation-patterns.md)  
  How to write declarative, auditable validation logic in Apex.

- [Exception Handling](./exception-handling.md)  
  Strategy for structured try/catch using semantic exception types.

- [Logger Class](./structured-logging.md)  
  Use alongside `ExceptionUtil` to capture validation failures cleanly.

## 📎 Aligned Fundamentals

These operational guides are built on:

- [`MambaDev Coding Style`](../fundamentals/mambadev-coding-style.md)
- [`Apex Style Guide`](../fundamentals/apex-style-guide.md)
- [`Architecture Principles`](../fundamentals/architecture-principles.md)
- [`Review Checklist`](../fundamentals/apex-review-checklist.md)

---

> MambaDev doesn't throw exceptions to stop the code.  
> It throws to reveal what should never be allowed to happen.
