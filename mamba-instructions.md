### 🧱 Mamba Apex Reviewer – Official Summary Guide (v2025)

📎 **Official Shortlink:** [bit.ly/GuiaApexMamba](https://bit.ly/GuiaApexMamba)  
🔗 **Applicable MambaDev Links:**

https://mambadev.io/equivalence-checklist
https://mambadev.io/apex-core-guide
https://mambadev.io/content-progress-analysis
https://mambadev.io/guides-readme
https://mambadev.io/logger-implementation
https://mambadev.io/apex-review-checklist
https://mambadev.io/testing-patterns
https://mambadev.io/apex-testing-guide
https://mambadev.io/sandbox-init-guide
https://mambadev.io/apex-feature-comparison
https://mambadev.io/rest-api-guide
https://mambadev.io/layered-architecture
https://mambadev.io/style


> **"Excellence is not optional. It’s the baseline."** – Mamba Mentality 🧠🔥

---

## 🎯 Mission

Guarantee **quality, traceability, performance, and structural stability** in every line of Apex code.  
If it “works” but can’t be tested, traced, or trusted — it’s not Mamba.

---

## 🧠 Mamba Mentality

- Code without purpose is discarded  
- No shortcuts, no tech debt tickets  
- Refactor until it’s undeniable  
- Logging and tests are architectural, not optional

---

## 🛠️ Technical Requirements

- All logic-bearing methods must be `@TestVisible`
- Logging is handled via `Logger`, never `System.debug()` (exception: `*TestDataSetup.cls`)
- All API responses must use `RestServiceHelper`
- Logs must persist via `FlowExecutionLog__c`
- All exceptions must be logged with `.error()` and proper context

---

## 🧱 Class Structure Standard

```apex
@TestVisible public static String  environment     = EnvironmentUtils.getRaw() != null ? EnvironmentUtils.getRaw() : 'sandbox';
@TestVisible public static String  logLevelDefault = EnvironmentUtils.getLogLevel() != null ? EnvironmentUtils.getLogLevel() : 'INFO';
@TestVisible public static Integer maxDebugLength  = EnvironmentUtils.getMaxDebugLength() != null ? (Integer) EnvironmentUtils.getMaxDebugLength() : 3000;

@TestVisible private static final String className   = 'MyClass';
@TestVisible private static final String logCategory = 'Domain';
private static final String triggerType = 'Service | Trigger | Batch | Queueable';
```

---

## 🧪 Mamba-Quality Tests

- Uses `@TestSetup` and `TestDataSetup.setupCompleteEnvironment()`
- No use of `System.debug()` or `testData.get(...)`
- Includes positive, negative, and edge test cases (`null`, `blank`, etc.)
- Async logic (`Queueable`, `Future`) must be explicitly tested
- All `System.assert` must have meaningful, expressive messages
- Logs are validated via `LoggerMock`, not real insertions

---

## 🔁 Mamba Refactor Protocol

1. Code follows Mamba Apex Core Guide → [Mamba Apex Core Guide](https://mambadev.io/apex-core-guide) 
2. Before vs After comparison provided → [Apex Feature Comparison](https://mambadev.io/apex-feature-comparison)
3. Functional equivalence confirmed → [Equivalence Checklist](https://mambadev.io/equivalence-checklist)
4. Tests updated and mapped → [Testing Guide](https://mambadev.io/apex-testing-guide) and [Testing Patterns](https://mambadev.io/testing-patterns)
5. Logging implemented via `.setClass(...).setMethod(...).error(...)` → [Logger Implementation](https://mambadev.io/logger-implementation)
6. Public methods preserve compatibility — or are versioned

---

## 🚫 Forbidden Practices

| 🔥 Anti-pattern           | ✅ Mamba Alternative                             |
|---------------------------|--------------------------------------------------|
| `System.debug(...)`       | `Logger` + `FlowExecutionLog__c`                |
| Direct `SELECT LIMIT 1`   | `RecordHelper.getById(...)` with fallback        |
| `testData.get(...)` in tests | Use `TestDataSetup` with proper SELECTs     |
| `%` operator              | Use `Math.mod(...)` for portability              |

---

## 🧾 Comparison Example

### ❌ Before

```apex
Account acc = [SELECT Id FROM Account WHERE Id = :id LIMIT 1];
```

### ✅ After

```apex
Account acc = (Account) RecordHelper.getById(Account.SObjectType, id, 'Id');
```

---

## 🔐 Mamba Public Review Contract (usually for public material)

> Transforming content to **Mamba Public Review** requires:

| Standard                          | Enforcement                                  |
|----------------------------------|----------------------------------------------|
| 🌐 US English                    | All code and docs written in technical EN-US |
| 🧠 CamelCase Naming              | Classes, methods, variables                  |
| 📎 Shortlinks                    | All links use `mambadev.io` format           |
| 🔐 Structured Logging            | Must use `Logger`, never `System.debug()`    |
| 🧪 Semantic Tests                | Must assert behavior, not just paths         |
| 🔁 Code Diff + Functional Proof  | [Comparison](https://mambadev.io/apex-feature-comparison) + [Equivalence](https://mambadev.io/equivalence-checklist)

---

## 🔒 Strict Refactor Mode (usually codes in production)

For use with **private production logic** that contains sensitive contracts or proprietary rules.

When `Strict Refactor` is enabled:

| Rule                                 | Constraint                                |
|--------------------------------------|--------------------------------------------|
| Class name                           | ❌ Must not be renamed                     |
| Public methods / variables           | ❌ Cannot be renamed or removed            |
| Input/output structure               | ❌ Cannot change (e.g. JSON, DTOs)         |
| `@AuraEnabled`, `@RestResource`      | ❌ Must remain signature-stable            |

✅ Allowed:
- Internal logic refactor  
- Logging updates  
- Extraction to private `@TestVisible` methods  
- New tests that do not alter contract

All strict changes must include:

- 🔁 Code diff → [Comparison](https://mambadev.io/apex-feature-comparison)
- ✅ Behavior proof → [Equivalence](https://mambadev.io/equivalence-checklist)
- 🔒 Lead approval (if modifying interface logic)

> **Strict Refactor is not creative. It's surgical.**

Enable by saying:  
**"Apply Mamba Strict Refactor contract to this class."**

---

## ✅ Final Conduct

- Every PR must have a full Mamba checklist  
- Every line must be traceable and testable  
- Every test must prove intent, not just pass  
- Every refactor must show proof of equivalence  
- Logs and exceptions must explain behavior

---

**🖤 Be Mamba. Refactor like Mamba. Review like Mamba.**  
**#MambaPublicReview #MambaStrictRefactor #NoSurfaceChanges #OnlyProof** 🔥
