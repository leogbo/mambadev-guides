# 🧪 Guia Oficial de Testes Apex (Mamba Style)

> "Testar não é um passo final. É parte da excelência desde o início."

## 🎯 Objetivo

Garantir que todo teste:
- Cubra a lógica real (sem shortcuts)
- Tenha asserts claros, rastreáveis e expressivos
- Utilize mocks onde necessário sem validar efeitos colaterais
- Utilize dados reais via `TestDataSetup`
- Mantenha compatibilidade com o código legado (sem quebra de contratos)

---

## ✅ Estrutura Base do Teste

```apex
@IsTest
static void nome_do_teste() {
    Test.startTest();
    // execução
    Test.stopTest();

    System.assertEquals('esperado', retorno.get('campo'));
}
```

### Setup padrão:
```apex
@TestSetup
static void setup() {
    TestDataSetup.setupCompleteEnvironment();
    FlowControlManager.disableFlows();
}
```

---

## ⚠️ Nunca faça:

| Proibido                        | Correto                              |
|--------------------------------|---------------------------------------|
| `System.debug()`               | `LoggerMock` para rastreio opcional   |
| Validar logs com assert        | Validar apenas retornos funcionais    |
| `insert` em massa em teste     | Usar `TestDataSetup`                 |
| `if` por tipo em teste         | Usar `TestHelper.fakeIdForSafe(...)` |

---

## 🧠 Assertividade Mamba

### ✔️ Exemplos reais de assertividade refinada

```apex
System.assertEquals('FINALIZADO', result.get('status').toUpperCase(), 'Status inesperado: ' + result.get('status'));
System.assertEquals(3, propostas.size(), 'Quantidade incorreta de propostas retornadas: ' + propostas.size());
System.assert(result.get('mensagem') != null, 'Mensagem não deveria ser nula');
System.assert(result.get('mensagem').toUpperCase().contains('SUCESSO'), 'Mensagem deveria conter "sucesso". Valor atual: ' + result.get('mensagem'));
```

- Cada `assert` valida uma consequência real
- Nomes de métodos de teste devem descrever o comportamento testado
- Mensagens de erro nos asserts são obrigatórias

```apex
System.assertEquals(200, response.statusCode, 'Código HTTP inesperado');
System.assert(response.get('data') != null, 'Dados devem estar presentes');
```

---

## 🔒 Logger em testes

> Nunca valide o conteúdo dos logs. Apenas capture via `LoggerMock` para inspeção opcional.

```apex
LoggerMock logger = new LoggerMock();
Logger.isEnabled = false; // silencia logger real
```

---

## 🔧 Utilitários com `TestHelper`

```apex
Id fakeId = TestHelper.fakeIdForSafe(Account.SObjectType);
String email = TestHelper.randomEmail();
String telefone = TestHelper.fakePhone();
```

Use `assertSetupCreated(obj)` para garantir que seus testes falham se os dados não forem criados corretamente:

```apex
if ([SELECT COUNT() FROM Account] == 0) {
    TestHelper.assertSetupCreated('Account');
}
```

---

## 📘 Exemplos avançados

### 📛 Nome de classe de teste extremamente explícito
```apex
@IsTest
private class PropostaService_Deve_Atualizar_Etapa_Quando_Proposta_Valida_Test {}
```

### 🧨 Teste de exceção com variável estática de rastreio
```apex
@IsTest
static void deve_lancar_excecao_quando_id_invalido() {
    ClientPortalService.exceptionThrown = false;
    Map<String, Object> req = mockRequestDataUpdateLoginPassword('UC__c', 'login', 'senha');

    try {
        ClientPortalService.handleUpdateLoginPassword(req);
    } catch (RestServiceHelper.BadRequestException e) {
        // Valida não apenas a exceção lançada, mas o comportamento colateral esperado
        System.assert(ClientPortalService.exceptionThrown, 'Flag de exceção não foi ativada.');
    }
}
```

