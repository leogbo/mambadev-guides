<p align="center">
  <img src="https://raw.githubusercontent.com/leogbo/mambadev-guides/main/static/img/github_banner_mambadev.png" alt="MambaDev Banner" width="100%" />
</p>

> 🧱 @status:core | This document defines the official layering model for Apex services in MambaDev.  
> All modules must comply to ensure testability, observability, and platform safety.

# 🧱 Layered Architecture – MambaDev

📎 [Shortlink: mambadev.io/layered-architecture](https://mambadev.io/layered-architecture)

> A guide for organizing Apex code into **modular, scalable, testable layers**.  
> Inspired by Domain-Driven Design and Clean Architecture — reinterpreted for Salesforce.

---

## 🎯 Purpose

Layering enforces **separation of concerns**, ensuring:

- ✅ You know **where** logic lives  
- ✅ You know **who** calls who  
- ✅ You can replace, mock, or extend behavior safely  
- ✅ The codebase is readable, testable, and collaboration-friendly

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

### 🔹 1. Controllers → **Handle requests only**

> Entry points for Flows, REST, Triggers.  
> Delegates to services. **Never** contains business logic.

Examples:
- Flow Action Apex Classes
- `@InvocableMethod`
- `@AuraEnabled`
- `@RestResource`

---

### 🔹 2. Services → **Coordinate use cases**

> Orchestrates operations. Owns transactions and logging.  
> Uses [`ExceptionUtil`](/src/classes/exception-util.cls) and [`Logger`](/src/classes/logger.cls), but avoids business logic.

- Named for behavior (`LeadConversionService`, `BillingService`)
- Central place to:
  - Validate with `ExceptionUtil`
  - Log with `Logger`
  - Call domain logic or helpers
  - Perform DML (as needed)

---

### 🔹 3. Domain Logic → **Contain business rules**

> Stateless, reusable logic that applies regardless of controller or integration.  
> Pure logic, no infrastructure.

Examples:
- `ProductPricingEngine`
- `AccountEligibilityRule`
- `QuoteApprovalStrategy`

Guidelines:
- No DML  
- No Logger  
- No platform dependencies

---

### 🔹 4. Helpers & Utilities → **Provide pure functions**

> Stateless, side-effect-free logic shared across layers.

Examples:
- `StringHelper`
- `DateMath`
- [`ExceptionUtil`](/src/classes/exception-util.cls)
- `ValidationRulesEngine`

Never:
- Contain business logic  
- Perform DML  
- Know about domains

---

### 🔹 5. Platform APIs → **Access the platform safely**

> Lowest layer. Used by services or helpers — never by controllers or domain logic.

Examples:
- `Database.convertLead`
- `Schema.getGlobalDescribe()`
- `insert/update/delete`
- `Flow.Interview`

---

## 🧪 Example: Lead Conversion Flow

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

| Pattern                            | Why it breaks architecture                                         |
|------------------------------------|--------------------------------------------------------------------|
| Logic in Triggers or Flow Actions | Hard to test, reuse or debug                                       |
| Services mixing logic and DML     | Violates separation of concerns                                    |
| Helpers doing DML or logging      | Breaks purity — helpers must be infrastructure-free                |
| Logger in domain rules            | Domain logic must not depend on side-effects or platform concerns  |

---

## ✅ Mamba Layer Rules

| Layer         | ✅ Allowed                           | ❌ Forbidden                         |
|---------------|-------------------------------------|-------------------------------------|
| Controller    | Call services                       | Business logic, DML, logging        |
| Service       | Orchestrate, log, validate, DML     | Complex rule logic                  |
| Domain        | Rules, pure logic                   | Logger, DML                         |
| Helper        | Pure functions                      | Business logic, platform access     |
| Platform API  | Called by service/helper            | Never directly from controller/domain |

---

## 📚 Related Guides

- [Structured Logging](/docs/apex/logging/structured-logging.md)  
- [Validation Patterns](/docs/apex/testing/validation-patterns.md)  
- [Testing Patterns](/docs/apex/testing/testing-patterns.md)

---

## 📎 Aligned Fundamentals

- [MambaDev Coding Style](/docs/apex/fundamentals/mamba-coding-style.md)  
- [Apex Style Guide](/docs/apex/fundamentals/apex-style-guide.md)  
- [Architecture Principles](/docs/apex/fundamentals/architecture-principles.md)  
- [Review Checklist](/docs/apex/fundamentals/apex-review-checklist.md)

---

> Code without layers is code without clarity.  
> **MambaDev separates to scale — and builds to endure.** 🧱🔥