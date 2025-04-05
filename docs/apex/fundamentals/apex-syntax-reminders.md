<p align="center">
  <img src="https://raw.githubusercontent.com/leogbo/mambadev-guides/main/static/img/github_banner_mambadev.png" alt="MambaDev Banner" width="100%" />
</p>

# 🧱 MambaDev Apex Syntax Reminders

> 🔒 Reference: Last updated 2025-04 by MambaDev reviewers & real-world architecture lessons.

---

## 🧩 Invocable Method Syntax

Always use **Flow-safe syntax** in `@InvocableMethod` declarations. Commas between parameters in the annotation are not allowed.

```apex
// ✅ Correct
@InvocableMethod(label='My Flow Action' category='Flow Utilities')
public static List<Output> doSomething(List<Input> inputs) { ... }

// ❌ Incorrect
@InvocableMethod(label='My Flow Action', category='Flow Utilities')
```

---

## 🧠 New Contributions for Apex Syntax Reminders

### ✅ Section: “Automation Safety”
> **Do not act on uploaded Apex classes unless explicitly referenced by the user.**  
> Refactors and reviews must always be user-initiated. Uploaded files are *not* implicit signals of action.

---

### 🔁 Section: “Triggering Refactors”
> **“Be prepared” ≠ “start refactor.”**  
> Always wait for a class name or refactor command. Preparing context ≠ acting on content.

---

### 💬 Section: “Chat Intent Recognition”
> 🧠 **Avoid assumptions about intent.**  
> Phrases like “next content” must be grounded in **explicit class reference** before processing.

---

### 🧾 Section: “Author Handling”
> If no author is defined in the class header, default to:  
> `@author Leo Garcia`  
> _Only apply this rule **after** the class has been explicitly selected for review._

---

### 🚫 Section: “Auto-Execution Rules”
> ❌ Never assume the first uploaded file is the target of the next action.  
> ✅ All execution must follow a direct, user-issued instruction.

---

## 🔒 MambaDev Syntax Practices

### ✅ Logger Usage
```apex
Logger logger = new Logger()
    .setClass(className)
    .setMethod('methodName')
    .setCategory(logCategory)
    .setTriggerType(triggerType)
    .setEnvironment(environment);

logger.info('Process started', JSON.serializePretty(context));
```
- ❌ Avoid `System.debug()` — replace with structured logging.
- ✅ Always wrap logs with telemetry metadata.

---

### 🔁 Async Patterns
- Use `Test.startTest()` / `Test.stopTest()` to test `Queueable`, `Future`, `Batch`.
- Assert job creation with `Test.getQueueableJobs()` when applicable.
- Always log inside `execute()` with `.info(...)`

---

### 🧪 TestData Setup
- ✅ Always use:
  ```apex
  @TestSetup with TestDataSetup.setupCompleteEnvironment()
  ```
- ❌ Do not use `testData.get(...)` inside test methods. Instead use SELECT [...] or RecordHelper.getById(...);;
---

### 🔄 Record Fetch Pattern
- ❌ `SELECT Id FROM Object WHERE Id = :id LIMIT 1`
- ✅ Use:
  ```apex
  Account acc = (Account) RecordHelper.getById(Account.SObjectType, id, 'Id');
  ```

---

### 🧱 Safe Constants Template
```apex
@TestVisible public static String  environment       = (EnvironmentUtils.getRaw() != null) ? EnvironmentUtils.getRaw() : 'sandbox';
@TestVisible public static String  logLevelDefault   = (EnvironmentUtils.getLogLevel() != null) ? EnvironmentUtils.getLogLevel() : 'INFO';
@TestVisible public static Integer maxDebugLength    = (EnvironmentUtils.getMaxDebugLength() != null ) ? (Integer)EnvironmentUtils.getMaxDebugLength() : 3000;
@TestVisible private static final String className   = 'MyClass';
@TestVisible private static final String logCategory = 'Domain';
@TestVisible private static final String triggerType = 'Service | Queueable | Trigger';
```

---

### 📈 Assertions
- ✅ Always provide messages in `System.assert(...)`
  ```apex
  System.assertEquals(true, condition, 'Condition should be true');
  ```

- ✅ Normalize strings before asserting:
  ```apex
  System.assertEquals(expected.toUpperCase(), actual.toUpperCase());
  ```

---

### 🧹 Test Guardrails
- Always insert records that match filters (e.g., `WHERE Ativo__c = true AND PF__c = true`)
- Always mock HTTP callouts:
  ```apex
  Test.setMock(HttpCalloutMock.class, new CustomHttpMock());
  ```

---

## ☑️ Invocable Guidelines

- ✅ No commas inside annotation params:
  ```apex
  @InvocableMethod(label='Label here' category='CategoryName')
  ```

- ✅ Wrap input in class, not primitive `List<Id>`
- ✅ Use `@InvocableVariable` with clear labels
- ❌ Avoid logic-heavy flows unless wrapped in guards

---

## 🔐 Public Method Contracts

> In `Mamba Strict Mode`, **never mutate** public/global method contracts.

You may:
- ✅ Add `@TestVisible` helpers
- ✅ Add new private methods
- ✅ Add logs

You may **not**:
- ❌ Rename public methods
- ❌ Change input/output types
- ❌ Remove exceptions

---

## 🏗️ Looping Hygiene
```apex
for (Integer i = 0; i < ids.size(); i += BATCH_SIZE) {
    List<Id> chunk = ids.subList(i, Math.min(i + BATCH_SIZE, ids.size()));
    processChunk(chunk);
}
```

---

## 🧪 Test Design Principles

- One method = one behavior
- Use `LoggerMock` to assert `.info()`, `.error()`, `.warn()` logs
- Include edge and null inputs

---

## 🧠 GPT Usage Tag

If this class was assisted by `Apex MambaDev`, include:

```text
#MambaReview #StrictRefactor #OnlyProofNoGuess
```

---

## 📌 Suggested Section in Syntax Guide

```md
## 🔒 MambaDev-Specific Syntax Standards
```

Include this block **after** "General Best Practices" in [`apex-syntax-reminders.md`](https://guides.mambadev.io/docs/apex/fundamentals/apex-syntax-reminders.md).

---

Let me know if you’d like this exported or versioned for GitHub inclusion (`mambadev-guides`)!
```