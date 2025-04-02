<p align="center">
  <img src="https://raw.githubusercontent.com/leogbo/mambadev-guides/main/static/img/github_banner_mambadev.png" alt="MambaDev Banner" width="100%" />
</p>

# ✅ Functional Equivalence Checklist – MambaDev

> This guide defines the minimum validation required to confirm that a refactor maintains the **same functional behavior** as the original code.  
> Use this checklist to validate pull requests, run regression tests, and confirm safe rollouts.

---

## 🎯 What is Functional Equivalence?

A refactor is **functionally equivalent** when:

- Inputs produce the same outputs  
- Side effects (DML, callouts, logs) are preserved or made explicit  
- External behavior, flows, and APIs remain stable  
- No user-facing behavior changes without intentional justification

---

## 🧾 Equivalence Checklist

| Area                      | Description                                                       | Required? |
|---------------------------|-------------------------------------------------------------------|-----------|
| ✅ Unit Tests             | All tests for the original behavior still pass                    | ✅         |
| ✅ Business Rules         | Rule branches produce same outcomes for same inputs               | ✅         |
| ✅ Logging Behavior       | Logger outputs remain equivalent (or improved with traceability)  | ✅         |
| ✅ Exception Handling     | Same exceptions thrown for same conditions                        | ✅         |
| ✅ Data Access            | Same records returned, created, or updated                        | ✅         |
| ✅ Trigger or Flow Impact | Any automation consuming this logic still behaves identically     | ✅         |
| ✅ API Compatibility      | Signatures and outputs are backward compatible                    | ✅         |
| ⚠️ Side Effects           | Email, callouts, async jobs produce same results (or better)       | ⚠️         |

---

## 🧪 Test Artifacts to Provide

In any pull request involving functional code changes:

- [x] List of tests proving equivalence
- [x] Test of failure condition (e.g., validation or exception)
- [x] Optional: output logs before vs after
- [x] Optional: screenshot or JSON diff of behavior if frontend/API involved

---

## 📝 Example Pull Request Confirmation

```markdown
### 🔒 Functional Equivalence Confirmation

- Unit tests all pass (run: `LeadConversionServiceTest`)
- Logger output confirmed via `LoggerMock` inspection
- Exception behavior preserved: still throws `AppValidationException` for invalid Lead
- Tested both null and populated input — same results
✔️ Safe to merge
```

---

## 🚫 When Not Equivalent

If your refactor intentionally changes behavior:

- Clearly state this in the pull request
- Include a **reason for the change**
- Update dependent logic, tests, and documentation
- Mark as **breaking change** if external consumers are affected

---

## 📚 Related Guides

- [Apex Feature Comparison Guide](./apex-feature-comparison.md)  
  How to show before vs after clearly and consistently.

- [Testing Patterns](../testing-patterns.md)  
  Build test classes that validate equivalence explicitly.

- [Review Checklist](../fundamentals/apex-review-checklist.md)  
  Enforces mandatory validations during code review.

---

## 🧠 Final Thought

> Equivalence isn't a feeling — it's a checklist.  
> MambaDev doesn’t assume things are working.  
> **Mamba proves it. Every time.**
