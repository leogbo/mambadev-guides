<p align="center">
  <img src="https://raw.githubusercontent.com/leogbo/mambadev-guides/main/static/img/github_banner_mambadev.png" alt="MambaDev Banner" width="100%" />
</p>

# FlowExecutionLog__c – Execution Trace Object

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

`FlowExecutionLog__c` is the **core traceability object** in MambaDev architecture.  
It captures runtime data in a structured and persistent format — enabling diagnostics, dashboards, and deep observability across:

- ✅ Apex logic
- ✅ Declarative Flows
- ✅ Callouts and integrations
- ✅ Manual or async operations

---

## 🧱 Field Reference

| Field Name                | Label                   | Type                | Description                                                             |
|--------------------------|-------------------------|---------------------|-------------------------------------------------------------------------|
| `Class__c`               | Class                   | Text(255)           | Apex class name that originated the log                                |
| `Origin_Method__c`       | Origin Method           | Text(255)           | Method name where log was triggered                                    |
| `Method__c`              | Method                  | Text(255)           | (Deprecated, consider merging with Origin_Method__c)                   |
| `Log_Level__c`           | Log Level               | Picklist            | DEBUG, INFO, WARN, ERROR, SUCCESS                                       |
| `Log_Category__c`        | Log Category            | Picklist            | Grouping: Flow, Apex, Validation, Callout, etc.                        |
| `Status__c`              | Status                  | Picklist            | Result status: Completed, Failed, Cancelled                            |
| `Trigger_Type__c`        | Trigger Type            | Picklist            | Invocation source: Flow, REST, Batch, Queueable, etc.                  |
| `Trigger_Record_ID__c`   | Trigger Record ID       | Text(255)           | Related record (Account, Lead, Opportunity, etc.)                      |
| `Execution_Timestamp__c` | Execution Timestamp     | Datetime            | When the execution occurred                                            |
| `Duration__c`            | Duration                | Number(14,4)        | Time taken in seconds                                                  |
| `Error_Message__c`       | Error Message           | Long Text(32k)      | Primary error or exception message                                     |
| `Stack_Trace__c`         | Stack Trace             | Long Text(32k)      | Full stack trace (if applicable)                                       |
| `Serialized_Data__c`     | Serialized Data         | Long Text(32k)      | JSON input or payload snapshot                                         |
| `Debug_Information__c`   | Debug Information       | Long Text(32k)      | Output JSON or additional debug context                                |
| `ValidationErros__c`     | Validation Errors       | Text(255)           | List of business rule or field-level validation issues                 |
| `Flow_Name__c`           | Flow Name               | Text(255)           | Name of the Flow executed (if applicable)                              |
| `Flow_Outcome__c`        | Flow Outcome            | Text(255)           | Result or branch taken in flow logic                                   |
| `Execution_ID__c`        | Execution ID            | Text(255)           | Unique execution identifier (e.g., Flow Interview Id or correlation)   |
| `Execution_Order__c`     | Execution Order         | Number(18,0)        | Sequence for parallel or multi-execution scenarios                     |
| `Related_Flow_Version__c`| Related Flow Version    | Number(18,0)        | Version number of the Flow (if applicable)                             |
| `Step_Name__c`           | Step Name               | Text(255)           | Specific step within the Flow                                          |
| `Environment__c`         | Environment             | Picklist            | Execution environment: Production, Sandbox, Scratch, etc.              |
| `FlowExecutionLink__c`   | Flow Execution Link     | URL(Text 1300)      | Direct link to Flow execution detail                                   |
| `User_ID__c`             | User                    | Lookup(User)        | User who triggered the execution                                       |
| `Integration_Ref__c`     | Integration Ref         | Text(255)           | External transaction or trace correlation Id                           |
| `Integration_Direction__c`| Integration Direction  | Picklist            | Inbound, Outbound, Internal                                            |
| `Is_Critical__c`         | Is Critical             | Checkbox            | Marks execution as critical even if no exception occurred              |

---

## 🔍 When to Log

| Context             | Use Logger? | Notes                                                                 |
|---------------------|-------------|-----------------------------------------------------------------------|
| Apex Class          | ✅ Yes      | Use `.setClass().setMethod().info()`                                 |
| Trigger             | ✅ Yes      | Include `setTriggerType('Trigger')`                                  |
| Flow Action         | ✅ Yes      | Can be set with `Logger.setAsync(true)` if inside Flow                |
| REST Endpoint       | ✅ Yes      | Use in error and success responses (see `RestServiceHelper`)         |
| Test Class          | 🚫 No       | Use `LoggerMock` instead                                             |

---

## ✅ Best Practices

- Always log with a defined class and method name
- Use `.setCategory()` to group logs (e.g., "Validation", "REST", "Flow")
- Use `.setAsync(true)` inside flows or if DML isn't allowed immediately
- Limit message lengths (`255` for summary, up to `32k` for JSONs)
- Log context objects with `JSON.serializePretty()` for readability
- Mark logs with `Is_Critical__c = true` to flag important events without errors

---

## 📚 Related Guides

- [Structured Logging](./structured-logging.md)  
  How to use the `Logger` and `LoggerQueueable` classes to populate this object.

- [Exception Handling](./exception-handling.md)  
  How to use try/catch with meaningful exception types and structured logs.

- [Validation Patterns](./validation-patterns.md)  
  Clean patterns for input validation that plug directly into Logger.

## 📎 Aligned Fundamentals

These operational guides are built on:

- [`MambaDev Coding Style`](../fundamentals/mambadev-coding-style.md)
- [`Apex Style Guide`](../fundamentals/apex-style-guide.md)
- [`Architecture Principles`](../fundamentals/architecture-principles.md)
- [`Review Checklist`](../fundamentals/apex-review-checklist.md)

---

> In MambaDev, we don’t debug by guesswork.  
> We debug with structured clarity.
