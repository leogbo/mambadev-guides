/**
 * @name        ILogger
 * @since       2025-04-01
 * @author      MambaDev
 * @description
 *  Logging interface for structured loggers.
 *  Supports fluent configuration, standard log levels,
 *  and debug utilities for consistent implementation.
 */
public interface ILogger {

    // Fluent configuration
    ILogger withMethod(String methodName);
    ILogger withRecordId(String recordId);
    ILogger withCategory(String category);
    ILogger withTriggerType(String triggerType);
    ILogger withEnvironment(String environment);
    ILogger withClass(String className);
    ILogger withAsync(Boolean value);

    // Logging operations
    void success(String message, String data);
    void info(String message, String data);
    void warn(String message, String data);
    void error(String message, Exception ex, String data);

    // Optional utilities
    void logRaw(String message);
    Map<String, Object> debugSnapshot();
}
