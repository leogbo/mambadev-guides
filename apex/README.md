<p align="center">
  <img src="https://raw.githubusercontent.com/leogbo/mambadev-guides/main/static/img/github_banner_mambadev.png" alt="MambaDev Banner" width="100%" />
</p>

# 🐍 MambaDev Apex Guide

> *Precision. Performance. Purpose.*  
> This is Apex — the MambaDev way.

📖 [Browse the full Table of Contents](./TOC.md)

---

## 📘 Purpose

This module defines the **official Apex architecture playbook** of MambaDev.

It exists to:

- 🧠 Set elite, auditable standards for Salesforce development  
- 🧱 Document modular, scalable architectural patterns  
- 🐍 Train developers to think like architects and operate like SEALs  

---

## 📂 Guide Index

Every file in this folder is handcrafted to be:

- 🔍 Clear in purpose  
- 🔄 Reusable across orgs  
- 🧠 Architecturally sound  
- 🧪 Fully testable  

| Guide                           | Purpose                                                                 |
|----------------------------------|-------------------------------------------------------------------------|
| [`validation-patterns.md`](./validation-patterns.md)        | Declarative guard clauses + semantic validation errors                |
| [`exception-handling.md`](./exception-handling.md)          | Try/catch strategy with custom exceptions and logging integration     |
| [`structured-logging.md`](./structured-logging.md)          | Logging architecture using `Logger` and `FlowExecutionLog__c`         |
| [`flow-execution-log.md`](./flow-execution-log.md)          | Persistent log object schema and tracking model                        |
| [`exceptionutil.md`](./exceptionutil.md)                    | Declarative validation utility with consistent exception strategy     |
| [`testing-patterns.md`](./testing-patterns.md)              | Isolation, mocking, coverage and test design principles                |
| [`layered-architecture.md`](./layered-architecture.md)      | Clean separation of concerns across controller, service and domain    |
| [`naming-standards.md`](./naming-standards.md)              | Unified naming conventions for Apex classes, methods, fields & tests  |

---

## 🧱 Aligned Fundamentals

This module is **built on top of the official MambaDev Fundamentals**, located at [`../fundamentals`](../fundamentals/):

- [`MambaDev Coding Style`](../fundamentals/mambadev-coding-style.md)
- [`Apex Style Guide`](../fundamentals/apex-style-guide.md)
- [`Architecture Principles`](../fundamentals/architecture-principles.md)
- [`Review Checklist`](../fundamentals/apex-review-checklist.md)

> All new MambaDev code must align with these fundamentals.  
> Legacy code should converge progressively.

---

## 🔁 MambaDev Logging Stack

All execution paths — Apex, Flow, REST, async — log into `FlowExecutionLog__c` using the `Logger` class.

Captured details include:

- Class + Method  
- Input/Output JSON  
- Exception Stack (if present)  
- Trigger Type, Flow Step, Environment  
- Integration direction & identifiers  

📎 See:
- [`structured-logging.md`](./structured-logging.md)
- [`flow-execution-log.md`](./flow-execution-log.md)

---

## ✅ Rules of the Game

- ❌ No client-specific code  
- ❌ No org-bound IDs or metadata  
- ❌ No sensitive fields or logic  
- ✅ Everything must be **reusable, testable, and auditable**

---

## 🌐 Access the Public Module

📍 [`https://mambadev.io/apex`](https://mambadev.io/apex)

This is a **clean public module** — open source for devs who don’t just ship code, but shape systems.

---

## ⚫ Mamba Mentality

We don’t build for today.  
We build for the developer who inherits this tomorrow.  
We leave behind clarity, precision, and structure.

> Every class is a contract.  
> Every exception has meaning.  
> Every log is a traceable artifact of intent.

**Welcome to the elite. Now execute.**
