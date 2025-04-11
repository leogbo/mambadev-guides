/**
 * @name              Logger
 * @classification    utility
 * @layer             core
 * @category          logging
 * @description       Centraliza o registro de logs com níveis semânticos (INFO, WARN, ERROR, SUCCESS), stack trace e debug info.
 *
 * ⚠️ Atenção:
 * Apex não permite chamadas `Logger.insert()` ou execução de logs diretamente dentro de loops como `for (...) { logger.info(...) }`.
 * Para evitar esse comportamento, crie o `Logger` **fora do loop** e capture logs de forma segura.
 * O mesmo vale para uso em triggers ou operações em lote — o log precisa ser instanciado fora do fluxo iterativo.
 *
 * Campos utilizados na FlowExecutionLog__c:
 *    - Log_Level__c, Class__c, Origin_Method__c, Trigger_Record_ID__c
 *    - Error_Message__c, Stack_Trace__c, Debug_Information__c
 *    - Serialized_Data__c, MethodHttp__c, StatusCode__c
 *    - RequestBody__c, ResponseBody__c, Endpoint__c
 *    - Trigger_Type__c, Log_Category__c, Environment__c, Execution_Timestamp__c
 *
 * @lastModified      2025-04-11
 * @author            MambaDev
 */
public class Logger {

    public enum LogLevel { INFO, WARN, ERROR, SUCCESS }

    @TestVisible public static String  environment     = (EnvironmentUtils.getRaw() != null) ? EnvironmentUtils.getRaw() : 'sandbox';
    @TestVisible public static String  logLevelDefault = (EnvironmentUtils.getLogLevel() != null) ? EnvironmentUtils.getLogLevel() : 'INFO';
    @TestVisible public static Integer maxDebugLength  = (EnvironmentUtils.getMaxDebugLength() != null) ? (Integer)EnvironmentUtils.getMaxDebugLength() : 3000;
    @TestVisible public static String  className;
    @TestVisible public static String  triggerType;
    @TestVisible public static String  logCategory;
    @TestVisible public static Boolean isEnabled = true;

    private String methodName;
    private String triggerRecordId;
    private String instanceEnvironment;
    private String instanceClassName;
    private String instanceTriggerType;
    private String instanceLogCategory;
    private Boolean async = false;

    // -------------------------------
    // :: Fluent Config
    // -------------------------------

    public Logger() {
        this.instanceClassName   = String.isBlank(className)   ? 'Logger'      : className;
        this.instanceTriggerType = String.isBlank(triggerType) ? 'TestContext' : triggerType;
        this.instanceLogCategory = String.isBlank(logCategory) ? 'General'     : logCategory;
        this.instanceEnvironment = String.isBlank(environment) ? 'Sandbox'     : environment;
    }

    public Logger setMethod(String val)        { this.methodName = val; return this; }
    public Logger setRecordId(String val)      { this.triggerRecordId = val; return this; }
    public Logger setCategory(String val)      { this.instanceLogCategory = val; return this; }
    public Logger setTriggerType(String val)   { this.instanceTriggerType = val; return this; }
    public Logger setEnvironment(String val)   { this.instanceEnvironment = val; return this; }
    public Logger setClass(String val)         { this.instanceClassName = val; return this; }
    public Logger setAsync(Boolean val)        { this.async = val; return this; }

    // -------------------------------
    // :: Public Shortcuts
    // -------------------------------

    public void info(String msg)                        { info(msg, null); }
    public void info(String msg, String data)           { logInternal(LogLevel.INFO, null, null, msg, null, null, null, null, data); }

    public void warn(String msg)                        { warn(msg, null); }
    public void warn(String msg, String data)           { logInternal(LogLevel.WARN, null, null, msg, null, null, null, null, data); }

    public void success(String msg)                     { success(msg, null); }
    public void success(String msg, String data)        { logInternal(LogLevel.SUCCESS, null, null, msg, null, null, null, null, data); }

    public void error(String msg, Exception ex)         { error(msg, ex, null); }
    public void error(String msg, Exception ex, String data) {
        String stack = (ex != null) ? ex.getStackTraceString() : null;
        logInternal(LogLevel.ERROR, msg, stack, data, null, null, null, null, null);
    }

    public void json(String title, Object payload) {
        String json = (payload != null) ? safeLeft(JSON.serializePretty(payload), 30000) : 'null';
        if (this.methodName == null) this.setMethod('payload');
        if (this.instanceLogCategory == null) this.setCategory('JSON');
        this.info(title, json);
    }

    // -------------------------------
    // :: HTTP Primitive Entry Points
    // -------------------------------

    public void logHttpInfo(String msg, String methodHttp, String endpoint, String reqBody, Integer status, String resBody) {
        try {
            logHttpInternal(
                LogLevel.INFO,
                null,                    // errorMessage
                null,                    // stackTrace
                msg,                     // debugInfo
                methodHttp,
                endpoint,
                reqBody,
                status,
                cleanBody(resBody)
            );
        } catch (Exception failEx) {
            // fallback: log parcial sem corpo
            logHttpInternal(
                LogLevel.INFO,
                null,
                null,
                '[LOGGER INFO FAILSAFE] ' + safeLeft(endpoint, 150),
                methodHttp,
                endpoint,
                safeLeft(reqBody, 500),
                null,
                null
            );
        }
    }
    

