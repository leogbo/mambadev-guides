<p align="center">
  <img src="https://raw.githubusercontent.com/leogbo/mambadev-guides/main/static/img/github_banner_mambadev.png" alt="MambaDev Banner" width="100%" />
</p>

# 🧱 MambaDev Fundamentals

> This folder contains the **official foundations** of MambaDev engineering discipline.  
> These documents define the **non-negotiable principles**, **base conventions**, and **architectural backbone** of the project.

---

## 🌟 Purpose

Fundamentals exist to:

- Establish shared mental models across teams and modules  
- Prevent fragmentation in style, structure, and decision-making  
- Act as the **baseline contract** for all implementations in `/apex/`, `/ai/`, `/marketing-cloud/`, etc.  
- Provide **stability** in large, evolving codebases

> ⚠️ These are not suggestions.  
> They are **architecture contracts**.

---

## 📚 Core Documents

- 🧱 [Apex Core Guide](/docs/apex/fundamentals/mamba-apex-core-guide.md)  
- 🧪 [Testing Guide](/docs/apex/testing/apex-testing-guide.md) • [Testing Patterns](/docs/apex/testing/testing-patterns.md)  
- 🪵 [Logger Implementation](/docs/apex/logging/logger-implementation.md)  
- 🔁 [Feature Comparison](/docs/apex/fundamentals/apex-feature-comparison.md) • [Equivalence Checklist](/docs/apex/fundamentals/equivalence-checklist.md)  
- 🧩 [Layered Architecture](/docs/apex/fundamentals/layered-architecture.md) • [REST API Guide](/docs/apex/integrations/rest-api-guide.md) • [Style Guide](/docs/apex/fundamentals/mamba-coding-style.md)

---

## 🧠 How to Use This Folder

- 🧱 **Follow**: All new modules and patterns must align with these fundamentals  
- 🧠 **Reference**: Link to these documents inside other guides when relevant  
- 🔐 **Protect**: Refactors that break fundamentals must be versioned and reviewed  
- ⟳ **Evolve**: New rules should build *on top of*, never *against* these foundations

---

## 🚧 Scope

| Applies to...           | Does *not* apply to...                            |
|-------------------------|---------------------------------------------------|
| All new projects        | Legacy code not yet migrated to Mamba standards   |
| All pull requests       | Spike branches or throwaway prototypes            |
| All Apex repos/modules  | Non-Apex-specific code (case-by-case evaluation)  |

---

## 🔁 Related Operational Guides

These documents apply Mamba fundamentals across technical implementation:

- [Structured Logging Stack](/docs/apex/logging/structured-logging.md)  
- [ExceptionUtil Helper](/docs/apex/logging/exception-util.md)  
- [Naming Standards](/docs/apex/fundamentals/naming-standards.md)  
- [Layered Architecture](/docs/apex/fundamentals/layered-architecture.md)  
- [Apex Review Checklist](/docs/apex/fundamentals/apex-review-checklist.md)

---

> **MambaDev Fundamentals are not rules for rules’ sake.**  
> They are the **infrastructure of excellence** that lets us build without fear.

**Honor the foundation. Evolve with discipline.**
