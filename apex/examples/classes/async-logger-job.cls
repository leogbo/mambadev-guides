/**
 * @name        LoggerQueueable
 * @since       2025-04-01
 * @author      MambaDev
 * @description
 *  Handles asynchronous persistence of log entries into FlowExecutionLog__c.
 *  Triggered by Logger when async logging is enabled.
 * 
 *  Implements Queueable and AllowsCallouts to support eventual integration use cases.
 */
public class LoggerQueueable implements Queueable, Database.AllowsCallouts {

    private final FlowExecutionLog__c log;

    /**
     * @description
     *  Constructor that receives a FlowExecutionLog__c instance.
     *
     * @param logEntry  The log record to persist asynchronously.
     */
    public LoggerQueueable(FlowExecutionLog__c logEntry) {
        this.log = logEntry;
    }

    /**
     * @description
     *  Executes the log insertion asynchronously.
     *  Failures are silently handled and logged to debug output.
     */
    public void execute(QueueableContext context) {
        try {
            insert log;
        } catch (Exception e) {
            System.debug('LoggerQueueable failed: ' + e.getMessage());
        }
    }
}
