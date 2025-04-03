<p align="center">
  <img src="https://raw.githubusercontent.com/leogbo/mambadev-guides/main/static/img/github_banner_mambadev.png" alt="MambaDev Banner" width="100%" />
</p>

> 🧱 @status:core | This module defines MambaDev's official framework for Apex unit testing, test data setup, and behavioral validation.

# 🧪 Testing Module – MambaDev

📎 [Shortlink: mambadev.io/testing](https://mambadev.io/testing)

This folder contains guides focused on **unit testing patterns**, **test data management**, and **assertion discipline** within Apex development.

These resources define the **MambaDev standard** for Apex test quality, repeatability, and long-term resilience.

---

## 📚 Included Guides

- [Testing Patterns](/docs/apex/testing/testing-patterns.md): Structure, naming, semantic assertion and anti-patterns  
- [Apex Testing Guide](/docs/apex/testing/apex-testing-guide.md): Setup flows, `@TestSetup`, LoggerMock, and equivalence testing  
- [TestDataSetup](/docs/apex/testing/test-data-setup.md): End-to-end sandboxed data generation for test safety  
- [`TestHelper.cls`](https://github.com/leogbo/mambadev-guides/blob/main/src/classes/test-helper.cls): Safe ID faker, random generators, and assertion helpers

---

## 🎯 Purpose

This module ensures every developer:

- ✅ Writes **assertive**, **repeatable**, and **clear** unit tests  
- ✅ Uses `TestDataSetup` for data — no raw DML in test methods  
- ✅ Uses `LoggerMock` to suppress real logging  
- ✅ Validates **behavior**, not implementation quirks  
- ✅ Covers **edge cases**, not just happy paths

> If it’s not testable, it’s not shippable.  
> If it’s not asserted, it doesn’t work.

---

## 🔁 Related Guides

- [Apex Review Checklist](/docs/apex/fundamentals/apex-review-checklist.md)  
- [Sandbox Initialization Guide](/docs/apex/sandbox/sandbox-init-guide.md)  
- [LoggerMock Utility](/docs/apex/logging/logger-mock.md)  
- [FlowExecutionLog__c Logging Schema](/docs/apex/logging/flow-execution-log.md)  
- [ExceptionUtil (validation)](/docs/apex/logging/exception-util.md)

---

📎 Tests are not bonus features — they’re **proof of design**.

**Build tests like contracts.  
Test edge cases like they're requirements.  
Ship Mamba.**

**#BehaviorOverCoverage #OneTestOnePurpose #NoGuessworkOnlyProof** 🧠🧪🧱🔥
