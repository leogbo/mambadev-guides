/**
 * @name              Logger
 * @classification    utility
 * @layer             core
 * @category          logging
 * @description       Centraliza o registro de logs com níveis semânticos (INFO, WARN, ERROR, SUCCESS), stack trace e debug info.
 * @lastModified      2025-04-10
 * @author            MambaDev
 */
public class Logger {

    // -----------------------------
    // :: Static Constants ::
    // -----------------------------

    public enum LogLevel { INFO, WARN, ERROR, SUCCESS }

    @TestVisible public static String  environment     = (EnvironmentUtils.getRaw() != null) ? EnvironmentUtils.getRaw() : 'sandbox';
    @TestVisible public static String  logLevelDefault = (EnvironmentUtils.getLogLevel() != null) ? EnvironmentUtils.getLogLevel() : 'INFO';
    @TestVisible public static Integer maxDebugLength  = (EnvironmentUtils.getMaxDebugLength() != null) ? (Integer)EnvironmentUtils.getMaxDebugLength() : 3000;
    @TestVisible public static String  className;
    @TestVisible public static String  triggerType;
    @TestVisible public static String  logCategory;
    @TestVisible public static Boolean isEnabled = true;

    // -----------------------------
    // :: Instance Config Fields ::
    // -----------------------------

    private String  methodName;
    private String  triggerRecordId;
    private String  instanceEnvironment;
    private String  instanceClassName;
    private String  instanceTriggerType;
    private String  instanceLogCategory;
    private Boolean async = false;

    // -----------------------------
    // :: Constructor & Setters ::
    // -----------------------------

    public Logger() {
        this.instanceClassName   = String.isBlank(Logger.className)   ? 'Logger'      : Logger.className;
        this.instanceTriggerType = String.isBlank(Logger.triggerType) ? 'TestContext' : Logger.triggerType;
        this.instanceLogCategory = String.isBlank(Logger.logCategory) ? 'General'     : Logger.logCategory;
        this.instanceEnvironment = String.isBlank(Logger.environment) ? 'Sandbox'     : Logger.environment;
    }

    @TestVisible public Logger setMethod(String val)        { this.methodName = val; return this; }
    @TestVisible public Logger setRecordId(String val)      { this.triggerRecordId = val; return this; }
    @TestVisible public Logger setCategory(String val)      { this.instanceLogCategory = val; return this; }
    @TestVisible public Logger setTriggerType(String val)   { this.instanceTriggerType = val; return this; }
    @TestVisible public Logger setEnvironment(String val)   { this.instanceEnvironment = val; return this; }
    @TestVisible public Logger setClass(String val)         { this.instanceClassName = val; return this; }
    @TestVisible public Logger setAsync(Boolean val)        { this.async = val; return this; }

    // -----------------------------
    // :: Public Logging Shortcuts ::
    // -----------------------------

    public void info(String msg)                           { info(msg, null); }
    public void info(String msg, String data)              { logInternal(LogLevel.INFO, null, null, data); }

    public void warn(String msg)                           { warn(msg, null); }
    public void warn(String msg, String data)              { logInternal(LogLevel.WARN, null, null, data); }

    public void success(String msg)                        { success(msg, null); }
    public void success(String msg, String data)           { logInternal(LogLevel.SUCCESS, null, null, data); }

    public void error(String msg)                          { error(msg, null, null); }
    public void error(String msg, Exception ex)            { error(msg, ex, null); }
    public void error(String msg, Exception ex, String data) {
        String stack = (ex != null) ? ex.getStackTraceString() : null;
        logInternal(LogLevel.ERROR, msg, stack, data);
    }

    public void json(String title, Object payload) {
        String json = (payload != null) ? JSON.serializePretty(payload) : 'null';
    
        if (this.methodName == null) {
            this.setMethod('payload');
        }
    
        if (this.instanceLogCategory == null) {
            this.setCategory('JSON');
        }
    
        this.info(title, json);
    }
    

    // -----------------------------
    // :: Public HTTP Wrappers ::
    // -----------------------------

    public void logHttpInfo(String msg, HttpResponse res, String ctx) {
        logWithPayload(LogLevel.INFO, null, null, res, ctx, null);
    }

    public void logHttpInfo(String msg, HttpResponse res, String ctx, String reqBody) {
        logWithPayload(LogLevel.INFO, null, null, res, ctx, reqBody);
    }

    public void logHttpWarning(String msg, HttpResponse res, String ctx) {
        logWithPayload(LogLevel.WARN, null, null, res, ctx, null);
    }

