<p align="center">
  <img src="https://raw.githubusercontent.com/leogbo/mambadev-guides/main/static/img/github_banner_mambadev.png" alt="MambaDev Banner" width="100%" />
</p>

# 🧪 Sandbox Setup Module – MambaDev

This folder contains operational guides for managing **sandbox initialization**, environment setup, and post-refresh automation inside Salesforce environments.

---

## 📚 Included Guides

- [Sandbox Initialization Guide](sandbox-init-guide.md): Full breakdown of what to configure when a new sandbox is created or refreshed.

---

## 🎯 Purpose

Sandboxes must behave like production-ready spaces from day one.  
This module helps teams:

- Set critical custom settings like `ConfiguracaoSistema__c`
- Automate org init logic using `OrgInitializer.cls`
- Preload environments via `TestDataSetup.cls`
- Log all boot processes via `FlowExecutionLog__c`
- Enforce `EnvironmentUtils` configuration at runtime

> A clean sandbox is the launchpad for serious delivery.

---

## 🔁 Related Docs

- [FlowExecutionLog Schema](../logging/flow-execution-log.md)  
- [Test Data Setup Guide](../testing/test-data-setup.md)  
- [EnvironmentUtils Overview](../core/environment-utils.md)  
- [Logger Architecture](../logging/logger-implementation.md)  
- [Apex Review Checklist](../fundamentals/apex-review-checklist.md)

---

📎 Don’t forget: run `OrgInitializer.run()` after every sandbox refresh  
✅ Or automate it via post-refresh scripts or CI jobs.

---

**Apex without initialization is a guess.  
Mamba without setup is not Mamba.**  
**Start clean. Build legendary.**
```

---

## 🔥 Summary of Fixes

| Fix Applied                     | Description                              |
|----------------------------------|------------------------------------------|
| 🔗 Linked `sandbox-init-guide.md` | Now clickable ✅                         |
| ✅ Cross-linked other modules    | Logger, TestDataSetup, EnvUtils, etc.    |
| 🧱 Rewrote purpose to be bolder  | Reinforces platform setup strategy       |
| 📘 Docsify-compatible            | All `.md` links are local & relative     |
