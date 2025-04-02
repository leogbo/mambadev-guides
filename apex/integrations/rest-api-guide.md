<p align="center">
  <img src="https://raw.githubusercontent.com/leogbo/mambadev-guides/main/static/img/github_banner_mambadev.png" alt="MambaDev Banner" width="100%" />
</p>

# 🌐 Official REST API Guide in Apex (v2025) – MambaDev Mindset

📎 **Shortlink**: [mambadev.io/rest-api-guide](https://mambadev.io/rest-api-guide)

> _“Every API carries the reputation of your platform. It must be clear, predictable, and traceable.”_  
> — Leo Mamba Garcia 🧠🔥

This guide defines the **mandatory architecture and behavior** for internal REST APIs built with Apex on Salesforce.

---

## 📚 Required Reference Guides

- 🧱 [Apex Core Standards](https://mambadev.io/apex-core-guide)  
- 🧩 [Layered Architecture](https://mambadev.io/layered-architecture)  
- 🔁 [Refactor & Equivalence](https://mambadev.io/apex-feature-comparison) • [Equivalence Checklist](https://mambadev.io/equivalence-checklist)  
- 🪵 [Logger Implementation](https://mambadev.io/logger-implementation)  
- 🧪 [Testing Guide](https://mambadev.io/apex-testing-guide) • [Testing Patterns](https://mambadev.io/testing-patterns)  
- 🧱 [REST Style Guide](https://mambadev.io/style)  

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

A standard utility class for:

- ✅ Validating access tokens  
- ✅ Safely parsing request bodies  
- ✅ Sending structured responses with HTTP status codes  
- ✅ Logging execution with `Logger`  
- ✅ Mapping JSON into SObject fields (`mapFieldsFromRequest(...)`)

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

| Mistake                      | Instead, do this                          |
|-----------------------------|-------------------------------------------|
| `JSON.deserializeUntyped()` | ❌ Use `RestServiceHelper.getRequestBody()` |
| `throw new Exception(...)`  | ❌ Use `RestServiceHelper.internalServerError(...)` |
| `return 'ok';`              | ❌ Always return full structured response |
| `System.debug(...)`         | ❌ Never. Use structured `Logger` instead  |

---

## 🧪 Required Test Scenarios for REST APIs

- ✅ `@IsTest` class with `@TestSetup` and real record insertion  
- ✅ Use `Logger.overrideLogger(new LoggerMock())`  
- ✅ Required test paths:
  - Happy path (200 or 201)
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

| Item                                                         | Done? |
|--------------------------------------------------------------|-------|
| REST class with `@RestResource`                              | [ ]   |
| Uses only `RestServiceHelper` for request/response handling  | [ ]   |
| Logs with `Logger`                                           | [ ]   |
| JSON uses `serializePretty()`                                | [ ]   |
| Critical flows persist logs to `FlowExecutionLog__c`         | [ ]   |
| `LoggerMock` used in tests                                   | [ ]   |
| Test asserts response `.statusCode`                          | [ ]   |
| Tests catch `BadRequestException` and `AccessException`      | [ ]   |
| No use of `System.debug(...)` anywhere                       | [ ]   |

---

> _Clarity, traceability, and structure are not extras — they’re the baseline._  
> 🧠🖤 #MambaAPI #StatusWithError #NoDebugOnlyLogger #TestOrRollback

**MambaDev Engineering | Excellence is the baseline.**

---

Let me know if you'd like this exported as `rest-api-guide.md` or packaged for a GitHub repo 📦
