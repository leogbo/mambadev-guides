/**
 * @name        OrgInitializer
 * @since       2025-04-01
 * @access      public
 * @author      MambaDev
 * @description
 *  Prepares the org environment for tests and automated execution.
 *  Ensures system config is loaded, test data is prepared, and sandbox safety is respected.
 */
public class OrgInitializer {

    private static final String CLASS_NAME = 'OrgInitializer';
    private static final String CATEGORY   = 'Setup';
    private static final String TRIGGER    = 'Manual';

    /**
     * Initializes system configuration via ConfiguracaoSistema__c.
     */
    @TestVisible
    public static void setupConfigSystem(
        String ambiente,
        String logLevel,
        Boolean logAtivo,
        Boolean habilitaMock,
        Boolean modoTesteAtivo,
        Decimal timeoutCallout,
        Boolean desativarFlows
    ) {
        Logger logger = new Logger()
            .setClass(CLASS_NAME)
            .setMethod('setupConfigSystem')
            .setCategory(CATEGORY);

        Map<String, Object> configData = new Map<String, Object>{
            'ambiente' => ambiente,
            'logLevel' => logLevel,
            'logAtivo' => logAtivo,
            'habilitaMock' => habilitaMock,
            'modoTesteAtivo' => modoTesteAtivo,
            'timeoutCallout' => timeoutCallout,
            'desativarFlows' => desativarFlows
        };

        try {
            logger.info('Starting system configuration', JSON.serializePretty(configData));

            delete [SELECT Id FROM ConfiguracaoSistema__c];

            ConfiguracaoSistema__c config = new ConfiguracaoSistema__c(
                SetupOwnerId        = UserInfo.getOrganizationId(),
                Ambiente__c         = ambiente,
                Log_Level__c        = logLevel,
                Log_Ativo__c        = logAtivo,
                Habilita_Mock__c    = habilitaMock,
                Modo_Teste_Ativo__c = modoTesteAtivo,
                Timeout_Callout__c  = timeoutCallout,
                Desativar_Flows__c  = desativarFlows
            );

            insert config;

            logger.success('System config completed successfully', JSON.serializePretty(config));

        } catch (Exception ex) {
            logger.error('Failed to configure system', ex, JSON.serializePretty(configData));
        }
    }

    /**
     * Prepares test data and validates setup success.
     */
    @TestVisible
    public static void setupTestData() {
        Logger logger = new Logger()
            .setClass(CLASS_NAME)
            .setMethod('setupTestData')
            .setCategory(CATEGORY);

        logger.info('Preparing test data using TestDataSetup', null);

        try {
            setupConfigSystem(
                'sandbox',
                'INFO',
                true,
                true,
                true,
                120000,
                false
            );

            TestDataSetup.setupCompleteEnvironment();
            validateTestData();

            logger.success('Test data successfully prepared', null);
        } catch (Exception ex) {
            logger.error('Error while setting up test data', ex, null);
        }
    }

    /**
     * Validates that critical test data exists.
     */
    @TestVisible
    public static void validateTestData() {
        List<Account> contas = [SELECT Id FROM Account LIMIT 1];
        ExceptionUtil.require(!contas.isEmpty(), 'Test data missing: no Account records found.');
    }

    /**
     * Configures the org safely (sandbox-only) and prepares test data.
     */
    @TestVisible
    public static void configureOrg() {
        Logger logger = new Logger()
            .setClass(CLASS_NAME)
            .setMethod('configureOrg')
            .setCategory(CATEGORY);

        try {
            Boolean isSandbox = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
            if (!Test.isRunningTest() && !isSandbox) {
                logger.warn('Execution in production environment is blocked.', null);
                return;
            }

            logger.info('Configuring sandbox org environment', null);
            setupTestData();
            logger.success('Org setup completed', null);

        } catch (Exception ex) {
            logger.error('Failed to configure org', ex, null);
        }
    }

    /**
     * Entry point for full org initialization.
     */
    @TestVisible
    public static void run() {
        configureOrg();
    }
}
