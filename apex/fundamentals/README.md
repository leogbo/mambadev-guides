<p align="center">
  <img src="https://raw.githubusercontent.com/leogbo/mambadev-guides/main/static/img/github_banner_mambadev.png" alt="MambaDev Banner" width="100%" />
</p>

# 🧱 MambaDev Fundamentals

> This folder contains the **official foundations** of MambaDev engineering discipline.  
> These documents define the **non-negotiable principles**, **base conventions**, and **architectural backbone** of the project.

---

## 🎯 Purpose

Fundamentals exist to:

- Establish shared mental models across teams and modules
- Prevent fragmentation in style, structure, and decision-making
- Act as the **baseline contract** for all implementations in `/apex/`, `/ai/`, `/marketing-cloud/`, etc.
- Provide **stability** in large, evolving codebases

> ⚠️ These are not suggestions. They are **architecture contracts**.

---

## 📚 Core Documents

| File                                | Purpose                                                               |
|-------------------------------------|-----------------------------------------------------------------------|
| `mambadev-coding-style.md`          | The official Apex style foundation used across all modules           |
| `apex-style-guide.md`               | Syntax, indentation, spacing, and formatting rules                   |
| `apex-review-checklist.md`          | What must be verified before approving a pull request                |
| `architecture-principles.md`        | Philosophy and mental models behind all layered design in MambaDev   |

---

## 🧭 How to Use This Folder

- 🧱 **Follow**: All new modules and patterns must align with these fundamentals  
- 🧠 **Reference**: Link to these documents inside other guides when relevant  
- 🔒 **Protect**: Refactors that break fundamentals should be versioned and approved  
- 🔄 **Evolve**: New guidelines should build *on top of*, not *against*, these documents

---

## 🪧 Scope

| Applies to...           | Does *not* apply to...                            |
|-------------------------|---------------------------------------------------|
| All new projects        | Legacy code that has not been migrated yet        |
| All pull requests       | Spike branches or prototypes                      |
| All Apex repos/modules  | Non-Apex-specific implementation (handled case-by-case) |

---

## 🔁 Related Operational Guides

See how these fundamentals are applied in modern MambaDev architecture:

- [`/apex/structured-logging.md`](../apex/structured-logging.md)  
- [`/apex/exceptionutil.md`](../apex/exceptionutil.md)  
- [`/apex/naming-standards.md`](../apex/naming-standards.md)  
- [`/apex/layered-architecture.md`](../apex/layered-architecture.md)

---

> MambaDev Fundamentals are not rules for rules’ sake.  
> They are the **infrastructure of excellence** that lets us build without fear.

**Honor the foundation. Evolve with discipline.**
