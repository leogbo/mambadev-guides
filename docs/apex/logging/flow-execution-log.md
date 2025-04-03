<p align="center">
  <img src="https://raw.githubusercontent.com/leogbo/mambadev-guides/main/static/img/github_banner_mambadev.png" alt="MambaDev Banner" width="100%" />
</p>

> 🧱 @status:core | This document defines the structure and required usage of the `FlowExecutionLog__c` object across Apex, Flows, and Integrations.

# 🧾 FlowExecutionLog__c – Execution Trace Object

```apex
/**
 * @name        FlowExecutionLog__c
 * @type        CustomObject
 * @since       2025-04-01
 * @access      system/internal
 * @description
 *  Central object for capturing structured execution logs across Apex, Flows, and Integrations.
 * 
 *  This object enables:
 *   - Full traceability (Class, Method, Flow Step, Record)
 *   - Diagnostics and observability for support and ops teams
 *   - Integration analytics and monitoring (inbound/outbound)
 *   - Auditable input/output via serialized JSON
 *
 *  Used by: Logger, LoggerQueueable, REST Services, Flow Actions
 */
```

---

## 🎯 Purpose

`FlowExecutionLog__c` is the **core traceability object** in the MambaDev framework.  
It captures runtime data in a structured, queryable, and persistent format — enabling:

- ✅ DevOps diagnostics  
- ✅ Flow and integration observability  
- ✅ Regression analysis  
- ✅ Dashboard metrics  
- ✅ Audit trace for external calls

---

## 🧱 Field Reference

| Field API Name               | Label                    | Type                | Description |
|-----------------------------|--------------------------|---------------------|-------------|
| `Class__c`                  | Class                    | Text(255)           | Originating Apex class |
| `Origin_Method__c`          | Origin Method            | Text(255)           | Method of origin |
| `Method__c`                 | Method (legacy)          | Text(255)           | Deprecated: prefer `Origin_Method__c` |
| `Log_Level__c`              | Log Level                | Picklist            | DEBUG, INFO, WARN, ERROR, SUCCESS |
| `Log_Category__c`           | Log Category             | Picklist            | Apex, Flow, Validation, Callout, etc. |
| `Status__c`                 | Status                   | Picklist            | Completed, Failed, Cancelled |
| `Trigger_Type__c`           | Trigger Type             | Picklist            | REST, Flow, Trigger, Queueable |
| `Trigger_Record_ID__c`      | Trigger Record ID        | Text(255)           | Related record ID |
| `Execution_Timestamp__c`    | Execution Timestamp      | Datetime            | Time of execution |
| `Duration__c`               | Duration                 | Number(14,4)        | Duration in seconds |
| `Error_Message__c`          | Error Message            | Long Text(32k)      | Root error / exception message |
| `Stack_Trace__c`            | Stack Trace              | Long Text(32k)      | Full stack trace |
| `Serialized_Data__c`        | Serialized Data          | Long Text(32k)      | JSON payload or request snapshot |
| `Debug_Information__c`      | Debug Information        | Long Text(32k)      | Response body / internal state |
| `ValidationErrors__c`       | Validation Errors        | Text(255)           | Field-level or rule failures |
| `Flow_Name__c`              | Flow Name                | Text(255)           | Name of declarative flow |
| `Flow_Outcome__c`           | Flow Outcome             | Text(255)           | Flow branch or condition |
| `Execution_ID__c`           | Execution ID             | Text(255)           | Correlation ID (e.g. Flow Interview) |
| `Execution_Order__c`        | Execution Order          | Number(18,0)        | Step order or batch loop |
| `Related_Flow_Version__c`   | Related Flow Version     | Number(18,0)        | Flow version number |
| `Step_Name__c`              | Step Name                | Text(255)           | Flow node / apex step |
| `Environment__c`            | Environment              | Picklist            | Production, Sandbox, Scratch |
| `FlowExecutionLink__c`      | Flow Execution Link      | Text(1300) (URL)    | UI deep-link (internal use) |
| `User_ID__c`                | User                     | Lookup(User)        | Who triggered the execution |
| `Integration_Ref__c`        | Integration Ref          | Text(255)           | External system trace ID |
| `Integration_Direction__c`  | Integration Direction    | Picklist            | Inbound, Outbound, Internal |
| `Is_Critical__c`            | Is Critical              | Checkbox            | Elevate visibility for critical flows |

---

## 🔍 When to Log

| Context          | Logger Required | Notes |
|------------------|-----------------|-------|
| Apex Service     | ✅ Yes          | Always `.setClass().setMethod().info()` or `.error()` |
| REST Controller  | ✅ Yes          | Log input, output, and exceptions |
| Trigger          | ✅ Yes          | Include `.setTriggerType('Trigger')` |
| Flow Action      | ✅ Yes          | Use `.setAsync(true)` in `Logger` |
| Test Class       | 🚫 No           | Use `LoggerMock` to stub output |

---

## ✅ Logging Best Practices

- Always declare `.setClass()` and `.setMethod()`  
- Use `.setCategory()` to classify domain (`"Validation"`, `"Callout"`, `"Flow"`)  
- Apply `.setAsync(true)` inside Flows and async-safe methods  
- Use `JSON.serializePretty()` for `Serialized_Data__c`  
- Mark key events with `Is_Critical__c = true` even if not errors  
- Avoid logging in test methods — use [`LoggerMock`](https://github.com/leogbo/mambadev-guides/blob/main/src/classes/logger-mock.cls)

---

## 📚 Related Guides

- [Structured Logging](/docs/apex/logging/structured-logging.md)  
- [Logger Implementation](/docs/apex/logging/logger-implementation.md)  
- [Exception Handling](/docs/apex/logging/exception-handling.md)  
- [Validation Patterns](/docs/apex/testing/validation-patterns.md)

---

## 📎 Aligned Fundamentals

- [MambaDev Coding Style](/docs/apex/fundamentals/mamba-coding-style.md)  
- [Architecture Principles](/docs/apex/fundamentals/architecture-principles.md)  
- [Review Checklist](/docs/apex/fundamentals/apex-review-checklist.md)  
- [Apex Core Guide](/docs/apex/fundamentals/mamba-apex-core-guide.md)

---

> **In MambaDev, logs are not optional.**  
> They are your black box. Your audit trail. Your truth.

**#FlowExecutionLogIsLaw #LogWithIntent #TraceabilityOverAssumption**