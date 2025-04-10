/**
 * @name        LoggerMock
 * @since       2025-04-10
 * @author      MambaDev
 * @description
 *  Mock implementation of ILogger used in unit tests.
 *  Captures logs in-memory without persisting anything to the database.
 *  Enables validation of logging behavior in isolation.
 */
public class LoggerMock implements ILogger {

    // -- Constants --

    @TestVisible public static String  environment     = (EnvironmentUtils.getRaw() != null) ? EnvironmentUtils.getRaw() : 'sandbox';
    @TestVisible public static String  logLevelDefault = (EnvironmentUtils.getLogLevel() != null) ? EnvironmentUtils.getLogLevel() : 'INFO';
    @TestVisible public static Integer maxDebugLength  = (EnvironmentUtils.getMaxDebugLength() != null ) ? (Integer)EnvironmentUtils.getMaxDebugLength() : 3000;

    // -- Fields --

    private List<String> capturedMessages = new List<String>();
    private Map<String, Object> context = new Map<String, Object>();

    // -- Fluent Configuration --

    public ILogger withMethod(String methodName)       { context.put('method', methodName); return this; }
    public ILogger withRecordId(String recordId)       { context.put('recordId', recordId); return this; }
    public ILogger withCategory(String category)       { context.put('category', category); return this; }
    public ILogger withTriggerType(String triggerType) { context.put('triggerType', triggerType); return this; }
    public ILogger withEnvironment(String environment) { context.put('environment', environment); return this; }
    public ILogger withClass(String className)         { context.put('class', className); return this; }
    public ILogger withAsync(Boolean value)            { context.put('async', value); return this; }

    // -- Logging Methods --

    public void success(String message, String serializedData) {
        capturedMessages.add('[SUCCESS] ' + safe(message) + ' | ' + safe(serializedData));
    }

    public void info(String message, String serializedData) {
        capturedMessages.add('[INFO] ' + safe(message) + ' | ' + safe(serializedData));
    }

    public void warn(String message, String serializedData) {
        capturedMessages.add('[WARN] ' + safe(message) + ' | ' + safe(serializedData));
    }

    public void error(String message, Exception ex, String serializedData) {
        String msg = safe(message) + (ex != null ? ' | ' + ex.getMessage() : '');
        capturedMessages.add('[ERROR] ' + msg + ' | ' + safe(serializedData));
    }

    public void logRaw(String message) {
        capturedMessages.add('[RAW] ' + safe(message));
    }

    // -- Test/Debug Helpers --

    public Map<String, Object> debugSnapshot() {
        return context.clone();
    }

    public List<String> getCaptured() {
        return capturedMessages.clone();
    }

    public void clear() {
        capturedMessages.clear();
        context.clear();
    }

    // -- Internal Utility --

    private String safe(String val) {
        return (val != null) ? val : '[null]';
    }
}
