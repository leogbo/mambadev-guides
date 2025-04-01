<p align="center">
  <img src="https://raw.githubusercontent.com/leogbo/mambadev-guides/main/static/img/github_banner_mambadev.png" alt="MambaDev Banner" width="100%" />
</p>

# FlowExecutionLog__c – Field Structure & Purpose

> This guide defines the structure and purpose of the `FlowExecutionLog__c` custom object.  
> It is designed for persistent logging to ensure:
> - Full traceability across Flows, Apex classes, REST APIs, and Callouts
> - Storage of input/output data (JSON)
> - Diagnostics by environment, trigger type, and log level

---

## Key Fields

| API Field Name             | Label                   | Type                | Description                                                                 |
|---------------------------|-------------------------|---------------------|-----------------------------------------------------------------------------|
| `Class__c`                | Class                   | String (255)        | Name of the class responsible for the log                                  |
| `Origin_Method__c`        | Origin Method           | String (255)        | Method where execution originated                                          |
| `Method__c`               | Method                  | String (255)        | Redundant with `Origin_Method__c` — consider merging                       |
| `Log_Level__c`            | Log Level               | String (255)        | Logging level: DEBUG, INFO, WARNING, ERROR                                 |
| `Log_Category__c`         | Log Category            | Picklist (255)      | Logical grouping: Apex, Flow, Validation, Callout, etc.                    |
| `Status__c`               | Status                  | Picklist (255)      | Execution result: Completed, Failed, Cancelled, etc.                       |
| `Trigger_Type__c`         | Trigger Type            | Picklist (255)      | Invocation type: REST, Batch, Queueable, Trigger, etc.                     |
| `Trigger_Record_ID__c`    | Trigger Record ID       | String (255)        | Related record ID (Account, Contact, Lead, etc.)                           |
| `Execution_Timestamp__c`  | Execution Timestamp     | Datetime            | Timestamp when execution occurred                                          |
| `Duration__c`             | Duration                | Double (14,4)       | Duration in seconds                                                        |
| `Error_Message__c`        | Error Message           | Long Text (32k)     | Main error message                                                         |
| `Stack_Trace__c`          | Stack Trace             | Long Text (32k)     | Full exception trace                                                       |
| `Serialized_Data__c`      | Serialized Data         | Long Text (32k)     | Input JSON, payload, or relevant context                                   |
| `Debug_Information__c`    | Debug Information       | Long Text (32k)     | Output JSON or complementary debug data                                    |
| `ValidationErros__c`      | Validation Errors       | String (255)        | List of internal validation errors                                         |
| `Flow_Name__c`            | Flow Name               | String (255)        | Name of the Flow (if applicable)                                           |
| `Flow_Outcome__c`         | Flow Outcome            | String (255)        | Expected or calculated outcome                                             |
| `Execution_ID__c`         | Execution ID            | String (255)        | External execution identifier (e.g., Flow Interview ID, Callout ID)       |
| `Execution_Order__c`      | Execution Order         | Double (18,0)       | Execution sequence for parallel/multiple flows                             |
| `Related_Flow_Version__c` | Related Flow Version    | Double (18,0)       | Version of the executed flow                                               |
| `Step_Name__c`            | Step Name               | String (255)        | Specific step in declarative flow                                          |
| `Environment__c`          | Environment             | Picklist (255)      | Runtime environment (Production, Sandbox, etc.)                            |
| `FlowExecutionLink__c`    | Flow Execution Link     | String (1300, HTML) | Direct link to the flow execution                                          |
| `User_ID__c`              | User ID                 | User Lookup         | User who triggered the execution                                           |
| `Integration_Ref__c`      | Integration Ref         | String (255)        | External transaction ID or trace reference                                 |
| `Integration_Direction__c`| Integration Direction   | Picklist (255)      | Direction of integration: Inbound, Outbound, Internal                      |
| `Is_Critical__c`          | Is Critical             | Checkbox            | Marks logs as critical even if no error occurred                           |

---

## Additional Notes

- Consider unifying `Method__c` and `Origin_Method__c`
- Combination of `Execution_ID__c` + `Integration_Ref__c` enables cross-system traceability
- `Integration_Direction__c` is essential for external integration dashboards
- `Is_Critical__c` supports prioritization in support and monitoring operations
- All JSON content must be serialized using `JSON.serializePretty()`

---

### 📚 Related Guides

- [Flow Logging Strategy](./flow-logging-strategy.md)  
  Overview of best practices for Flow and Apex logging in enterprise systems.

- [Apex Error Handling Standard](./apex-error-handling.md)  
  Unified exception handling across declarative and programmatic automation.

- [Integration Trace Pattern](./integration-trace-pattern.md)  
  How to track external calls, REST payloads, and responses using `Integration_Ref__c`.

- [Flow Naming Convention](./flow-naming.md)  
  Consistent naming strategy for Flows, Steps, and Versions.

---
