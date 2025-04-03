/**
 * Class `EnvironmentUtils`
 * 
 * This utility class centralizes the access and management of environment-level configuration settings
 * stored in the Custom Setting `SystemConfig__c`. It provides methods to read and update
 * critical parameters such as environment type (production or sandbox), log level, logging status,
 * mock enablement, test mode, and more.
 * 
 * ### Functionality:
 * - **Read Configurations:** Access current values from the custom setting for environment-related flags.
 * - **Update Configurations:** Modify custom setting values dynamically.
 * - **Internal Cache:** Reduces redundant queries by caching values after initial load.
 * 
 * ### Fields Accessed in `SystemConfig__c`:
 * - `Environment__c`
 * - `Log_Level__c`
 * - `Log_Enabled__c`
 * - `Enable_Mock__c`
 * - `Test_Mode_Active__c`
 * - `Timeout_Callout__c`
 * - `Max_Debug_Length__c`
 * - `Disable_Flows__c`
 * 
 * ### Example Usage:
 * - Determine current environment: `isProduction()`, `isSandbox()`
 * - Control logging: `getLogLevel()`, `isLogEnabled()`
 * - Configure mocks/test modes: `isMockEnabled()`, `isTestModeActive()`
 * - Update values dynamically for testing or configuration changes.
 * 
 * @author      MambaDev
 * @since       2025-04-01
 */
public class EnvironmentUtils {

    // 🔒 Cached values
    @TestVisible private static String ENVIRONMENT;
    @TestVisible private static String LOG_LEVEL;
    @TestVisible private static Boolean LOG_ENABLED;
    @TestVisible private static Boolean ENABLE_MOCK;
    @TestVisible private static Boolean TEST_MODE_ACTIVE;
    @TestVisible private static Decimal TIMEOUT_CALLOUT;
    @TestVisible private static Decimal MAX_DEBUG_LENGTH;
    @TestVisible private static Boolean DISABLE_FLOWS;

    static {
        loadSettings();
    }

    @TestVisible
    public static void resetCache() {
        loadAllSettings();
    }

    @TestVisible
    private static void loadSettings() {
        try {
            SystemConfig__c config = [
                SELECT Environment__c, Log_Level__c, Log_Enabled__c, 
                       Enable_Mock__c, Test_Mode_Active__c, 
                       Timeout_Callout__c, Max_Debug_Length__c, Disable_Flows__c 
                  FROM SystemConfig__c
                 ORDER BY CreatedDate DESC LIMIT 1
            ];
            if (config != null) {
                ENVIRONMENT        = String.isNotBlank(config.Environment__c) ? config.Environment__c.trim().toLowerCase() : null;
                LOG_LEVEL          = String.isNotBlank(config.Log_Level__c) ? config.Log_Level__c.trim().toLowerCase() : null;
                LOG_ENABLED        = config.Log_Enabled__c;
                ENABLE_MOCK        = config.Enable_Mock__c;
                TEST_MODE_ACTIVE   = config.Test_Mode_Active__c;
                TIMEOUT_CALLOUT    = config.Timeout_Callout__c;
                MAX_DEBUG_LENGTH   = config.Max_Debug_Length__c;
                DISABLE_FLOWS      = config.Disable_Flows__c;
            }
        } catch (Exception ex) {
            System.debug('⚠️ Failed to load SystemConfig__c: ' + ex.getMessage());
        }
    }

    public static Boolean isProduction() {
        return 'production'.equalsIgnoreCase(ENVIRONMENT);
    }

    public static Boolean isSandbox() {
        return 'sandbox'.equalsIgnoreCase(ENVIRONMENT);
    }

    public static Boolean isKnownEnvironment() {
        return isProduction() || isSandbox();
    }

    public static String getEnvironmentRaw() {
        return ENVIRONMENT;
    }

    public static String getLogLevel() {
        return LOG_LEVEL;
    }

    public static Boolean isLogEnabled() {
        return LOG_ENABLED;
    }

    public static Boolean isMockEnabled() {
        return ENABLE_MOCK;
    }

    public static Boolean isTestModeActive() {
        return TEST_MODE_ACTIVE;
    }

    public static Decimal getTimeoutCallout() {
        return TIMEOUT_CALLOUT;
    }

    public static Decimal getMaxDebugLength() {
        return MAX_DEBUG_LENGTH;
    }

    public static Boolean isFlowsDisabled() {
        return DISABLE_FLOWS;
    }

    // ---- UPDATE METHODS ----

    public static void updateEnvironment(String value) {
        validateAndUpdate('Environment__c', value, new List<String>{'production', 'sandbox'});
        ENVIRONMENT = value.toLowerCase();
    }

    public static void updateLogLevel(String value) {
        validateAndUpdate('Log_Level__c', value, new List<String>{'info', 'warn', 'error'});
        LOG_LEVEL = value.toLowerCase();
    }

    public static void updateLogEnabled(Boolean value) {
        updateField('Log_Enabled__c', value);
        LOG_ENABLED = value;
    }

    public static void updateEnableMock(Boolean value) {
        updateField('Enable_Mock__c', value);
        ENABLE_MOCK = value;
    }

    public static void updateTestModeActive(Boolean value) {
        updateField('Test_Mode_Active__c', value);
        TEST_MODE_ACTIVE = value;
    }

    public static void updateTimeoutCallout(Decimal value) {
        updateField('Timeout_Callout__c', value);
        TIMEOUT_CALLOUT = value;
    }

    public static void updateMaxDebugLength(Decimal value) {
        updateField('Max_Debug_Length__c', value);
        MAX_DEBUG_LENGTH = value;
    }

    public static void updateDisableFlows(Boolean value) {
        updateField('Disable_Flows__c', value);
        DISABLE_FLOWS = value;
    }

    private static void validateAndUpdate(String field, String value, List<String> allowedValues) {
        if (String.isBlank(value) || !allowedValues.contains(value.toLowerCase())) {
            throw new IllegalArgumentException(field + ' must be one of: ' + String.join(allowedValues, ', '));
        }
        updateField(field, value);
    }

    @TestVisible
    private static void updateField(String fieldName, Object newValue) {
        try {
            SystemConfig__c config = [
                SELECT Id FROM SystemConfig__c 
                 ORDER BY CreatedDate DESC LIMIT 1
            ];
            if (config == null) {
                config = new SystemConfig__c(SetupOwnerId = UserInfo.getOrganizationId());
            }
            config.put(fieldName, newValue);
            update config;
        } catch (Exception ex) {
            System.debug('⚠️ Failed to update SystemConfig__c.' + fieldName + ': ' + ex.getMessage());
        }
    }
}
