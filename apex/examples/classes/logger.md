/**
 * @since 2025-03-28
 * @author Leo Mamba Garcia
 *
 * Apex Logger
 *
 * Responsible for structured logging across Apex logic.
 * Allows capturing class, method, category, trigger type,
 * data payloads, and stack traces with full traceability.
 * Supports both sync and async persistence via FlowExecutionLog__c.
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

    public Logger() {
        this.instanceClassName   = Logger.className;
        this.instanceTriggerType = Logger.triggerType;
        this.instanceLogCategory = Logger.logCategory;
        this.instanceEnvironment = Logger.environment;
    }

    @TestVisible public Logger setMethod(String methodName) { this.methodName = methodName; return this; }
    @TestVisible public Logger setRecordId(String recordId) { this.triggerRecordId = recordId; return this; }
    @TestVisible public Logger setCategory(String category) { this.instanceLogCategory = category; return this; }
    @TestVisible public Logger setTriggerType(String triggerType) { this.instanceTriggerType = triggerType; return this; }
    @TestVisible public Logger setEnvironment(String environment) { this.instanceEnvironment = environment; return this; }
    @TestVisible public Logger setClass(String className) { this.instanceClassName = className; return this; }
    @TestVisible public Logger setAsync(Boolean value) { this.async = value; return this; }

    @TestVisible public void success(String message, String data) {
        log(LogLevel.SUCCESS, message, null, data);
    }

    @TestVisible public void info(String message, String data) {
        log(LogLevel.INFO, message, null, data);
    }

    @TestVisible public void warn(String message, String data) {
        log(LogLevel.WARN, message, null, data);
    }

    @TestVisible public void error(String message, Exception ex, String data) {
        String stack = (ex != null) ? ex.getStackTraceString() : null;
        log(LogLevel.ERROR, message, stack, data);
    }

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

    @TestVisible private String safeLeft(String value, Integer max) {
        return (value == null) ? null : value.left(max);
    }

    @TestVisible public static Logger fromTrigger(SObject record) {
        Logger logger = new Logger();
        if (record != null && record.Id != null) {
            logger.setRecordId(record.Id);
        }
        return logger;
    }
}
