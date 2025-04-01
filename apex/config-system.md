# ConfigSystem__ Guide

## Overview
`ConfigSystem__` is a **Custom Setting** used to store and manage global configuration parameters for the Salesforce org. It provides a flexible and centralized way to control environment-specific behaviors, logging, testing flags, timeout values, and other adjustable system parameters. This object is the single source of truth for environment configuration in all deployments.

## Fields
Below is the list of key fields and their purpose:

| Field API Name              | Type     | Description                                                                 |
|----------------------------|----------|-----------------------------------------------------------------------------|
| `Ambiente__c`              | Text     | Indicates the environment type: `production`, `sandbox`, or others.        |
| `Log_Level__c`             | Text     | Sets the log level: `info`, `error`, `warn`.                              |
| `Log_Ativo__c`             | Checkbox | Enables or disables log output.                                            |
| `Habilita_Mock__c`         | Checkbox | Activates mock behavior for test scenarios.                                |
| `Modo_Teste_Ativo__c`      | Checkbox | Indicates whether test mode is active.                                     |
| `Timeout_Callout__c`       | Decimal  | Default callout timeout for external integrations.                         |
| `Max_Debug_Length__c`      | Decimal  | Character limit for debug logs.                                            |
| `Desativar_Flows__c`       | Checkbox | If true, disables execution of certain Flows for performance or testing.   |

## Usage
This custom setting is loaded once via the `EnvironmentUtils` class and cached internally to ensure performance. Any update to the values in this setting will immediately affect behavior across the application where `EnvironmentUtils` is referenced.

### Key Use Cases
- Identify the current org environment for conditional logic.
- Adjust system logging dynamically.
- Toggle mocks and testing features programmatically.
- Control performance-related parameters like timeouts and flow disabling.

## Best Practices
- Only one record of this Custom Setting should exist (Organization-level).
- Validate user profiles have read/write access when appropriate.
- Always reload cached values after updates to reflect the new configuration immediately.
- Handle all updates via the `EnvironmentUtils` class to ensure consistency.

## Example
Example usage from Apex:
```apex
if (EnvironmentUtils.isProduction()) {
    // Execute production-specific logic
}

if (EnvironmentUtils.isMockEnabled()) {
    // Inject mock responses
}

Decimal timeout = EnvironmentUtils.getTimeoutCallout();
```

## Related
- `EnvironmentUtils`: Main Apex class that manages this setting.
- `FlowExecutionLog__c`: Another complementary custom object for managing logs and runtime diagnostics.

---
© MambaDev — The Elite Developer Squad

