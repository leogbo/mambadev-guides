### 🧱 Mamba Apex Reviewer – Official Guide (v2025)

🔗 MambaDev Links by Category:

- 🧱 Core: https://mambadev.io/apex-core-guide
- 🧪 Testing: https://mambadev.io/apex-testing-guide • https://mambadev.io/testing-patterns
- 🪵 Logging: https://mambadev.io/logger-implementation
- 🔁 Refactor: https://mambadev.io/apex-feature-comparison • https://mambadev.io/equivalence-checklist
- 🧩 Architecture: https://mambadev.io/layered-architecture • https://mambadev.io/rest-api-guide • https://mambadev.io/style

> **"Excellence is not optional. It’s the baseline."** — Mamba Mentality 🧠🔥

---

## 🎯 Mission

Ensure all Apex code is traceable, testable, modular, and stable.  
No shortcuts. No guesswork. Every line must justify its existence.

---

## 🧠 Mamba Mentality Principles

- Code without purpose is rejected  
- Logs and tests are architectural, not optional  
- Refactor until the code is undeniable  
- No `System.debug()` — ever

---

## 🛠️ Core Standards

- Logic methods: `@TestVisible` + direct test coverage  
- Logging: only via `Logger` (supports `.info()`, `.warn()`, `.error()`); never `System.debug()`  
- API responses via `RestServiceHelper`  
- Logs persist via `FlowExecutionLog__c`
- Every exception must be logged with full context

---

## 🧱 Class Skeleton (Mamba Format)
```apex
@TestVisible public static String environment = EnvironmentUtils.getRaw() ?? 'sandbox';
@TestVisible public static String logLevelDefault = EnvironmentUtils.getLogLevel() ?? 'INFO';
@TestVisible public static Integer maxDebugLength = (Integer)(EnvironmentUtils.getMaxDebugLength() ?? 3000);
@TestVisible private static final String className = 'MyClass';
@TestVisible private static final String logCategory = 'Domain';
private static final String triggerType = 'Service | Queueable | Trigger';
```

---

## 🧪 Test Expectations

- Uses `@TestSetup` + `TestDataSetup.setupCompleteEnvironment()`  
- Includes happy path + null/blank/error edge cases  
- Uses `LoggerMock` for all log assertions  
- Async logic (`Queueable`, `Future`) must be tested  
- `System.assert*()` must include clear messages  
- No `testData.get(...)`, no DML in method bodies

---

## 🔁 Refactor Protocol

1. Follow architecture → https://mambadev.io/apex-core-guide  
2. Show before vs after → https://mambadev.io/apex-feature-comparison  
3. Confirm equivalence → https://mambadev.io/equivalence-checklist  
4. Update tests → https://mambadev.io/apex-testing-guide  
5. Log properly → https://mambadev.io/logger-implementation  
6. Public APIs remain unchanged or are versioned
7. Always use mambadev.io/ shortened links and alert in case of missing links to replace not mambadev.io links
---

## 🚫 Anti-Patterns

| ❌ Don’t use              | ✅ Use instead                               |
|--------------------------|---------------------------------------------|
| `System.debug()`         | `Logger().error(...)` with `FlowExecutionLog__c` |
| `SELECT ... LIMIT 1`     | `RecordHelper.getById(...)` with fallback   |
| `testData.get(...)`      | Use actual SELECT after setup               |
| `%` operator             | Use `Math.mod(...)`                         |

---

## 🧾 Comparison Example

```apex
// ❌ Before:
Account acc = [SELECT Id FROM Account WHERE Id = :id LIMIT 1];
// ✅ After:
Account acc = (Account) RecordHelper.getById(Account.SObjectType, id, 'Id');
```

---

## 🔐 Public Review Contract

| Rule                         | Enforcement                                |
|------------------------------|---------------------------------------------|
| 🌐 US English                | All docs/code must be in technical EN       |
| 🧠 CamelCase Naming          | Classes, methods, variables                 |
| 📎 MambaDev Shortlinks       | Use `mambadev.io/...` in all docs           |
| 🔐 Logging via `Logger`      | No `System.debug()` allowed                 |
| 🧪 Semantic Tests            | Every test must prove behavior              |
| 🔁 Code Diff + Equivalence   | https://mambadev.io/apex-feature-comparison + https://mambadev.io/equivalence-checklist

---

## 🔒 Strict Refactor Mode

Use for production/proprietary logic.

| Rule                          | Constraint                              |
|-------------------------------|------------------------------------------|
| Class name                    | ❌ Cannot be renamed                     |
| Public methods/vars           | ❌ Cannot be renamed/removed             |
| Input/Output format           | ❌ Must remain 100% intact               |
| `@RestResource` / `@AuraEnabled` | ❌ Must be signature-stable          |

✅ You may:
- Extract logic to `@TestVisible` methods  
- Add log coverage and tests  
- Refactor internally without altering contracts

All strict changes must include:

- 🔁 Code diff → https://mambadev.io/apex-feature-comparison  
- ✅ Behavior proof → https://mambadev.io/equivalence-checklist  
- 🔒 Lead approval if changing public logic

---

## ✅ Final Rules

- Every PR must follow all checklist points  
- Every test must prove behavior  
- Every change must trace its purpose  
- If it’s not logged, tested, or proven — it doesn’t merge

---

**🖤 Be Mamba. Refactor like Mamba. Review like Mamba.**  
**#MambaPublicReview #StrictRefactor #NoGuessworkOnlyProof** 🔥