    public void logHttpWarning(String msg, String methodHttp, String endpoint, String reqBody, Integer status, String resBody) {
        try {
            logHttpInternal(
                LogLevel.WARN,
                null, null,
                msg,
                methodHttp,
                endpoint,
                reqBody,
                status,
                cleanBody(resBody)
            );
        } catch (Exception failEx) {
            logHttpInternal(
                LogLevel.WARN,
                null,
                null,
                '[LOGGER WARN FAILSAFE] ' + safeLeft(endpoint, 150),
                methodHttp,
                endpoint,
                safeLeft(reqBody, 500),
                null,
                null
            );
        }
    }
    

    public void logHttpError(String msg, Exception ex, String methodHttp, String endpoint, String reqBody, Integer status, String resBody) {
        try {
            String stack = (ex != null) ? ex.getStackTraceString() : null;
            logHttpInternal(
                LogLevel.ERROR,
                safeLeft(msg, 255),
                stack,
                msg,         // debug info
                methodHttp,
                endpoint,
                reqBody,
                status,
                cleanBody(resBody)
            );
        } catch (Exception failEx) {
            // Falha ao tentar logar com corpo completo — reduza
            logHttpInternal(
                LogLevel.ERROR,
                '[LOGGER ERROR FAILSAFE] ' + safeLeft(msg, 150),
                null,
                'fallback=' + endpoint,
                methodHttp,
                endpoint,
                safeLeft(reqBody, 500),
                null,
                null
            );
        }
    }
    

    // -------------------------------
    // :: Logger Core Engines
    // -------------------------------

    @TestVisible
    private void logInternal(
        LogLevel level,
        String errorMessage,
        String stackTrace,
        String debugInfo,
        String httpMethod,
        Integer statusCode,
        String requestBody,
        String responseBody,
        String serializedData
    ) {
        logAnyInternal(
            level, errorMessage, stackTrace, debugInfo,
            httpMethod, statusCode, requestBody, responseBody,
            serializedData, null
        );
    }

    @TestVisible
    private void logHttpInternal(
        LogLevel level,
        String errorMessage,
        String stackTrace,
        String debugInfo,
        String httpMethod,
        String endpoint,
        String requestBody,
        Integer statusCode,
        String responseBody
    ) {
        logAnyInternal(
            level,
            (level == LogLevel.ERROR) ? safeLeft(errorMessage, 255) : null,
            (level == LogLevel.ERROR) ? stackTrace : null,
            debugInfo,
            httpMethod,
            statusCode,
            requestBody,
            responseBody,
            null,
            endpoint
        );
    }

    @TestVisible
    private void logAnyInternal(
        LogLevel level,
        String errorMessage,
        String stackTrace,
        String debugInfo,
        String httpMethod,
        Integer statusCode,
        String requestBody,
        String responseBody,
        String serializedData,
        String endpoint
    ) {
        if (!isEnabled && !Test.isRunningTest()) return;

        FlowExecutionLog__c logEntry = new FlowExecutionLog__c(
            Log_Level__c           = level.name(),
            Class__c               = safeLeft(instanceClassName, 255),
            Origin_Method__c       = safeLeft(methodName, 255),
            Trigger_Record_ID__c   = triggerRecordId,
            Error_Message__c       = (level == LogLevel.ERROR) ? safeLeft(errorMessage, 255) : null,
            Stack_Trace__c         = (level == LogLevel.ERROR) ? safeLeft(stackTrace, 30000) : null,
            Debug_Information__c   = safeLeft(debugInfo, maxDebugLength),
            Serialized_Data__c     = safeLeft(serializedData, 30000),
            MethodHttp__c          = httpMethod,
            StatusCode__c          = statusCode,
            RequestBody__c         = safeLeft(requestBody, maxDebugLength),
            ResponseBody__c        = safeLeft(responseBody, maxDebugLength),
            Endpoint__c            = safeLeft(endpoint, 255),
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
            System.debug('[LOGGER FAIL] ' + e.getMessage());
        }
    }

    // -------------------------------
    // :: Utilities
    // -------------------------------

    @TestVisible
    private static String safeLeft(String val, Integer max) {
        return (val == null) ? null : val.left(max);
    }

    @TestVisible
    private static String cleanBody(String raw) {
        if (String.isBlank(raw)) return null;
        String safe = raw.replaceAll('[^\\x20-\\x7E\\n\\r\\t]', '');
        return (safe.length() > 2500) ? safe.left(2500) + '...' : safe;
    }    

    public static Logger fromTrigger(SObject record) {
        Logger log = new Logger();
        if (record != null && record.Id != null) {
            log.setRecordId(record.Id);
        }
        return log;
    }
}
