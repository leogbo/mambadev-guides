/**
 * @since 2025-03-28
 * @author Leo Mamba Garcia
 *
 * LoggerQueueable
 *
 * Handles asynchronous persistence of logs into FlowExecutionLog__c
 * via Queueable Apex, used by Logger when async mode is enabled.
 */
public class LoggerQueueable implements Queueable, Database.AllowsCallouts {
    private final FlowExecutionLog__c log;

    public LoggerQueueable(FlowExecutionLog__c logEntry) {
        this.log = logEntry;
    }

    public void execute(QueueableContext context) {
        try {
            insert log;
        } catch (Exception e) {
            System.debug('LoggerQueueable failed: ' + e.getMessage());
        }
    }
}
