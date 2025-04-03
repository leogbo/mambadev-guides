<p align="center">
  <img src="https://raw.githubusercontent.com/leogbo/mambadev-guides/main/static/img/github_banner_mambadev.png" alt="MambaDev Banner" width="100%" />
</p>

# 🔁 Apex Feature Comparison Guide – v2025 (Mamba Mentality)

📎 **Official Shortlink:** [https://mambadev.io/apex-feature-comparison](https://mambadev.io/apex-feature-comparison)

> “No refactor is legit without explicit comparison, formal review, and proven equivalence.” – Mamba Mentality 🧠🔥

This guide defines how to document, review, and validate Apex refactors with safety, clarity, and traceability.

---

## 📚 Required Related Guides

- 📘 [Master Architecture Guide](/docs/apex/fundamentals/mamba-apex-core-guide.md)  
- 🔍 [Review Checklist](/docs/apex/fundamentals/apex-review-checklist.md)  
- 🧪 [Testing Guide](/docs/apex/testing/apex-testing-guide.md)  
- ✅ [Functional Equivalence Checklist](/docs/apex/fundamentals/equivalence-checklist.md)

---

## ✅ What Should Be Compared

🧠 Every refactor must preserve compatibility with legacy functional behavior.  
Mamba doesn’t break — Mamba evolves with responsibility.

Whenever possible:

- Preserve method names (`public`, `@TestVisible`)  
- Add overloads instead of replacing behavior  
- Introduce helpers or optional parameters for clarity  

🚨 Mandatory comparison scenarios:

- Changes in `public` or `@TestVisible` methods  
- `SELECT` replaced by [`RecordHelper.getById(...)`](https://github.com/leogbo/mambadev-guides/blob/main/src/classes/rest-service-helper.cls)  
- Fallback logic updated (`null` → `Optional`, etc.)  
- Logger refactors (`System.debug()` → [`Logger.error(...)`](https://github.com/leogbo/mambadev-guides/blob/main/src/classes/logger.cls))  
- Exception handling switched to [`ExceptionUtil`](https://github.com/leogbo/mambadev-guides/blob/main/src/classes/exception-util.cls)

---

## ✅ Minimum Comparison Template

### ❌ Before

```apex
Account acc = [SELECT Id, Name FROM Account WHERE Id = :id LIMIT 1];
```

### ✅ After

```apex
Account acc = (Account) RecordHelper.getById(Account.SObjectType, id, 'Id, Name');
```

> Document comparisons in comments, pull requests, or in-code markdown.

---

## 📝 Suggested Pull Request Template

```markdown
### 🔄 Proposed Refactor

- Refactored `buscarConta()` to use `RecordHelper.getById(...)`
- Preserved method signature
- Replaced raw SOQL with safe helper
- Maintained `@TestVisible`

### ✅ Before
```apex
Account acc = [SELECT Id FROM Account WHERE Id = :id LIMIT 1];
```

### ✅ After
```apex
Account acc = (Account) RecordHelper.getById(Account.SObjectType, id, 'Id');
```

### 🧪 Tests
- Updated test coverage via [`TestDataSetup`](/src/classes/test-data-setup.cls)
- Added test for null id fallback

### 🔒 Functional Equivalence Confirmed
✔️ Validated via [Equivalence Checklist](/docs/apex/fundamentals/equivalence-checklist.md)
```

---

## ✅ When Is Comparison Mandatory?

| Situation                            | Mandatory?   |
|-------------------------------------|--------------|
| Public method changed               | ✅            |
| `SELECT` replaced by helper         | ✅            |
| Test builder (`*TestDataSetup`) refactor | ✅       |
| Logging logic replaced              | ✅            |
| Spacing or comments only            | ❌            |
| Rename of private var only          | ⚠️ Contextual |
| Test assert added                   | ⚠️ Contextual |

---

## 📌 Advanced Comparison Tips

- Use `git diff --word-diff` to catch subtle logic changes  
- Use Split View in VS Code or GitHub PR  
- Compare logs when modifying exception handlers or `Logger` usage  
- Group code by block type during review:
  - 🔍 Queries (`SELECT`)  
  - 🧠 Business rules  
  - 🪵 Logger usage  
  - 🧱 Exception handling

---

## 🔗 Useful Integrations

| Guide                                              | Purpose                                      |
|---------------------------------------------------|----------------------------------------------|
| [Logger Guide](/docs/apex/logging/logger-implementation.md) | When replacing `System.debug()`              |
| [Testing Guide](/docs/apex/testing/apex-testing-guide.md)   | When confirming behavior equivalence          |
| [REST API Guide](/docs/apex/integrations/rest-api-guide.md) | When changing public endpoints or contracts   |

---

## 🧠 Final Thought

> Every improvement needs proof.  
> Every proof needs context.  
> Every change must go through the lens of comparison.

📌 Refactoring without comparison is **improvisation**.  
🧱🧠🧪 #RefactorWithRoots #BeforeVsAfter #ChangeRequiresTraceability