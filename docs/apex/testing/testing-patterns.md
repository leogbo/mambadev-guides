<p align="center">
  <img src="https://raw.githubusercontent.com/leogbo/mambadev-guides/main/static/img/github_banner_mambadev.png" alt="MambaDev Banner" width="100%" />
</p>

> 🧱 @status:core | This guide defines MambaDev's official Apex testing patterns — focused on logic, readability, and guarantees.

# 🧪 Testing Patterns – MambaDev

📎 [Shortlink: mambadev.io/testing-patterns](https://mambadev.io/testing-patterns)

> A Mamba test is not just a check.  
> **It's a contract. A guarantee. A shield.**  
> And it never fails for the wrong reason. 🧠🔥

---

## 🎯 Purpose

A true Mamba test must be:

- ✅ Focused — one behavior per method  
- ✅ Deterministic — never flaky  
- ✅ Expressive — readable and semantic  
- ✅ Self-contained — sets up what it needs  
- ✅ Proof-driven — validates meaning, not coverage

---

## 🧱 Core Testing Stack

| Component              | Role                                    |
|------------------------|-----------------------------------------|
| [`TestHelper.cls`](https://github.com/leogbo/mambadev-guides/blob/main/src/classes/test-helper.cls) | Utility for fake values + asserts |
| [`LoggerMock.cls`](https://github.com/leogbo/mambadev-guides/blob/main/src/classes/logger-mock.cls) | Prevents log persistence           |
| [`ExceptionUtil.cls`](https://github.com/leogbo/mambadev-guides/blob/main/src/classes/exception-util.cls) | Declarative validation assertions |
| [`TestDataSetup.cls`](https://github.com/leogbo/mambadev-guides/blob/main/src/classes/test-data-setup.cls) | Org-safe full environment setup    |

---

## 📐 Test Class Layout

```apex
@IsTest
private class MyServiceTest {

    @IsTest
    static void should_create_record_when_input_valid() {
        // Arrange
        Account acc = AccountTestDataSetup.createAccount();

        // Act
        MyService.run(acc.Id);

        // Assert
        List<CustomObject__c> results = [SELECT Id FROM CustomObject__c WHERE Account__c = :acc.Id];
        System.assertEquals(1, results.size(), 'Expected one record to be created');
    }
}
```

> ✅ Name methods like behavior contracts: `should_do_X_when_Y()`

---

## 🔁 Logging in Tests

```apex
Logger.overrideLogger(new LoggerMock());
Logger.isEnabled = false;
```

✅ Always use `LoggerMock`  
❌ Never use `Logger` in test classes

---

## ⚠️ Anti-Patterns

| 🚫 Pattern              | ⚠️ Why It Breaks Tests                 | ✅ Mamba Fix                      |
|------------------------|----------------------------------------|----------------------------------|
| `System.debug()`       | Adds noise, not proof                  | Use `System.assert()` instead   |
| `insert 20 records`    | Slows down tests                       | Insert only what is needed      |
| Raw `new + insert`     | Bypasses builders                      | Use `*TestDataSetup`            |
| No assertions          | Test doesn't prove anything            | Assert expected outcome clearly |
| Asserting `Logger` logs| Tightly coupled + fragile              | Use `LoggerMock.getCaptured()`  |

---

## ✅ Assertion Patterns

```apex
System.assertEquals(3, items.size(), 'Expected 3 items created');
System.assert(result != null, 'Result should not be null');
System.assert(result.contains('SUCCESS'), 'Expected success message');
```

✅ Always include messages  
✅ Assert decisions, not side-effects

---

## 🔁 `ExceptionUtil` for Validation Testing

```apex
try {
    ExceptionUtil.throwIfBlank('', 'Email required');
    System.assert(false, 'Expected exception not thrown');
} catch (AppValidationException ex) {
    System.assertEquals('Email required', ex.getMessage());
}
```

---

## 🧱 Use of `TestDataSetup`

> **All test data must be created via `*TestDataSetup.cls` builders.**

✅ Ensures:

- Referential integrity  
- Rule-consistent setup  
- Cache isolation  
- Reusability

```apex
// Bad
insert new Opportunity(Name = 'Deal');

// Good
Opportunity opp = OpportunityTestDataSetup.createOpportunity();
```

---

## ✅ LoggerMock Example

```apex
LoggerMock mock = new LoggerMock().withClass('TestCase');
mock.error('Failure occurred', new Exception('Boom'), null);
System.assert(mock.getCaptured()[0].contains('Failure occurred'));
```

---

## ⚠️ Exception: System.debug in Setup Builders

```apex
// Allowed inside TestDataSetup:
System.debug('Creating test Account...');
```

❌ Never use `Logger` inside setup data factories.  
✅ Use `System.debug()` for trace **only** if no side effects exist.

---

## 🧪 Modularization Rules

| Rule                         | Enforced |
|------------------------------|----------|
| One test class per service   | ✅        |
| One method per behavior      | ✅        |
| All builders centralized     | ✅        |
| Use `@TestSetup`             | ✅        |
| No cross-method dependencies | ✅        |

---

## 📏 Naming Conventions

| Type                  | Format                        |
|-----------------------|-------------------------------|
| Unit test class       | `ClassUnderTestTest`          |
| Integration test class| `ClassUnderTestIntegrationTest` |
| Data setup factory    | `XyzTestDataSetup.cls`        |
| Logger mock           | `LoggerMock.cls`              |

---

## 🧠 Coverage Philosophy

> ✅ 100% logic clarity  
> ❌ 100% line coverage obsession

A passing test must prove:

- The logic makes decisions  
- The decisions are correct  
- The outputs are validated  
- The behavior is preserved after refactor

---

## 📚 Related Guides

- [Apex Testing Guide](/docs/apex/testing/apex-testing-guide.md)  
- [LoggerMock Guide](/docs/apex/logging/logger-mock.md)  
- [ExceptionUtil](/docs/apex/logging/exception-util.md)  
- [Validation Patterns](/docs/apex/testing/validation-patterns.md)  
- [Structured Logging](/docs/apex/logging/structured-logging.md)

---

## 📎 Aligned Fundamentals

- [MambaDev Coding Style](/docs/apex/fundamentals/mamba-coding-style.md)  
- [Review Checklist](/docs/apex/fundamentals/apex-review-checklist.md)  
- [Architecture Principles](/docs/apex/fundamentals/architecture-principles.md)

---

> Mamba tests aren’t scripts.  
> They are contracts.  
> **They guard the truth of the platform.**

**#TestWithPurpose #NoDebugOnlyProof #ClarityOverCoverage** 🧠🧪🧱🔥