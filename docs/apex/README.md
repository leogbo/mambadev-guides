<p align="center">
  <img src="https://raw.githubusercontent.com/leogbo/mambadev-guides/main/static/img/github_banner_mambadev.png" alt="MambaDev Banner" width="100%" />
</p>

# 🧱 Apex Module – MambaDev

This module consolidates all Apex development standards and best practices used in MambaDev projects.  
Each subfolder represents a specific domain of expertise — from architecture and logging, to testing, sandbox automation, and integration patterns.

[🔙 Return to Global Index](/README.md)

---

## 📁 Folder Structure

| Folder            | Purpose                                                                 |
|-------------------|-------------------------------------------------------------------------|
| [`fundamentals/`](/docs/apex/fundamentals/) | Core architectural rules, naming conventions, equivalence checklists, and review structure |
| [`integrations/`](/docs/apex/integrations/) | API integration patterns, including REST, callouts, tokens, and webhooks |
| [`logging/`](/docs/apex/logging/)           | Structured logging stack, Logger class, and persistent logs              |
| [`sandbox/`](/docs/apex/sandbox/)           | Post-refresh automation and org initialization                           |
| [`testing/`](/docs/apex/testing/)           | Unit test architecture, factories, mocks, and validation patterns        |

---

## 📐 Key Principles

- **Apex code must be modular, testable, and maintainable**
- **Logging and error handling are not optional** – they are required by contract
- **Functional equivalence must be proven** when refactoring ([see Feature Comparison](fundamentals/apex-feature-comparison.md))
- **Tests must validate logic**, not implementation quirks
- **Each folder enforces a strategic pattern of excellence**

---

## 📚 Recommended Reading Order

1. [✅ Apex Review Checklist](fundamentals/apex-review-checklist.md)  
2. [🧱 Layered Architecture](fundamentals/layered-architecture.md)  
3. [🛡️ ExceptionUtil](logging/exception-util.md)  
4. [🪵 Logger Guide](logging/structured-logging.md)  
5. [🧪 Testing Patterns](testing/testing-patterns.md)  
6. [🔁 Feature Comparison](fundamentals/apex-feature-comparison.md)  

> MambaDev Apex isn’t about writing code.  
> It’s about **building unbreakable systems.**

---

## ⚫ Mamba Mentality

We don’t build for today.  
We build for the developer who inherits this tomorrow.  
We leave behind clarity, precision, and structure.

> Every class is a contract.  
> Every exception has meaning.  
> Every log is a traceable artifact of intent.

**Welcome to the elite. Now execute.**
