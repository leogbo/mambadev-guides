<p align="center">
  <img src="https://raw.githubusercontent.com/leogbo/mambadev-guides/main/static/img/github_banner_mambadev.png" alt="MambaDev Banner" width="100%" />
</p>

> 🧱 @status:core | This document defines the official Apex coding style guide for all MambaDev projects.  
> All changes must be reviewed and versioned by architecture leads.  
> Every Apex module must reference and comply with this guide.

# ✍️ MambaDev Apex Coding Style Guide – 2025

📎 [Shortlink](https://mambadev.io/coding-style)

> **"Style isn’t vanity — it’s traceability under pressure."** – MambaDev

---

## 🎯 Purpose

This guide enforces consistent, testable, and maintainable Apex syntax and structure across all projects.  
It complements the [Core Architecture Guide](/docs/apex/fundamentals/mamba-apex-core-guide.md) and the [Review Checklist](/docs/apex/fundamentals/apex-review-checklist.md).

Every style rule supports **traceability**, **clarity**, and **scalability**.

---

## 🧱 Mamba Code Pillars

| Pillar        | Meaning                                                                 |
|---------------|-------------------------------------------------------------------------|
| **Traceable** | Logs must be persisted with context using [`Logger.cls`](https://github.com/leogbo/mambadev-guides/blob/main/src/classes/logger.cls) |
| **Testable**  | All logic is exposed via `@TestVisible` and covered with unit tests    |
| **Concise**   | No unnecessary lines or bloated logic                                   |
| **Defensive** | Null-checks, safe access, and fallback handling are always enforced     |
| **Modular**   | Methods are short, focused, and follow single responsibility            |
| **Consistent**| All naming, layout, and formatting follow Mamba standards               |

---

## 🏷️ Required Header Signature

Every Apex class must include authorship and origin:

```apex
/**
 * @name: class name or file name
 * @description: ['describe document purpose and main related topics'] 
 * @lastModified 2025-04-01 (current date)
 * @author ['MambaDev' if public review] [`Previous Author Name` if private content]
 */
```

---

## 🔒 Required Constants

Every class must declare traceability metadata:

```apex
@TestVisible public static String  environment       = (EnvironmentUtils.getRaw() != null) ? EnvironmentUtils.getRaw() : 'sandbox';
@TestVisible public static String  logLevelDefault   = (EnvironmentUtils.getLogLevel() != null) ? EnvironmentUtils.getLogLevel() : 'INFO';
@TestVisible public static Integer maxDebugLength    = (EnvironmentUtils.getMaxDebugLength() != null ) ? (Integer)EnvironmentUtils.getMaxDebugLength() : 3000;
@TestVisible private static final String CLASS_NAME = 'MyClass';
@TestVisible private static final String CATEGORY = 'Service';
@TestVisible private static final String EXECUTION_TYPE = 'Queueable'; // or REST, Flow, Apex
```

---

## 🪵 Logging Example (Fluent)

All logs must use the [`Logger`](https://github.com/leogbo/mambadev-guides/blob/main/src/classes/logger.cls) class (never `System.debug()`):

```apex
new Logger()
  .setClass(CLASS_NAME)
  .setMethod('processData')
  .setCategory(CATEGORY)
  .setAsync(true)
  .info('Payload received', JSON.serializePretty(input));

new Logger()
  .setClass(CLASS_NAME)
  .setMethod('processData')
  .error('Failed to process payload', ex, JSON.serializePretty(input));
```

In tests, use [`LoggerMock`](https://github.com/leogbo/mambadev-guides/blob/main/src/classes/logger-mock.cls) to capture logs without DML.

---

## 🧪 Testing Pattern (Given–When–Then)

```apex
@IsTest
static void should_enable_feature_when_config_is_active() {
    // Given
    insert new AppConfiguration__c(IsActive__c = true);

    // When
    Boolean result = FeatureManager.isFeatureEnabled();

    // Then
    System.assertEquals(true, result, 'Feature should be active');
}
```

---

## 🧱 List Safety

Always validate list presence:

```apex
if (list != null && !list.isEmpty()) {
    process(list[0]);
}
```

---

## ⚙️ Method Guidelines

| Type             | Rule                          |
|------------------|-------------------------------|
| Utility methods  | ≤ 30 lines                    |
| Test methods     | One case per method           |
| Wrapper classes  | Unlimited                     |

---

## 📋 Naming Patterns

| Context     | Convention                  |
|-------------|-----------------------------|
| Public      | `executeX`, `getY`, `runZ`  |
| Private     | `validateX`, `buildY`       |
| Test method | `should_do_X_when_Y`        |

---

## 🧼 Layout & Formatting

- ✅ 4-space indentation  
- ❌ No empty blocks after `if`, `else`, `catch`  
- ❌ No placeholder comments (`// TODO`, `// DEBUG`)  
- ✅ Line breaks between method sections  
- ✅ Use `JSON.serializePretty()` for logs

---

## 🔐 Production Safety

```apex
if (![SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox) {
  new Logger().setClass(CLASS_NAME).warn('Execution blocked in PROD');
  return;
}
```

---

## 🚫 Never Allowed (Anti-Patterns)

| 🚫 Pattern                   | ✅ Fix                              |
|-----------------------------|-------------------------------------|
| `System.debug()`            | Use [`Logger`](https://github.com/leogbo/mambadev-guides/blob/main/src/classes/logger.cls) |
| `LIMIT 1` without `ORDER BY`| Always sort queries                 |
| Unsafe map load             | Validate input before mass mapping  |
| Nested/bloated methods      | Split into private `@TestVisible`   |
| `assertEquals(true, ...)`   | Always include a message            |


## 🧩 Invocable Method Syntax

Always use **Flow-safe syntax** in `@InvocableMethod` declarations. Commas between parameters in the annotation are not allowed.

```apex
// ✅ Correct
@InvocableMethod(label='My Flow Action' category='Flow Utilities')
public static List<Output> doSomething(List<Input> inputs) { ... }

// ❌ Incorrect
@InvocableMethod(label='My Flow Action', category='Flow Utilities')

---

## ✅ Mamba Style Checklist

> Every PR must respect all style rules below:

- [ ] Header signature with `@since`, `author`
- [ ] All logic methods are `@TestVisible`
- [ ] Logger is used (no `System.debug()`)
- [ ] Test data uses [`TestDataSetup`](https://github.com/leogbo/mambadev-guides/blob/main/src/classes/test-data-setup.cls)
- [ ] Method length < 30 lines unless DTO
- [ ] Each `assert` includes message
- [ ] One test = one behavior
- [ ] Lists checked for `null` and `!isEmpty()`
- [ ] All queries ordered + safe

---

## 📄 Quick Reference

→ See the condensed cheat sheet in [`style-reference.md`](/docs/apex/fundamentals/style-reference.md)

---

## 🚀 Ready to Merge

If everything checks out, the code is ready.  
No guessing. No luck. Just precision.

---

🧠🖤  
**MambaDev**  
_"Consistency is discipline. And discipline builds elite code."_  
**#MambaCodingStyle #StyleIsTraceability #NothingLessThanClean**