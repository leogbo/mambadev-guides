<p align="center">
  <img src="https://raw.githubusercontent.com/leogbo/mambadev-guides/main/static/img/github_banner_mambadev.png" alt="MambaDev Banner" width="100%" />
</p>

> 🧱 @status:core | This document defines official MambaDev Apex coding standards.  
> All changes must be reviewed and versioned by the architecture team.  
> Applied modules (e.g., `/apex/`) may evolve from this foundation for scale and compliance.

# 🧱 MambaDev Apex Core Guide – 2025

> **"Excellence is not an option. It's the only way."** – Mamba Mentality

---

## 🎯 Mission

Promote **unbreakable traceability**, **ruthless quality**, and **architectural clarity** in Apex development by enforcing:

- Standardized architecture across all modules  
- Tests with traceable, expressive assertions  
- Structured logging for proactive diagnosis  
- Clear separation of production, test, and mocking code

---

## 🛠️ Non-Negotiable Standards

### ✅ 1. Use `@TestVisible` in logic methods

Every logic-carrying method must:

- Be marked as `@TestVisible`  
- Be **covered in isolation** with meaningful asserts

```apex
@TestVisible private static void calculateProposal() {
    // ...
}
```

---

### ✅ 2. Structured logging with `Logger`

- Never use `System.debug()`  
- Use fluent `Logger` with full context

```apex
new Logger()
  .setClass('MyClass')
  .setMethod('myMethod')
  .error('Proposal calculation failed', e, JSON.serializePretty(proposal));
```

In tests, always use `LoggerMock` to capture logs safely without persistence.

---

### ✅ 3. REST responses with `RestServiceHelper`

Wrap all API responses using `RestServiceHelper`:

```apex
RestServiceHelper.badRequest('Missing required field.');
RestServiceHelper.sendResponse(200, 'Success', result);
```

This ensures:
- Proper status codes
- Standard JSON output
- Headers and formatting enforced

Example response body:

```json
{
  "status": "error",
  "message": "Invalid access token",
  "details": null
}
```

---

### ✅ 4. Test utilities via `TestHelper`

Use safe fake IDs:

```apex
TestHelper.fakeIdForSafe(Proposta__c.SObjectType);
```

Dynamic mocks for test data:

```apex
TestHelper.randomEmail();
TestHelper.fakePhone();
```

---

## 🧪 Mamba-Level Testing

### 🔒 Logging discipline
- Do not assert logs directly  
- Use `LoggerMock` to verify that logging occurred

### 🔁 Standard setup

```apex
@TestSetup
static void setup() {
    TestDataSetup.setupCompleteEnvironment();
}
```

### 🧠 Every assert matters

```apex
System.assertEquals(
    'update_uc',
    res.get('action'),
    'Expected action to be "update_uc", but got: ' + res.get('action')
);

System.assertEquals(
    recordId,
    res.get('record_id'),
    'Expected record_id to match, but got: ' + res.get('record_id')
);
```

---

## 📌 Required Refactor Docs

- Before vs After → [Comparison Guide](https://mambadev.io/41XGoTz)  
- Functional Confirmation → [Equivalence Guide](https://mambadev.io/4jjcWx9)

---

## 🚫 Eliminated Anti-patterns

| 🚫 Anti-pattern         | ✅ Correct Form                        |
|-------------------------|----------------------------------------|
| `System.debug()`        | `Logger().info()` or `.error()`        |
| Logging inside tests    | `LoggerMock` to capture calls          |
| If by SObject type      | Use ID prefix → `recordId.startsWith(...)` |

---

## 🚀 Purpose of This Guide

To ensure that every Apex codebase is:

- 🔐 Secure  
- 🧠 Clear  
- 🧪 Testable  
- 🧱 Traceable  
- 🐍 Mamba

> **"The only failure is the lack of will to be excellent."**
