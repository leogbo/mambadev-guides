<p align="center">
  <img src="https://raw.githubusercontent.com/leogbo/mambadev-guides/main/static/img/github_banner_mambadev.png" alt="MambaDev Banner" width="100%" />
</p>

# 🧪 Testing Patterns – MambaDev

> This guide defines the testing standards and patterns for Apex development in MambaDev.  
> It prioritizes **clarity, isolation, consistency**, and **semantic validation** — not raw coverage numbers.

---

## 🎯 Purpose

A Mamba test must be:

- ✅ Focused — it verifies **one behavior** only  
- ✅ Deterministic — fails only if logic is broken  
- ✅ Declarative — the intent is obvious  
- ✅ Self-contained — no external dependencies  
- ✅ Semantic — asserts **meaning**, not just values

---

## 🧱 Core Testing Stack

| Component         | Role                                                |
|-------------------|-----------------------------------------------------|
| `TestHelper`      | Utility for generating fake/random values           |
| `LoggerMock`      | In-memory logger used to intercept logs in tests    |
| `ExceptionUtil`   | One-line validation and failure assertions           |
| `*TestDataSetup`  | Factory-style data setup to ensure integrity         |

---

## 📐 Test Class Structure (Standard)

```apex
@IsTest
private class MyServiceTest {

    @IsTest
    static void test_shouldCreateRecordSuccessfully() {
        // Arrange
        Account acc = AccountTestDataSetup.createAccount();

        // Act
        MyService.run(acc.Id);

        // Assert
        List<CustomObject__c> results = [SELECT Id FROM CustomObject__c WHERE Account__c = :acc.Id];
        System.assertEquals(1, results.size(), 'Should have created one record');
    }
}
```

---

## 🔁 Using `LoggerMock`

```apex
LoggerMock mock = new LoggerMock()
    .withClass('MyService')
    .withMethod('doSomething');

mock.info('Test message', 'payload');

System.assert(mock.getCaptured().contains('[INFO] Test message | payload'));
```

> Use `LoggerMock` to avoid DML during tests. Never use real `Logger`.

---

## ⚠️ Anti-Patterns to Avoid

| Anti-pattern                   | Why it's bad                                           | Fix                                       |
|-------------------------------|--------------------------------------------------------|-------------------------------------------|
| `System.debug()` in tests     | Logs ≠ validations                                     | Use `System.assert(...)`                  |
| Inserting 10+ records         | Adds noise and slowness                                | Only create what's needed                 |
| Direct `new` + `insert`       | Bypasses setup logic and causes integrity issues       | Use `*TestDataSetup` classes              |
| Using real `Logger`           | Causes real DML and pollutes log tables                | Use `LoggerMock`                          |
| No assertions                 | Test does not prove anything                           | Always assert at least one expected result |

---

## ✅ Recommended Patterns

### 1. Assert Exception is Thrown

```apex
try {
    ExceptionUtil.throwIfBlank('', 'Missing value');
    System.assert(false, 'Expected exception not thrown');
} catch (AppValidationException ex) {
    System.assertEquals('Missing value', ex.getMessage());
}
```

---

### 2. Assert Log is Captured

```apex
LoggerMock mock = new LoggerMock().withClass('TestCase');

mock.error('Failure occurred', new Exception('Boom'), null);

System.assert(mock.getCaptured()[0].contains('Failure occurred'));
```

---

### 3. Validate Results by Query

```apex
Account acc = AccountTestDataSetup.createAccount();

List<Account> results = [SELECT Id FROM Account WHERE Id = :acc.Id];
System.assertEquals(1, results.size());
```

---

## 🧼 TestDataSetup Rule

> 🧱 **All records must be created using their respective `*TestDataSetup.cls` factory classes.**

This ensures:

- Referential integrity  
- Business rule compliance  
- Isolation from production logic  
- Predictable, reusable test environments

```apex
// ❌ Don't do this:
insert new Opportunity(Name = 'Deal');

// ✅ Do this:
Opportunity opp = OpportunityTestDataSetup.createOpportunity();
```

---

## ⚠️ Exception – System.debug() in Setup

```md
System.debug() is **prohibited everywhere**, except inside `*TestDataSetup.cls` classes.

These classes are used for high-volume setup and must **avoid Logger or DML side effects**.
Use `System.debug()` only to support trace during local testing or data factory diagnostics.
```

---

## 📏 Naming Conventions

| Type                     | Pattern                      |
|--------------------------|------------------------------|
| Unit test class          | `ClassNameTest`              |
| Integration test class   | `ClassNameIntegrationTest`   |
| Shared setup utility     | `TestDataSetup`              |
| Mocks                    | `LoggerMock`, `EmailServiceMock` |

> Test names should describe **behavior and expectation**.

---

## 🧠 Coverage Philosophy

> ✅ **100% clarity.**  
> ❌ 100% coverage obsession.

Instead of asking:
> “Did we test every line?”

Ask:
> “Did we test every decision?”

---

## 📚 Related Guides

- [ExceptionUtil](./exceptionutil.md)  
  Enables concise exception assertions.

- [Structured Logging](./structured-logging.md#🧪-testing-with-loggermock)  
  Avoid log pollution — mock and assert logs cleanly.

- [Validation Patterns](./validation-patterns.md)  
  Declarative rules tested semantically.

---

## 📎 Aligned Fundamentals

- [`MambaDev Coding Style`](../fundamentals/mambadev-coding-style.md)  
- [`Apex Style Guide`](../fundamentals/apex-style-guide.md)  
- [`Architecture Principles`](../fundamentals/architecture-principles.md)  
- [`Review Checklist`](../fundamentals/apex-review-checklist.md)

---

> A Mamba test is not just a check.  
> **It's a contract. A guarantee. A shield.**  
> And it never fails for the wrong reason. 🧠🔥
