<p align="center">
  <img src="https://raw.githubusercontent.com/leogbo/mambadev-guides/main/static/img/github_banner_mambadev.png" alt="MambaDev Banner" width="100%" />
</p>

_last update 10/04/2025_
> 🧱 @status:core | This document defines **official naming conventions** for Apex code in MambaDev.  
> All modules must comply to ensure clarity, testability, and semantic traceability.

# ✍️ Naming Standards – MambaDev Apex

📎 [Shortlink: mambadev.io/naming](https://mambadev.io/naming)

> Naming is not cosmetic — it's architectural.  
> Clarity survives refactor. Cleverness does not.

---

## 🎯 Purpose

**Naming is architecture.**

In MambaDev, names must:

- ✅ Reveal intent  
- ✅ Respect hierarchy  
- ✅ Be searchable  
- ✅ Avoid ambiguity  
- ✅ Survive refactors

> Consider aligning your class name with the `@category` tag used in its header.  
> Example: a class named `LeadValidationService.cls` might have `@category: lead` in its metadata.  
> See: [Classification Tags Guide](https://guides.mambadev.io/docs/apex/fundamentals/mamba-apex-classification-tags.md)

---

## 🧱 General Naming Rules

| Rule                             | Example                              |
|----------------------------------|--------------------------------------|
| Use `PascalCase` for class names | `AccountService`, `QuoteHelper`      |
| Use `camelCase` for variables    | `userId`, `accountList`              |
| Use **nouns** for classes        | `Logger`, `PricingRule`              |
| Use **verbs** for methods        | `calculateTotal()`, `validateEmail()`|
| Never use abbreviations          | `leadConversionService`, not `LCS`   |

---

## 📦 Class Naming Patterns

| Class Type        | Convention                 | Example                        |
|-------------------|----------------------------|--------------------------------|
| Controller         | Ends with `Controller`     | `LeadController`               |
| Service            | Ends with `Service`        | `AccountMergeService`          |
| Domain Logic       | Ends with `Rule`, `Engine` | `DiscountRule`, `PricingEngine`|
| Utility / Helper   | Ends with `Helper`, `Util` | `ExceptionUtil`, `DateHelper`  |
| Exception          | Ends with `Exception`      | `AppValidationException`       |
| Test Class         | Ends with `Test`           | `AccountServiceTest`           |
| Mocks              | Ends with `Mock`           | `LoggerMock`, `EmailServiceMock`|
| Trigger Handler    | Ends with `TriggerHandler` | `OpportunityTriggerHandler`    |

---

## 🔁 Method Naming Patterns

| Pattern            | Intent                               | Example                        |
|--------------------|--------------------------------------|--------------------------------|
| `getX()` / `fetchX()` | Query or retrieval                 | `getEligibleAccounts()`        |
| `setX()`           | Mutation or assignment               | `setAccountId()`               |
| `isX()` / `hasX()` | Boolean condition                    | `isActive()`, `hasAccess()`    |
| `validateX()`      | Business rule enforcement            | `validatePromoCode()`          |
| `run()` / `execute()`| Entry point / controller dispatch  | `executeBatch()`               |
| `fromX()` / `toX()`| Converters / DTO factories           | `fromTrigger()`, `toJSON()`    |

---

## 📄 Variable Naming Guidelines

| Type               | Convention                           | Example                        |
|--------------------|--------------------------------------|--------------------------------|
| Boolean            | Start with `is`, `has`, or `should`  | `isEligible`, `shouldConvert` |
| Lists / Sets       | Use plural form                      | `accounts`, `failedIds`        |
| Identifiers        | End with `Id`, `Ids`                 | `accountId`, `recordIds`       |
| Maps / DTOs        | Context-based naming                 | `flowInput`, `responsePayload` |

---

## 🧪 Test Class Naming & Structure

- Class: `ClassUnderTestTest`  
- Method: `test_<scenario>_<expectedResult>()`

```apex
@IsTest
private class LeadConversionServiceTest {

    @IsTest
    static void test_convertLead_shouldCreateAccountAndContact() {
        // Setup, run, assert
    }
}
```

> ✅ Tests should describe **intent**, not just code path.

---

## 🧼 Custom Metadata & Field Naming

| Element               | Convention                    | Example                          |
|------------------------|-------------------------------|----------------------------------|
| Custom Object API Name | PascalCase + `__c`            | `FlowExecutionLog__c`            |
| Custom Field API Name  | camelCase + `__c`             | `logLevel__c`, `triggerType__c`  |
| Picklist Values        | SCREAMING_SNAKE_CASE          | `INBOUND`, `OUTBOUND`, `ERROR`   |

---

## ❌ Anti-Patterns

| Problem                  | Fix                                                           |
|--------------------------|---------------------------------------------------------------|
| Generic names: `Utils`, `Manager`, `Stuff` | Rename by domain: `EmailHelper`, `PromoEngine`        |
| Vague: `doIt()`, `handle()`                 | Use verbs that express behavior & result              |
| Single-letter vars: `x`, `y`, `a`           | Use: `quote`, `user`, `isValid`                      |
| Class called `Main`, `Default`, or `Generic`| Rename to match domain responsibility                |

---

## 📚 Related Guides

- [Layered Architecture](/docs/apex/fundamentals/layered-architecture.md)  
- [Testing Patterns](/docs/apex/testing/testing-patterns.md)  
- [Validation Patterns](/docs/apex/testing/validation-patterns.md)  

---

## 📎 Aligned Fundamentals

- [MambaDev Coding Style](/docs/apex/fundamentals/mamba-coding-style.md)  
- [Apex Style Guide](/docs/apex/fundamentals/apex-style-guide.md)  
- [Apex Classification Tags](https://guides.mambadev.io/docs/apex/fundamentals/mamba-apex-classification-tags.md)
- [Architecture Principles](/docs/apex/fundamentals/architecture-principles.md)  
- [Review Checklist](/docs/apex/fundamentals/apex-review-checklist.md)

---

> MambaDev doesn’t name things to be clever.  
> **We name to communicate. To scale. To dominate.**

**#NamingIsArchitecture #NoAmbiguityOnlyIntent #BuiltForTraceability** 🧠🧱🔥