## 🧩 Invocable Method Syntax

Always use **Flow-safe syntax** in `@InvocableMethod` declarations. Commas between parameters in the annotation are not allowed.

```apex
// ✅ Correct
@InvocableMethod(label='My Flow Action' category='Flow Utilities')
public static List<Output> doSomething(List<Input> inputs) { ... }

// ❌ Incorrect
@InvocableMethod(label='My Flow Action', category='Flow Utilities')
