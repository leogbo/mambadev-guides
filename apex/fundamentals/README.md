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

- 🧱 Core: https://mambadev.io/apex-core-guide
- 🧪 Testing: https://mambadev.io/apex-testing-guide • https://mambadev.io/testing-patterns
- 🪵 Logging: https://mambadev.io/logger-implementation
- 🔁 Refactor: https://mambadev.io/apex-feature-comparison • https://mambadev.io/equivalence-checklist
- 🧩 Architecture: https://mambadev.io/layered-architecture • https://mambadev.io/rest-api-guide • https://mambadev.io/style


---

## 🧡🔬 How to Use This Folder

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

See how these fundamentals apply in real-world architecture:

- [`/apex/structured-logging.md`](../apex/structured-logging.md)  
- [`/apex/exceptionutil.md`](../apex/exceptionutil.md)  
- [`/apex/naming-standards.md`](../apex/naming-standards.md)  
- [`/apex/layered-architecture.md`](../apex/layered-architecture.md)

---

> **MambaDev Fundamentals are not rules for rules’ sake.**  
> They are the **infrastructure of excellence** that lets us build without fear.

**Honor the foundation. Evolve with discipline.**
