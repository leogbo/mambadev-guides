<p align="center">
  <img src="https://raw.githubusercontent.com/leogbo/mambadev-guides/main/static/img/github_banner_mambadev.png" alt="MambaDev Banner" width="100%" />
</p>

# 🐍 MambaDev Apex Guide

> *Precision. Performance. Purpose.*  
> This is Apex — the MambaDev way.

---

## 📘 Purpose

This module defines the **official Apex architecture playbook** of MambaDev.

It exists to:

- 🧠 Set elite, auditable standards for Salesforce development
- 🧱 Document modular, scalable architectural patterns
- 🐍 Train developers to think like architects and operate like SEALs

---

## 📂 Current Structure

Each guide in this module is handcrafted for clarity, reusability, and operational excellence.

| Guide                           | Purpose                                                         |
|----------------------------------|-----------------------------------------------------------------|
| `validation-patterns.md`        | Declarative validation using guard clauses and semantic errors |
| `exception-handling.md`         | Semantic try/catch patterns with custom exceptions             |
| `structured-logging.md`         | Logging architecture using `Logger` and `FlowExecutionLog__c`  |
| `flow-execution-log.md`         | Object reference for persistent structured logs                |
| `exceptionutil.md`              | Utility for fast, clear validation with `AppValidationException`|

---

## 🔁 MambaDev Logging Stack

All logs flow through the `Logger` abstraction into `FlowExecutionLog__c`, capturing:

- Class + Method
- Input/Output Payloads (JSON)
- Stack Trace (if any)
- Flow Step, Trigger Type, and Execution Metadata

Refer to:

- [`structured-logging.md`](./structured-logging.md)
- [`flow-execution-log.md`](./flow-execution-log.md)

---

## ✅ Rules of the Game

- No client-specific logic  
- No org-bound IDs or hardcoded metadata  
- No sensitive data  
- All code must be modular, auditable, and reusable across orgs

---

## 🌐 Access the Public Module

👉 [`https://mambadev.io/apex`](https://mambadev.io/apex)

---

## 🐍 Mamba Mentality

We don’t build for today.  
We build for every dev who comes after us.  
Every class is a contract.  
Every exception has meaning.  
Every log is an artifact of truth.

**Welcome to the elite. Now execute.**
