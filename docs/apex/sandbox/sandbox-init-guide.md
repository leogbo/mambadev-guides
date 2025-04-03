<p align="center">
  <img src="https://raw.githubusercontent.com/leogbo/mambadev-guides/main/static/img/github_banner_mambadev.png" alt="MambaDev Banner" width="100%" />
</p>

# 🧱 Sandbox Initialization Guide (`OrgInitializer` + `EnvironmentUtils`)  
**Version**: `v2025.1` • _Last updated: Apr 2025_

> “Inconsistent environments cause invisible bugs.  
> Traceable environments create unbeatable code.” — MambaDev 🧠🔥

---

## 🌟 Purpose

Standardize and automate sandbox initialization to ensure:

- 🌐 Centralized config via `ConfigSystem__c` (Custom Setting or Custom Metadata)
- ⟳ Seeded test data via `TestDataSetup`
- ✅ Explicit setup of env flags, mocks, and flow controls
- 🔐 Production-safe execution guardrails

---

## ⚙️ Key Classes

### 🔹 `OrgInitializer` (https://mambadev.io/org-initializer)

Main class responsible for initializing your Salesforce sandbox environment.

#### 📦 Responsibilities:
- Populates `ConfigSystem__c` with default values
- Runs `TestDataSetup.setupCompleteEnvironment()`
- Logs everything via `Logger`
- Blocks execution in production

#### 💡 Usage:
```apex
OrgInitializer.run();
```

---

### 🔹 `EnvironmentUtils` (https://mambadev.io/environment-utils)

Utility class that reads and updates environment config from `ConfigSystem__c`.

#### 🔍 Common Methods:
```apex
EnvironmentUtils.isMockEnabled();
EnvironmentUtils.getLogLevel();
EnvironmentUtils.isSandbox();
EnvironmentUtils.isLogEnabled();
```

#### ⟳ Config Updates:
```apex
EnvironmentUtils.updateLogLevel('ERROR');
EnvironmentUtils.updateEnvironment('sandbox');
```

---

### 🔹 `ConfigSystem__c` Fields (https://mambadev.io/config-system)

| Field Name               | Type     | Used By                          |
|--------------------------|----------|----------------------------------|
| `Environment__c`         | Text     | `EnvironmentUtils.isSandbox()`   |
| `Log_Level__c`           | Text     | `Logger`, `RestServiceHelper`    |
| `Log_Enabled__c`         | Boolean  | `Logger`, `LoggerQueueable`      |
| `Enable_Mock__c`         | Boolean  | External services & tests        |
| `Enable_Test_Mode__c`    | Boolean  | Flow/test logic toggles          |
| `Timeout_Callout__c`     | Decimal  | Timeout for outbound callouts    |
| `Disable_Flows__c`       | Boolean  | `FlowControlManager`             |

---

## 🔐 Protections & Guarantees

- `OrgInitializer.run()` is guarded:
  - ✅ Only runs in `Test.isRunningTest()` or sandbox environments
  - ❌ Skips if `Organization.IsSandbox == false`

- `EnvironmentUtils` uses caching for efficiency  
- Logs are persisted in `FlowExecutionLog__c` (Category: `Setup`)

---

## 🚀 Manual Execution (Developer Console)
```apex
OrgInitializer.run();
```

---

## 🧪 Recommended Tests

### ✅ Happy Path
```apex
@isTest
static void should_initialize_sandbox_successfully() {
    OrgInitializer.run();
    ConfigSystem__c config = [SELECT Environment__c FROM ConfigSystem__c LIMIT 1];
    System.assertEquals('sandbox', config.Environment__c);
}
```

### 🚫 Production Guard
```apex
@isTest
static void should_block_execution_in_production() {
    Test.startTest();
    // simulate environment override if your test framework supports it
    EnvironmentUtils.updateEnvironment('production');
    OrgInitializer.run(); // should not proceed
    Test.stopTest();
    // Add log or assert validations if available
}
```

---

## 🔗 Integration with Other MambaDev Guides

| Guide                                            | How It Connects                                     |
|--------------------------------------------------|-----------------------------------------------------|
| [Logger Guide](https://mambadev.io/logger-implementation)         | Uses `getLogLevel()` and `isLogEnabled()`           |
| [TestData Setup](https://mambadev.io/testing-patterns)           | Invokes `setupCompleteEnvironment()`                |
| [Sandbox Mocks](https://mambadev.io/testing-patterns#mocking)     | Controlled by `isMockEnabled()`                     |
| [REST API Guide](https://mambadev.io/rest-api-guide)              | Reads environment flags via `EnvironmentUtils`      |

---

## 🔍 Final Recommendations

- Always run `OrgInitializer.run()` after a **sandbox refresh**
- Never assume your environment is “clean” — _configure it every time_
- Add guard asserts like `EnvironmentUtils.isSandbox()` before test-only logic
- Use `EnvironmentUtils.updateX()` methods to safely mutate runtime settings

---

> **“Unconfigured environments are latent failures.  
> Mamba environments are trusted, auditable, and ready.”**  
> — MambaDev Engineering 🧱🖤

---

```

Would you like me to:

- 📥 Generate a downloadable `.md` file?
- 🧩 Add this to a GitHub Pages setup or `docs/` folder?
- 📚 Bundle it with your `rest-api-guide.md` as a zip?

Just say the word.
