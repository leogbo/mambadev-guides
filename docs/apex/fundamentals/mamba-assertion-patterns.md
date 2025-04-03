<p align="center">
  <img src="https://raw.githubusercontent.com/leogbo/mambadev-guides/main/static/img/github_banner_mambadev.png" alt="MambaDev Banner" width="100%" />
</p>

> 🧱 @status:core | This document defines the official assertion rules for Apex testing in MambaDev.  
> All unit tests must follow these patterns to ensure traceability, clarity, and failure context.

# ✅ Mamba Apex – Assertion Patterns

📎 [Assertion Guide](/docs/apex/fundamentals/mamba-assertion-patterns.md)

> All assertions must express **intent**, reveal **expectation**, and provide **traceable failure context**.

---

## 🔍 Pattern: Assert Action Name

```apex
System.assertEquals(
    'update_uc',
    res.get('action'),
    'Expected action to be "update_uc", but got: ' + res.get('action')
);
```

---

## 🔍 Pattern: Assert Record ID Match

```apex
System.assertEquals(
    recordId,
    res.get('record_id'),
    'Expected record_id to match, but got: ' + res.get('record_id')
);
```

---

## 🧱 Assertion Rule (Mamba Mentality)

- ❌ Never leave assertion messages empty  
- ✅ Always express:  
  - What was expected  
  - What was received  
  - Where it failed (e.g., `"record_id" mismatch in update flow"`)

---

## 🧪 Bonus: Assert with Condition (Validation Style)

```apex
System.assert(
    opportunity.Amount > 0,
    'Expected opportunity amount to be greater than 0. Got: ' + opportunity.Amount
);
```

---

## 📎 See Also

- [Mamba Testing Guide](/docs/apex/testing/apex-testing-guide.md)  
- [ExceptionUtil for validations](/src/classes/exception-util.cls)  
- [LoggerMock for log assertions](/src/classes/logger-mock.cls)  
- [TestHelper.assertSetupCreated()](/src/classes/test-helper.cls)

---

> Assert like every line matters — because it does.  
> **#AssertWithIntent #FailWithContext #MambaTesting**