<p align="center">
  <img src="https://raw.githubusercontent.com/leogbo/mambadev-guides/main/static/img/github_banner_mambadev.png" alt="MambaDev Banner" width="100%" />
</p>

> 🧱 @status:core | This document defines the structure and behavioral contract of `ConfigSystem__c`, used to manage logging, mocking, test flags, and org-level configuration.

# 🛠️ ConfigSystem__c – Environment Configuration Object

```apex
/**
 * @name        ConfigSystem__c
 * @type        CustomSetting
 * @since       2025-04-01
 * @access      system/internal
 * @description
 *  Centralized configuration object that governs global environment flags, logging behavior,
 *  test toggles, integration timeouts, and system diagnostics parameters across the org.
 *
 *  This object supports:
 *   - Central environment definition (Production/Sandbox)
 *   - Feature toggles (Mocks, Logs, Flows)
 *   - Runtime tuning (Timeouts, Debug limits)
 *   - Flexible test mode behavior
 *
 *  Used by: EnvironmentUtils, Logger, Integration Services, Flow Conditions
 */
```

---

## 🎯 Purpose

`ConfigSystem__c` is the **core environment switchboard** for MambaDev architecture.  
It exposes flags that govern how Apex behaves per org context — including:

- ✅ Production vs sandbox vs scratch logic  
- ✅ Mock injection in testable layers  
- ✅ Logging toggles and debug length control  
- ✅ Flow enablement and bypass options  
- ✅ Timeout tuning and trace control  

This setting is consumed by [`EnvironmentUtils.cls`](https://github.com/leogbo/mambadev-guides/blob/main/src/classes/environment-utils.cls) and accessed via cached read methods.

---

## 🧱 Field Reference

| Field API Name           | Label                | Type     | Description |
|---------------------------|----------------------|----------|-------------|
| `Environment__c`         | Environment          | Text     | `production`, `sandbox`, `scratch`, etc. |
| `Log_Level__c`           | Log Level            | Text     | `info`, `warn`, `error` |
| `Is_Log_Enabled__c`      | Log Enabled          | Checkbox | Toggles platform logging globally |
| `Is_Mock_Enabled__c`     | Mock Mode            | Checkbox | Enables `LoggerMock`, fake callouts, stubs |
| `Is_Test_Mode__c`        | Test Mode            | Checkbox | Flag for asserting test-specific flow behavior |
| `Callout_Timeout__c`     | Timeout (Seconds)    | Decimal  | Default HTTP timeout duration |
| `Max_Debug_Length__c`    | Max Debug Length     | Decimal  | Truncates long logs (if needed) |
| `Disable_Flows__c`       | Disable Flows        | Checkbox | Short-circuits non-critical flow executions |

---

## 🔍 Usage Patterns

### ✅ Org-Aware Execution

```apex
if (EnvironmentUtils.isProduction()) {
    callExternalBillingService();
}
```

### ✅ Mock Toggle Behavior

```apex
if (EnvironmentUtils.isMockEnabled()) {
    return MockService.getFakeResponse();
}
```

### ✅ Timeout Configuration

```apex
HttpRequest req = new HttpRequest();
req.setTimeout(EnvironmentUtils.getTimeoutCallout() * 1000);
```

---

## ⚠️ Best Practices

- ✅ Use one **org-wide default** record only (custom setting)  
- ✅ Never hardcode environments — always use `EnvironmentUtils`  
- ✅ Use `EnvironmentUtils.updateX()` in test setup to mutate values safely  
- ✅ Validate required config fields exist in post-refresh scripts  
- ✅ Don’t bypass test logic — respect `isTestMode()` checks

---

## ⚙️ Related Classes

- [`EnvironmentUtils.cls`](https://github.com/leogbo/mambadev-guides/blob/main/src/classes/environment-utils.cls) – Accesses, caches, and exposes `ConfigSystem__c` fields  
- [`Logger.cls`](https://github.com/leogbo/mambadev-guides/blob/main/src/classes/logger.cls) – Honors log level and log enablement  
- [Structured Logging](/docs/apex/logging/structured-logging.md) – Applies `Log_Level__c` dynamically  
- [FlowExecutionLog__c](/docs/apex/logging/flow-execution-log.md) – Stores logs from systems governed by this config

---

## 🧪 In Test Classes

You can override config using:

```apex
EnvironmentUtils.updateEnvironment('sandbox');
EnvironmentUtils.updateLogAtivo(true);
EnvironmentUtils.updateHabilitaMock(true);
EnvironmentUtils.updateDesativarFlows(false);
```

Make sure your test data includes:

- A `ConfigSystem__c` record in `@TestSetup`  
- Matching assertions in tests (e.g., mock enabled)

---

## 📚 Related Guides

- [Logger Implementation](/docs/apex/logging/logger-implementation.md)  
- [Test Data Setup](/docs/apex/testing/test-data-setup.md)  
- [Review Checklist](/docs/apex/fundamentals/apex-review-checklist.md)

---

## 📎 Aligned Fundamentals

- [MambaDev Coding Style](/docs/apex/fundamentals/mamba-coding-style.md)  
- [Apex Core Guide](/docs/apex/fundamentals/mamba-apex-core-guide.md)  
- [Architecture Principles](/docs/apex/fundamentals/architecture-principles.md)

---

> "Environment behavior is a contract. In MambaDev, the contract is explicit, versioned, and observed."

**#EnvironmentDriven #NoHardcodedOrgs #TraceabilityStartsWithConfig**