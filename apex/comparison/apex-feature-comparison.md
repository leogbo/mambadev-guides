<p align="center">
  <img src="https://raw.githubusercontent.com/leogbo/mambadev-guides/main/static/img/github_banner_mambadev.png" alt="MambaDev Banner" width="100%" />
</p>

# 🔁 Apex Feature Comparison Guide – v2025 (Mamba Mentality)

📎 **Official Shortlink:** [mambadev.io/41XGoTz](https://mambadev.io/41XGoTz)

> “No refactor is legit without explicit comparison, formal review, and proven equivalence.” – Mamba Mentality 🧠🔥

This guide defines how to document, review, and validate Apex refactors with safety, clarity, and traceability.

---

## 📚 Required Related Guides

- 📘 [Master Architecture Guide](https://mambadev.io/42iHzvK)
- 🔍 [Review Guide](https://mambadev.io/3FScojm)
- 🧪 [Testing Guide](https://mambadev.io/3YgDDdx)
- ✅ [Functional Equivalence Checklist](https://mambadev.io/4jjcWx9)

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
- SELECT replaced by `RecordHelper`, `SOQLBuilder`, or DAO  
- Fallback logic updated (`null` → `Optional`, etc.)  
- Logger refactors (`System.debug()` → `Logger.error()`)  
- Variable renaming that affects interfaces or tests  
- Exception handling switched to `ExceptionUtil`  

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
- Updated test coverage via `TestDataSetup`
- Added test for null id fallback

### 🔒 Functional Equivalence Confirmed
✔️ Validated via [mambadev.io/4jjcWx9](https://mambadev.io/4jjcWx9)
```

---

## ✅ When Is Comparison Mandatory?

| Situation                            | Mandatory?   |
|-------------------------------------|--------------|
| Public method changed               | ✅            |
| SELECT replaced by helper           | ✅            |
| Test builder (`*TestDataSetup`) refactor | ✅      |
| Logging logic replaced              | ✅            |
| Spacing or comments only            | ❌            |
| Rename of private var only          | ⚠️ Contextual |
| Test assert added                   | ⚠️ Contextual |

---

## 📌 Advanced Comparison Tips

- Use `git diff --word-diff` to catch subtle logic changes  
- Use `Split View` in VS Code or GitHub PR  
- Compare logs when modifying exception handlers or `Logger` usage  
- Group code by block type during review:
  - 🔍 Queries (SELECT)
  - 🧠 Business rules
  - 🧪 Logger usage
  - 🧱 Exception handling

---

## 🔗 Useful Integrations

| Guide                                         | Contribution                                  |
|----------------------------------------------|-----------------------------------------------|
| [Logger Guide](https://mambadev.io/41WCcDA)   | When replacing `System.debug()`               |
| [Testing Guide](https://mambadev.io/3YgDDdx)  | When confirming equivalence via test          |
| [REST API Guide](https://mambadev.io/428yTrz) | When changing public endpoints or handlers    |

---

## 🧠 Final Thought

> Every improvement needs proof.  
> Every proof needs context.  
> Every change must go through the lens of comparison.

📌 Refactoring without comparison is **improvisation**.  
🧱🧠🧪 #RefactorWithRoots #BeforeVsAfter #ChangeRequiresTraceability
