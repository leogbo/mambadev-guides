/**
 * @name        ILogger
 * @since       2025-04-01
 * @author      MambaDev
 * @description
 *  Logging interface used by structured logging implementations.
 *  Supports fluent-style configuration and consistent logging methods.
 *  Implemented by Logger and LoggerMock for both production and test environments.
 */
public interface ILogger {

    // ===== Fluent Configuration =====

    /**
     * Sets the origin method name.
     */
    ILogger withMethod(String methodName);

    /**
     * Sets the related record ID.
     */
    ILogger withRecordId(String recordId);

    /**
     * Sets the log category (e.g., Apex, Flow, Integration).
     */
    ILogger withCategory(String category);

    /**
     * Sets the trigger type (e.g., REST, Batch, Queueable).
     */
    ILogger withTriggerType(String triggerType);

    /**
     * Sets the execution environment (e.g., Production, Sandbox).
     */
    ILogger withEnvironment(String environment);

    /**
     * Sets the originating Apex class name.
     */
    ILogger withClass(String className);

    /**
     * Enables or disables asynchronous logging.
     */
    ILogger withAsync(Boolean value);

    // ===== Logging Methods =====

    /**
     * Logs a SUCCESS message.
     */
    void success(String message, String serializedData);

    /**
     * Logs an INFO message.
     */
    void info(String message, String serializedData);

    /**
     * Logs a WARN message.
     */
    void warn(String message, String serializedData);

    /**
     * Logs an ERROR message with optional exception stack trace.
     */
    void error(String message, Exception ex, String serializedData);

    // ===== Optional Utilities =====

    /**
     * Writes a raw message to debug logs only (no persistence).
     */
    void logRaw(String message);

    /**
     * Returns the internal snapshot of current logger state.
     */
    Map<String, Object> debugSnapshot();
}
