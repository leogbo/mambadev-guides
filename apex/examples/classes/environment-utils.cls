/**
 * @name        EnvironmentUtils
 * @since       2025-04-01
 * @access      global
 * @author      MambaDev
 * @description
 *  Apex utility class for reading and updating environment-level configuration stored in the
 *  org-wide Custom Setting `ConfigSystem__c`. Acts as a cache layer and access point for global flags.
 *
 *  Responsibilities:
 *   - Read environment, logging, mocking, test mode, flow toggle, and timeout values
 *   - Update values dynamically while maintaining in-memory cache
 *   - Support org-aware logic through helper methods (e.g., `isProduction()`)
 */
public class EnvironmentUtils {

    // 🔒 Internal cache (loaded at class init or after update)
    @TestVisible private static String environment;
    @TestVisible private static String logLevel;
    @TestVisible private static Boolean isLogEnabled;
    @TestVisible private static Boolean isMockEnabled;
    @TestVisible private static Boolean isTestMode;
    @TestVisible private static Decimal timeoutCallout;
    @TestVisible private static Decimal maxDebugLength;
    @TestVisible private static Boolean disableFlows;

    static {
        load();
    }

    @TestVisible
    private static void load() {
        try {
            ConfigSystem__c config = [
                SELECT Environment__c, Log_Level__c, Is_Log_Enabled__c, Is_Mock_Enabled__c,
                       Is_Test_Mode__c, Callout_Timeout__c, Max_Debug_Length__c, Disable_Flows__c
                  FROM ConfigSystem__c
                 ORDER BY CreatedDate DESC LIMIT 1
            ];

            environment = String.isNotBlank(config.Environment__c) ? config.Environment__c.trim().toLowerCase() : null;
            logLevel = String.isNotBlank(config.Log_Level__c) ? config.Log_Level__c.trim().toLowerCase() : null;
            isLogEnabled = config.Is_Log_Enabled__c;
            isMockEnabled = config.Is_Mock_Enabled__c;
            isTestMode = config.Is_Test_Mode__c;
            timeoutCallout = config.Callout_Timeout__c;
            maxDebugLength = config.Max_Debug_Length__c;
            disableFlows = config.Disable_Flows__c;
        } catch (Exception ex) {
            System.debug('⚠️ Failed to load ConfigSystem__c: ' + ex.getMessage());
        }
    }

    // 🔍 Read Accessors
    public static Boolean isProduction()        { return 'production'.equalsIgnoreCase(environment); }
    public static Boolean isSandbox()           { return 'sandbox'.equalsIgnoreCase(environment); }
    public static Boolean isKnownEnvironment()  { return isProduction() || isSandbox(); }
    public static String  getEnvironment()      { return environment; }
    public static String  getLogLevel()         { return logLevel; }
    public static Boolean isLogActive()         { return isLogEnabled; }
    public static Boolean isMockEnabled()       { return isMockEnabled; }
    public static Boolean isTestMode()          { return isTestMode; }
    public static Decimal getTimeoutCallout()   { return timeoutCallout; }
    public static Decimal getMaxDebugLength()   { return maxDebugLength; }
    public static Boolean areFlowsDisabled()    { return disableFlows; }

    // ⚙️ Updaters
    @TestVisible public static void updateEnvironment(String newValue) {
        updateField('Environment__c', newValue);
        environment = newValue?.toLowerCase();
    }

    @TestVisible public static void updateLogLevel(String newValue) {
        updateField('Log_Level__c', newValue);
        logLevel = newValue?.toLowerCase();
    }

    @TestVisible public static void updateLogEnabled(Boolean newValue) {
        updateField('Is_Log_Enabled__c', newValue);
        isLogEnabled = newValue;
    }

    @TestVisible public static void updateMockEnabled(Boolean newValue) {
        updateField('Is_Mock_Enabled__c', newValue);
        isMockEnabled = newValue;
    }

    @TestVisible public static void updateTestMode(Boolean newValue) {
        updateField('Is_Test_Mode__c', newValue);
        isTestMode = newValue;
    }

    @TestVisible public static void updateTimeoutCallout(Decimal newValue) {
        updateField('Callout_Timeout__c', newValue);
        timeoutCallout = newValue;
    }

    @TestVisible public static void updateMaxDebugLength(Decimal newValue) {
        updateField('Max_Debug_Length__c', newValue);
        maxDebugLength = newValue;
    }

    @TestVisible public static void updateDisableFlows(Boolean newValue) {
        updateField('Disable_Flows__c', newValue);
        disableFlows = newValue;
    }

    @TestVisible private static void updateField(String fieldName, Object newValue) {
        try {
            ConfigSystem__c config = [
                SELECT Id, Environment__c, Log_Level__c, Is_Log_Enabled__c, Is_Mock_Enabled__c,
                       Is_Test_Mode__c, Callout_Timeout__c, Max_Debug_Length__c, Disable_Flows__c
                  FROM ConfigSystem__c
                 ORDER BY CreatedDate DESC LIMIT 1
            ];
            if (config == null) {
                config = new ConfigSystem__c(SetupOwnerId = UserInfo.getOrganizationId());
            }
            config.put(fieldName, newValue);
            update config;
        } catch (Exception ex) {
            System.debug('⚠️ Failed to update ConfigSystem__c.' + fieldName + ': ' + ex.getMessage());
        }
    }
}
