<p align="center">
  <img src="https://raw.githubusercontent.com/leogbo/mambadev-guides/main/static/img/github_banner_mambadev.png" alt="MambaDev Banner" width="100%" />
</p>

# 🧱 Layered Architecture – MambaDev

> A guide for organizing Apex code into **modular, scalable, testable layers**.  
> Inspired by Domain-Driven Design and Clean Architecture — reinterpreted for Salesforce.

---

## 🎯 Purpose

The goal of layering is **separation of concerns**.

- ✅ Know **where** logic lives  
- ✅ Know **who** calls who  
- ✅ Replace, mock, or extend behavior **without breaking the system**  
- ✅ Improve readability, testability, and team collaboration

---

## 🧭 Mamba Layer Model

```plaintext
[ Controllers ]
     ↓
[ Services ]
     ↓
[ Domain Logic ]
     ↓
[ Helpers & Utilities ]
     ↓
[ Platform APIs & DML ]
```

---

### 🔹 1. Controllers

> Responsible for receiving the request (from Flow, REST, Trigger)  
> Calls the service layer. Does not contain logic.

Examples:
- Flow Action Apex Class
- `@InvocableMethod`
- `@AuraEnabled` methods
- REST `@RestResource` methods

---

### 🔹 2. Services

> Coordinate use cases. They orchestrate logic but do not implement the rules themselves.

- Named with clear intent (`LeadConversionService`, `BillingService`)
- Own the transaction boundaries
- Use `ExceptionUtil` to validate
- Use `Logger` to record the operation

---

### 🔹 3. Domain Logic

> Business rules that apply regardless of UI or integration.  
> Pure Apex logic, reusable across org boundaries.

Examples:
- `ProductPricingEngine`
- `AccountEligibilityRule`
- `QuoteApprovalStrategy`

They should be:
- Stateless
- Testable
- Free from DML and UI logic

---

### 🔹 4. Helpers & Utilities

> Shared logic across layers. Simple functions with no side effects.

Examples:
- `StringHelper`
- `DateMath`
- `ExceptionUtil`
- `RecordHelper`
- `ValidationRulesEngine`

Should be `public` or `global` and **never know about business logic**.

---

### 🔹 5. Platform APIs (DML, SOQL, Schema)

> Lowest layer: only used by services and helpers.

Examples:
- `Database.convertLead`
- `Schema.getGlobalDescribe()`
- `insert/update/delete`
- `Flow.Interview`

These should **never be called directly from controllers**.

---

## 🧪 Example: Lead Conversion

```plaintext
Flow → LeadController → LeadConversionService → LeadConversionRule → Logger + DML
```

```apex
public class LeadController {
    @InvocableMethod
    public static void convertLeads(List<Id> leadIds) {
        new LeadConversionService().convertBatch(leadIds);
    }
}
```

---

## ⚠️ Anti-Patterns to Avoid

| Pattern                              | Why it breaks the architecture                              |
|--------------------------------------|--------------------------------------------------------------|
| Logic in Triggers or Flow Actions   | Hard to test, duplicate, or reuse                            |
| Services doing DML and business logic| Too much responsibility, no separation                       |
| Helpers calling DML or Logger        | Violates pure function principles                            |
| Logging in domain classes            | Domain logic shouldn't care about infrastructure             |

---

## ✅ Mamba Rules

- Controllers: ❌ no logic, ✅ call services
- Services: ✅ coordinate, ❌ contain rules
- Domain: ✅ isolated, testable, ❌ DML
- Helpers: ✅ reusable, ❌ know business
- Logger/Exception: ✅ only in service or controller layer

---

## 📚 Related Guides

- [Structured Logging](./structured-logging.md)  
  Logging flows cleanly through service layers only.

- [Validation Patterns](./validation-patterns.md)  
  All validations should be at the service layer using `ExceptionUtil`.

- [Testing Patterns](./testing-patterns.md)  
  How to test each layer in isolation and mock the rest.

## 📎 Aligned Fundamentals

These operational guides are built on:

- [`MambaDev Coding Style`](../fundamentals/mambadev-coding-style.md)
- [`Apex Style Guide`](../fundamentals/apex-style-guide.md)
- [`Architecture Principles`](../fundamentals/architecture-principles.md)
- [`Review Checklist`](../fundamentals/apex-review-checklist.md)

---

> Code without layers is code without clarity.  
> In MambaDev, we separate to scale — and we build to last.
