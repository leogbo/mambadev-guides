<p align="center">
  <img src="https://raw.githubusercontent.com/leogbo/mambadev-guides/main/static/img/github_banner_mambadev.png" alt="MambaDev Banner" width="100%" />
</p>

> 🧱 @status:core | This document defines secure, testable, and traceable callout architecture for Apex in MambaDev.

# 🔁 Callout Patterns in Apex – MambaDev

📎 [Shortlink: mambadev.io/callouts](https://mambadev.io/callouts)

This guide defines **reliable**, **testable**, and **secure** callout architecture using Apex.  
It provides patterns for synchronous and asynchronous HTTP requests, authentication handling, error mapping, and structured logging.

---

## 📦 Use Cases Covered

- 🔒 Token-based REST authentication  
- 🔁 Retryable callouts with exponential backoff  
- 🚨 Structured error logging via [`Logger`](https://github.com/leogbo/mambadev-guides/blob/main/src/classes/logger.cls)  
- 🧪 Mock-friendly callout architecture  
- 🧠 Separation of parsing, payloads, and execution

---

## ✅ Mamba Callout Structure (Sync)

```apex
public class ExternalApiService {
    public static HttpResponse callExternalApi(String url, String token) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('GET');
        req.setHeader('Authorization', 'Bearer ' + token);
        req.setHeader('Content-Type', 'application/json');

        try {
            Http http = new Http();
            HttpResponse res = http.send(req);

            if (res.getStatusCode() >= 200 && res.getStatusCode() < 300) {
                return res;
            } else {
                Logger logger = new Logger().setClass('ExternalApiService').setMethod('callExternalApi');
                logger.error('Callout failed', null, res.getBody());
                throw new CalloutException('API returned error: ' + res.getStatusCode());
            }
        } catch (Exception e) {
            Logger logger = new Logger().setClass('ExternalApiService').setMethod('callExternalApi');
            logger.error('Unexpected callout failure', e);
            throw e;
        }
    }
}
```

---

## 🔄 Retry Strategy Pattern

Use `Queueable` or `Scheduled` jobs to retry failed callouts with:

- ⏱ Backoff timers  
- 🔁 `Retry_Count__c` tracking fields  
- 🧱 `FlowExecutionLog__c` entries per attempt

```apex
public class RetryableCalloutJob implements Queueable {
    public void execute(QueueableContext context) {
        try {
            HttpResponse res = ExternalApiService.callExternalApi(...);
            // Log success or persist state
        } catch (Exception ex) {
            // Optionally re-enqueue with delay
        }
    }
}
```

---

## 🧪 Mocking Strategy

Use `HttpCalloutMock` and `Test.setMock()` to:

- 🚫 Prevent real HTTP traffic  
- ✅ Inspect headers and payloads  
- 🔁 Return static responses per scenario

```apex
Test.setMock(HttpCalloutMock.class, new MyFakeMock());
```

---

## 🔗 Related Modules

- [Logger Implementation](/docs/apex/logging/logger-implementation.md)  
- [REST API Guide](/docs/apex/integrations/rest-api-guide.md)  
- [TestDataSetup](/docs/apex/testing/test-data-setup.md)  
- [FlowExecutionLog Schema](/docs/apex/logging/flow-execution-log.md)

---

> **Mamba callouts are observable, testable, and fail with clarity.**  
> No debug. No chaos. Just contracts and evidence.

**#CalloutStrategy #NoGuessworkOnlyProof #TestTheBridge**