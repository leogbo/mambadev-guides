<p align="center">
  <img src="https://raw.githubusercontent.com/leogbo/mambadev-guides/main/static/img/github_banner_mambadev.png" alt="MambaDev Banner" width="100%" />
</p>

> 🧱 @status:core | This document defines the official MambaDev pattern for receiving and processing webhooks in Apex.

# 📡 Webhook Strategy – MambaDev

📎 [Shortlink: mambadev.io/webhook-strategy](https://mambadev.io/webhook-strategy)

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

> [`RestServiceHelper.cls`](https://github.com/leogbo/mambadev-guides/blob/main/src/classes/rest-service-helper.cls)  
> [`Logger.cls`](https://github.com/leogbo/mambadev-guides/blob/main/src/classes/logger.cls)

---

## 🧠 Idempotency Handling

Use a unique external reference to track previously received events:

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

> [`WebhookHelper.cls`](https://github.com/leogbo/mambadev-guides/blob/main/src/classes/webhook-helper.cls) *(recommended if not created yet)*

---

## 🧪 Testing Webhook Logic

Simulate `RestContext` to trigger controller logic:

```apex
RestContext.request = new RestRequest();
RestContext.response = new RestResponse();
RestContext.request.requestBody = Blob.valueOf('{"event_id": "abc123"}');
RestContext.request.httpMethod = 'POST';

Test.startTest();
WebhookReceiver.handleWebhook();
Test.stopTest();
```

- Use [`TestDataSetup`](https://github.com/leogbo/mambadev-guides/blob/main/src/classes/test-data-setup.cls) to set up expected environment  
- Use [`LoggerMock`](https://github.com/leogbo/mambadev-guides/blob/main/src/classes/logger-mock.cls) to assert logs  

---

## 🔗 Related Modules

- [REST API Guide](/docs/apex/integrations/rest-api-guide.md)  
- [Logger Implementation](/docs/apex/logging/logger-implementation.md)  
- [FlowExecutionLog Schema](/docs/apex/logging/flow-execution-log.md)  
- [Testing Patterns](/docs/apex/testing/testing-patterns.md)

---

> **A webhook is a handshake with another system.**  
> Mamba always shakes with a log, a check, and a fallback.

**#MambaWebhook #IdempotentAlways #LogBeforeYouAct**