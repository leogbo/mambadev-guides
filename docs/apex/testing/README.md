<p align="center">
  <img src="https://raw.githubusercontent.com/leogbo/mambadev-guides/main/static/img/github_banner_mambadev.png" alt="MambaDev Banner" width="100%" />
</p>

# 🧪 Testing Module – MambaDev

This folder contains guides focused on **unit testing patterns**, **test data management**, and **assertion discipline** within Apex development.

These resources define the **MambaDev standard** for Apex test quality, repeatability, and long-term resilience.

---

## 📚 Included Guides

- [Testing Patterns](/docs/apex/testing/testing-patterns.md): Structure, philosophy, and anti-patterns to avoid  
- [Apex Testing Guide](/docs/apex/testing/apex-testing-guide.md): Setup of reusable test data, factories, and assertive validations  
- [TestDataSetup](/docs/apex/testing/test-data-setup.md): Central test data builder for mock environments  
- [`TestHelper.cls`](https://github.com/leogbo/mambadev-guides/blob/main/src/classes/test-helper.cls): Utility for safe IDs, fake emails, CNPJs, and assert contracts

---

## 🎯 Purpose

This testing module ensures that every developer:

- Writes **meaningful**, **stable**, and **efficient** unit tests  
- Validates business logic independently from static data  
- Leverages **factory methods** and utilities for maintainability  
- Follows a predictable, modular test structure per domain class  
- Covers edge cases with `@IsTest` + `@TestSetup` strategy

> If it’s not testable, it’s not shippable.  
> If it’s not asserted, it doesn’t work.

---

## 🔁 Related Docs

- [Apex Review Checklist](/docs/apex/fundamentals/apex-review-checklist.md)  
- [Sandbox Initialization Guide](/docs/apex/sandbox/sandbox-init-guide.md)  
- [LoggerMock Utility](/docs/apex/logging/logger-mock.md)  
- [FlowExecutionLog Logging Schema](/docs/apex/logging/flow-execution-log.md)  
- [Exception Handling & Guards](/docs/apex/logging/exception-util.md)

---

📎 Testing is more than coverage — it’s architectural proof.  
This module exists to raise the quality bar on every PR, every class, every change.

**Ship tested. Ship Mamba.**