    public void logHttpWarning(String msg, HttpResponse res, String ctx, String reqBody) {
        logWithPayload(LogLevel.WARN, null, null, res, ctx, reqBody);
    }

    public void logHttpError(String msg, Exception ex, HttpResponse res, String ctx) {
        logWithPayload(LogLevel.ERROR, msg, ex, res, ctx, null);
    }

    public void logHttpError(String msg, Exception ex, HttpResponse res, String ctx, String reqBody) {
        logWithPayload(LogLevel.ERROR, msg, ex, res, ctx, reqBody);
    }

    // -----------------------------
    // :: HTTP Smart Routing ::
    // -----------------------------

    public void route(HttpResponse response, Exception ex, String context, String requestPayload) {
        httpRoute(response, ex, context, requestPayload);
    }

    @TestVisible
    public void httpRoute(HttpResponse response, Exception ex, String context, String requestPayload) {
        Integer status = (response != null) ? response.getStatusCode() : 0;

        if (String.isNotBlank(requestPayload)) {
            this.json('Payload enviado', requestPayload);
        }

        if (response == null && ex != null) {
            this.logHttpError('Erro inesperado sem resposta HTTP.', ex, null, context, requestPayload);
        } else if (status >= 500 || ex != null) {
            this.logHttpError('Erro HTTP ' + status, ex, response, context, requestPayload);
        } else if (status >= 400) {
            this.logHttpError('Erro HTTP esperado ' + status, null, response, context, requestPayload);
        } else if (status >= 300) {
            this.logHttpWarning('Redirecionamento HTTP ' + status, response, context, requestPayload);
        } else {
            this.logHttpInfo('Callout finalizado com sucesso. Status ' + status, response, context, requestPayload);
        }
    }

    // -----------------------------
    // :: Internal Logging Engine ::
    // -----------------------------

    @TestVisible
    private void logWithPayload(LogLevel level, String err, Exception ex, HttpResponse res, String ctx, String reqBody) {
        if (String.isNotBlank(reqBody)) this.json('Payload enviado', reqBody);
        String stack = (ex != null && level == LogLevel.ERROR) ? ex.getStackTraceString() : null;
        String debug = buildHttpContext(res, ctx);
        logInternal(level, err, stack, debug);
    }

    @TestVisible
    private void logInternal(LogLevel level, String errorMessage, String stack, String debugOrPayload) {
        if (!isEnabled && !Test.isRunningTest()) return;

        FlowExecutionLog__c logEntry = new FlowExecutionLog__c(
            Log_Level__c           = level.name(),
            Class__c               = safeLeft(instanceClassName, 255),
            Origin_Method__c       = safeLeft(methodName, 255),
            Trigger_Record_ID__c   = triggerRecordId,
            Error_Message__c       = (level == LogLevel.ERROR) ? safeLeft(errorMessage, 255) : null,
            Debug_Information__c   = safeLeft(debugOrPayload, maxDebugLength),
            Stack_Trace__c         = (level == LogLevel.ERROR) ? safeLeft(stack, 30000) : null,
            Serialized_Data__c     = (level == LogLevel.INFO || level == LogLevel.SUCCESS) ? safeLeft(debugOrPayload, 30000) : null,
            Trigger_Type__c        = instanceTriggerType,
            Log_Category__c        = instanceLogCategory,
            Environment__c         = instanceEnvironment,
            Execution_Timestamp__c = System.now()
        );

        try {
            if (async) {
                System.enqueueJob(new LoggerQueueable(logEntry));
            } else {
                insert logEntry;
            }
        } catch (Exception e) {
            System.debug('[Logger FAIL] ' + e.getMessage());
        }        
    }

    @TestVisible
    private static String buildHttpContext(HttpResponse response, String context) {
        String debug = (context != null) ? context : '';
        if (response != null) {
            debug += ' | HTTP Status=' + response.getStatusCode();
            if (response.getBody() != null) {
                debug += ' | ResponseBody=' + response.getBody();
            }
        }
        return debug;
    }

    @TestVisible
    private static String safeLeft(String val, Integer max) {
        return (val == null) ? null : val.left(max);
    }

    // -----------------------------
    // :: Trigger Context Helper ::
    // -----------------------------

    public static Logger fromTrigger(SObject record) {
        Logger logger = new Logger();
        if (record != null && record.Id != null) {
            logger.setRecordId(record.Id);
        }
        return logger;
    }
}
