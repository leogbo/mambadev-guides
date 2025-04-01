<p align="center">
  <img src="https://raw.githubusercontent.com/leogbo/mambadev-guides/main/static/img/github_banner_mambadev.png" alt="MambaDev Banner" width="100%" />
</p>

# Validation Patterns – MambaDev

> This guide defines standard patterns for input and business rule validation in Apex.  
> Designed to be declarative, semantic, and aligned with MambaDev’s logging and exception architecture.

---

## 🎯 Validation Philosophy

- ✅ Fail fast, fail clearly  
- ✅ Use exceptions to represent functional problems — not control flow  
- ✅ Prefer `ExceptionUtil` over inline `if/throw`  
- ✅ Always log before throwing when in a controller, trigger, or integration boundary  
- ✅ Keep business logic **clean**, **auditable**, and **testable**

---

## 🔁 Reusable Guard Clauses with `ExceptionUtil`

### 1. Required Field

```apex
ExceptionUtil.throwIfBlank(account.Name, 'Account Name is required.');
```

### 2. Mandatory Reference

```apex
ExceptionUtil.throwIfNull(opportunity.AccountId, 'Opportunity must be related to an Account.');
```

### 3. Custom Rule

```apex
ExceptionUtil.require(user.Email.endsWith('@company.com'), 'Only corporate emails are allowed.');
```

### 4. Logged & Thrown Validation

```apex
if (!isAccountEligible(account)) {
    new Logger()
        .setClass('AccountService')
        .setMethod('checkEligibility')
        .warn('Account not eligible', JSON.serialize(account));

    ExceptionUtil.fail('Account is not eligible for conversion.');
}
```

---

## 🧪 Before Insert / Before Update Validations

```apex
for (Opportunity opp : Trigger.new) {
    ExceptionUtil.throwIfBlank(opp.StageName, 'Stage is required.');
    ExceptionUtil.throwIfNull(opp.CloseDate, 'Close Date is required.');
    ExceptionUtil.throwIf(
        opp.Amount < 0,
        'Amount must be non-negative.'
    );
}
```

---

## ✅ Validation Checklist (Service Layer)

| Validation Type         | Pattern                                                                |
|-------------------------|------------------------------------------------------------------------|
| Required String         | `ExceptionUtil.throwIfBlank(value, msg)`                              |
| Required Object         | `ExceptionUtil.throwIfNull(obj, msg)`                                 |
| Rule Evaluation         | `ExceptionUtil.require(condition, msg)`                               |
| Logged Failure          | `logger.warn(...)` + `ExceptionUtil.fail(msg)`                        |
| Label / Config Missing  | `ExceptionUtil.throwIfBlank(Label.MY_LABEL, 'Label MY_LABEL missing')`|

---

## 🧠 Pro Tips

- Use `ExceptionUtil` in service classes, utility layers, and validations
- Use `Logger` to **document validation failures**
- Prefer **semantic exceptions** like `AppValidationException` over generic `Exception`
- Test validation scenarios explicitly in unit tests

---

## 📚 Related Guides

- [Exception Handling](./exception-handling.md)  
  How to define and catch semantic exceptions using the Mamba style.

- [Structured Logging](./structured-logging.md)  
  Log all validation and system failures consistently to `FlowExecutionLog__c`.

- [ExceptionUtil Class](./exceptionutil.md)  
  Helper methods to enforce preconditions with semantic exceptions.

---

> In MambaDev, validation isn't defensive —  
> it's assertive, intentional, and part of the architecture.