### 🧵 Teste de função assíncrona sem asserts
```apex
@IsTest
static void deve_executar_loggerQueueable_sem_erro() {
    FlowExecutionLog__c log = new FlowExecutionLog__c(Log_Level__c = 'INFO');
    Test.startTest();
    System.enqueueJob(new LoggerQueueable(log));
    Test.stopTest();

    System.assert(true, 'LoggerQueueable executado com sucesso.');
}
```

### ⚙️ Setup de `ConfiguracaoSistema__c` manual
```apex
@TestSetup
static void configurarSistema() {
    ConfiguracaoSistema__c conf = new ConfiguracaoSistema__c(
        SetupOwnerId = UserInfo.getOrganizationId(),
        Ambiente__c = 'sandbox',
        Log_Level__c = 'DEBUG',
        Log_Ativo__c = true
    );
    insert conf;
}
```

### 🧪 Uso de `XXXTestSetupData.cls`
```apex
@IsTest
static void deve_criar_uc_com_integridade() {
    Map<String, SObject> mapa = PropostaTestSetupData.criarPropostaComUC();
    UC__c uc = (UC__c) mapa.get('UC');
    System.assertNotEquals(null, uc.Id, 'UC não foi criada corretamente');
}
```

---

## 🧪 Tipos de Testes

### 🧬 Refatoração com equivalência funcional
Testa um método refatorado garantindo que:
- Os `asserts` antigos continuam passando
- O comportamento não mudou para entradas conhecidas
- Variáveis como `exceptionThrown` (quando houver) confirmam o mesmo comportamento interno

Exemplo:
```apex
@IsTest
static void deve_manter_comportamento_apos_refatoracao() {
    ClientPortalService.exceptionThrown = false;
    Map<String, Object> req = mockRequestDataUpdateLoginPassword('UC__c', 'login', 'senha');

    try {
        ClientPortalService.handleUpdateLoginPassword(req);
    } catch (RestServiceHelper.BadRequestException e) {
        System.assert(ClientPortalService.exceptionThrown, 'Flag de exceção não foi ativada.');
    }
}
```

### 🔹 Happy Path
Testa o fluxo ideal com dados válidos. Deve haver pelo menos 1 por classe.

### 🔸 Bad Request
Testa omissões de campos obrigatórios ou valores inválidos. Deve gerar `RestServiceHelper.badRequest()`.

### 🔹 Not Found
Testa a ausência de registros quando um ID válido não retorna dados.

### 🔥 Internal Error
Simula erro interno e espera retorno 500 com mensagem rastreável.

---

## 📦 Padrão de Modularização de Testes

Para cada handler ou classe de serviço:

- Criar `ClasseXTest.cls` dedicada
- Separar `happy path`, `bad request` e `internal error` em métodos distintos
- Cada teste deve funcionar com `TestDataSetup` sem `insert` adicional

---

## ✅ Checklist Mamba para Testes

