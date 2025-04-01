# 🧱 Guia Oficial de TestData Setup – v2025 (Mentalidade Mamba)

📎 **Shortlink oficial:** [bit.ly/TestDataSetup](https://bit.ly/TestDataSetup)

> “Setup de teste não é detalhe. É o alicerce de toda validação.” – Mentalidade Mamba 🧠🔥

Este guia define o padrão de como preparar dados de teste reutilizáveis, rastreáveis e seguros com `TestDataSetup` e classes auxiliares associadas.

---

## 📚 Referências cruzadas obrigatórias

- 📘 [Guia Master de Arquitetura](https://bit.ly/GuiaApexMamba)
- 🧪 [Guia de Testes Apex](https://bit.ly/GuiaTestsApex)
- 🔍 [Guia de Revisão](https://bit.ly/GuiaApexRevisao)

---

## ✅ Padrões Gerais

- Dados de teste devem ser criados **somente no `@TestSetup`**
- Nunca usar `testData.get(...)` dentro de testes – apenas `SELECT` com fallback
- Builders devem evitar duplicidade com `SELECT LIMIT 1` antes do `insert`

---

## ✅ Setup máximo via `setupCompleteEnvironment()`

Use sempre que o teste depender de uma cadeia completa:
```apex
@TestSetup
static void setup() {
    TestDataSetup.setupCompleteEnvironment();
    FlowControlManager.disableFlows();
}
```

---

## 🧪 Recuperando dados criados

```apex
List<Account> accs = [SELECT Id FROM Account LIMIT 1];
if (accs.isEmpty()) TestHelper.assertSetupCreated('Account');
Account acc = accs[0];
```

---

## ✅ Propriedades do `TestDataSetup`

- Criado com padrão `@isTest` e métodos `@TestVisible`
- `overrideLabel(...)` permite simular labels para testes
- `createIntegracao()` garante idempotência
- `setupCompleteEnvironment()` retorna um `Map<String, SObject>` com chaves padronizadas
- `fullCleanUpAllSupportedObjects()` limpa tudo para testes de isolamento extremo

---

## ✅ Naming Padronizado dos Builders

| Objeto                  | Builder                                      |
|-------------------------|----------------------------------------------|
| Account                 | `AccountTestDataSetup.createAccount()`       |
| Contact                 | `AccountTestDataSetup.createContact()`       |
| Lead PF                 | `LeadTestDataSetup.createLeadPfQualificando()`|
| Lead PJ                 | `LeadTestDataSetup.createLeadPjQualificando()`|
| UC                     | `UcTestDataSetup.createUC(...)`              |
| Cobranca               | `CobrancaTestDataSetup.createCobranca(...)`  |

---

## 🧱 Utilitário `cleanUp()`

Use quando quiser deletar um conjunto específico de registros criados:
```apex
List<Opportunity> opps = [SELECT Id FROM Opportunity];
TestDataSetup.cleanUp(new List<SObject>{ opps[0] });
```

---

## 🔁 Utilitário `fullCleanUpAllSupportedObjects()`

Deleta tudo, em ordem reversa e segura. Útil para testes end-to-end ou de isolamento absoluto.

> ⚠️ Não usar em ambientes com dados reais. Uso exclusivo para classes `@IsTest`.

---

## 🧠 Checklist para Builders e Setup

| Item                                                       | Verificado? |
|------------------------------------------------------------|-------------|
| Builder verifica duplicidade com `SELECT LIMIT 1`          | [ ]         |
| Builder insere apenas se `isEmpty()`                       | [ ]         |
| Dados de teste são inseridos no `@TestSetup`               | [ ]         |
| Nenhum `testData.get(...)` usado em testes                 | [ ]         |
| `assertSetupCreated(...)` usado quando `SELECT` retorna vazio | [ ]         |

---

🧠🧱🧪 #SetupMamba #BuildersComRaiz #NadaDuplicado #MapComChavePadronizada


---  CONTEUDO EXPLICITO DA CLASSE

// @isTest
public class TestDataSetup {

    private static final String MOCK_DOMINIO = 'https://mock-dominio.com';
    private static final String MOCK_URL     = 'https://mock-token.com/oauth';

    @TestVisible
    public class TestSetupException extends Exception {}

    @TestVisible
    private static Map<String, String> testLabels = new Map<String, String>();

    @TestVisible
    public static void overrideLabel(String labelName, String value) {
        if (Test.isRunningTest()) {
            testLabels.put(labelName, value);
        } else {
            throw new TestSetupException('Override de Label não permitido em produção.');
        }
    }

    @TestVisible
    public static String getLabel(String labelName) {
        return testLabels.containsKey(labelName) ? testLabels.get(labelName) : null;
    }

    @TestVisible
    public static Integracao__c createIntegracao() {

        try {
            List<Integracao__c> existentes = [SELECT Id FROM Integracao__c LIMIT 1];

            if (!existentes.isEmpty()) {
                return existentes[0];
            }

            Integracao__c integracao = new Integracao__c(
                Dominio__c       = MOCK_DOMINIO,
                clientId__c      = 'mockClientId' + String.valueOf(System.currentTimeMillis()).right(8),
                clientSecret__c  = 'mockSecret'   + String.valueOf(System.currentTimeMillis()).right(8),
                username__c      = 'usuario'      + String.valueOf(System.currentTimeMillis()).right(8),
                password__c      = 'senha'        + String.valueOf(System.currentTimeMillis()).right(8),
                url__c           = MOCK_URL
            );

            insert integracao;
            return integracao;

        } catch (Exception ex) {
            throw ex;
        }
    }

    @TestVisible
    public static Map<String, SObject> setupCompleteEnvironment() {

        Map<String, SObject> createdRecords = new Map<String, SObject>();

        try {
            User user = UserTestDataSetup.createUser();
            Configuracoes__c responsavel = ResponsavelTestDataSetup.createResponsavel(user.Id);
            Integracao__c integracao = createIntegracao();

            Vertical__c vertical = VerticalTestDataSetup.createVertical('Ultragaz Energia');
            Originador__c originadorPai = OriginadorTestDataSetup.createOriginador(vertical.Id, null);
            Originador__c originadorFilho = OriginadorTestDataSetup.createOriginadorFilho(vertical.Id, null, originadorPai.Id);

            Distribuidora__c distribuidora = DistribuidoraTestDataSetup.createDistribuidora();
            Tarifa_Distribuidora__c tarifa = DistribuidoraTestDataSetup.createTarifaDistribuidora(distribuidora);

            Gerador__c gerador = GeradorTestDataSetup.createGerador();
            Veiculo__c veiculo = GeradorTestDataSetup.createVeiculo(gerador.Id, null);
            Plataforma_de_Cobranca__c plataforma = GeradorTestDataSetup.createPlataformaCobranca(veiculo.Id, 'itau');
            Produto_do_Gerador__c produto = GeradorTestDataSetup.createProdutoDoGerador(vertical.Id, veiculo.Id, distribuidora.Id, plataforma.Id);
            
            Usina__c usina = UsinaTestDataSetup.createUsina(distribuidora.Id, gerador.Id, veiculo.Id);
            Fatura_da_Usina__c faturaUsina = UsinaTestDataSetup.createFaturaDaUsina(usina.Id, Date.today().toStartOfMonth());
            List<Geracao__c> geracoes = UsinaTestDataSetup.createGeracoesParaUsina(usina.Id, Date.today().addMonths(-2), Date.today());

            Lead leadPF = LeadTestDataSetup.createLeadPfQualificando(originadorPai.Id, distribuidora.Id);
            Lead leadPJ = LeadTestDataSetup.createLeadPjQualificando(originadorFilho.Id, distribuidora.Id, null);

            Account account = AccountTestDataSetup.createAccount(vertical.Id, originadorFilho.Id, null, '76.999.774/0001-30');
            Contact contact = AccountTestDataSetup.createContact(account.Id, null, null, null, null, null);

            Opportunity opportunity = OpportunityTestDataSetup.createOpportunity(account.Id, produto.Id, contact.Id);
            Proposta__c proposta = PropostaTestDataSetup.createProposta(opportunity.Id);
            
            Documento_da_Conta__c docConta = DocumentoTestDataSetup.createDocConta(account.Id, null, null, null);
            Documento_do_Contato__c docContato = DocumentoTestDataSetup.createDocContato(contact.Id, null, null, null);
            Documento_da_Proposta__c docProposta = DocumentoTestDataSetup.createDocProposta(proposta.Id, null, null, null);
            Documento_da_Oportunidade__c docOportunidade = DocumentoTestDataSetup.createDocOportunidade(opportunity.Id, null, null);
            
            Signatario_do_Gerador__c signGerador = SignatarioTestDataSetup.createSignatarioGerador(gerador.Id, contact.Id);
            Signatario_da_Oportunidade__c signOpp = SignatarioTestDataSetup.createSignatarioOportunidade(docOportunidade.Id, contact.Id);
            
            Contrato_de_Adesao__c contrato = UcTestDataSetup.createContratoDeAdesao(account.Id, contact.Id, veiculo.Id);
            UC__c uc = UcTestDataSetup.createUC(contrato.Id, produto.Id, proposta.Id, user.Id);
            Contato_da_UC__c contatoDaUc = UcTestDataSetup.createContatoDaUC(uc.Id, uc.Rep_Legal__c, null);
            
            Fatura__c faturaUc = UcTestDataSetup.createFatura(uc.Id, Date.today().toStartOfMonth());
            Cobranca__c cobranca = CobrancaTestDataSetup.createCobranca(uc.Id, null, 1000, null);
            
            Case caseRecord = CaseTestDataSetup.createCase(uc.Id);

            createdRecords.put('User', user);
            createdRecords.put('Responsavel', responsavel);
            createdRecords.put('Integracao', integracao);
            createdRecords.put('Vertical', vertical);
            createdRecords.put('Originador', originadorPai);
            createdRecords.put('OriginadorPai', originadorPai);
            createdRecords.put('OriginadorFilho', originadorFilho);
            createdRecords.put('Distribuidora', distribuidora);
            createdRecords.put('TarifaDistribuidora', tarifa);
            createdRecords.put('Gerador', gerador);
            createdRecords.put('Veiculo', veiculo);
            createdRecords.put('Plataforma', plataforma);
            createdRecords.put('Produto', produto);
            createdRecords.put('Usina', usina);
            createdRecords.put('LeadPF', leadPF);
            createdRecords.put('LeadPJ', leadPJ);
            createdRecords.put('Account', account);
            createdRecords.put('Contact', contact);
            createdRecords.put('Opportunity', opportunity);
            createdRecords.put('Proposta', proposta);
            createdRecords.put('DocConta', docConta);
            createdRecords.put('DocContato', docContato);
            createdRecords.put('DocProposta', docProposta);
            createdRecords.put('DocOportunidade', docOportunidade);
            createdRecords.put('SignatarioGerador', signGerador);
            createdRecords.put('SignatarioOportunidade', signOpp);
            createdRecords.put('Contrato', contrato);
            createdRecords.put('UC', uc);
            createdRecords.put('ContatoDaUc', contatoDaUc);
            createdRecords.put('Cobranca', cobranca);
            createdRecords.put('Case', caseRecord);
            createdRecords.put('FaturaUC', faturaUc);
            createdRecords.put('FaturaUsina', faturaUsina);
            createdRecords.put('Geracoes', geracoes[0]);

            return createdRecords;

        } catch (Exception ex) {
            throw ex;
        }
    }

    @TestVisible
    public static void cleanUp(List<SObject> records) {

        try {
            if (records == null || records.isEmpty()) {
                return;
            }

            Map<String, List<SObject>> grouped = new Map<String, List<SObject>>();
            for (SObject s : records) {
                String tipo = String.valueOf(s.getSObjectType());
                if (!grouped.containsKey(tipo)) grouped.put(tipo, new List<SObject>());
                grouped.get(tipo).add(s);
            }

            Integer totalDeleted = 0;
            for (List<SObject> listToDelete : grouped.values()) {
                if (!listToDelete.isEmpty()) {
                    String tipo = String.valueOf(listToDelete[0].getSObjectType());
                    if (tipo == 'User') continue;
                    try {
                        delete listToDelete;
                        totalDeleted += listToDelete.size();
                    } catch (DmlException dex) {
                        if (!dex.getMessage().contains('ENTITY_IS_DELETED')) {
                            throw dex;
                        }
                    }
                }
            }

        } catch (Exception ex) {
            throw ex;
        }
    }

    @TestVisible
    public static void fullCleanUpAllSupportedObjects() {

        try {
            List<List<SObject>> batches = new List<List<SObject>>();
            batches.add(new List<SObject>(Database.query('SELECT Id FROM Geracao__c')));
            batches.add(new List<SObject>(Database.query('SELECT Id FROM Fatura_da_Usina__c')));
            batches.add(new List<SObject>(Database.query('SELECT Id FROM Fatura__c')));
            batches.add(new List<SObject>(Database.query('SELECT Id FROM Contato_da_UC__c')));
            batches.add(new List<SObject>(Database.query('SELECT Id FROM UC__c')));
            batches.add(new List<SObject>(Database.query('SELECT Id FROM Contrato_de_Adesao__c')));
            batches.add(new List<SObject>(Database.query('SELECT Id FROM Documento_da_Oportunidade__c')));
            batches.add(new List<SObject>(Database.query('SELECT Id FROM Documento_da_Proposta__c')));
            batches.add(new List<SObject>(Database.query('SELECT Id FROM Documento_do_Contato__c')));
            batches.add(new List<SObject>(Database.query('SELECT Id FROM Documento_da_Conta__c')));
            batches.add(new List<SObject>(Database.query('SELECT Id FROM Signatario_da_Oportunidade__c')));
            batches.add(new List<SObject>(Database.query('SELECT Id FROM Signatario_do_Gerador__c')));
            batches.add(new List<SObject>(Database.query('SELECT Id FROM Proposta__c')));
            batches.add(new List<SObject>(Database.query('SELECT Id FROM Opportunity')));
            batches.add(new List<SObject>(Database.query('SELECT Id FROM Contact')));
            batches.add(new List<SObject>(Database.query('SELECT Id FROM Account')));
            batches.add(new List<SObject>(Database.query('SELECT Id FROM Lead')));
            batches.add(new List<SObject>(Database.query('SELECT Id FROM Usina__c')));
            batches.add(new List<SObject>(Database.query('SELECT Id FROM Produto_do_Gerador__c')));
            batches.add(new List<SObject>(Database.query('SELECT Id FROM Plataforma_de_Cobranca__c')));
            batches.add(new List<SObject>(Database.query('SELECT Id FROM Veiculo__c')));
            batches.add(new List<SObject>(Database.query('SELECT Id FROM Gerador__c')));
            batches.add(new List<SObject>(Database.query('SELECT Id FROM Tarifa_Distribuidora__c')));
            batches.add(new List<SObject>(Database.query('SELECT Id FROM Distribuidora__c')));
            batches.add(new List<SObject>(Database.query('SELECT Id FROM Originador__c')));
            batches.add(new List<SObject>(Database.query('SELECT Id FROM Vertical__c')));
            batches.add(new List<SObject>(Database.query('SELECT Id FROM Configuracoes__c')));
            batches.add(new List<SObject>(Database.query('SELECT Id FROM Integracao__c')));
            batches.add(new List<SObject>(Database.query('SELECT Id FROM Case')));
            batches.add(new List<SObject>(Database.query('SELECT Id FROM Cobranca__c')));

            Integer totalDeleted = 0;
            for (List<SObject> listToDelete : batches) {
                if (!listToDelete.isEmpty()) {
                    String tipo = String.valueOf(listToDelete[0].getSObjectType());
                    if (tipo == 'User') continue;
                    try {
                        delete listToDelete;
                        totalDeleted += listToDelete.size();
                    } catch (DmlException dex) {
                        if (!dex.getMessage().contains('ENTITY_IS_DELETED')) {
                            throw dex;
                        }
                    }
                }
            }

        } catch (Exception ex) {
            throw ex;
        }
    }
}

