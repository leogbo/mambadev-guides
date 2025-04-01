/**
 * @name        OrgInitializer
 * @since       2025-04-01
 * @access      public
 * @author      MambaDev
 * @description
 *  Initializes the org for test execution or sandbox configuration.
 *  This includes structured system configuration, test data population,
 *  and safety checks to avoid execution in production environments.
 */
public class OrgInitializer {

    private static final String CLASS_NAME = 'OrgInitializer';
    private static final String CATEGORY   = 'Setup';

    /**
     * Applies system-wide configuration via SystemConfig__c.
     *
     * @param environment        The environment name (e.g., 'sandbox')
     * @param logLevel           Desired log level (INFO, DEBUG, etc.)
     * @param logEnabled         Whether logging is active
     * @param enableMock         Whether mocks are enabled
     * @param testModeEnabled    Whether test mode is active
     * @param calloutTimeout     Timeout for callouts in milliseconds
     * @param disableFlows       Whether flows should be disabled
     */
    public static void setupSystemConfig(
        String environment,
        String logLevel,
        Boolean logEnabled,
        Boolean enableMock,
        Boolean testModeEnabled,
        Decimal calloutTimeout,
        Boolean disableFlows
    ) {
        Logger logger = new Logger()
            .setClass(CLASS_NAME)
            .setMethod('setupSystemConfig')
            .setCategory(CATEGORY);

        Map<String, Object> configData = new Map<String, Object>{
            'environment'       => environment,
            'logLevel'          => logLevel,
            'logEnabled'        => logEnabled,
            'enableMock'        => enableMock,
            'testModeEnabled'   => testModeEnabled,
            'calloutTimeout'    => calloutTimeout,
            'disableFlows'      => disableFlows
        };

        try {
            logger.info('Initializing system configuration', JSON.serializePretty(configData));

            delete [SELECT Id FROM SystemConfig__c];

            SystemConfig__c config = new SystemConfig__c(
                SetupOwnerId        = UserInfo.getOrganizationId(),
                Environment__c      = environment,
                LogLevel__c         = logLevel,
                LogEnabled__c       = logEnabled,
                EnableMock__c       = enableMock,
                TestModeEnabled__c  = testModeEnabled,
                CalloutTimeout__c   = calloutTimeout,
                DisableFlows__c     = disableFlows
            );

            insert config;

            logger.success('System configuration completed', JSON.serializePretty(config));

        } catch (Exception ex) {
            logger.error('System configuration failed', ex, JSON.serializePretty(configData));
        }
    }

    /**
     * Populates the org with necessary test data.
     */
    public static void setupTestData() {
        Logger logger = new Logger()
            .setClass(CLASS_NAME)
            .setMethod('setupTestData')
            .setCategory(CATEGORY);

        logger.info('Preparing test data environment', null);

        try {
            setupSystemConfig(
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

            logger.success('Test data environment successfully configured', null);
        } catch (Exception ex) {
            logger.error('Test data setup failed', ex, null);
        }
    }

    /**
     * Ensures test data was properly created.
     */
    public static void validateTestData() {
        List<Account> accounts = [SELECT Id FROM Account LIMIT 1];
        ExceptionUtil.require(!accounts.isEmpty(), 'Missing test data: no Account records found.');
    }

    /**
     * Orchestrates full org configuration (safe for sandbox only).
     */
    public static void configureOrg() {
        Logger logger = new Logger()
            .setClass(CLASS_NAME)
            .setMethod('configureOrg')
            .setCategory(CATEGORY);

        try {
            Boolean isSandbox = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
            if (!Test.isRunningTest() && !isSandbox) {
                logger.warn('Blocked: attempted execution in production environment.', null);
                return;
            }

            logger.info('Executing full org initialization (sandbox)', null);
            setupTestData();
            logger.success('Org initialization completed', null);

        } catch (Exception ex) {
            logger.error('Org initialization failed', ex, null);
        }
    }

    /**
     * Entrypoint method to initialize the org setup pipeline.
     */
    public static void run() {
        configureOrg();
    }
}
