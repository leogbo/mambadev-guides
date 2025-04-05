<p align="center">
  <img src="https://raw.githubusercontent.com/leogbo/mambadev-guides/main/static/img/github_banner_mambadev.png" alt="MambaDev Banner" width="100%" />
</p>

# 🧱 MambaDev Apex Syntax Reminders

## 🧩 Invocable Method Syntax

Always use **Flow-safe syntax** in `@InvocableMethod` declarations. Commas between parameters in the annotation are not allowed.

```apex
// ✅ Correct
@InvocableMethod(label='My Flow Action' category='Flow Utilities')
public static List<Output> doSomething(List<Input> inputs) { ... }

// ❌ Incorrect
@InvocableMethod(label='My Flow Action', category='Flow Utilities')
```

<!-- more sections will be added as we refine learnings from refactors and reviews -->

