/**
 * -----------------------------------------------------------------------------------------
 * Nome da Classe.......: Logger
 * Data.................: 2025-04-01
 * Autor................: MambaDev
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

    // -------------------------------------------------------------------------------------
    // Enum para níveis de Log
    // -------------------------------------------------------------------------------------
    public enum LogLevel { INFO, WARN, ERROR, SUCCESS }

    // -------------------------------------------------------------------------------------
    // Propriedades estáticas (globais) para configuração
    // -------------------------------------------------------------------------------------
    @TestVisible public static String  environment       = Label.ENVIRONMENT;
    @TestVisible public static String  logLevelDefault   = 'INFO';
    @TestVisible public static Integer MAX_DEBUG_LENGTH  = 3000;
    @TestVisible public static String  className;
    @TestVisible public static String  triggerType;
    @TestVisible public static String  logCategory;
    @TestVisible public static Boolean isEnabled         = true;

    // -------------------------------------------------------------------------------------
    // Propriedades de instância para permitir configurações específicas (Fluent API)
    // -------------------------------------------------------------------------------------
    private String  methodName;
    private String  triggerRecordId;
    private String  stackTrace;
    private String  serializedData;
    private String  instanceEnvironment;
    private String  instanceClassName;
    private String  instanceTriggerType;
    private String  instanceLogCategory;
    private Boolean async = false;

    /**
     * Construtor padrão, inicializa a instância com valores das propriedades estáticas.
     */
    public Logger() {
        this.instanceClassName   = Logger.className;
        this.instanceTriggerType = Logger.triggerType;
        this.instanceLogCategory = Logger.logCategory;
        this.instanceEnvironment = Logger.environment;
    }

    // ----------------------------
    //   FLUENT SETTERS
    // ----------------------------
    @TestVisible
    public Logger setMethod(String methodName) {
        this.methodName = methodName;
        return this;
    }

    @TestVisible
    public Logger setRecordId(String recordId) {
        this.triggerRecordId = recordId;
        return this;
    }

    @TestVisible
    public Logger setCategory(String category) {
        this.instanceLogCategory = category;
        return this;
    }

    @TestVisible
    public Logger setTriggerType(String triggerType) {
        this.instanceTriggerType = triggerType;
        return this;
    }

    @TestVisible
    public Logger setEnvironment(String environment) {
        this.instanceEnvironment = environment;
        return this;
    }

    @TestVisible
    public Logger setClass(String className) {
        this.instanceClassName = className;
        return this;
    }

    @TestVisible
    public Logger setAsync(Boolean value) {
        this.async = value;
        return this;
    }

    // ------------------------------------------------------------------------
    //   INSTANCE METHODS (renamed to avoid conflicts with static methods)
    // ------------------------------------------------------------------------
    @TestVisible
    public void logSuccess(String message, String data) {
        logInternal(LogLevel.SUCCESS, message, null, data);
    }

    @TestVisible
    public void logInfo(String message, String data) {
        logInternal(LogLevel.INFO, message, null, data);
    }

    @TestVisible
    public void logWarn(String message, String data) {
        logInternal(LogLevel.WARN, message, null, data);
    }

    @TestVisible
    public void logError(String message, Exception ex, String data) {
        String stack = (ex != null) ? ex.getStackTraceString() : null;
        logInternal(LogLevel.ERROR, message, stack, data);
    }

    // ------------------------------------------------------------------------
    //         MÉTODO PRINCIPAL DE LOG (INSTANCIAL)
    // ------------------------------------------------------------------------
    @TestVisible
    private void logInternal(LogLevel level, String message, String stack, String data) {
        // Se logs desabilitados e não está em teste, sai
        if (!isEnabled && !Test.isRunningTest()) {
            return;
        }

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
     * Auxiliar para truncar strings longas.
     */
    @TestVisible
    private String safeLeft(String value, Integer max) {
        return (value == null) ? null : value.left(max);
    }

    // -------------------------------------------------------------------------------------
    // STATIC HELPER METHODS (for quick usage)
    //
    //   You can call:
    //       Logger.logInfo('message');
    //       Logger.logWarn('warning');
    //       Logger.logError('error', exceptionObj, 'some data');
    //       Logger.logSuccess('it worked!');
    //
    //   No need to create a new Logger() if you just want quick logs.
    // -------------------------------------------------------------------------------------

    // --- INFO
    public static void info(String message) {
        info(message, null);
    }
    public static void info(String message, String data) {
        Logger logger = new Logger();
        logger.logInfo(message, data);
    }

    // --- WARN
    public static void warn(String message) {
        warn(message, null);
    }
    public static void warn(String message, String data) {
        Logger logger = new Logger();
        logger.logWarn(message, data);
    }

    // --- ERROR
    public static void error(String message) {
        error(message, null, null);
    }
    public static void error(String message, Exception ex) {
        error(message, ex, null);
    }
    public static void error(String message, Exception ex, String data) {
        Logger logger = new Logger();
        logger.logError(message, ex, data);
    }

    // --- SUCCESS
    public static void success(String message) {
        success(message, null);
    }
    public static void success(String message, String data) {
        Logger logger = new Logger();
        logger.logSuccess(message, data);
    }

    // -------------------------------------------------------------------------------------
    //       Método utilitário para criar Logger com recordId a partir de SObject
    // -------------------------------------------------------------------------------------
    @TestVisible
    public static Logger fromTrigger(SObject record) {
        Logger logger = new Logger();
        if (record != null && record.Id != null) {
            logger.setRecordId(record.Id);
        }
        return logger;
    }
}
