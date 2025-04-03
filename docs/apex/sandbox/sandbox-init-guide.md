<p align="center">
  <img src="https://raw.githubusercontent.com/leogbo/mambadev-guides/main/static/img/github_banner_mambadev.png" alt="MambaDev Banner" width="100%" />
</p>

> 🧱 @status:core | This document defines the official MambaDev pattern for initializing and securing sandbox environments using `OrgInitializer` and `EnvironmentUtils`.

# 🧱 Sandbox Initialization Guide (`OrgInitializer` + `EnvironmentUtils`)  
**Version**: `v2025.1` • _Last updated: Apr 2025_

> “Inconsistent environments cause invisible bugs.  
> Traceable environments create unbeatable code.” — MambaDev 🧠🔥

---

## 🌟 Purpose

Standardize and automate sandbox initialization to ensure:

- 🌐 Centralized config via [`ConfigSystem__c`](/docs/apex/logging/config-system.md)
- ⟳ Seeded test data via [`TestDataSetup`](https://github.com/leogbo/mambadev-guides/blob/main/src/classes/test-data-setup.cls)
- ✅ Explicit setup of flags, mocks, and flow control
- 🔐 Safe execution with production block logic

---

## ⚙️ Key Classes

### 🔹 [`OrgInitializer.cls`](https://github.com/leogbo/mambadev-guides/blob/main/src/classes/org-initializer.cls)

Initializes Salesforce sandboxes with safe, traceable defaults.

#### 📦 Responsibilities

- Inserts baseline `ConfigSystem__c` values  
- Runs `TestDataSetup.setupCompleteEnvironment()`  
- Logs via [`Logger`](https://github.com/leogbo/mambadev-guides/blob/main/src/classes/logger.cls)  
- Blocks production usage automatically

#### 💡 Usage

```apex
OrgInitializer.run();
```

---

### 🔹 [`EnvironmentUtils.cls`](https://github.com/leogbo/mambadev-guides/blob/main/src/classes/environment-utils.cls)

Provides cached access and updates to `ConfigSystem__c`.

#### 🔍 Common Getters

```apex
EnvironmentUtils.isSandbox();
EnvironmentUtils.getLogLevel();
EnvironmentUtils.isMockEnabled();
EnvironmentUtils.isTestMode();
```

#### ⟳ Config Updates

```apex
EnvironmentUtils.updateEnvironment('sandbox');
EnvironmentUtils.updateLogLevel('ERROR');
```

---

### 🔹 `ConfigSystem__c` Fields

📎 See: [Config System Reference](/docs/apex/logging/config-system.md)

| Field Name             | Type     | Used By                      |
|------------------------|----------|------------------------------|
| `Environment__c`       | Text     | `EnvironmentUtils.isSandbox()` |
| `Log_Level__c`         | Text     | `Logger`, `RestServiceHelper` |
| `Is_Log_Enabled__c`    | Boolean  | `LoggerQueueable`, `Logger` |
| `Is_Mock_Enabled__c`   | Boolean  | Mocks + service testing     |
| `Is_Test_Mode__c`      | Boolean  | Flow/test logic gates       |
| `Callout_Timeout__c`   | Decimal  | HTTP callout limits         |
| `Disable_Flows__c`     | Boolean  | `FlowControlManager`        |

---

## 🔐 Safety Guarantees

- `OrgInitializer.run()`:
  - ✅ Runs only inside `Test.isRunningTest()` or sandbox orgs  
  - ❌ Skips entirely if `Organization.IsSandbox == false`

- `EnvironmentUtils`:
  - ✅ Uses internal static cache for perf  
  - ✅ Returns null-safe fallback defaults if config is missing

- All logs use `Logger.setCategory('Setup')` and are persisted via [`FlowExecutionLog__c`](/docs/apex/logging/flow-execution-log.md)

---

## 🚀 Manual Execution (Developer Console)

```apex
OrgInitializer.run();
```

✅ Safe to call after sandbox refresh, CI job, or `TestSetup`.

---

## 🧪 Test Examples

### ✅ Happy Path

```apex
@IsTest
static void should_initialize_sandbox_successfully() {
    OrgInitializer.run();
    ConfigSystem__c config = [SELECT Environment__c FROM ConfigSystem__c LIMIT 1];
    System.assertEquals('sandbox', config.Environment__c);
}
```

### 🚫 Guard Against Production

```apex
@IsTest
static void should_block_execution_in_production() {
    EnvironmentUtils.updateEnvironment('production');

    Test.startTest();
    OrgInitializer.run(); // logic should not proceed
    Test.stopTest();

    // Optionally assert logs were skipped
}
```

---

## 🔗 Integration with Other Guides

| Guide                                               | Why It Connects                      |
|-----------------------------------------------------|--------------------------------------|
| [Logger Implementation](/docs/apex/logging/logger-implementation.md) | Uses `getLogLevel()` and `isLogEnabled()` |
| [TestDataSetup](/docs/apex/testing/test-data-setup.md)               | Automatically called during setup   |
| [REST API Guide](/docs/apex/integrations/rest-api-guide.md)          | Reads env flags from `EnvironmentUtils` |
| [Validation Patterns](/docs/apex/testing/validation-patterns.md)     | Controlled by `isTestMode()` flags |

---

## 🔍 Final Recommendations

- ✅ Always run `OrgInitializer.run()` after **sandbox refresh**  
- ❌ Never assume config is present — validate via `EnvironmentUtils`  
- ✅ Use `updateX()` methods in `@TestSetup` to control test config  
- ✅ Log all setup paths using `Logger.setCategory('Setup')`  
- ✅ Prefer declarative flow disablement via `Disable_Flows__c` instead of deleting logic

---

> **“Unconfigured environments are latent failures.  
> Mamba environments are traceable, repeatable, and test-first.”**  
> — MambaDev Engineering 🧱🔥