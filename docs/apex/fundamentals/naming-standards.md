<p align="center">
  <img src="https://raw.githubusercontent.com/leogbo/mambadev-guides/main/static/img/github_banner_mambadev.png" alt="MambaDev Banner" width="100%" />
</p>

# ✍️ Naming Standards – MambaDev Apex

> This guide defines **clear, consistent naming conventions** for Apex code in MambaDev.  
> Because naming is not cosmetic — it's architectural.

---

## 🎯 Purpose

**Naming is architecture.**

In MambaDev, names must:

- ✅ Reveal intent  
- ✅ Respect hierarchy  
- ✅ Be searchable  
- ✅ Avoid ambiguity  
- ✅ Survive refactors

---

## 🧱 General Guidelines

| Pattern                            | Example                              |
|------------------------------------|--------------------------------------|
| Use `PascalCase` for class names   | `AccountService`, `QuoteHelper`      |
| Use `camelCase` for variables      | `userId`, `accountList`              |
| Use **meaningful**, not clever names | `LeadConversionService`, not `LCS` |
| Use **nouns** for classes          | `Logger`, `PricingRule`              |
| Use **verbs** for methods          | `calculateTotal()`, `validateEmail()`|

---

## 📦 Class Naming Patterns

| Class Type         | Convention                   | Example                        |
|--------------------|------------------------------|--------------------------------|
| Controller / Invocable | Ends with `Controller`    | `LeadController`               |
| Service            | Ends with `Service`          | `AccountMergeService`          |
| Domain Logic       | Ends with `Rule`, `Engine`   | `DiscountRule`, `PricingEngine`|
| Utility / Helper   | Ends with `Helper`, `Util`   | `ExceptionUtil`, `DateHelper`  |
| Exception          | Ends with `Exception`        | `AppValidationException`       |
| Test Class         | Ends with `Test`             | `AccountServiceTest`           |
| Mock               | Ends with `Mock`             | `LoggerMock`, `EmailServiceMock`|
| Trigger Handler    | Ends with `TriggerHandler`   | `OpportunityTriggerHandler`    |

---

## 🔁 Method Naming Patterns

| Pattern              | Intent                                 | Example                      |
|----------------------|----------------------------------------|------------------------------|
| `getX()` / `fetchX()`| Retrieve or query                      | `getEligibleAccounts()`      |
| `setX()`             | Assign a value                         | `setUserId()`                |
| `isX()` / `hasX()`   | Boolean checks                         | `isActive()`, `hasAccess()`  |
| `validateX()`        | Enforce validation rules               | `validateEmail()`            |
| `run()` / `execute()`| Entry points / orchestration methods   | `run()`, `executeBatch()`    |
| `fromX()` / `toX()`  | Converters / factories                 | `fromTrigger()`, `toJSON()`  |

---

## 📄 Variable Naming Guidelines

| Type               | Rule                                   | Example                     |
|--------------------|----------------------------------------|-----------------------------|
| Boolean            | Prefix with `is`, `has`, `should`      | `isValid`, `shouldNotify`  |
| Lists / Collections| Use plural                             | `accounts`, `errorMessages`|
| Identifiers        | End with `Id`, `Ids`                   | `userId`, `contactIds`     |
| Maps / DTOs        | Describe structure or context          | `flowInput`, `requestData` |

---

## 🧪 Test Class Naming & Structure

- **Test class:** `ClassUnderTestTest`  
- **Test method:** `test_<scenario>_<expectedBehavior>()`

```apex
@IsTest
private class LeadConversionServiceTest {

    @IsTest
    static void test_convertLead_shouldCreateAccountAndContact() {
        // Setup, execute, assert
    }
}
```

> ✅ Tests should describe **intent**, not just code paths.

---

## 🧼 Custom Metadata & Field Naming

| Element               | Pattern                        | Example                       |
|------------------------|-------------------------------|-------------------------------|
| Custom Object API Name | PascalCase + `__c`            | `FlowExecutionLog__c`         |
| Custom Field API Name  | camelCase + `__c`             | `triggerType__c`, `flowName__c`|
| Picklist Values        | `SCREAMING_SNAKE_CASE`        | `INBOUND`, `OUTBOUND`         |

---

## ❌ Naming Anti-Patterns

| Anti-pattern              | Fix                                                       |
|---------------------------|------------------------------------------------------------|
| Generic: `Utils`, `Things`, `Manager` | Rename with domain or function: `EmailHelper`, `QuoteEngine` |
| Cryptic variables: `a`, `x`, `y`      | Use meaningful names: `lead`, `lineItem`, `approvalStep`      |
| Vague methods: `doStuff()`, `handleIt()` | Use verbs that express **what** and **why**                |

---

## 📚 Related Guides

- [Layered Architecture](./layered-architecture.md)  
  Naming flows from structure — and structure flows from responsibility.

- [Testing Patterns](./testing-patterns.md)  
  Write tests that are self-documenting via naming.

- [Validation Patterns](./validation-patterns.md)  
  Rule naming should describe business conditions clearly.

---

## 📎 Aligned Fundamentals

- [`MambaDev Coding Style`](../fundamentals/mambadev-coding-style.md)  
- [`Apex Style Guide`](../fundamentals/apex-style-guide.md)  
- [`Architecture Principles`](../fundamentals/architecture-principles.md)  
- [`Review Checklist`](../fundamentals/apex-review-checklist.md)

---

> MambaDev doesn’t name things to be clever.  
> **We name to communicate. To scale. To dominate.** 🧠🔥