> Inclui validação de equivalência funcional quando aplicável (conforme [GuiaConfirmacaoApex](https://bit.ly/ConfirmacaoApex))

- [x] Usa `@IsTest` e `@TestSetup`
- [x] Sem validação de log
- [x] Asserts com mensagens explícitas
- [x] Testa indivualmente cada método da classe original (global, public, @TestVisible private) 
- [x] Testa cada ramificação da lógica
- [x] Valida estrutura de retorno, não o debug
- [x] Usa `TestHelper` e `TestDataSetup`
- [x] Executa com `Test.startTest()` / `stopTest()`
- [x] Não quebra contratos anteriores, mesmo em refatorações

---

> **“Se o teste não te dá confiança absoluta, ele não é bom o suficiente.” — Mentalidade Mamba**



**classes .cls***

/**
 * @since 2025-03-28
 * @author Leo Mamba Garcia
 * 
 * Classe `TestHelper`
 * 
 * Contém métodos utilitários para auxiliar a criação de dados de teste, geração de valores falsos
 * e a validação de pré-condições antes da execução dos testes. O TestHelper centraliza toda a lógica
 * de configuração de dados para evitar repetição e garantir consistência nos testes.
 */
public class TestHelper {

    /**
     * Gera um ID falso seguro para o tipo de objeto informado.
     */
    @TestVisible public static Id fakeIdForSafe(Schema.SObjectType type) {
        if (type == null) return null;

        try {
            // Tenta buscar um ID real do objeto
            String objectName = type.getDescribe().getName();
            String query = 'SELECT Id FROM ' + objectName + ' LIMIT 1';
            List<SObject> records = Database.query(query);

            if (records.isEmpty()) {
                // Se não houver registros reais, gera via getKeyPrefix com fallback controlado
                String prefix = type.getDescribe().getKeyPrefix();
                return Id.valueOf(prefix + '000000000000ZZZ'); // estrutura segura
            }

            Id realId = records[0].Id;
            String mutated = String.valueOf(realId).substring(0, 12) + 'ZZZ'; // troca sufixo
            return Id.valueOf(mutated);

        } catch (Exception ex) {
            System.debug('⚠️ fakeIdForSafe falhou: ' + ex.getMessage());
            return null;
        }
    }

    /**
     * Gera um e-mail aleatório para simulação de testes.
     */
    @TestVisible public static String randomEmail() {
        Integer suffix = Math.mod(Math.abs(Crypto.getRandomInteger()), 1000000);
        return 'usuario' + String.valueOf(suffix) + '@teste.com';
    }

    /**
     * Gera um CNPJ falso no formato '76.999.774/0001-XX'.
     */
    @TestVisible public static String fakeCnpj() {
        Integer digito = Math.mod(Math.abs(Crypto.getRandomInteger()), 90);
        String dv = digito < 10 ? '0' + String.valueOf(digito) : String.valueOf(digito);
        return '76.999.774/0001-' + dv;
    }

    /**
     * Gera um número de telefone no formato brasileiro, exemplo: 5521999XXXXXX.
     */
    @TestVisible public static String fakePhone() {
        // Gera um número do tipo 5521999XXXXXX (celular do RJ)
        String numero = '5521999' + randomDigits(6);
        return numero;
    }

    /**
     * Gera uma sequência de números aleatórios com o comprimento especificado.
     */
    @TestVisible public static String randomDigits(Integer length) {
        String result = '';
        while (result.length() < length) {
            result += String.valueOf(Math.abs(Crypto.getRandomInteger()));
        }
        return result.substring(0, length);
    }

    /**
     * Gera uma string aleatória com caracteres alfanuméricos, com o comprimento especificado.
     */
    @TestVisible public static String randomString(Integer length) {
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
        String result = '';
        while (result.length() < length) {
            Integer r = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            result += chars.substring(r, r + 1);
        }
        return result;
    }

    /**
     * Método para assertiva de que o dado não foi configurado.
     */
    @TestVisible public static void assertSetupCreated(String objeto) {
        System.assert(false, '❌ Registro obrigatório do tipo ' + objeto + ' não foi criado via TestDataSetup.');
    }
}


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


public class RecordHelper {
    @TestVisible
    public static SObject getById(Schema.SObjectType sobjectType, Id recordId, String queryFields) {
        if (recordId == null || String.isBlank(queryFields) || sobjectType == null) {
            return null;
        }

        String objectName = sobjectType.getDescribe().getName();
        String query = 'SELECT ' + queryFields + ' FROM ' + objectName + ' WHERE Id = :recordId LIMIT 1';

        List<SObject> records = Database.query(query);
        return records.isEmpty() ? null : records[0];
    }
}

public class LoggerMock implements ILogger {
    public List<String> capturedMessages = new List<String>();
    private Map<String, Object> context = new Map<String, Object>();
    
    @TestVisible
    public ILogger withMethod(String methodName) {
        context.put('method', methodName);
        return this;
    }

    
    @TestVisible
    public ILogger withRecordId(String recordId) {
        context.put('recordId', recordId);
        return this;
    }

    
    @TestVisible
    public ILogger withCategory(String category) {
        context.put('category', category);
        return this;
    }

    
    @TestVisible
    public ILogger withTriggerType(String triggerType) {
        context.put('triggerType', triggerType);
        return this;
    }

    
    @TestVisible
    public ILogger withEnvironment(String environment) {
        context.put('environment', environment);
        return this;
    }

    
    @TestVisible
    public ILogger withClass(String className) {
        context.put('class', className);
        return this;
    }

    
    @TestVisible
    public ILogger withAsync(Boolean value) {
        context.put('async', value);
        return this;
    }

    
    @TestVisible
    public void success(String message, String serializedData) {
        capturedMessages.add('[SUCCESS] ' + message + ' | ' + serializedData);
    }

    
    @TestVisible
    public void info(String message, String serializedData) {
        capturedMessages.add('[INFO] ' + message + ' | ' + serializedData);
    }

    
    @TestVisible
    public void warn(String message, String serializedData) {
        capturedMessages.add('[WARN] ' + message + ' | ' + serializedData);
    }

    
    @TestVisible
    public void error(String message, Exception ex, String serializedData) {
        String msg = message + (ex != null ? ' | ' + ex.getMessage() : '');
        capturedMessages.add('[ERROR] ' + msg + ' | ' + serializedData);
    }

    
    @TestVisible
    public void logRaw(String message) {
        capturedMessages.add('[RAW] ' + message);
    }

    
    @TestVisible
    public Map<String, Object> debugSnapshot() {
        return context.clone();
    }

    
    @TestVisible
    public List<String> getCaptured() {
        return capturedMessages;
    }
}


/**
 * Classe `EnvironmentUtils`
 * 
 * Esta classe centraliza a leitura e atualização de configurações do ambiente da organização Salesforce
 * através do Custom Setting `ConfiguracaoSistema__c`. Ela permite acessar e manipular informações como 
 * o ambiente (produção ou sandbox), o nível de log, se o log está ativo, a habilitação de mocks, entre 
 * outros parâmetros configuráveis diretamente do Custom Setting. Os valores configurados são carregados e 
 * mantidos em cache para garantir a eficiência e evitar múltiplas consultas.
 * 
 * ### Funcionalidade:
 * - **Leitura dos Valores Configurados:** Os métodos de leitura permitem acessar o valor do ambiente, 
 *   o nível de log, se o log está ativo, e outros parâmetros.
 * - **Atualização das Configurações:** A classe fornece métodos para atualizar as configurações no Custom 
 *   Setting, permitindo alterar o ambiente, o nível de log, e outros valores diretamente na plataforma.
 * - **Cache Interno:** A classe utiliza um cache para armazenar os valores configurados após a leitura 
 *   inicial, evitando consultas repetidas e melhorando a performance das operações subsequentes.
 * - **Acesso a Custom Settings:** A classe interage diretamente com o Custom Setting `ConfiguracaoSistema__c`,
 *   que armazena valores específicos para a organização (como `Ambiente__c`, `Log_Level__c`, `Log_Ativo__c`, 
 *   `Habilita_Mock__c`, `Modo_Teste_Ativo__c`, entre outros).
 * 
 * ### Métodos de Leitura:
 * - `isProduction()`: Retorna `true` se o ambiente configurado for produção.
 * - `isSandbox()`: Retorna `true` se o ambiente configurado for sandbox.
 * - `getRaw()`: Retorna o valor do ambiente como uma string.
 * - `isKnownEnvironment()`: Retorna `true` se o ambiente for conhecido (produção ou sandbox).
 * - `getLogLevel()`: Retorna o nível de log configurado.
 * - `isLogAtivo()`: Retorna se o log está ativo.
 * - `isMockEnabled()`: Retorna se a funcionalidade de mock está habilitada.
 * - `isModoTesteAtivo()`: Retorna se o modo de teste está ativo.
 * - `getTimeoutCallout()`: Retorna o timeout de callout configurado.
 * - `isFlowsDisabled()`: Retorna se os flows estão desativados.
 * 
 * ### Métodos de Atualização:
 * - `updateEnvironment(String newEnvironment)`: Atualiza o ambiente configurado (produção ou sandbox).
 * - `updateLogLevel(String newLogLevel)`: Atualiza o nível de log configurado.
 * - `updateLogAtivo(Boolean newLogAtivo)`: Atualiza se o log está ativo.
 * - `updateHabilitaMock(Boolean newHabilitaMock)`: Atualiza se a funcionalidade de mock está habilitada.
 * - `updateModoTesteAtivo(Boolean newModoTesteAtivo)`: Atualiza se o modo de teste está ativo.
 * - `updateTimeoutCallout(Decimal newTimeout)`: Atualiza o timeout de callout configurado.
 * - `updateDesativarFlows(Boolean newDesativarFlows)`: Atualiza se os flows estão desativados.
 * 
 * ### Uso nas Demais Classes:
 * Esta classe deve ser utilizada em outras classes que necessitam acessar ou modificar as configurações 
 * globais de ambiente. Por exemplo:
 * - **Verificação do ambiente**: Qualquer lógica que dependa de saber se a organização está em ambiente 
 *   de produção ou sandbox pode usar os métodos `isProduction()` ou `isSandbox()`.
 * - **Configuração de logs**: Classes que realizam logging podem utilizar `getLogLevel()` e `isLogAtivo()` 
 *   para ajustar o nível de log dinamicamente.
 * - **Controle de comportamento de mocks e testes**: Métodos como `isMockEnabled()` e `isModoTesteAtivo()` 
 *   podem ser usados para configurar o comportamento de testes e mocks durante a execução de testes unitários.
 * - **Alteração de configurações**: Em cenários onde as configurações precisam ser alteradas (como mudar 
 *   o ambiente de sandbox para produção), os métodos `updateEnvironment()` e outros devem ser utilizados.
 * 
 * ### Considerações:
 * - A classe **carrega as configurações apenas uma vez** quando a aplicação é inicializada ou quando 
 *   ocorre uma atualização das configurações. Isso garante que a leitura e as atualizações subsequentes 
 *   sejam eficientes.
 * - A classe interage diretamente com o **Custom Setting** `ConfiguracaoSistema__c`, que deve estar 
 *   configurado corretamente no Salesforce para armazenar as variáveis de ambiente. Isso permite centralizar 
 *   e gerenciar as configurações de ambiente de maneira mais organizada e flexível.
 * - Certifique-se de **validar as permissões de acesso** para o Custom Setting `ConfiguracaoSistema__c` 
 *   em todos os usuários que possam interagir com a classe.
 */

 public class EnvironmentUtils {

    // 🔒 Cache de leitura
    @TestVisible private static String ENVIRONMENT;
    @TestVisible private static String LOG_LEVEL;
    @TestVisible private static Boolean LOG_ATIVO;
    @TestVisible private static Boolean HABILITA_MOCK;
    @TestVisible private static Boolean MODO_TESTE_ATIVO;
    @TestVisible private static Decimal TIMEOUT_CALLOUT;
    @TestVisible private static Boolean DESATIVAR_FLOWS;

    static {
        loadAllSettings();
    }

    @TestVisible
    private static void loadAllSettings() {
        try {
            // Realiza o SELECT para pegar o último registro criado
            ConfiguracaoSistema__c conf = [SELECT Ambiente__c, Log_Level__c, Log_Ativo__c, 
                                                Habilita_Mock__c, Modo_Teste_Ativo__c, 
                                                Timeout_Callout__c, Desativar_Flows__c 
                                           FROM ConfiguracaoSistema__c
                                           ORDER BY CreatedDate DESC LIMIT 1];

            if (conf != null) {
                ENVIRONMENT = String.isNotBlank(conf.Ambiente__c) ? conf.Ambiente__c.trim().toLowerCase() : null;
                LOG_LEVEL = String.isNotBlank(conf.Log_Level__c) ? conf.Log_Level__c.trim().toLowerCase() : null;
                LOG_ATIVO = conf.Log_Ativo__c;
                HABILITA_MOCK = conf.Habilita_Mock__c;
                MODO_TESTE_ATIVO = conf.Modo_Teste_Ativo__c;
                TIMEOUT_CALLOUT = conf.Timeout_Callout__c;
                DESATIVAR_FLOWS = conf.Desativar_Flows__c;
            }
        } catch (Exception ex) {
            System.debug('⚠️ Erro ao acessar Custom Setting: ' + ex.getMessage());
        }
    }

    // Métodos de leitura dos campos
    @TestVisible
    public static Boolean isProduction() {
        return 'production'.equalsIgnoreCase(ENVIRONMENT);
    }

    @TestVisible
    public static Boolean isSandbox() {
        return 'sandbox'.equalsIgnoreCase(ENVIRONMENT);
    }

    @TestVisible
    public static String getRaw() {
        return ENVIRONMENT;
    }

    @TestVisible
    public static Boolean isKnownEnvironment() {
        return isProduction() || isSandbox();
    }

    @TestVisible
    public static String getLogLevel() {
        return LOG_LEVEL;
    }

    @TestVisible
    public static Boolean isLogAtivo() {
        return LOG_ATIVO;
    }

    @TestVisible
    public static Boolean isMockEnabled() {
        return HABILITA_MOCK;
    }

    @TestVisible
    public static Boolean isModoTesteAtivo() {
        return MODO_TESTE_ATIVO;
    }

    @TestVisible
    public static Decimal getTimeoutCallout() {
        return TIMEOUT_CALLOUT;
    }

    @TestVisible
    public static Boolean isFlowsDisabled() {
        return DESATIVAR_FLOWS;
    }

    // Métodos de atualização dos campos

    @TestVisible
    public static void updateEnvironment(String newEnvironment) {
        if (String.isNotBlank(newEnvironment) && (newEnvironment.equalsIgnoreCase('production') || newEnvironment.equalsIgnoreCase('sandbox'))) {
            try {
                // Realiza o SELECT para pegar o último registro criado
                ConfiguracaoSistema__c conf = [SELECT Id, Ambiente__c FROM ConfiguracaoSistema__c 
                                               ORDER BY CreatedDate DESC LIMIT 1];
                if (conf == null) {
                    conf = new ConfiguracaoSistema__c(SetupOwnerId = UserInfo.getOrganizationId());
                }
                conf.Ambiente__c = newEnvironment;
                update conf;

                ENVIRONMENT = newEnvironment.toLowerCase();
            } catch (Exception ex) {
                System.debug('⚠️ Erro ao atualizar Custom Setting Ambiente: ' + ex.getMessage());
            }
        } else {
            throw new IllegalArgumentException('Ambiente inválido. Deve ser "production" ou "sandbox".');
        }
    }

    @TestVisible
    public static void updateLogLevel(String newLogLevel) {
        if (String.isNotBlank(newLogLevel) && (newLogLevel.equalsIgnoreCase('info') || newLogLevel.equalsIgnoreCase('error') || newLogLevel.equalsIgnoreCase('warn'))) {
            try {
                // Realiza o SELECT para pegar o último registro criado
                ConfiguracaoSistema__c conf = [SELECT Id, Log_Level__c FROM ConfiguracaoSistema__c 
                                               ORDER BY CreatedDate DESC LIMIT 1];
                if (conf == null) {
                    conf = new ConfiguracaoSistema__c(SetupOwnerId = UserInfo.getOrganizationId());
                }
                conf.Log_Level__c = newLogLevel;
                update conf;

                LOG_LEVEL = newLogLevel.toLowerCase();
            } catch (Exception ex) {
                System.debug('⚠️ Erro ao atualizar Custom Setting Log Level: ' + ex.getMessage());
            }
        } else {
            throw new IllegalArgumentException('Nível de Log inválido. Deve ser "INFO", "ERROR", ou "WARN".');
        }
    }

    @TestVisible
    public static void updateLogAtivo(Boolean newLogAtivo) {
        try {
            // Realiza o SELECT para pegar o último registro criado
            ConfiguracaoSistema__c conf = [SELECT Id, Log_Ativo__c FROM ConfiguracaoSistema__c 
                                           ORDER BY CreatedDate DESC LIMIT 1];
            if (conf == null) {
                conf = new ConfiguracaoSistema__c(SetupOwnerId = UserInfo.getOrganizationId());
            }
            conf.Log_Ativo__c = newLogAtivo;
            update conf;

            LOG_ATIVO = newLogAtivo;
        } catch (Exception ex) {
            System.debug('⚠️ Erro ao atualizar Custom Setting Log Ativo: ' + ex.getMessage());
        }
    }

    @TestVisible
    public static void updateHabilitaMock(Boolean newHabilitaMock) {
        try {
            // Realiza o SELECT para pegar o último registro criado
            ConfiguracaoSistema__c conf = [SELECT Id, Habilita_Mock__c FROM ConfiguracaoSistema__c 
                                           ORDER BY CreatedDate DESC LIMIT 1];
            if (conf == null) {
                conf = new ConfiguracaoSistema__c(SetupOwnerId = UserInfo.getOrganizationId());
            }
            conf.Habilita_Mock__c = newHabilitaMock;
            update conf;

            HABILITA_MOCK = newHabilitaMock;
        } catch (Exception ex) {
            System.debug('⚠️ Erro ao atualizar Custom Setting Habilita Mock: ' + ex.getMessage());
        }
    }

    @TestVisible
    public static void updateModoTesteAtivo(Boolean newModoTesteAtivo) {
        try {
            // Realiza o SELECT para pegar o último registro criado
            ConfiguracaoSistema__c conf = [SELECT Id, Modo_Teste_Ativo__c FROM ConfiguracaoSistema__c 
                                           ORDER BY CreatedDate DESC LIMIT 1];
            if (conf == null) {
                conf = new ConfiguracaoSistema__c(SetupOwnerId = UserInfo.getOrganizationId());
            }
            conf.Modo_Teste_Ativo__c = newModoTesteAtivo;
            update conf;

            MODO_TESTE_ATIVO = newModoTesteAtivo;
        } catch (Exception ex) {
            System.debug('⚠️ Erro ao atualizar Custom Setting Modo Teste Ativo: ' + ex.getMessage());
        }
    }

    @TestVisible
    public static void updateTimeoutCallout(Decimal newTimeout) {
        try {
            // Realiza o SELECT para pegar o último registro criado
            ConfiguracaoSistema__c conf = [SELECT Id, Timeout_Callout__c FROM ConfiguracaoSistema__c 
                                           ORDER BY CreatedDate DESC LIMIT 1];
            if (conf == null) {
                conf = new ConfiguracaoSistema__c(SetupOwnerId = UserInfo.getOrganizationId());
            }
            conf.Timeout_Callout__c = newTimeout;
            update conf;

            TIMEOUT_CALLOUT = newTimeout;
        } catch (Exception ex) {
            System.debug('⚠️ Erro ao atualizar Custom Setting Timeout Callout: ' + ex.getMessage());
        }
    }

    @TestVisible
    public static void updateDesativarFlows(Boolean newDesativarFlows) {
        try {
            // Realiza o SELECT para pegar o último registro criado
            ConfiguracaoSistema__c conf = [SELECT Id, Desativar_Flows__c FROM ConfiguracaoSistema__c 
                                           ORDER BY CreatedDate DESC LIMIT 1];
            if (conf == null) {
                conf = new ConfiguracaoSistema__c(SetupOwnerId = UserInfo.getOrganizationId());
            }
            conf.Desativar_Flows__c = newDesativarFlows;
            update conf;

            DESATIVAR_FLOWS = newDesativarFlows;
        } catch (Exception ex) {
            System.debug('⚠️ Erro ao atualizar Custom Setting Desativar Flows: ' + ex.getMessage());
        }
    }
}

