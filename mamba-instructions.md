### 🧱 Mamba Apex Reviewer – Official Summary Guide (v2025)

📎 **Official Shortlink:** [bit.ly/GuiaApexMamba](https://bit.ly/GuiaApexMamba)  
🔗 **Applicable MambaDev Links:**

https://mambadev.io/42iHzvK | https://mambadev.io/3FScojm | https://mambadev.io/3YgDDdx  
https://mambadev.io/41WCcDA | https://mambadev.io/428yTrz | https://mambadev.io/4ceNlTD  
https://mambadev.io/41XGoTz | https://mambadev.io/4jjcWx9

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

1. Code follows architecture → [MambaDev Architecture](https://mambadev.io/42iHzvK)  
2. Before vs After comparison provided → [Comparison Guide](https://mambadev.io/41XGoTz)  
3. Functional equivalence confirmed → [Equivalence Checklist](https://mambadev.io/4jjcWx9)  
4. Tests updated and mapped → [Testing Guide](https://mambadev.io/3YgDDdx)  
5. Logging implemented via `.setClass(...).setMethod(...).error(...)`  
6. Public methods preserve compatibility — or are versioned

---

## 🚫 Forbidden Practices

| 🔥 Anti-pattern           | ✅ Mamba Alternative                             |
|---------------------------|--------------------------------------------------|
| `System.debug(...)`       | `Logger` + `FlowExecutionLog__c`                |
| Direct `SELECT LIMIT 1`   | `RecordHelper.getById(...)` with fallback        |
| `testData.get(...)` in tests | Always use `TestDataSetup` with real data   |
| `%` operator              | `Math.mod(...)` for clarity and portability     |

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

## 🔐 Mamba Public Review Contract

> Transforming content to **Mamba Public Review** requires:

| Standard                          | Enforcement                                  |
|----------------------------------|----------------------------------------------|
| 🌐 US English                    | No PT-BR, only technical EN-US               |
| 🧠 CamelCase Naming              | Classes, methods, variables                  |
| 📎 Shortlinks                    | All links use `mambadev.io` format           |
| 🔐 Structured Logging            | Must use `Logger`, never `System.debug()`    |
| 🧪 Semantic Tests                | Must assert behavior, not just code paths    |
| 🔁 Code Diff + Functional Proof  | [Comparison](https://mambadev.io/41XGoTz) + [Equivalence](https://mambadev.io/4jjcWx9)

---

## 🧱 Final Conduct

- Every PR must have a full Mamba checklist  
- Every line must be traceable and testable  
- Every test must prove intent, not just reach coverage  
- Refactors must be accompanied by code comparison and equivalence  
- Logs and exceptions must explain the execution story

---

**🖤 Be Mamba. Refactor like Mamba. Review like Mamba.**  
**#MambaPublicReview #NonNegotiableExcellence #LoggerOnly** 🔥
**#MambaMentality #NothingUntraced #NoDebugsEver** 🧠🔥
