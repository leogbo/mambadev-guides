### 📘 `validation-patterns.md` – Guia de Padrões de Validação Mamba

Esse guia documenta **formas estruturadas e padronizadas de validar dados e regras de negócio** no seu código Apex.

Ele unifica:

- 💡 **Estilo de validação Mamba**: direto, explícito, sem `if` aninhado
- 🔄 **Pontos de validação comuns**: campos obrigatórios, limites, permissões
- 🧱 **Blocos reutilizáveis de validação**
- 🔥 **Integração com `ExceptionUtil` + `Logger`**
- ✅ **Checklist de validação para serviços e controllers**

---

### ✅ Exemplo de conteúdo

```markdown
# Validation Patterns – MambaDev

> This guide defines standard patterns for input and business rule validation in Apex.
> These patterns are designed for clarity, reuse, and alignment with MambaDev's exception + logging architecture.

---

## 🎯 Validation Philosophy

- ✅ Fail fast, fail clearly
- ✅ Use exceptions to represent functional problems, not control flow
- ✅ Use `ExceptionUtil` for common validations
- ✅ Always log before throwing if in a controller or public interface

---

## 🔁 Reusable Guard Clauses

### 1. Required Field

```apex
ExceptionUtil.throwIfBlank(account.Name, 'Account Name is required.');
```

### 2. Custom Condition

```apex
ExceptionUtil.require(contact.Email.endsWith('@company.com'), 'Only corporate emails are allowed.');
```

### 3. Complex Validation

```apex
if (!isAccountEligible(account)) {
    Logger logger = new Logger().setClass('AccountService');
    logger.warn('Account failed eligibility check', JSON.serialize(account));
    ExceptionUtil.fail('Account is not eligible for conversion.');
}
```

---

## 🧪 How to Validate Before Insert

```apex
for (Opportunity opp : Trigger.new) {
    ExceptionUtil.throwIfBlank(opp.StageName, 'Stage is required.');
    ExceptionUtil.throwIfNull(opp.AccountId, 'Opportunity must be related to an Account.');
}
```

---

## ✅ Validation Checklist (Service Layer)

| Check Type            | Pattern                                                                 |
|-----------------------|-------------------------------------------------------------------------|
| Required String       | `ExceptionUtil.throwIfBlank(value, msg)`                               |
| Required Object       | `ExceptionUtil.throwIfNull(obj, msg)`                                  |
| Rule Violation        | `ExceptionUtil.require(condition, msg)`                                |
| Logging Failure       | `logger.warn('Reason', JSON.serialize(obj)) + ExceptionUtil.fail(msg)` |
| Config Validation     | `ExceptionUtil.throwIfBlank(Label.MY_LABEL, 'Label MY_LABEL is missing')`|

---

## 📚 Related Guides

- [Exception Handling](./exception-handling.md)  
  How to structure try/catch blocks semantically.

- [ExceptionUtil Class](./exceptionutil.md)  
  Documentation for the utility used in all validation logic.

- [Logger Class](./structured-logging.md)  
  Log all validation failures consistently.

---

> In MambaDev, validation isn't just defensive.  
> It's declarative, semantic, and testable.
```
