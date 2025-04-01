<p align="center">
  <img src="https://raw.githubusercontent.com/leogbo/mambadev-guides/main/static/img/github_banner_mambadev.png" alt="MambaDev Banner" width="100%" />
</p>

> 🧱 @status:core | This document defines official MambaDev coding fundamentals.  
> Changes must be versioned and approved by architecture leads.  
> Applied guides (e.g. `/apex/`) may evolve beyond this for future-proofing.

# 🧠 Apex Architecture | MambaDev

> *"Either your code has a standard — or it hides a bug."*  
> — Leo Mamba Garcia

---

## 🔗 Official Shortlink

Access this guide at:  
👉 [https://mambadev.io/coding-style](https://mambadev.io/coding-style)

---

## 🎯 Purpose

This guide is the **non-negotiable standard** for building Apex inside any elite org. It's not a suggestion — it's a system.  
Every line of code must be **traceable**, **testable**, and **performance-oriented**.

---

## ✅ Mamba Code Pillars

| Pillar        | Definition                                                                 |
|---------------|------------------------------------------------------------------------------|
| **Traceable** | Every execution is logged with full context using `Logger`.                 |
| **Testable**  | No `if`, no method escapes **explicit** test coverage.                      |
| **Concise**   | No excess lines. No fat. No empty blocks.                                   |
| **Defensive** | Never assume: validate `null`, empty lists, picklists, anything nullable.   |
| **Modular**   | Single-responsibility methods, ideally under 30 lines.                      |
| **Visible**   | All critical logic is exposed to tests via `@TestVisible`.                  |

---

## 🏷️ Standard Signature

Use this in **every class or handler** for authorship traceability:

```apex
/**
 * @since {{DateTime}}
 * @author {{Your Name}} inspired by MambaDev
 */
```

---

## 🔒 Fixed Conventions

```apex
@TestVisible private static final String CLASS_NAME = 'SomeClass';
@TestVisible private static final String CATEGORY = 'Domain';
@TestVisible private static final String EXECUTION_TYPE = 'Apex'; // Apex | REST | Flow | Queueable
```

---

## 🧱 Utility Class Extract

See full code at [`examples/feature-manager.cls`](../examples/feature-manager.cls)

```apex
@TestVisible
public static Boolean isFeatureEnabled() {
    if (cache != null) return cache;

    try {
        cache = [SELECT IsActive__c FROM AppConfiguration__c ORDER BY CreatedDate DESC LIMIT 1].IsActive__c;
    } catch (Exception e) {
        cache = false;
    }

    return cache;
}
```

---

## 🪵 Structured Logging Extract

See complete logger setup in [`examples/logger-usage.cls`](../examples/logger-usage.cls)

```apex
Logger logger = new Logger()
    .setClass(CLASS_NAME)
    .setMethod('executeProcess')
    .setCategory(CATEGORY);

logger.info('Starting process...', JSON.serializePretty(inputData));

// On failure:
logger.error('Process failed', ex, JSON.serializePretty(inputData));
```

---

## 🧪 Testing Style

### ✅ Given-When-Then Pattern

```apex
@IsTest
static void should_enable_feature_when_config_is_active() {
    // Arrange
    insert new AppConfiguration__c(
        OwnerId = UserInfo.getOrganizationId(),
        IsActive__c = true
    );

    // Act
    Boolean result = SomeFeatureManager.isFeatureEnabled();

    // Assert
    System.assertEquals(true, result, 'Feature should be active');
}
```

---

## 🔁 List Validation

### ❌ Don't:
```apex
if (!list.isEmpty()) {
    SObject item = list[0];
}
```

### ✅ Do:
```apex
if (list != null && !list.isEmpty()) {
    SObject item = list[0];
}
```

---

## 🧼 Visual Layout Rules

- ❌ No empty logic blocks after `if`, `else`, `try`, `catch`
- ✅ Consistent 4-space indentation
- ✅ No placeholder comments like `// TODO`

---

## ⚖️ Method Size Guidelines

| Type               | Max Length     |
|--------------------|----------------|
| Utility / Logic    | ~30 lines      |
| DTO / Wrapper      | No limit       |
| `@IsTest` Methods  | One test = one case |

---

## 📋 Method Naming Patterns

| Context           | Convention                     |
|-------------------|--------------------------------|
| Public Methods    | `executeAction`, `getRecords`  |
| Test Methods      | `should_do_X_when_Y`           |
| Private Methods   | `buildWrapper`, `validateInput`|

---

## 🔐 Production Safety

Prevent critical execution in production environments:

```apex
if (![SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox) {
    logger.warn('Execution blocked in production');
    return;
}
```

---

## 🚫 Mamba Anti-Patterns (Never Allowed)

- `System.debug()` outside test classes
- `LIMIT 1` without `ORDER BY`
- Unsafe map loading: `new Map<Id, SObject>([SELECT ...])` without validation
- Bloated, nested, unsegmented methods
- `assertEquals(true, result)` without error message
- `@TestVisible` with no test coverage

---

## ✅ Mamba Checklist

> Apply this rigorously in every PR and deployment. No shortcuts.

### 🧱 Structure & Signature
- [ ] Includes docstring with purpose
- [ ] Has signature: `@since`, `@author`

### 🔍 Visibility & Testing
- [ ] Logic methods are `@TestVisible`
- [ ] Each `@TestVisible` has a direct test
- [ ] Methods over 30 lines are modularized
- [ ] Utility logic is not coupled in test methods

### 🪵 Logging
- [ ] Uses `Logger`, not `System.debug()`
- [ ] Pretty JSON formatting on logged objects

### 🔐 Defensive Code
- [ ] Lists checked for `null` and `!isEmpty()`
- [ ] Queries with `LIMIT 1` always ordered
- [ ] Optional fields validated with `String.isNotBlank()`

### 🧪 Test Quality
- [ ] Test data handled in `@TestSetup`
- [ ] No DML inside individual test methods
- [ ] Every `System.assert*()` includes message
- [ ] Each test = one isolated scenario

### 💅 Style
- [ ] No empty lines between control blocks
- [ ] No leftover comments (`// TODO`, `// DEBUG`)
- [ ] Indentation is always 4 spaces
- [ ] Test methods are clearly named (`should_return_X_when_Y`)

---

## 🚀 Ready to Ship

If everything is ✅, it's ready for merge.  
**No mystery. No luck. Just control.**

---

🧠🖤  
**Leo Mamba Garcia**  
_Style isn’t vanity. It’s traceability under pressure._  
#MambaStandard #TestOrRefactor #EliteCodeOnly
