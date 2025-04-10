<p align="center">
  <img src="https://raw.githubusercontent.com/leogbo/mambadev-guides/main/static/img/github_banner_mambadev.png" alt="MambaDev Banner" width="100%" />
</p>

# 🔒 MambaDev Apex Syntax Standards

_last update 10/04/2025_ 
Curated from real-world Apex reviews and enforced across all Mamba Strict Mode pipelines.

---

## ✅ Structuring Wins

| Principle              | Pattern                               | Benefit                        |
|------------------------|----------------------------------------|--------------------------------|
| 🧱 Flatten composition | `buildPagador()` → no nested `new`     | Readable, reusable             |
| 🔁 Split by method     | `buildPostWrapper()`, `buildPatchWrapper()` | Isolated contracts per verb |
| 📦 Flexible payloads   | `public Object dados`                  | Supports PATCH/POST/GET       |
| 🧠 Avoid over-nesting  | Never chain `new Foo { bar = new Bar }` | Apex doesn’t support this     |
| 🎯 Avoid premature casting | Keep `Object` until needed         | Avoids casting errors          |

---

## ⚠️ Apex Syntax Rules You Can’t Break

| ❌ Anti-pattern                  | ✅ Correct Alternative                     | Why                                     |
|----------------------------------|-------------------------------------------|------------------------------------------|
| `new Foo { bar = val }`         | Instantiate + assign                      | Apex doesn’t allow object literals       |
| `List<Foo> = new List<Foo>{ new Foo { ... } }` | Declare first, assign in loop     | No nested literals allowed               |
| `desc` as a variable            | Use `descricao`, `desconto`               | `DESC` is a SOQL keyword                 |
| `(Object) somePrimitive`        | Use safe casting                          | Apex is statically typed                 |
| Field access on `Object`       | Cast to concrete type before dot access   | Apex doesn’t support inferred polymorphs |

---

## 🔁 Logger Usage Pattern

```apex
Logger log = new Logger()
    .setClass('MyQueueable')
    .setMethod('execute')
    .setTriggerType('Queueable')
    .setCategory('Integration')
    .setEnvironment('sandbox');

log.route(response, null, 'Context message', payload);
```

### Log Field Contracts

| Field                | Source                     |
|----------------------|----------------------------|
| `Error_Message__c`   | Only on `.error()`         |
| `Stack_Trace__c`     | `.error()` with exception  |
| `Debug_Information__c` | `response.getBody()` and status |
| `Serialized_Data__c` | `.json()` or `.info(...)` with payload |

---

## 🔧 Logger Test Assertion Example

```apex
List<FlowExecutionLog__c> logs = [...];

Boolean hasPayload = false;
Boolean hasStatus = false;

for (FlowExecutionLog__c log : logs) {
    if (log.Serialized_Data__c?.contains('"req":"payload"')) hasPayload = true;
    if (log.Debug_Information__c?.contains('HTTP Status=200')) hasStatus = true;
}

System.assert(hasPayload, 'Should contain payload in Serialized_Data__c');
System.assert(hasStatus, 'Should contain status in Debug_Information__c');
```

---

## 🧱 Safe Constants Template

```apex
@TestVisible public static String  environment       = (EnvironmentUtils.getRaw() != null) ? EnvironmentUtils.getRaw() : 'sandbox';
@TestVisible public static String  logLevelDefault   = (EnvironmentUtils.getLogLevel() != null) ? EnvironmentUtils.getLogLevel() : 'INFO';
@TestVisible public static Integer maxDebugLength    = (EnvironmentUtils.getMaxDebugLength() != null ) ? (Integer)EnvironmentUtils.getMaxDebugLength() : 3000;
@TestVisible private static final String className   = 'MyClass';
@TestVisible private static final String logCategory = 'Domain';
@TestVisible private static final String triggerType = 'Service | Queueable | Trigger';
```

---

## ☑️ Invocable Syntax

```apex
@InvocableMethod(label='My Flow Action' category='Utilities')
public static List<Output> run(List<Input> inputs) { ... }

public class Input {
    @InvocableVariable(label='Record Id') public Id recordId;
}
```

- ✅ No commas in `@InvocableMethod(...)` annotations
- ✅ Use wrapper classes — not `List<Id>`
- ✅ Label and describe every `@InvocableVariable`

---

## 🧪 Test Structure Standards

| Pattern                  | Best Practice                           |
|--------------------------|------------------------------------------|
| Test log assertions      | Use `LoggerMock` or `FlowExecutionLog__c` |
| `@TestSetup`             | Always call `TestDataSetup.setupCompleteEnvironment()` |
| Async logging in tests   | Use `.setAsync(false)` or `Test.stopTest()` |
| Callout mocking          | Always `Test.setMock(...)`               |
| Avoid `testData.get(...)` | Use `SELECT` or `RecordHelper.getById(...)` |

---

## 📈 Assertion Rules

```apex
System.assertEquals(true, condition, 'Expected condition to be true');
System.assertEquals('ABC', actualValue, 'Expected value mismatch');
System.assertNotEquals(null, result, 'Result should not be null');
```

---

## 🏗️ Looping Hygiene

```apex
for (Integer i = 0; i < ids.size(); i += BATCH_SIZE) {
    List<Id> chunk = ids.subList(i, Math.min(i + BATCH_SIZE, ids.size()));
    processChunk(chunk);
}
```

---

## 🔐 Public Method Contracts

> In **Mamba Strict Mode**:

| You may…                   | You may not…                         |
|----------------------------|--------------------------------------|
| ✅ Add private helpers     | ❌ Rename public methods             |
| ✅ Add `.log()` calls      | ❌ Change public input/output types  |
| ✅ Add `@TestVisible` utils| ❌ Remove declared exceptions         |

---

## 🧠 Mamba Final Lesson

> **"If it’s nested, inline, or clever — break it apart.  
If it’s readable, reusable, and strict — that’s Mamba."**