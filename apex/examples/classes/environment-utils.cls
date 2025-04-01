/**
 * -----------------------------------------------------------------------------------------
 * Nome da Classe.......: Logger
 * Data.................: 2025-04-01
 * Autor................: Leo Mamba Garcia
 * 
 * Descrição:
 *     Classe responsável por registrar logs de execução, erros e dados de auditoria
 *     com rastreabilidade completa. A classe também oferece controle sobre o armazenamento
 *     de logs em produção ou testes. Além disso, fornece métodos estáticos (helper) para 
 *     facilitar o registro de logs sem precisar instanciar a classe.
 * 
 * Observações:
 *     - Permite criar logs com níveis INFO, WARN, ERROR e SUCCESS.
 *     - Suporta gravação síncrona (INSERT) ou assíncrona (QUEUEABLE).
 *     - Os dados são armazenados em FlowExecutionLog__c, mas você pode trocar para outro objeto.
 *     - Possui métodos estáticos para log simplificado e métodos de instância para 
 *       configurações avançadas.
 * -----------------------------------------------------------------------------------------
 */
public class Logger {

    public enum LogLevel { INFO, WARN, ERROR, SUCCESS }

    @TestVisible public static String  environment       = (EnvironmentUtils.getRaw() != null) ? EnvironmentUtils.getRaw() : 'sandbox';
    @TestVisible public static String  logLevelDefault   = (EnvironmentUtils.getLogLevel() != null) ? EnvironmentUtils.getLogLevel() : 'INFO';
    @TestVisible public static Integer maxDebugLength  = (EnvironmentUtils.getMaxDebugLength() != null ) ? (Integer)EnvironmentUtils.getMaxDebugLength() : 3000;
    @TestVisible public static String  className;
    @TestVisible public static String  triggerType;
    @TestVisible public static String  logCategory;
    @TestVisible public static Boolean isEnabled = true;

    private String  methodName;
    private String  triggerRecordId;
    private String  stackTrace;
    private String  serializedData;
    private String  instanceEnvironment;
    private String  instanceClassName;
    private String  instanceTriggerType;
    private String  instanceLogCategory;
    private Boolean async = false;

    public Logger() {
        this.instanceClassName   = String.isBlank(Logger.className)   ? 'Logger'     : Logger.className;
        this.instanceTriggerType = String.isBlank(Logger.triggerType) ? 'TestContext': Logger.triggerType;
        this.instanceLogCategory = String.isBlank(Logger.logCategory) ? 'General'    : Logger.logCategory;
        this.instanceEnvironment = String.isBlank(Logger.environment) ? 'Sandbox'    : Logger.environment;
    }

    public Logger setMethod(String methodName) {
        this.methodName = methodName;
        return this;
    }

    public Logger setRecordId(String recordId) {
        this.triggerRecordId = recordId;
        return this;
    }

    public Logger setCategory(String category) {
        this.instanceLogCategory = category;
        return this;
    }

    public Logger setTriggerType(String triggerType) {
        this.instanceTriggerType = triggerType;
        return this;
    }

    public Logger setEnvironment(String environment) {
        this.instanceEnvironment = environment;
        return this;
    }

    public Logger setClass(String className) {
        this.instanceClassName = className;
        return this;
    }

    public Logger setAsync(Boolean value) {
        this.async = value;
        return this;
    }

    @TestVisible 
    private void logInternal(LogLevel level, String message, String stack, String data) {
        if (!isEnabled && !Test.isRunningTest()) return;

        FlowExecutionLog__c logEntry = new FlowExecutionLog__c(
            Log_Level__c           = level.name(),
            Class__c               = safeLeft(instanceClassName, 255),
            Origin_Method__c       = safeLeft(methodName, 255),
            Trigger_Record_ID__c   = triggerRecordId,
            Error_Message__c       = safeLeft(message, 255),
            Debug_Information__c   = safeLeft(data, maxDebugLength),
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

    @TestVisible 
    private static String safeLeft(String value, Integer max) {
        return (value == null) ? null : value.left(max);
    }

    public void info(String message) {
        info(message, null);
    }

    public void info(String message, String data) {
        this.logInternal(LogLevel.INFO, message, null, data);
    }

    public void warn(String message) {
        warn(message, null);
    }

    public void warn(String message, String data) {
        this.logInternal(LogLevel.WARN, message, null, data);
    }

    public void error(String message) {
        error(message, null, null);
    }

    public void error(String message, Exception ex) {
        error(message, ex, null);
    }

    public void error(String message, Exception ex, String data) {
        String stack = (ex != null) ? ex.getStackTraceString() : null;
        this.logInternal(LogLevel.ERROR, message, stack, data);
    }

    public void success(String message) {
        success(message, null);
    }

    public void success(String message, String data) {
        this.logInternal(LogLevel.SUCCESS, message, null, data);
    }

    public static Logger fromTrigger(SObject record) {
        Logger logger = new Logger();
        if (record != null && record.Id != null) {
            logger.setRecordId(record.Id);
        }
        return logger;
    }
}
