public class LoggerQueueable implements Queueable, Database.AllowsCallouts {

    @TestVisible public static String  environment       = (EnvironmentUtils.getRaw() != null) ? EnvironmentUtils.getRaw() : 'sandbox';
    @TestVisible public static String  logLevelDefault   = (EnvironmentUtils.getLogLevel() != null) ? EnvironmentUtils.getLogLevel() : 'INFO';
    @TestVisible public static Integer maxDebugLength    = (EnvironmentUtils.getMaxDebugLength() != null ) ? (Integer)EnvironmentUtils.getMaxDebugLength() : 3000;
    
    private final List<FlowExecutionLog__c> logs;

    public LoggerQueueable(FlowExecutionLog__c log) {
        this(new List<FlowExecutionLog__c>{ log });
    }

    public LoggerQueueable(List<FlowExecutionLog__c> logs) {
        this.logs = (logs == null) ? new List<FlowExecutionLog__c>() : logs;
    }

    public void execute(QueueableContext context) {
        if (logs.isEmpty()) {
            System.debug('⚠️ Nenhum log recebido.');
            return;
        }

        // DEBUG COMPLETO PARA DIAGNÓSTICO
        for (FlowExecutionLog__c log : logs) {
            System.debug('🧪 LoggerQueueable > Log: ' + JSON.serializePretty(log));
        }

        // REMOVA O CATCH TEMPORARIAMENTE PARA PERMITIR QUE O TESTE FAÇA FAIL E MOSTRE A CAUSA
        insert logs;
    }
}