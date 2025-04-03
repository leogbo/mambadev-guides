<p align="center">
  <img src="https://raw.githubusercontent.com/leogbo/mambadev-guides/main/static/img/github_banner_mambadev.png" alt="MambaDev Banner" width="100%" />
</p>

# 📡 Webhook Strategy – MambaDev

This guide defines how to implement **robust**, **idempotent**, and **traceable** webhook endpoints in Apex. These patterns ensure safe processing of inbound events, deduplication, logging, and testability.

---

## 📬 Webhook Requirements

- 🔐 Auth validation (token or IP-based)
- 🧾 Request logging with payload snapshot
- 🧠 Idempotency (deduplication by reference ID)
- ✅ Validations before processing
- 🧪 Unit test coverage with mock `RestContext`

---

## ✅ Standard Apex Webhook Pattern

```apex
@RestResource(urlMapping='/webhook/external/v1')
global with sharing class WebhookReceiver {
    @HttpPost
    global static void handleWebhook() {
        Logger logger = new Logger().setClass('WebhookReceiver').setMethod('handleWebhook');

        try {
            Map<String, Object> payload = RestServiceHelper.getRequestBody();
            String externalId = (String) payload.get('event_id');

            if (WebhookHelper.hasAlreadyProcessed(externalId)) {
                logger.info('Webhook already processed', payload);
                RestServiceHelper.ok('Already received');
                return;
            }

            WebhookHelper.process(payload);
            RestServiceHelper.ok('Processed');

        } catch (Exception ex) {
            logger.error('Webhook processing failed', ex);
            RestServiceHelper.internalServerError('Webhook error', ex);
        }
    }
}
```

---

## 🧠 Idempotency Handling

Use an external ID (event ID, timestamp, etc.) to track whether an event was processed:

```apex
public class WebhookHelper {
    public static Boolean hasAlreadyProcessed(String externalId) {
        return [SELECT COUNT() FROM Webhook_Event__c WHERE External_Id__c = :externalId] > 0;
    }

    public static void process(Map<String, Object> payload) {
        // Insert record, call logic, update status, etc.
    }
}
```

---

## 🧪 Testing Webhook Logic

Use `RestContext` simulation:

```apex
RestContext.request = new RestRequest();
RestContext.response = new RestResponse();
RestContext.request.requestBody = Blob.valueOf('{"event_id": "abc123"}');
RestContext.request.httpMethod = 'POST';

Test.startTest();
WebhookReceiver.handleWebhook();
Test.stopTest();
```

---

## 🔗 Related Modules

- [RestServiceHelper](rest-api-guide.md)  
- [Logger](../logging/logger-implementation.md)  
- [FlowExecutionLog Schema](../logging/flow-execution-log.md)  
- [Test Patterns](../testing/testing-patterns.md)

---

> **A webhook is a handshake with another system.**
> Mamba always shakes with a log, a check, and a fallback.

**#MambaWebhook #IdempotentAlways #LogBeforeYouAct**