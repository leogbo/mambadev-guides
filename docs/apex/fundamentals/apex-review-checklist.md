<p align="center">
  <img src="https://raw.githubusercontent.com/leogbo/mambadev-guides/main/static/img/github_banner_mambadev.png" alt="MambaDev Banner" width="100%" />
</p>

> 🧱 @status:core | This document defines official MambaDev Apex review standards.  
> All changes must be versioned and approved by architecture leads.  
> Consumer guides (e.g., `/apex/`) may extend this foundation for specific use cases.

# 🔍 Apex Review Checklist – v2025 (MambaDev Standard)

📎 **Shortlink:** `/docs/apex/fundamentals/apex-review-checklist.md`

> “Review is the final filter of excellence. No line survives without purpose.” – Mamba Mentality 🧠🔥

---

## 📚 Related Core Guides

- 📘 [Architecture Guide](/docs/apex/fundamentals/mamba-apex-core-guide.md)  
- 🧪 [Testing Guide](/docs/apex/testing/apex-testing-guide.md)  
- 🪵 [Logger Guide](/docs/apex/logging/logger-implementation.md)  
- 🧱 [Test Data Setup](/docs/apex/testing/test-data-setup.md)  
- 🔁 [Feature Comparison Guide](/docs/apex/fundamentals/apex-feature-comparison.md)  
- ✅ [Equivalence Checklist](/docs/apex/fundamentals/equivalence-checklist.md)

---

## ✅ Core Review Principles

- **Traceability before performance**  
- **Boilerplate is predictability**  
- **Passing tests ≠ sufficient tests**  
- **Code should explain itself — the log should confirm it**

---

## 🧾 Mamba Review Checklist

### 🔒 Architecture & Structure
- [ ] Includes classification tags - [Apex Classification Tags](https://guides.mambadev.io/docs/apex/fundamentals/mamba-apex-classification-tags.md)
- [ ] Uses [`RecordHelper.getById(...)`](https://github.com/leogbo/mambadev-guides/blob/main/src/classes/rest-service-helper.cls) instead of raw `SELECT LIMIT 1`
- [ ] Logs critical paths to `FlowExecutionLog__c` when applicable
- [ ] No use of `System.debug()` outside of test factories
- [ ] Public and `@TestVisible` methods are backwards compatible
- [ ] Versioning applied for REST handlers (`v2`, `v3`, etc.)

---

### 🧪 Testing & Validation

- [ ] Has `@TestSetup` using `TestDataSetup.setupCompleteEnvironment()`
- [ ] `SELECT LIMIT 1` includes fallback to avoid `QueryException`
- [ ] All `System.assert(...)` include message and assert **meaning**
- [ ] No use of `testData.get(...)` inside test methods
- [ ] Uses [`TestHelper.fakeIdForSafe(...)`](/src/classes/test-helper.cls) for fallback scenarios
- [ ] Negative test case included (`exceptionThrown` or fail path)
- [ ] Async behavior tested if code includes `Queueable`, `Future`, etc.

---

### 🔁 Refactor Checks

- [ ] Before vs After documented → [Feature Comparison Guide](/docs/apex/fundamentals/apex-feature-comparison.md)
- [ ] Functional equivalence confirmed → [Equivalence Checklist](/docs/apex/fundamentals/equivalence-checklist.md)
- [ ] All `null` / `blank` / `invalid` inputs have fallback
- [ ] Null-safe checks in all list returns / optional lookups
- [ ] No breaking changes to REST contracts or public methods

---

## 🚫 Forbidden Patterns

| ❌ Pattern               | ✅ Correct Alternative                       |
|--------------------------|----------------------------------------------|
| `System.debug(...)`      | Use [`Logger`](/src/classes/logger.cls)     |
| `SELECT ... LIMIT 1`     | Use [`RecordHelper.getById(...)`](https://github.com/leogbo/mambadev-guides/blob/main/src/classes/rest-service-helper.cls) |
| `testData.get(...)`      | Use `SELECT` after `@TestSetup`              |
| `a % b` (modulo)         | Use `Math.mod(a, b)`                         |
| `padLeft`, `padRight`    | Use `String.format()` or manual handling     |

---

## 📌 Before vs After Example

### ❌ Before

```apex
Account acc = [SELECT Id, Name FROM Account WHERE Id = :id LIMIT 1];
```

### ✅ After

```apex
Account acc = (Account) RecordHelper.getById(Account.SObjectType, id, 'Id, Name');
```

---

## 🧠 Assertion Examples (Mamba Style)

```apex
System.assertEquals(1, accounts.size(), 'Expected 1 account, got: ' + accounts.size());
System.assertNotEquals(null, account, 'Account should not be null');
```

---

## 🧪 Fallback Testing Example

```apex
List<UC__c> ucs = [SELECT Id FROM UC__c LIMIT 1];
if (ucs.isEmpty()) {
    TestHelper.assertSetupCreated('UC__c');
}
UC__c uc = ucs[0];
```

---

## 📄 Pull Request Review Template (Mamba Style)

```markdown
### 🧠 Review Summary

- [x] Full checklist completed
- [x] Logger used instead of System.debug
- [x] Tests include negative case and async path
- [x] FlowExecutionLog__c logs added in service methods
- [x] No breaking signature change
- [x] Refactor validated → [Comparison](/docs/apex/fundamentals/apex-feature-comparison.md)
- [x] Functional behavior confirmed → [Equivalence](/docs/apex/fundamentals/equivalence-checklist.md)
```

---

## 🚫 Bad Refactor Example

```diff
- public Map<String, Object> getAccount(String id) {
-     Account acc = [SELECT Id, Name FROM Account WHERE Id = :id LIMIT 1];
-     return new Map<String, Object>{ 'Id' => acc.Id, 'Name' => acc.Name };
- }
+ public Map<String, Object> getAccountWithDocument(String id) {
+     Account acc = [SELECT Id, Name, Document__c FROM Account WHERE Id = :id LIMIT 1];
+     return new Map<String, Object>{ 'Id' => acc.Id, 'Document' => acc.Document__c };
+ }
```

❌ **Problem:** You removed `getAccount(...)` — breaking compatibility  
✅ **Correct:** Keep the original method and extend with a new one if needed

---

## 🧠 Final Words

Code review isn’t just approval — it’s validation that:

- ✅ Behavior is traceable  
- ✅ Logs are structured  
- ✅ Tests fail for the right reasons  
- ✅ No regression slips into production

📌 **No code is considered reviewed without a completed checklist.**

🧠🧱🧪 #MambaReview #ExcellenceGatekeeper #NothingUnvalidated