<p align="center">
  <img src="https://raw.githubusercontent.com/leogbo/mambadev-guides/main/static/img/github_banner_mambadev.png" alt="MambaDev Banner" width="100%" />
</p>

# 🧪 Sandbox Setup Module – MambaDev

This folder contains operational guides for managing **sandbox initialization**, environment setup, and post-refresh automation inside Salesforce environments.

---

## 📚 Included Guides

- [Sandbox Initialization Guide](/docs/apex/sandbox/sandbox-init-guide.md): Full breakdown of what to configure when a new sandbox is created or refreshed.

---

## 🎯 Purpose

Sandboxes must behave like production-ready spaces from day one.  
This module helps teams:

- Set critical custom settings like [`ConfigSystem__c`](/docs/apex/logging/config-system.md)  
- Automate org init logic using [`OrgInitializer.cls`](/src/classes/org-initializer.cls)  
- Preload environments via [`TestDataSetup.cls`](/src/classes/test-data-setup.cls)  
- Log all boot processes via [`FlowExecutionLog__c`](/docs/apex/logging/flow-execution-log.md)  
- Enforce [`EnvironmentUtils`](/src/classes/environment-utils.cls) configuration at runtime

> A clean sandbox is the launchpad for serious delivery.

---

## 🔁 Related Docs

- [FlowExecutionLog Schema](/docs/apex/logging/flow-execution-log.md)  
- [Test Data Setup Guide](/docs/apex/testing/test-data-setup.md)  
- [`EnvironmentUtils.cls`](/src/classes/environment-utils.cls)  
- [Logger Architecture](/docs/apex/logging/logger-implementation.md)  
- [Apex Review Checklist](/docs/apex/fundamentals/apex-review-checklist.md)

---

📎 Don’t forget: run `OrgInitializer.run()` after every sandbox refresh  
✅ Or automate it via post-refresh scripts or CI jobs.

---

**Apex without initialization is a guess.  
Mamba without setup is not Mamba.**  
**Start clean. Build legendary.**
