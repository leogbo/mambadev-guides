<p align="center">
  <img src="https://raw.githubusercontent.com/leogbo/mambadev-guides/main/static/img/github_banner_mambadev.png" alt="MambaDev Banner" width="100%" />
</p>

# >>>> START OF NEW INPUT TO INTEGRATE IN REFACTORING <<<<

🐍 **Mamba Lessons Recap – Apex Syntax & Style (So Far)**

Over this refactor chain, we uncovered several **critical Apex syntax rules and best practices** that separate Apex from JS/Java hybrids. Below is your **Mamba Digest** 🧠 of what to always watch for:

---

## ⚠️ Apex Syntax Rules You Can’t Break

| ❌ Mistake | ✅ Correct | 📚 Explanation |
|-----------|------------|----------------|
| `new Class { prop = val }` | Instantiate, then assign | Apex doesn't support **object literals** |
| `List<Foo> list = new List<Foo>{ new Foo { ... } }` | Declare `Foo` first, then add | Nested inline initializers are illegal |
| `desc` as var name | Use `desconto`, `descricao`, etc. | `desc` is a **reserved word** (ORDER BY DESC) |
| `return new Class { ... };` | Create `Class x = new Class();`, assign, return `x` | Inline `return` with fields is invalid |
| Casts like `(Object) x` when incompatible | Ensure both are compatible types | Apex casting is strict and static |
| Mixing commas in assignments | One assignment per line | Commas in field-level assignments are invalid |
| Using non-existent fields (ex: `wrapper.dados.etapa`) | Must explicitly cast `wrapper.dados` | Apex won't infer polymorphic structures |

---

## ✅ Apex Structuring Wins

| Principle | Example | Result |
|----------|---------|--------|
| 🧱 **Build your wrapper classes flat, then compose** | `buildDadoBoleto()`, `buildPagador()` | Easier to test, extend, and read |
| 🧠 **Avoid premature casting** | Let wrapper fields remain as typed | Prevents compilation issues |
| 🔄 **Split by HTTP method** | `buildPostWrapper()`, `buildPatchWrapper()` | Clean contracts per use case |
| 🚫 **Avoid over-nesting** | Don’t chain `new Class { new SubClass { ... } }` | Apex is not JS. Break it down |
| 📦 **Use `Object` for flexible payloads** | `public Object dados` | Supports PATCH/POST/GET without tight coupling |

---

## 🔄 Refactor Patterns Now in Use

| Pattern | Where We Used |
|--------|----------------|
| 🔨 Builder Pattern | `buildPatchWrapper`, `buildPostWrapper` |
| 🎯 Type-safe Casting | `(DadosPost) wrapper.dados` |
| 🔁 Flattened Composition | `buildDadoBoleto()`, `buildPagador()` |
| 🧪 Mamba Testing | Validates contract equivalence and fallback behavior |

---

## ✨ Bonus: Naming Best Practices

| Concept | Old | Mamba Style |
|--------|-----|-------------|
| Avoid reserved names | `desc` | `desconto` |
| Use intent-specific methods | `getData()` | `buildPostWrapper()` |
| Centralize logic | duplicate inline objects | reusable `buildPagador()` |

---

## 🐍 Final Lesson:

> **"If it’s nested, inline, or clever — break it apart.  
> If it’s readable, reusable, and strict — that’s Mamba."**

# >>>> END OF NEW INPUT TO INTEGRATE <<<<

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
