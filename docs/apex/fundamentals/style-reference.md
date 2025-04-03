<p align="center">
  <img src="https://raw.githubusercontent.com/leogbo/mambadev-guides/main/static/img/github_banner_mambadev.png" alt="MambaDev Banner" width="100%" />
</p>

# 🧾 MambaDev Apex Style Reference

> Fast-reference checklist for applying MambaDev's Apex style rules  
> Companion to: [Apex Core Guide](/docs/apex/fundamentals/mamba-apex-core-guide.md)

---

## 🧱 Class Metadata Required

```apex
/**
 * @since 2025-04-01
 * @author You
 */
@TestVisible private static final String CLASS_NAME = 'MyClass';
@TestVisible private static final String CATEGORY = 'Service';
@TestVisible private static final String EXECUTION_TYPE = 'Queueable';
```

---

## 🪵 Logger Pattern

```apex
new Logger()
  .setClass(CLASS_NAME)
  .setMethod('doWork')
  .setCategory(CATEGORY)
  .error('Something failed', ex, JSON.serializePretty(input));
```

In tests:

```apex
Logger.overrideLogger(new LoggerMock());
Logger.isEnabled = false;
```

---

## 🧪 Testing Structure

```apex
@IsTest
static void should_do_X_when_Y() {
    // Given
    insert new MySetting__c(IsActive__c = true);

    // When
    Boolean enabled = MyService.isFeatureEnabled();

    // Then
    System.assertEquals(true, enabled, 'Feature should be active');
}
```

---

## 📋 Naming Rules

| Context      | Convention             |
|--------------|------------------------|
| Public method | `executeX`, `getY()`   |
| Private method| `validateX`, `buildY()`|
| Test method  | `should_do_X_when_Y()` |

---

## 📐 Method Guidelines

| Type         | Rule                   |
|--------------|------------------------|
| Logic method | ≤ 30 lines             |
| Test         | One assertion per case |
| DTOs         | No limit               |

---

## 🚫 Anti-Patterns

| 🚫 Don’t do this            | ✅ Use this instead                     |
|-----------------------------|----------------------------------------|
| `System.debug(...)`         | Use [`Logger.cls`](https://github.com/leogbo/mambadev-guides/blob/main/src/classes/logger.cls) |
| `LIMIT 1` without `ORDER BY`| Always sort queries                    |
| `testData.get(...)`         | Use [`TestDataSetup.cls`](https://github.com/leogbo/mambadev-guides/blob/main/src/classes/test-data-setup.cls) |
| Complex nesting             | Extract into `@TestVisible` methods    |

---

## 🔐 Production Guard

```apex
if (![SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox) {
  logger.warn('Blocked in production');
  return;
}
```

---

## 🧱 Enforcement Checklist

- [ ] `@since` + `@author`
- [ ] Class metadata constants
- [ ] `@TestVisible` for all logic
- [ ] Logger used (no `System.debug()`)
- [ ] List safety checks
- [ ] Queries ordered
- [ ] `LoggerMock` used in tests
- [ ] All `assertEquals()` calls include a message

---

📎 Full reference: [Apex Coding Style Guide](/docs/apex/fundamentals/mamba-coding-style.md)  
🧱 Enforcement logic: [Apex Core Guide](/docs/apex/fundamentals/mamba-apex-core-guide.md)

---

**#StyleIsStructure #MambaOnReview #OneStyleToEnforceThemAll**

