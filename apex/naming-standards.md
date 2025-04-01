<p align="center">
  <img src="https://raw.githubusercontent.com/leogbo/mambadev-guides/main/static/img/github_banner_mambadev.png" alt="MambaDev Banner" width="100%" />
</p>

# ✍️ Naming Standards – MambaDev Apex

> This guide defines **clear, consistent naming conventions** for Apex code in MambaDev.  
> Because naming is not cosmetic — it's architectural.

---

## 🎯 Purpose

Naming is architecture.

In MambaDev, names must:

- ✅ Reveal intent
- ✅ Respect hierarchy
- ✅ Be searchable
- ✅ Avoid ambiguity
- ✅ Stand the test of refactoring

---

## 🧱 General Principles

| Rule                               | Example                              |
|------------------------------------|--------------------------------------|
| Use `PascalCase` for class names   | `AccountService`, `QuoteHelper`      |
| Use `camelCase` for variables      | `userId`, `accountList`              |
| Always be **descriptive**, not clever | `LeadConversionService`, not `LCS` |
| Use nouns for classes              | `Logger`, `PricingRule`              |
| Use verbs for methods              | `calculateTotal()`, `validateEmail()`|

---

## 📦 Class Naming Conventions

| Class Type         | Convention                   | Example                       |
|--------------------|------------------------------|-------------------------------|
| Controller / Invocable | Ends with `Controller`    | `LeadController`              |
| Service            | Ends with `Service`          | `AccountMergeService`         |
| Domain Logic       | Ends with `Rule`, `Engine`   | `DiscountRule`, `PricingEngine`|
| Utility / Helper   | Ends with `Helper`, `Util`   | `ExceptionUtil`, `DateHelper` |
| Exception          | Ends with `Exception`        | `AppValidationException`      |
| Test Class         | Ends with `Test`             | `AccountServiceTest`          |
| Mock               | Ends with `Mock`             | `LoggerMock`, `ServiceMock`   |
| Trigger Handler    | Ends with `TriggerHandler`   | `OpportunityTriggerHandler`   |

---

## 🔁 Method Naming

| Pattern                    | Purpose                                      | Example                  |
|----------------------------|----------------------------------------------|--------------------------|
| `getX()` / `fetchX()`      | Return a value                               | `getEligibleAccounts()`  |
| `setX()`                   | Assign a value                               | `setUserId()`            |
| `isX()` / `hasX()`         | Return a boolean                             | `isActive()`, `hasAccess()` |
| `validateX()`              | Perform validation                           | `validateEmail()`        |
| `run()`, `execute()`       | Entry points / orchestration                 | `run()`, `executeBatch()`|
| `fromX()` / `toX()`        | Factory or conversion                        | `fromTrigger()`, `toJSON()`|

---

## 📄 Variable Naming

| Type               | Rule                         | Example                       |
|--------------------|------------------------------|-------------------------------|
| Boolean            | Prefix with `is`, `has`, `should` | `isValid`, `hasEmail`    |
| List / Collection  | Use plural                   | `accounts`, `rules`           |
| IDs                | End with `Id`, `Ids`         | `userId`, `leadIds`           |
| DTO / Map          | Describe purpose             | `flowInput`, `requestData`    |

---

## 🧪 Test Class Naming & Structure

- Test class: `ClassUnderTestTest`
- Test method: `test_<scenario>_<expectedBehavior>()`

```apex
@IsTest
private class LeadConversionServiceTest {

    @IsTest
    static void test_convertLead_shouldCreateAccountAndContact() {
        // ...
    }
}
```

---

## 🧼 Apex Custom Metadata & Fields

| Element               | Convention                   | Example                        |
|------------------------|------------------------------|--------------------------------|
| Custom Object API Name | PascalCase + `__c`           | `FlowExecutionLog__c`         |
| Custom Field API Name  | camelCase + `__c`            | `triggerType__c`, `flowName__c`|
| Picklist Values        | SCREAMING_SNAKE_CASE         | `INBOUND`, `OUTBOUND`         |

---

## ❌ Naming Anti-Patterns

| Anti-pattern              | Fix                                                       |
|---------------------------|------------------------------------------------------------|
| `Utils`, `Things`, `Manager` | Rename with domain or purpose: `Logger`, `PricingRule` |
| `a`, `x`, `y` in loops     | Use meaningful names: `lead`, `account`, `lineItem`       |
| `doStuff()`, `handleIt()` | Use verbs that show **what** and **why**                  |

---

## 📚 Related Guides

- [Layered Architecture](./layered-architecture.md)  
  Naming follows structure. Structure follows intent.

- [Testing Patterns](./testing-patterns.md)  
  How to name tests that describe behavior clearly.

- [Validation Patterns](./validation-patterns.md)  
  Use naming that reveals rule logic and scope.

## 📎 Aligned Fundamentals

These operational guides are built on:

- [`MambaDev Coding Style`](../fundamentals/mambadev-coding-style.md)
- [`Apex Style Guide`](../fundamentals/apex-style-guide.md)
- [`Architecture Principles`](../fundamentals/architecture-principles.md)
- [`Review Checklist`](../fundamentals/apex-review-checklist.md)

---

> MambaDev doesn’t name things to be clever.  
> We name to communicate. To scale. To dominate.
