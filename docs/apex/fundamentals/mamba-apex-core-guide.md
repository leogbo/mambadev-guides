<p align="center">
  <img src="https://raw.githubusercontent.com/leogbo/mambadev-guides/main/static/img/github_banner_mambadev.png" alt="MambaDev Banner" width="100%" />
</p>

# 🧱 MambaDev Apex Core Guide – 2025

@status:core | This document defines non-negotiable coding principles for Apex.  
All modules (e.g., `/apex/`, `/batch/`, `/triggers/`) must comply.  
Changes must be approved by architecture leadership.

---

## 📘 Shortlink

https://mambadev.io/coding-style

---

## 🎯 Mission

Guarantee **traceability, clarity, modularity, and testability** in all Apex code.  
If it's not auditable, it's not acceptable.

---

## ✅ Mamba Architecture Principles

| Principle                | In Practice                                                                  |
|--------------------------|-------------------------------------------------------------------------------|
| SRP – Single Responsibility | Every method does one thing well and is isolated for testing            |
| Traceability             | `Logger`, `@TestVisible`, `FlowExecutionLog__c` for all logic layers         |
| Testability              | Logic receives primitive values and can be tested without external calls     |
| Defensive by default     | Validate all inputs: nulls, lists, enums, fallback logic required            |
| Modular structure        | Methods stay under ~30 lines, delegate clearly, and never nest excessively   |

---

## 🏗️ Standard Class Setup

```apex
@TestVisible public static String  environment     = EnvironmentUtils.getRaw() != null ? EnvironmentUtils.getRaw() : 'sandbox';
@TestVisible public static String  logLevelDefault = EnvironmentUtils.getLogLevel() != null ? EnvironmentUtils.getLogLevel() : 'INFO';
@TestVisible public static Integer maxDebugLength  = EnvironmentUtils.getMaxDebugLength() != null ? (Integer) EnvironmentUtils.getMaxDebugLength() : 3000;

@TestVisible private static final String className   = 'MyClass';
@TestVisible private static final String logCategory = 'Domain';
private static final String triggerType = 'Service | Queueable | Trigger';
```

---

## 🪵 Logging (Standard)

Use the `Logger` class:

```apex
new Logger()
  .setClass('MyClass')
  .setMethod('processRecord')
  .error('Unexpected exception', ex, JSON.serializePretty(input));
```

In tests, use `LoggerMock`.

---

## 🌐 REST Responses

```apex
RestServiceHelper.badRequest('Missing required parameter');
RestServiceHelper.sendResponse(200, 'Success', returnData);
```

---

## 🧪 Testing Expectations

- `@TestVisible` for all logic  
- Setup via `TestDataSetup.setupCompleteEnvironment()`  
- Each test must cover one case, with expressive `System.assertEquals(...)`  
- Use `LoggerMock`, not real logging  
- Validate fallbacks, errors, async paths

---

## 🧠 Assertion Examples

```apex
System.assertEquals(
  'expected_action',
  res.get('action'),
  'Expected "expected_action", got: ' + res.get('action')
);
```

---

## 📦 Method Patterns

| Context        | Naming                     |
|----------------|----------------------------|
| Public logic   | `executeX`, `getY`, `runZ` |
| Test methods   | `should_do_X_when_Y`       |
| Private logic  | `validateInput`, `buildMap`|

---

## ✅ Required Supporting Docs

- Before vs After → https://mambadev.io/41XGoTz  
- Equivalence → https://mambadev.io/4jjcWx9  
- Logger Guide → https://mambadev.io/41WCcDA  
- Test Setup → https://mambadev.io/4ceNlTD

---

## 🚫 Anti-Patterns

| ❌ Wrong                   | ✅ Correct                          |
|---------------------------|-------------------------------------|
| `System.debug()`          | Use `Logger`                        |
| `testData.get(...)`       | Use `TestDataSetup`                 |
| `SELECT ... LIMIT 1`      | Use `RecordHelper.getById(...)`     |
| Multiple `if/try/catch`   | Extract into named, testable methods|

---

## 🔐 Production Safety

Block unsafe behavior in prod:

```apex
if (![SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox) {
  logger.warn('Blocked in production');
  return;
}
```

---

## 🧱 Final Rule

> Every method with more than one responsibility must be broken into `@TestVisible` primitives, fully traceable and testable.

---

## 🖤 Mamba Mentality

- Every line must justify its existence  
- No logic escapes logging  
- Every test proves **behavior**, not just coverage

**#BuiltForTraceability #ModularByDesign #NothingLessThanExcellent**
- Docusaurus/GitBook page?

**#OneCoreGuide #AllMamba #ArchitectureWithoutCompromise** 🧠🔥
