/**
 * @name        TestDataSetup
 * @description
 *  Standardized test data initializer for Apex test classes.
 *  Provides helper methods to override Custom Settings, test labels,
 *  and build complete environments for functional and integration testing.
 */
@IsTest
public class TestDataSetup {

    @TestVisible public static String  environment       = (EnvironmentUtils.getRaw() != null) ? EnvironmentUtils.getRaw() : 'sandbox';
    @TestVisible public static String  logLevelDefault   = (EnvironmentUtils.getLogLevel() != null) ? EnvironmentUtils.getLogLevel() : 'INFO';
    @TestVisible public static Integer maxDebugLength    = (EnvironmentUtils.getMaxDebugLength() != null ) ? (Integer)EnvironmentUtils.getMaxDebugLength() : 3000;

    private static final String MOCK_DOMAIN = 'https://mock-domain.test';
    private static final String MOCK_URL    = 'https://mock-token.test/oauth';

    @TestVisible
    public class TestSetupException extends Exception {}

    @TestVisible
    private static Map<String, String> labelOverrides = new Map<String, String>();

    @TestVisible
    public static void overrideLabel(String labelName, String value) {
        if (Test.isRunningTest()) {
            labelOverrides.put(labelName, value);
        } else {
            throw new TestSetupException('Label override is not allowed outside test context.');
        }
    }

    @TestVisible
    public static String getLabel(String labelName) {
        return labelOverrides.containsKey(labelName) ? labelOverrides.get(labelName) : null;
    }

    @TestVisible
    public static Integracao__c createMockIntegration() {
        try {
            List<Integracao__c> existing = [SELECT Id FROM Integracao__c LIMIT 1];
            if (!existing.isEmpty()) return existing[0];

            Integracao__c integration = new Integracao__c(
                Dominio__c      = MOCK_DOMAIN,
                clientId__c     = 'mockClientId' + String.valueOf(System.currentTimeMillis()).right(8),
                clientSecret__c = 'mockSecret'   + String.valueOf(System.currentTimeMillis()).right(8),
                username__c     = 'user'         + String.valueOf(System.currentTimeMillis()).right(8),
                password__c     = 'pass'         + String.valueOf(System.currentTimeMillis()).right(8),
                url__c          = MOCK_URL
            );
            insert integration;
            return integration;

        } catch (Exception ex) {
            throw ex;
        }
    }

    @TestVisible
    public static ConfigSystem__c setupSystemConfiguration() {
        try {
            List<ConfigSystem__c> existing = [
                SELECT Id FROM ConfigSystem__c LIMIT 1
            ];

            if (existing.isEmpty()) {
                return new ConfigSystem__c();
            }

            ConfigSystem__c config = existing[0];

            config.Ambiente__c             = 'sandbox';
            config.Desativar_Flows__c      = false;
            config.Habilita_Log_JSON__c    = true;
            config.Habilita_Mock__c        = true;
            config.Log_Ativo__c            = true;
            config.Log_Level__c            = 'INFO';
            config.Max_Debug_Length__c     = 3000;
            config.Notificar_Erros__c      = false;
            config.Modo_Teste_Ativo__c     = false;
            config.Timeout_Callout__c      = 120000; // Max allowed by platform
            config.Endpoint_GCP__c         = 'https://mock-endpoint.test/api';

            update config;
            return config;

        } catch (Exception ex) {
            throw ex;
        }
    }

    @TestVisible
    public static Map<String, SObject> setupCompleteEnvironment() {
        Map<String, SObject> created = new Map<String, SObject>();

        try {
            ConfigSystem__c config = setupSystemConfiguration();
            User user = UserTestDataSetup.createUser();
            Configuracoes__c owner = ResponsavelTestDataSetup.createResponsavel(user.Id);
            Integracao__c integration = createMockIntegration();

            Vertical__c vertical = VerticalTestDataSetup.createVertical('Default Vertical');
            Originador__c originatorParent = OriginadorTestDataSetup.createOriginador(vertical.Id, null);
            Originador__c originatorChild = OriginadorTestDataSetup.createOriginadorFilho(vertical.Id, null, originatorParent.Id);

            Distribuidora__c distributor = DistribuidoraTestDataSetup.createDistribuidora();
            Tarifa_Distribuidora__c rate = DistribuidoraTestDataSetup.createTarifaDistribuidora(distributor);

            Gerador__c generator = GeradorTestDataSetup.createGerador();
            Veiculo__c vehicle = GeradorTestDataSetup.createVeiculo(generator.Id, null);
            Plataforma_de_Cobranca__c paymentPlatform = GeradorTestDataSetup.createPlataformaCobranca(vehicle.Id, 'itau');
            Produto_do_Gerador__c product = GeradorTestDataSetup.createProdutoDoGerador(vertical.Id, vehicle.Id, distributor.Id, paymentPlatform.Id);

            Usina__c plant = UsinaTestDataSetup.createUsina(distributor.Id, generator.Id, vehicle.Id);
            Fatura_da_Usina__c plantBill = UsinaTestDataSetup.createFaturaDaUsina(plant.Id, Date.today().toStartOfMonth());
            List<Geracao__c> generations = UsinaTestDataSetup.createGeracoesParaUsina(plant.Id, Date.today().addMonths(-2), Date.today());

            Lead leadIndividual = LeadTestDataSetup.createLeadPfQualificando(originatorParent.Id, distributor.Id);
            Lead leadBusiness = LeadTestDataSetup.createLeadPjQualificando(originatorChild.Id, distributor.Id, null);

            Account account = AccountTestDataSetup.createAccount(vertical.Id, originatorChild.Id, null, '76999774000130');
            Contact contact = AccountTestDataSetup.createContact(account.Id, null, null, null, null, null);

            Opportunity opp = OpportunityTestDataSetup.createOpportunity(account.Id, product.Id, contact.Id);
            Proposta__c proposal = PropostaTestDataSetup.createProposta(opp.Id);

            created.put('SystemConfiguration', config);
            created.put('User', user);
            created.put('Owner', owner);
            created.put('Integration', integration);
            created.put('Vertical', vertical);
            created.put('OriginatorParent', originatorParent);
            created.put('OriginatorChild', originatorChild);
            created.put('Distributor', distributor);
            created.put('Rate', rate);
            created.put('Generator', generator);
            created.put('Vehicle', vehicle);
            created.put('PaymentPlatform', paymentPlatform);
            created.put('Product', product);
            created.put('Plant', plant);
            created.put('PlantBill', plantBill);
            created.put('Generation', generations.isEmpty() ? null : generations[0]);
            created.put('LeadIndividual', leadIndividual);
            created.put('LeadBusiness', leadBusiness);
            created.put('Account', account);
            created.put('Contact', contact);
            created.put('Opportunity', opp);
            created.put('Proposal', proposal);

            return created;

        } catch (Exception ex) {
            throw ex;
        }
    }
}
