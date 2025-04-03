<p align="center">
  <img src="https://raw.githubusercontent.com/leogbo/mambadev-guides/main/static/img/github_banner_mambadev.png" alt="MambaDev Banner" width="100%" />
</p>

> 🧱 @status:core | This document defines the official assertion rules for Apex testing in MambaDev.  
> All unit tests must follow these patterns to ensure traceability, clarity, and failure context.

# ✅ Mamba Apex – Assertion Patterns

📎 [Assertion Guide](/docs/apex/fundamentals/mamba-assertion-patterns.md)

> All assertions must express **intent**, reveal **expectation**, and provide **traceable failure context**.

---

## 🎯 Purpose

- 🧪 Clarify test failure reasons immediately  
- 🔍 Improve signal-to-noise in logs and CI output  
- 📋 Enforce behavior-driven testing style  
- 🧱 Support [Mamba Review Checklist](/docs/apex/fundamentals/apex-review-checklist.md)  

---

## 🔍 Pattern: Assert Action Name

```apex
System.assertEquals(
    'update_uc',
    res.get('action'),
    'Expected action to be "update_uc", but got: ' + res.get('action')
);
```

Use when your test validates a string-based outcome such as response keys or flags.

---

## 🔍 Pattern: Assert Record ID Match

```apex
System.assertEquals(
    recordId,
    res.get('record_id'),
    'Expected record_id to match, but got: ' + res.get('record_id')
);
```

Use when the outcome must be tied to a specific `SObject` ID from the test setup.

---

## 🧪 Pattern: Assert with Boolean Condition (Validation Style)

```apex
System.assert(
    opportunity.Amount > 0,
    'Expected opportunity amount to be greater than 0. Got: ' + opportunity.Amount
);
```

Use when you’re enforcing range conditions, thresholds, or validation boundaries.

---

## 🧠 Rule: Assertion Discipline

- ❌ Never leave assertion messages empty  
- ✅ Always explain:
  - What was expected  
  - What was received  
  - Where the failure occurred

> ✅ Format: `"Expected X, got Y – in context Z"`

---

## 🚫 Bad Assertion Example

```apex
System.assertEquals(true, isConverted);
```

✅ Correct version:

```apex
System.assertEquals(true, isConverted, 'Lead should be converted after rule passes');
```

---

## 📎 See Also

- [Mamba Testing Guide](/docs/apex/testing/apex-testing-guide.md)  
- [`ExceptionUtil.cls`](https://github.com/leogbo/mambadev-guides/blob/main/src/classes/exception-util.cls) – For assert-like validations inside logic  
- [`LoggerMock.cls`](https://github.com/leogbo/mambadev-guides/blob/main/src/classes/logger-mock.cls) – Capture logs in tests  
- [`TestHelper.cls`](https://github.com/leogbo/mambadev-guides/blob/main/src/classes/test-helper.cls) – Includes `assertSetupCreated(...)`  
- [Apex Core Style Guide](/docs/apex/fundamentals/mamba-coding-style.md) – General test layout and patterns

---

## 🔁 Suggested Test Structure (Brought Together)

```apex
@IsTest
static void should_return_correct_action_for_uc_update() {
    // Given
    UC__c uc = TestDataSetup.createUC();

    // When
    Map<String, Object> result = MyService.updateUC(uc.Id);

    // Then
    System.assertEquals('update_uc', result.get('action'), 'Expected action "update_uc" for update path');
    System.assertEquals(uc.Id, result.get('record_id'), 'Expected record_id to match UC');
}
```

---

## ✅ Assert Checklist for PRs

| Requirement                        | ✅ Required |
|------------------------------------|------------|
| All `assert` calls include messages | ✅          |
| Message states expected + actual   | ✅          |
| IDs and keys explicitly compared   | ✅          |
| Behavior-level validations present | ✅          |
| Fallbacks and error cases tested   | ✅          |

---

## 🧠 Final Thought

> Every test is a contract.  
> Every assertion is a signature.  
> Write them like your team depends on them — because they do.

**#AssertWithIntent #FailWithContext #MambaTesting #TraceEveryTest**
**#TestBehavior #AssertToProveNotHope #MambaEveryLine** 🧠🧱🔥