<p align="center">
  <img src="https://raw.githubusercontent.com/leogbo/mambadev-guides/main/static/img/github_banner_mambadev.png" alt="MambaDev Banner" width="100%" />
</p>

# 🧱 Apex Module – MambaDev

This module consolidates all Apex development standards and best practices used in MambaDev projects. Each subfolder represents a specific domain of expertise — from architecture and logging, to testing, sandbox automation, and operational comparison patterns.

---

## 📁 Folder Structure

| Folder            | Purpose                                                                 |
|-------------------|-------------------------------------------------------------------------|
| [`comparison/`](comparison/)     | Refactor comparisons, equivalence checklists, and review-oriented guides |
| [`fundamentals/`](fundamentals/) | Core architectural rules, naming conventions, and checklists             |
| [`integrations/`](integrations/) | API integration patterns, especially for REST and webhooks               |
| [`logging/`](logging/)           | Structured logging stack, Logger class, and persistent logs              |
| [`sandbox/`](sandbox/)           | Post-refresh automation and org initialization                           |
| [`testing/`](testing/)           | Unit test architecture, factories, and test patterns                     |
| [`examples/`](examples/)         | Reference code and reusable implementation examples                      |

---

## 📐 Key Principles

- **Apex code must be modular, testable, and maintainable**
- **Logging and error handling are not optional** – they are required by contract
- **Functional equivalence must be proven** when refactoring ([see comparison guide](comparison/apex-feature-comparison.md))
- **Tests must validate logic**, not implementation quirks
- **Each folder enforces a strategic pattern of excellence**

---

## 📚 Recommended Reading Order

1. [✅ Apex Review Checklist](fundamentals/apex-review-checklist.md)
2. [🧱 Layered Architecture](fundamentals/layered-architecture.md)
3. [🛡️ ExceptionUtil](logging/exception-util.md)
4. [🪵 Logger Guide](logging/structured-logging.md)
5. [🧪 Testing Patterns](testing/testing-patterns.md)
6. [🔁 Feature Comparison](comparison/apex-feature-comparison.md)

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
```

---

## ✅ Cross-Link Status

| Link Target                         | 🧠 Validated |
|------------------------------------|--------------|
| `fundamentals/apex-review-checklist.md` | ✅ |
| `fundamentals/layered-architecture.md`  | ✅ |
| `logging/exception-util.md`             | ✅ |
| `logging/structured-logging.md`         | ✅ |
| `testing/testing-patterns.md`           | ✅ |
| `comparison/apex-feature-comparison.md` | ✅ |