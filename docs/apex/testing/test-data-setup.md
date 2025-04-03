<p align="center">
  <img src="https://raw.githubusercontent.com/leogbo/mambadev-guides/main/static/img/github_banner_mambadev.png" alt="MambaDev Banner" width="100%" />
</p>

> 🧱 @status:core | This document defines how to structure, reuse, and validate test environments using `TestDataSetup.cls` and builder utilities.

# 🧱 TestData Setup Guide – v2025 (Mentalidade Mamba)

📎 [Shortlink: mambadev.io/test-data-setup](https://mambadev.io/test-data-setup)

> “Setup de teste não é detalhe.  
> É o alicerce de toda validação.” — Mamba Mentalidade 🧠🔥

---

## 📘 Referências Obrigatórias

- [Apex Core Guide](/docs/apex/fundamentals/mamba-apex-core-guide.md)  
- [Testing Patterns](/docs/apex/testing/testing-patterns.md)  
- [Review Checklist](/docs/apex/fundamentals/apex-review-checklist.md)

---

## ✅ Regras Fundamentais

- Todos os dados devem ser criados **em `@TestSetup`**  
- Nunca usar `testData.get(...)` dentro de testes — use `SELECT` com fallback  
- Builders devem usar `SELECT LIMIT 1` para evitar duplicidade  
- `TestHelper.assertSetupCreated()` deve ser usado se o `SELECT` não retornar registros

---

## 🚀 Setup Padrão via `setupCompleteEnvironment()`

```apex
@TestSetup
static void setup() {
    TestDataSetup.setupCompleteEnvironment();
    FlowControlManager.disableFlows();
}
```

✅ Retorna `Map<String, SObject>` com chaves padrão  
✅ Cria Account, Contact, Lead, Oportunidade, UC, Cobranca, Faturas e mais

---

## 🔍 Como Recuperar Dados Criados

```apex
List<Account> accs = [SELECT Id FROM Account LIMIT 1];
if (accs.isEmpty()) {
    TestHelper.assertSetupCreated('Account');
}
Account acc = accs[0];
```

---

## 🔧 Funções Chave em `TestDataSetup.cls`

| Método                          | Função                                                           |
|---------------------------------|------------------------------------------------------------------|
| `setupCompleteEnvironment()`    | Cria o cenário completo para testes                              |
| `createIntegracao()`            | Cria ou retorna registro `Integracao__c`                         |
| `overrideLabel()`               | Simula labels em ambiente de teste                               |
| `setupConfiguracaoSistema()`    | Atualiza o registro `ConfigSystem__c` para testes                |
| `cleanUp(List<SObject>)`        | Remove registros passados manualmente                            |
| `fullCleanUpAllSupportedObjects()` | Limpa toda a estrutura de dados de forma segura               |

---

## 🔁 Padrão de Builders

| Objeto                    | Builder                                   |
|---------------------------|-------------------------------------------|
| Account                   | `AccountTestDataSetup.createAccount()`    |
| Contact                   | `AccountTestDataSetup.createContact()`    |
| Lead PF                  | `LeadTestDataSetup.createLeadPfQualificando()`  
| Lead PJ                  | `LeadTestDataSetup.createLeadPjQualificando()`  
| UC                       | `UcTestDataSetup.createUC()`              |
| Cobranca                 | `CobrancaTestDataSetup.createCobranca()` |

---

## 🔬 Assert de Setup

```apex
if ([SELECT COUNT() FROM UC__c] == 0) {
    TestHelper.assertSetupCreated('UC__c');
}
```

---

## ⚠️ `cleanUp()` e `fullCleanUpAllSupportedObjects()`

✅ Use `cleanUp(List<SObject>)` para remover apenas o que precisa  
✅ Use `fullCleanUpAllSupportedObjects()` para testes end-to-end com ambiente limpo  

> ⚠️ Só utilize `fullCleanUp...()` em `@IsTest`.  
> Nunca em produção ou em sandboxes reais.

---

## 🧠 Checklist para Builders

| Item                                                       | Verificado? |
|------------------------------------------------------------|-------------|
| Builder verifica duplicidade com `SELECT LIMIT 1`          | [ ]         |
| Builder só insere se `isEmpty()`                           | [ ]         |
| Dados criados no `@TestSetup`                              | [ ]         |
| Nenhum uso de `testData.get(...)`                          | [ ]         |
| Usa `assertSetupCreated(...)` para validação               | [ ]         |

---

## 📚 Classes Relacionadas

- [`TestHelper.cls`](https://github.com/leogbo/mambadev-guides/blob/main/src/classes/test-helper.cls)  
- [`EnvironmentUtils.cls`](https://github.com/leogbo/mambadev-guides/blob/main/src/classes/environment-utils.cls)  
- [`OrgInitializer.cls`](https://github.com/leogbo/mambadev-guides/blob/main/src/classes/org-initializer.cls)  
- [Logger Guide](/docs/apex/logging/logger-implementation.md)  
- [Sandbox Init Guide](/docs/apex/sandbox/sandbox-init-guide.md)

---

> Setup é onde começa a verdade.  
> Se o dado é frágil, o teste é inútil.  
> **#SetupMamba #NadaFalsoTudoReusável**

**#BuilderComRaiz #NadaDuplicado #SimulaComOrgulho** 🧪🧱🔥