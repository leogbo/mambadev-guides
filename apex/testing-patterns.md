<p align="center">
  <img src="https://raw.githubusercontent.com/leogbo/mambadev-guides/main/static/img/github_banner_mambadev.png" alt="MambaDev Banner" width="100%" />
</p>

# 🧪 Testing Patterns – MambaDev

> This guide defines the testing standards and patterns for Apex development in MambaDev.  
> It prioritizes **clarity, isolation, consistency**, and **semantic verification** over raw coverage numbers.

---

## 🎯 Purpose

A Mamba test is:

- ✅ Focused — it tests one thing only
- ✅ Deterministic — it fails only if logic is wrong
- ✅ Declarative — you understand what it's testing in seconds
- ✅ Self-contained — it sets up exactly what it needs
- ✅ Semantic — it asserts meaning, not just values

---

## 🧱 Core Testing Stack

| Class              | Purpose                                             |
|--------------------|-----------------------------------------------------|
| `TestHelper`       | Utility for generating fake data and random values  |
| `LoggerMock`       | In-memory logger used to intercept logs in tests    |
| `ExceptionUtil`    | Enables one-line validation assertions               |
| `TestDataSetup`    | *(optional)* Factory-style setup for reusable test data |

---

## 🧪 Structure of a Mamba Test Class

```apex
@IsTest
private class MyServiceTest {

    @IsTest
    static void test_shouldCreateRecordSuccessfully() {
        // Arrange
        Account acc = new Account(Name = 'Test');
        insert acc;

        // Act
        MyService.run(acc.Id);

        // Assert
        List<CustomObject__c> results = [SELECT Id FROM CustomObject__c WHERE Account__c = :acc.Id];
        System.assertEquals(1, results.size(), 'Should have created one custom record');
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

System.assert(mock.capturedMessages.contains('[INFO] Test message | payload'));
```

---

## ⚠️ Avoid Anti-Patterns

| Anti-Pattern                          | Refactor Tip                                                |
|--------------------------------------|-------------------------------------------------------------|
| `System.debug()` in tests            | Use assertions instead. Logs are not validations.           |
| Tests that insert 10+ records        | Test only the records you need. Use batches only for batch tests. |
| Using real `Logger` in tests         | Use `LoggerMock` to avoid polluting logs.                   |
| No assertions                        | Every test must prove something. At least one `System.assert`. |

---

## ✅ Recommended Patterns

### 1. Assert That Exception Is Thrown

```apex
try {
    ExceptionUtil.throwIfBlank('', 'Missing value');
    System.assert(false, 'Expected exception not thrown');
} catch (AppValidationException ex) {
    System.assertEquals('Missing value', ex.getMessage());
}
```

---

### 2. Assert That Log Was Captured

```apex
LoggerMock mock = new LoggerMock().withClass('TestCase');
mock.error('Failure occurred', new Exception('Boom'), null);

System.assert(mock.capturedMessages[0].contains('Failure occurred'));
```

---

### 3. Validate Results by Query

```apex
insert new Account(Name = 'Apex Test');

List<Account> results = [SELECT Id FROM Account WHERE Name = 'Apex Test'];
System.assertEquals(1, results.size());
```

---

## 📏 Naming Standards for Test Classes

| Type                     | Convention               |
|--------------------------|--------------------------|
| Unit test class          | `ClassNameTest`          |
| Integration test class   | `ClassNameIntegrationTest` |
| Data factory (if used)   | `TestDataSetup`          |
| Mocks                    | `LoggerMock`, `ServiceMock`, etc. |

---

## 🧠 Test Coverage Philosophy

> 100% coverage is not the goal.  
> 100% clarity is.

Instead of asking:
> “Did we test every line?”

Ask:
> “Did we test every decision?”

---

## 📚 Related Guides

- [ExceptionUtil](./exceptionutil.md)  
  Validates and throws cleanly inside tests and services.

- [LoggerMock](./structured-logging.md#🧪-testing-with-loggermock)  
  Avoid polluting real logs and test exactly what was captured.

- [Validation Patterns](./validation-patterns.md)  
  Combine declarative validation with semantic testing.

## 📎 Aligned Fundamentals

These operational guides are built on:

- [`MambaDev Coding Style`](../fundamentals/mambadev-coding-style.md)
- [`Apex Style Guide`](../fundamentals/apex-style-guide.md)
- [`Architecture Principles`](../fundamentals/architecture-principles.md)
- [`Review Checklist`](../fundamentals/apex-review-checklist.md)

---

> A Mamba test is not just a check.  
> It’s a contract — proving the system works as intended.
