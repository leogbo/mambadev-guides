/**
 * @name        Logger
 * @since       2025-04-01
 * @author      MambaDev
 * @description
 *  Structured logging utility for Apex execution.
 *  Enables traceability across classes, methods, categories, trigger types,
 *  payloads, and stack traces. Logs are persisted to FlowExecutionLog__c
 *  with full support for synchronous and asynchronous operation.
 *
 *  Recommended for tracking business logic, errors, and integration diagnostics.
 */
public class Logger {

    public enum LogLevel { INFO, WARN, ERROR, SUCCESS }

    @TestVisible public static String environment       = Label.ENVIRONMENT;
    @TestVisible public static String logLevelDefault   = 'INFO';
    @TestVisible public static Integer MAX_DEBUG_LENGTH = 3000;
    @TestVisible public static String className;
    @TestVisible public static String triggerType;
    @TestVisible public static String logCategory;
    @TestVisible public static Boolean isEnabled        = true;

    private String methodName;
    private String triggerRecordId;
    private String stackTrace;
    private String serializedData;
    private String instanceEnvironment;
    private String instanceClassName;
    private String instanceTriggerType;
    private String instanceLogCategory;
    private Boolean async = false;

    /**
     * @description
     *  Initializes logger with static context from class variables.
     */
    public Logger() {
        this.instanceClassName   = Logger.className;
        this.instanceTriggerType = Logger.triggerType;
        this.instanceLogCategory = Logger.logCategory;
        this.instanceEnvironment = Logger.environment;
    }

    @TestVisible public Logger setMethod(String methodName) {
        this.methodName = methodName;
        return this;
    }

    @TestVisible public Logger setRecordId(String recordId) {
        this.triggerRecordId = recordId;
        return this;
    }

    @TestVisible public Logger setCategory(String category) {
        this.instanceLogCategory = category;
        return this;
    }

    @TestVisible public Logger setTriggerType(String triggerType) {
        this.instanceTriggerType = triggerType;
        return this;
    }

    @TestVisible public Logger setEnvironment(String environment) {
        this.instanceEnvironment = environment;
        return this;
    }

    @TestVisible public Logger setClass(String className) {
        this.instanceClassName = className;
        return this;
    }

    @TestVisible public Logger setAsync(Boolean value) {
        this.async = value;
        return this;
    }

    /**
     * @description
     *  Logs a SUCCESS message with optional data.
     */
    @TestVisible public void success(String message, String data) {
        log(LogLevel.SUCCESS, message, null, data);
    }

    /**
     * @description
     *  Logs an INFO message with optional data.
     */
    @TestVisible public void info(String message, String data) {
        log(LogLevel.INFO, message, null, data);
    }

    /**
     * @description
     *  Logs a WARN message with optional data.
     */
    @TestVisible public void warn(String message, String data) {
        log(LogLevel.WARN, message, null, data);
    }

    /**
     * @description
     *  Logs an ERROR message with optional exception stack trace.
     */
    @TestVisible public void error(String message, Exception ex, String data) {
        String stack = (ex != null) ? ex.getStackTraceString() : null;
        log(LogLevel.ERROR, message, stack, data);
    }

    /**
     * @description
     *  Core logging implementation with persistence.
     *  Supports async or sync logging depending on `setAsync`.
     */
    @TestVisible private void log(LogLevel level, String message, String stack, String data) {
        if (!isEnabled && !Test.isRunningTest()) return;

        FlowExecutionLog__c logEntry = new FlowExecutionLog__c(
            Log_Level__c           = level.name(),
            Class__c               = safeLeft(instanceClassName, 255),
            Origin_Method__c       = safeLeft(methodName, 255),
            Trigger_Record_ID__c   = triggerRecordId,
            Error_Message__c       = safeLeft(message, 255),
            Debug_Information__c   = safeLeft(message, MAX_DEBUG_LENGTH),
            Stack_Trace__c         = safeLeft(stack, 30000),
            Serialized_Data__c     = safeLeft(data, 30000),
            Trigger_Type__c        = instanceTriggerType,
            Log_Category__c        = instanceLogCategory,
            Environment__c         = instanceEnvironment,
            Execution_Timestamp__c = System.now()
        );

        if (async) {
            System.enqueueJob(new LoggerQueueable(logEntry));
        } else {
            insert logEntry;
        }
    }

    /**
     * @description
     *  Truncates string to safe maximum length.
     */
    @TestVisible private String safeLeft(String value, Integer max) {
        return (value == null) ? null : value.left(max);
    }

    /**
     * @description
     *  Factory method for Logger based on a trigger record.
     */
    @TestVisible public static Logger fromTrigger(SObject record) {
        Logger logger = new Logger();
        if (record != null && record.Id != null) {
            logger.setRecordId(record.Id);
        }
        return logger;
    }
}
