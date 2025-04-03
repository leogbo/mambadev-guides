<p align="center">
  <img src="https://raw.githubusercontent.com/leogbo/mambadev-guides/main/static/img/github_banner_mambadev.png" alt="MambaDev Banner" width="100%" />
</p>

> 🧱 @status:core | This document defines the required architecture and behavior for internal REST APIs in MambaDev.

# 🌐 Official REST API Guide in Apex (v2025) – MambaDev Mindset

📎 [Shortlink: mambadev.io/rest-api-guide](https://mambadev.io/rest-api-guide)

> _“Every API carries the reputation of your platform. It must be clear, predictable, and traceable.”_  
> — Leo Mamba Garcia 🧠🔥

---

## 📚 Required Reference Guides

- 🧱 [Apex Core Guide](/docs/apex/fundamentals/mamba-apex-core-guide.md)  
- 🧩 [Layered Architecture](/docs/apex/fundamentals/layered-architecture.md)  
- 🔁 [Feature Comparison Guide](/docs/apex/fundamentals/apex-feature-comparison.md) • [Equivalence Checklist](/docs/apex/fundamentals/equivalence-checklist.md)  
- 🪵 [Logger Implementation](/docs/apex/logging/logger-implementation.md)  
- 🧪 [Testing Guide](/docs/apex/testing/apex-testing-guide.md) • [Testing Patterns](/docs/apex/testing/testing-patterns.md)  
- 🧱 [Style Guide](/docs/apex/fundamentals/mamba-coding-style.md)

---

## ✅ REST Class Structure Example

```apex
@RestResource(urlMapping='/lead/v1')
global with sharing class LeadRestController {

    @HttpPost
    global static void createLead() {
        try {
            Map<String, Object> payload = RestServiceHelper.getRequestBody();
            Lead newLead = new Lead();
            newLead = applyFields(payload, newLead);
            insert newLead;
            RestServiceHelper.sendResponse(201, 'Lead created successfully', newLead);
        } catch (Exception ex) {
            RestServiceHelper.internalServerError('Failed to create Lead', ex);
        }
    }

    @TestVisible
    private static Lead applyFields(Map<String, Object> payload, Lead newLead) {
        // Transform and apply values from payload
        return newLead;
    }
}
```

---

## 🧩 What is `RestServiceHelper`?

A core utility class defined at  
[`RestServiceHelper.cls`](https://github.com/leogbo/mambadev-guides/blob/main/src/classes/rest-service-helper.cls)

Responsibilities:

- ✅ Validating access tokens  
- ✅ Safely parsing request bodies  
- ✅ Sending structured responses with HTTP status codes  
- ✅ Logging execution via [`Logger`](https://github.com/leogbo/mambadev-guides/blob/main/src/classes/logger.cls)  
- ✅ Mapping JSON into SObject fields via `mapFieldsFromRequest(...)`

> 🧠 All REST APIs **must** use this class. Never handle raw requests manually.

---

## ✅ Standard REST Response Format

```json
{
  "message": "Lead created successfully",
  "details": {
    "Id": "00Q...",
    "Name": "Test Name"
  }
}
```

---

## ✅ Built-in Response Methods

| Method                           | Status | Purpose                              |
|----------------------------------|--------|--------------------------------------|
| `ok(data)`                       | 200    | Success with data                    |
| `created(message, data)`        | 201    | Resource created                     |
| `badRequest(message)`           | 400    | Input validation error               |
| `unauthorized(message)`         | 401    | Missing or invalid token             |
| `notFound(message)`             | 404    | Resource not found                   |
| `internalServerError(message)`  | 500    | Unexpected error, auto-logged        |

---

## ❌ Common Mistakes to Avoid

| Mistake                      | Use Instead                                |
|-----------------------------|---------------------------------------------|
| `JSON.deserializeUntyped()` | `RestServiceHelper.getRequestBody()`        |
| `throw new Exception(...)`  | `RestServiceHelper.internalServerError(...)`|
| `return 'ok';`              | Always return full structured response      |
| `System.debug(...)`         | Use [`Logger`](https://github.com/leogbo/mambadev-guides/blob/main/src/classes/logger.cls) instead |

---

## 🧪 Required Test Scenarios

- ✅ `@IsTest` class with `@TestSetup` using real records  
- ✅ Use [`LoggerMock`](https://github.com/leogbo/mambadev-guides/blob/main/src/classes/logger-mock.cls) to stub logging  
- ✅ Validate:
  - Happy path (200/201)
  - Bad request (400)
  - Unauthorized token (401)
  - Resource not found (404)
  - Internal error (500)

---

### Example – Test for 400 Bad Request

```apex
@IsTest
static void test_invalid_payload_returns_400() {
    RestContext.request = new RestRequest();
    RestContext.response = new RestResponse();
    RestContext.request.httpMethod = 'POST';
    RestContext.request.requestBody = Blob.valueOf('{ "email": "" }');
    RestContext.request.addHeader('Access_token', 'Bearer INVALID');

    Test.startTest();
    MyRestClass.receivePost();
    Test.stopTest();

    System.assertEquals(400, RestContext.response.statusCode);
    System.assert(RestContext.response.responseBody.toString().contains('email'));
}
```

---

## ✅ Mamba REST Checklist

| Item                                                           | Done? |
|----------------------------------------------------------------|-------|
| REST class with `@RestResource`                                | [ ]   |
| Uses only `RestServiceHelper` for request/response handling    | [ ]   |
| Logs via `Logger`                                              | [ ]   |
| JSON uses `serializePretty()`                                  | [ ]   |
| Critical flows persist to `FlowExecutionLog__c`                | [ ]   |
| Uses `LoggerMock` in tests                                     | [ ]   |
| Asserts `response.statusCode`                                  | [ ]   |
| Tests catch `BadRequestException` or `AccessException`         | [ ]   |
| No use of `System.debug(...)` anywhere                         | [ ]   |

---

> _Clarity, traceability, and structure are not extras — they’re the baseline._  
> 🧠🖤 #MambaAPI #StatusWithError #NoDebugOnlyLogger #TestOrRollback

**MambaDev Engineering | Excellence is the baseline.**