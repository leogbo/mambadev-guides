<p align="center">
  <img src="https://raw.githubusercontent.com/leogbo/mambadev-guides/main/static/img/github_banner_mambadev.png" alt="MambaDev Banner" width="100%" />
</p>

> 🧱 @status:core | This module governs the official approach to sandbox setup and post-refresh environment automation.

# 🧪 Sandbox Setup Module – MambaDev

📎 [Shortlink: mambadev.io/sandbox](https://mambadev.io/sandbox)

This folder contains operational guides for managing **sandbox initialization**, environment setup, and post-refresh automation inside Salesforce environments.

---

## 📚 Included Guides

- [Sandbox Initialization Guide](/docs/apex/sandbox/sandbox-init-guide.md)  
  Full breakdown of what to configure when a new sandbox is created or refreshed.

---

## 🎯 Purpose

Sandboxes must behave like **production-aligned, test-configured spaces** from day one.  
This module helps teams:

- ✅ Set baseline config with [`ConfigSystem__c`](/docs/apex/logging/config-system.md)  
- ✅ Initialize logic via [`OrgInitializer.cls`](https://github.com/leogbo/mambadev-guides/blob/main/src/classes/org-initializer.cls)  
- ✅ Preload environments via [`TestDataSetup.cls`](https://github.com/leogbo/mambadev-guides/blob/main/src/classes/test-data-setup.cls)  
- ✅ Persist logs using [`FlowExecutionLog__c`](/docs/apex/logging/flow-execution-log.md)  
- ✅ Enforce runtime flags using [`EnvironmentUtils.cls`](https://github.com/leogbo/mambadev-guides/blob/main/src/classes/environment-utils.cls)

> A clean sandbox is the launchpad for serious delivery.

---

## 🔁 Related Docs

- [FlowExecutionLog__c Schema](/docs/apex/logging/flow-execution-log.md)  
- [Test Data Setup Guide](/docs/apex/testing/test-data-setup.md)  
- [Logger Architecture](/docs/apex/logging/logger-implementation.md)  
- [`EnvironmentUtils.cls`](https://github.com/leogbo/mambadev-guides/blob/main/src/classes/environment-utils.cls)  
- [Apex Review Checklist](/docs/apex/fundamentals/apex-review-checklist.md)

---

📎 Don’t forget:

```apex
OrgInitializer.run();
```

✅ Run after **every sandbox refresh**  
✅ Or automate it in **CI post-deploy jobs**

---

**Apex without initialization is a guess.  
Mamba without setup is not Mamba.**  
**Start clean. Build legendary.**