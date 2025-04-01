# ConfigSystem__c – Environment Configuration Object

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

`ConfigSystem__c` is the **central system configuration layer** for MambaDev architecture.  
It abstracts critical flags and environment states into a single, queryable Custom Setting — providing the backbone for:

- ✅ Dynamic behavior in different orgs (prod/sandbox/scratch)
- ✅ Toggle-based activation of logs, mocks, and test modes
- ✅ Unified source for timeouts and debug limits
- ✅ Performance and operational control at runtime

---

## 🧱 Field Reference

| Field API Name            | Label                 | Type      | Description                                                                 |
|--------------------------|-----------------------|-----------|-----------------------------------------------------------------------------|
| `Environment__c`         | Environment           | Text      | Logical environment: `production`, `sandbox`, `scratch`, etc.              |
| `Log_Level__c`           | Log Level             | Text      | Logging level: `info`, `warn`, `error`                                     |
| `Is_Log_Enabled__c`      | Log Enabled           | Checkbox  | Enables or disables logging globally                                       |
| `Is_Mock_Enabled__c`     | Mock Mode             | Checkbox  | Activates mocks for testing/integration                                    |
| `Is_Test_Mode__c`        | Test Mode             | Checkbox  | Declares whether test-specific flows and data should execute               |
| `Callout_Timeout__c`     | Timeout (Seconds)     | Decimal   | Timeout value in seconds for HTTP callouts                                 |
| `Max_Debug_Length__c`    | Max Debug Length      | Decimal   | Character length for truncating long debug messages                        |
| `Disable_Flows__c`       | Disable Flows         | Checkbox  | When true, skips non-critical Flow logic (performance bypass)              |

> Note: Fields may be aliased from legacy names (e.g., `Ambiente__c` → `Environment__c`) for clarity.

---

## 🔍 Usage Patterns

### ✅ Org-Aware Logic
```apex
if (EnvironmentUtils.isProduction()) {
    // Run critical workflows or integrations
}
```

### ✅ Mock Behavior Toggle
```apex
if (EnvironmentUtils.isMockEnabled()) {
    response = MockHelper.getFakeResponse();
}
```

### ✅ Dynamic Timeout
```apex
HttpRequest req = new HttpRequest();
req.setTimeout(EnvironmentUtils.getTimeoutCallout() * 1000);
```

---

## 🧠 Best Practices

- Use **one record** per org (Org-Wide default custom setting)
- Enforce read access to ensure Apex classes function in all contexts
- **Never hardcode** environment-specific logic — rely on these fields
- Apply updates only via `EnvironmentUtils.update*()` methods to persist and refresh cache
- Ensure integration and Flow logic checks `isTestMode()` or `isMockEnabled()` when applicable

---

## ⚙️ Related Classes

- [`EnvironmentUtils`](examples/classes/environment-utils.cls) – Apex class that interfaces with this object
- [`Logger`](./structured-logging.md) – Structured log writer that respects environment log toggles
- [`FlowExecutionLog__c`](./flowexecutionlog.md) – Diagnostic runtime trace that complements this config

---

## 📎 Aligned Fundamentals

- [`MambaDev Coding Style`](../fundamentals/mambadev-coding-style.md)  
- [`Apex Style Guide`](../fundamentals/apex-style-guide.md)  
- [`Architecture Principles`](../fundamentals/architecture-principles.md)  
- [`Review Checklist`](../fundamentals/apex-review-checklist.md)  

---

> "Environment behavior is a contract. In MambaDev, the contract is explicit, versioned, and observed."

© MambaDev — The Elite Developer Squad
