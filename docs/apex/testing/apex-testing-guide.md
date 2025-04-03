<p align="center">
  <img src="https://raw.githubusercontent.com/leogbo/mambadev-guides/main/static/img/github_banner_mambadev.png" alt="MambaDev Banner" width="100%" />
</p>

> 🧱 @status:core | This guide defines the official MambaDev testing standards for Apex, including test structure, setup, assertions, and mocking.

# 🧪 Official Apex Testing Guide (Mamba Style)

📎 [Shortlink: mambadev.io/apex-testing-guide](https://mambadev.io/apex-testing-guide)

> "Testing isn't the last step. It's part of excellence from day one."

---

## 🌟 Purpose

Ensure every test:

- ✅ Covers actual logic (not boilerplate)
- ✅ Uses `TestDataSetup` — no inline inserts
- ✅ Makes expressive, traceable assertions
- ✅ Validates logic — not implementation
- ✅ Preserves backward compatibility in refactors

---

## 🔗 See Also

- [Mamba Layered Architecture](/docs/apex/fundamentals/layered-architecture.md)  
- [Testing Patterns](/docs/apex/testing/testing-patterns.md)  
- [LoggerMock](/docs/apex/logging/logger-mock.md)  
- [TestDataSetup](/docs/apex/testing/test-data-setup.md)  
- [EnvironmentUtils.cls](https://github.com/leogbo/mambadev-guides/blob/main/src/classes/environment-utils.cls)  
- [TestHelper.cls](https://github.com/leogbo/mambadev-guides/blob/main/src/classes/test-helper.cls)  
- [Equivalence Checklist](/docs/apex/fundamentals/equivalence-checklist.md)

---

## ✅ Base Test Template

```apex
@IsTest
static void test_case_behavior_expectedResult() {
    Test.startTest();
    // Execute
    Test.stopTest();

    System.assertEquals('expected', result.get('key'));
}
```

### Standard Setup

```apex
@TestSetup
static void setup() {
    TestDataSetup.setupCompleteEnvironment();
    FlowControlManager.disableFlows();
}
```

---

## ❌ Anti-Patterns → ✅ Mamba Way

| Anti-pattern               | ✅ Mamba Fix                         |
|---------------------------|--------------------------------------|
| `System.debug()`          | Use `LoggerMock` if needed           |
| Log assertions            | Assert only on logic/data outcomes   |
| Manual DML                | Use `TestDataSetup` only             |
| Type-branching logic      | Use `TestHelper.fakeIdForSafe(...)`  |

---

## 🧠 Assert Mastery

```apex
System.assertEquals('FINALIZED', result.get('status'), 'Expected status to be FINALIZED');
System.assertEquals(3, list.size(), 'Expected 3 results');
System.assert(result.get('message') != null, 'Message must not be null');
```

- ✅ Always include assertion messages  
- ✅ Focus on behavior, not structure  
- ✅ Avoid silent test passes

---

## 🔒 Logger in Tests

```apex
Logger.overrideLogger(new LoggerMock());
Logger.isEnabled = false;
```

- ✅ Never persist `FlowExecutionLog__c` in tests  
- ✅ Always use `LoggerMock` instead

---

## ⚖️ `TestHelper` Utilities

```apex
Id fakeId = TestHelper.fakeIdForSafe(Account.SObjectType);
String email = TestHelper.randomEmail();
TestHelper.assertSetupCreated('Account');
```

---

## 📘 Advanced Patterns

### ✅ Exception Flagging

```apex
@IsTest
static void should_throw_validation() {
    try {
        service.doSomethingInvalid();
        System.assert(false, 'Expected exception');
    } catch (AppValidationException ex) {
        System.assertEquals('Missing field', ex.getMessage());
    }
}
```

### ✅ Async Logging Test

```apex
@IsTest
static void should_enqueue_logger_queueable() {
    Test.startTest();
    System.enqueueJob(new LoggerQueueable(log));
    Test.stopTest();
    System.assert(true, 'LoggerQueueable executed.');
}
```

---

## 🧱 Test Class Naming

```apex
@IsTest
private class LeadConversionService_Should_Convert_When_Valid_Test {}
```

- ✅ Method = `should_do_X_when_Y()`

---

## 🧪 Test Types Required

| Type         | Expectation |
|--------------|-------------|
| Happy Path   | Valid flow success |
| Bad Request  | Missing/invalid input triggers `badRequest()` |
| Not Found    | Valid ID returns no data |
| Internal Error | Unexpected failure triggers `500` |
| Functional Equivalence | Refactor must pass legacy assertions |

---

## 📦 Modularization Pattern

- ✅ One test class per logic/service class  
- ✅ One method per behavior  
- ✅ Always use `TestDataSetup` for inserts  
- ✅ No logic leakage between tests

---

## ✅ Mamba Test Checklist

- [x] Uses `@IsTest` and `@TestSetup`  
- [x] Covers happy, error, and edge cases  
- [x] Uses `LoggerMock`, never real logs  
- [x] Assertion messages are clear and expressive  
- [x] Logic paths fully covered  
- [x] Contracts preserved after refactors  
- [x] Behavior is proven — not guessed

---

> If your test doesn't give you confidence, it doesn't qualify as Mamba.  
> **Test what matters. Test like Mamba.**

**#TestBehaviorNotStructure #AssertWithMeaning #RefactorWithProof**