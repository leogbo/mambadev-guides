<p align="center">
  <img src="https://raw.githubusercontent.com/leogbo/mambadev-guides/main/static/img/github_banner_mambadev.png" alt="MambaDev Banner" width="100%" />
</p>

# 🔁 Apex Feature Comparison Guide – v2025 (Mamba Mentality)

📎 **Official Shortlink:** [bit.ly/ComparacaoApex](https://bit.ly/ComparacaoApex)

> “No refactor is legit without explicit comparison, formal review, and proven equivalence.” – Mamba Mentality 🧠🔥

This guide defines how to document, review, and validate Apex refactors with safety, clarity, and traceability.

---

## 📚 Required Related Guides

- 📘 [Master Architecture Guide](https://bit.ly/GuiaApexMamba)
- 🔍 [Review Guide](https://bit.ly/GuiaApexRevisao)
- 🧪 [Testing Guide](https://bit.ly/GuiaTestsApex)
- ✅ [Functional Equivalence Checklist](https://bit.ly/ConfirmacaoApex)

---

## ✅ What Should Be Compared

🧠 Every refactor must preserve compatibility with functional legacy code. Mamba doesn’t break – Mamba evolves with responsibility.

Whenever possible:
- Keep the original method name
- Add overloads (new method signatures)
- Use optional parameters or helpers to simplify without removing previous behavior

Mandatory comparison situations:
- Public or `@TestVisible` method changes
- Internal structure changes
- Fallback changes (e.g., `null` → `Optional`, `LIMIT 1` → `RecordHelper`)
- Logic block replacements with external helper
- Renaming of visible variables (except private ones without external impact)
- Replacing `System.debug()` with `Logger.info()` or `Logger.error()`

---

## ✅ Minimum Comparison Structure

### ❌ Before
```apex
Account acc = [SELECT Id, Name FROM Account WHERE Id = :id LIMIT 1];
```

### ✅ After
```apex
Account acc = (Account) RecordHelper.getById(Account.SObjectType, id, 'Id, Name');
```

> Every comparison must be documented in a comment, PR, or markdown inside the branch.

---

## 📝 Suggested Pull Request Template

```markdown
### 🔄 Proposed Refactor

- Refactored `buscarConta()` to use `RecordHelper.getById(...)`
- Added fallback to null
- Preserved `@TestVisible` for coverage

### ✅ Before
```apex
Account acc = [SELECT Id FROM Account WHERE Id = :id LIMIT 1];
```

### ✅ After
```apex
Account acc = (Account) RecordHelper.getById(Account.SObjectType, id, 'Id');
```

### 🧪 Tests
- Updated tests with `@TestSetup` and specific coverage
- Added null-id test case

### 🔒 Functional Equivalence Maintained
✔️ Confirmed via [bit.ly/ConfirmacaoApex](https://bit.ly/ConfirmacaoApex)
```

---

## ✅ When Is Comparison Mandatory?

| Situation                            | Mandatory?   |
|-------------------------------------|--------------|
| Public method change                | ✅            |
| SELECT replaced with helper         | ✅            |
| Test builder refactor               | ✅            |
| Log logic change (`Logger`)         | ✅            |
| Only spacing changes                | ❌            |
| Change in `private` variable        | ⚠️ Contextual |
| Assert added in test                | ⚠️ Contextual |

---

## 📌 Advanced Comparison Tips

- Use `git diff --word-diff` to highlight subtle changes
- Use `Side-by-Side` in VS Code to analyze long refactors
- Compare logs when modifying `Logger` or `RestServiceHelper` calls
- Group code blocks by type for comparison:
  - `SELECT`
  - `Logger`
  - `Branch / if`
  - `Serialization`

---

## 🔗 Useful Integrations

| Guide                            | Contribution                                  |
|----------------------------------|-----------------------------------------------|
| [Logger Guide](https://bit.ly/GuiaLoggerApex)     | Common target for refactors                    |
| [Testing Guide](https://bit.ly/GuiaTestsApex)     | Validates equivalence after changes            |
| [REST API Guide](https://bit.ly/Guia_APIs_REST)   | Handlers must be compared when changed         |

---

## 🧠 Final Thought

> Every improvement needs proof.  
> Every proof needs context.  
> Every change must go through the lens of comparison.

📌 Refactoring without comparison is improvisation.  
🧱🧠🧪 #RefactorWithRoots #BeforeVsAfter #ChangeRequiresTraceability

