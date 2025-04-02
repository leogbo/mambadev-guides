<p align="center">
  <img src="https://raw.githubusercontent.com/leogbo/mambadev-guides/main/static/img/github_banner_mambadev.png" alt="MambaDev Banner" width="100%" />
</p>

# 🧪 Official Apex Testing Guide (Mamba Style)

> "Testing isn't the last step. It's part of excellence from day one."

---

## 🌟 Purpose

Ensure every test:
- Covers real logic (no shortcuts)
- Has clear, traceable, expressive assertions
- Uses mocks without asserting side effects
- Relies on real test data via `TestDataSetup`
- Maintains legacy compatibility (no contract breaks)

> See also:
> - [Mamba Architecture](https://mambadev.io/layered-architecture)
> - [Apex Testing Patterns](https://mambadev.io/testing-patterns)
> - [Mamba Logger](https://mambadev.io/logger-implementation)
> - [TestDataSetup Guide](https://mambadev.io/test-data-setup)
> - [TestHelper Utility](https://mambadev.io/test-helper)
> - [EnvironmentUtils Config](https://mambadev.io/environment-utils)
> - [LoggerMock Mocking](https://mambadev.io/logger-mock)

---

## ✅ Base Test Structure

```apex
@IsTest
static void test_method_name() {
    Test.startTest();
    // execute logic
    Test.stopTest();

    System.assertEquals('expected', response.get('key'));
}
```

### Standard Setup:
```apex
@TestSetup
static void setup() {
    TestDataSetup.setupCompleteEnvironment();
    FlowControlManager.disableFlows();
}
```

---

## ⚠️ Never Do This:

| Anti-pattern               | Mamba Way                               |
|---------------------------|------------------------------------------|
| `System.debug()`          | Use `LoggerMock` if needed for inspection|
| Asserting log content     | Assert only on actual behavior/results   |
| Manual bulk `insert`      | Use `TestDataSetup`                      |
| `if` by type inside test  | Use `TestHelper.fakeIdForSafe(...)`      |

---

## 🧠 Assert Mastery

### ✅ Refined Assertions
```apex
System.assertEquals('FINALIZED', result.get('status').toUpperCase(), 'Unexpected status: ' + result.get('status'));
System.assertEquals(3, proposals.size(), 'Incorrect proposal count: ' + proposals.size());
System.assert(result.get('message') != null, 'Message should not be null');
System.assert(result.get('message').toUpperCase().contains('SUCCESS'), 'Message should contain "SUCCESS". Got: ' + result.get('message'));
```

- Each assert must verify actual impact
- Method names should describe the behavior
- Assert messages are **mandatory**

```apex
System.assertEquals(200, response.statusCode, 'Unexpected HTTP status');
System.assert(response.get('data') != null, 'Expected data to be present');
```

---

## 🔒 Logger in Tests

> Never assert log values. Use `LoggerMock` to capture, not validate.

```apex
Logger.overrideLogger(new LoggerMock());
Logger.isEnabled = false; // disables real logger
```

---

## ⚖️ Utilities via `TestHelper`

```apex
Id fakeId = TestHelper.fakeIdForSafe(Account.SObjectType);
String email = TestHelper.randomEmail();
String phone = TestHelper.fakePhone();
```

Validate test setup success:
```apex
if ([SELECT COUNT() FROM Account] == 0) {
    TestHelper.assertSetupCreated('Account');
}
```

---

## 📘 Advanced Examples

### 💫 Explicit Class Naming
```apex
@IsTest
private class PropostaService_Should_Update_Stage_When_Valid_Test {}
```

### 🚨 Exception Tracking with Flag
```apex
@IsTest
static void should_throw_exception_for_invalid_id() {
    ClientPortalService.exceptionThrown = false;
    Map<String, Object> req = mockRequestDataUpdateLoginPassword('UC__c', 'login', 'senha');

    try {
        ClientPortalService.handleUpdateLoginPassword(req);
    } catch (RestServiceHelper.BadRequestException e) {
        System.assert(ClientPortalService.exceptionThrown, 'Exception flag not activated.');
    }
}
```

### 🧵 Async Test with No Assertions
```apex
@IsTest
static void should_execute_logger_queueable() {
    FlowExecutionLog__c log = new FlowExecutionLog__c(Log_Level__c = 'INFO');
    Test.startTest();
    System.enqueueJob(new LoggerQueueable(log));
    Test.stopTest();

    System.assert(true, 'LoggerQueueable executed successfully.');
}
```

### ⚙️ Manual Config Setup
```apex
@TestSetup
static void configureSystem() {
    ConfiguracaoSistema__c conf = new ConfiguracaoSistema__c(
        SetupOwnerId = UserInfo.getOrganizationId(),
        Ambiente__c = 'sandbox',
        Log_Level__c = 'DEBUG',
        Log_Ativo__c = true
    );
    insert conf;
}
```

### 🧪 Usage of `XXXTestSetupData.cls`
```apex
@IsTest
static void should_create_uc_with_integrity() {
    Map<String, SObject> map = PropostaTestSetupData.criarPropostaComUC();
    UC__c uc = (UC__c) map.get('UC');
    System.assertNotEquals(null, uc.Id, 'UC not created properly');
}
```

---

## 🧱 Types of Tests

### 🧬 Refactor with Functional Equivalence
Ensure:
- Legacy assertions still pass
- Behavior is identical for known inputs
- Internal flags (e.g., `exceptionThrown`) confirm same internals

```apex
@IsTest
static void should_preserve_behavior_after_refactor() {
    ClientPortalService.exceptionThrown = false;
    Map<String, Object> req = mockRequestDataUpdateLoginPassword('UC__c', 'login', 'senha');

    try {
        ClientPortalService.handleUpdateLoginPassword(req);
    } catch (RestServiceHelper.BadRequestException e) {
        System.assert(ClientPortalService.exceptionThrown, 'Exception flag not activated.');
    }
}
```

### 🛡️ Happy Path
Ideal execution flow with valid inputs. Every class must have at least one.

### ❌ Bad Request
Missing fields or invalid values. Should trigger `RestServiceHelper.badRequest()`.

### ❓ Not Found
Valid ID returns no data. Should raise 404 behavior.

### 🚫 Internal Error
Simulated failure. Expect 500 response + traceability.

---

## 📦 Test Modularization Pattern

For each service or handler class:
- Create a dedicated `XyzTest.cls`
- Separate methods for: happy path, bad request, internal error
- All tests must run using `TestDataSetup` without inline inserts

---

## ✅ Mamba Test Checklist

> Includes equivalence validation when refactoring. See: [Equivalence Guide](https://mambadev.io/equivalence-checklist)

- [x] Uses `@IsTest` + `@TestSetup`
- [x] No log validation
- [x] Assert messages are explicit
- [x] Covers each logic path
- [x] Tests all visible methods (`public`, `@TestVisible`)
- [x] Uses `TestHelper` + `TestDataSetup`
- [x] Uses `Test.startTest()` / `stopTest()`
- [x] Contracts preserved in refactors

---

> **"If a test doesn't give you full confidence, it's not good enough."** — Mamba Mentality

