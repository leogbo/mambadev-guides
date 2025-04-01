/**
 * -----------------------------------------------------------------------------------------
 * Class Name..........: Logger
 * Date................: 2025-04-01
 * Author..............: MambaDev
 * 
 * Description:
 *     Utility class responsible for capturing execution logs, error traces, and audit data 
 *     with full traceability. It offers runtime control over whether logs should be stored 
 *     in production or testing environments. It also provides static helper methods 
 *     for simplified logging without requiring class instantiation.
 * 
 * Notes:
 *     - Supports log levels: INFO, WARN, ERROR, and SUCCESS.
 *     - Can log records synchronously (INSERT) or asynchronously (QUEUEABLE).
 *     - Logs are stored in FlowExecutionLog__c (can be changed if needed).
 *     - Provides both static and instance-based methods for flexible usage.
 * 
 * -----------------------------------------------------------------------------------------
 */
public class Logger {

    public enum LogLevel { INFO, WARN, ERROR, SUCCESS }

    @TestVisible public static String  environment     = EnvironmentUtils.getRaw() != null ? EnvironmentUtils.getRaw() : 'sandbox';
    @TestVisible public static String  defaultLogLevel = EnvironmentUtils.getLogLevel() != null ? EnvironmentUtils.getLogLevel() : 'INFO';
    @TestVisible public static Integer maxDebugLength  = EnvironmentUtils.getMaxDebugLength() != null ? (Integer)EnvironmentUtils.getMaxDebugLength() : 3000;
    @TestVisible public static String  globalClassName;
    @TestVisible public static String  globalTriggerType;
    @TestVisible public static String  globalLogCategory;
    @TestVisible public static Boolean isEnabled = true;

    private String methodName;
    private String recordId;
    private String stackTrace;
    private String serializedData;
    private String contextEnvironment;
    private String contextClassName;
    private String contextTriggerType;
    private String contextLogCategory;
    private Boolean isAsync = false;

    public Logger() {
        this.contextClassName   = String.isBlank(globalClassName)     ? 'Logger'      : globalClassName;
        this.contextTriggerType = String.isBlank(globalTriggerType)   ? 'TestContext' : globalTriggerType;
        this.contextLogCategory = String.isBlank(globalLogCategory)   ? 'General'     : globalLogCategory;
        this.contextEnvironment = String.isBlank(environment)         ? 'Sandbox'     : environment;
    }

    public Logger setMethod(String methodName) {
        this.methodName = methodName;
        return this;
    }

    public Logger setRecordId(String recordId) {
        this.recordId = recordId;
        return this;
    }

    public Logger setCategory(String category) {
        this.contextLogCategory = category;
        return this;
    }

    public Logger setTriggerType(String triggerType) {
        this.contextTriggerType = triggerType;
        return this;
    }

    public Logger setEnvironment(String environment) {
        this.contextEnvironment = environment;
        return this;
    }

    public Logger setClass(String className) {
        this.contextClassName = className;
        return this;
    }

    public Logger setAsync(Boolean async) {
        this.isAsync = async;
        return this;
    }

    public void info(String message) {
        info(message, null);
    }

    public void info(String message, String data) {
        logInternal(LogLevel.INFO, message, null, data);
    }

    public void warn(String message) {
        warn(message, null);
    }

    public void warn(String message, String data) {
        logInternal(LogLevel.WARN, message, null, data);
    }

    public void error(String message) {
        error(message, null, null);
    }

    public void error(String message, Exception ex) {
        error(message, ex, null);
    }

    public void error(String message, Exception ex, String data) {
        String stack = (ex != null) ? ex.getStackTraceString() : null;
        logInternal(LogLevel.ERROR, message, stack, data);
    }

    public void success(String message) {
        success(message, null);
    }

    public void success(String message, String data) {
        logInternal(LogLevel.SUCCESS, message, null, data);
    }

    @TestVisible
    private void logInternal(LogLevel level, String message, String stack, String data) {
        if (!isEnabled && !Test.isRunningTest()) return;

        FlowExecutionLog__c logEntry = new FlowExecutionLog__c(
            Log_Level__c           = level.name(),
            Class__c               = safeLeft(contextClassName, 255),
            Origin_Method__c       = safeLeft(methodName, 255),
            Trigger_Record_ID__c   = recordId,
            Error_Message__c       = safeLeft(message, 255),
            Debug_Information__c   = safeLeft(data, maxDebugLength),
            Stack_Trace__c         = safeLeft(stack, 30000),
            Serialized_Data__c     = safeLeft(data, 30000),
            Trigger_Type__c        = contextTriggerType,
            Log_Category__c        = contextLogCategory,
            Environment__c         = contextEnvironment,
            Execution_Timestamp__c = System.now()
        );

        if (isAsync) {
            System.enqueueJob(new LoggerQueueable(logEntry));
        } else {
            insert logEntry;
        }
    }

    @TestVisible
    private static String safeLeft(String value, Integer max) {
        return value == null ? null : value.left(max);
    }

    public static Logger fromTrigger(SObject record) {
        Logger logger = new Logger();
        if (record != null && record.Id != null) {
            logger.setRecordId(record.Id);
        }
        return logger;
    }
}
