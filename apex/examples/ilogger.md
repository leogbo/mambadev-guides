/**
 * @since 2025-03-28
 * @author Leo Mamba Garcia
 *
 * ILogger Interface
 *
 * Interface for loggers (Logger, LoggerMock).
 * Supports fluent configuration and structured logging methods.
 */
public interface ILogger {

    // ===== Fluent Configuration =====
    ILogger withMethod(String methodName);
    ILogger withRecordId(String recordId);
    ILogger withCategory(String category);
    ILogger withTriggerType(String triggerType);
    ILogger withEnvironment(String environment);
    ILogger withClass(String className);
    ILogger withAsync(Boolean value);

    // ===== Logging Methods =====
    void success(String message, String serializedData);
    void info(String message, String serializedData);
    void warn(String message, String serializedData);
    void error(String message, Exception ex, String serializedData);

    // ===== Optional Utilities =====
    void logRaw(String message);
    Map<String, Object> debugSnapshot();
}
