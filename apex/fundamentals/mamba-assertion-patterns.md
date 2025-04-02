# ✅ Mamba Apex – Assertion Patterns

> All assertions must express **intent**, reveal **expectation**, and provide **traceable failure context**.

---

## 🔍 Pattern: Assert Action Name

```apex
System.assertEquals(
    'update_uc',
    res.get('action'),
    'Expected action to be "update_uc", but got: ' + res.get('action')
);
```

---

## 🔍 Pattern: Assert Record ID Match

```apex
System.assertEquals(
    recordId,
    res.get('record_id'),
    'Expected record_id to match, but got: ' + res.get('record_id')
);
```

---

## 🧱 Assertion Rule (Mamba Mentality)

- ❌ Never leave assertion messages empty  
- ✅ Always express:  
  - What was expected  
  - What was received  
  - Where it failed (e.g., `"record_id" mismatch in update flow"`)

---

## 🧪 Bonus: Assert with Condition (Validation Style)

```apex
System.assert(
    opportunity.Amount > 0,
    'Expected opportunity amount to be greater than 0. Got: ' + opportunity.Amount
);
```

---

## 📎 See Also

- [Mamba Testing Guide](https://mambadev.io/3YgDDdx)
- [ExceptionUtil for validations](https://mambadev.io/3QWe8dH)
- [LoggerMock for log assertions](https://mambadev.io/41WCcDA)

---

> Assert like every line matters — because it does.  
> **#AssertWithIntent #FailWithContext #MambaTesting**
