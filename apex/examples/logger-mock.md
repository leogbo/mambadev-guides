/**
 * @since 2025-03-28
 * @author Leo Mamba Garcia
 *
 * LoggerMock
 *
 * Mock implementation of ILogger for use in unit tests.
 * Prevents actual log persistence and captures outputs locally.
 */
public class LoggerMock implements ILogger {
    public List<String> capturedMessages = new List<String>();
    private Map<String, Object> context = new Map<String, Object>();

    @TestVisible public ILogger withMethod(String methodName) {
        context.put('method', methodName);
        return this;
    }

    @TestVisible public ILogger withRecordId(String recordId) {
        context.put('recordId', recordId);
        return this;
    }

    @TestVisible public ILogger withCategory(String category) {
        context.put('category', category);
        return this;
    }

    @TestVisible public ILogger withTriggerType(String triggerType) {
        context.put('triggerType', triggerType);
        return this;
    }

    @TestVisible public ILogger withEnvironment(String environment) {
        context.put('environment', environment);
        return this;
    }

    @TestVisible public ILogger withClass(String className) {
        context.put('class', className);
        return this;
    }

    @TestVisible public ILogger withAsync(Boolean value) {
        context.put('async', value);
        return this;
    }

    @TestVisible public void success(String message, String serializedData) {
        capturedMessages.add('[SUCCESS] ' + message + ' | ' + serializedData);
    }

    @TestVisible public void info(String message, String serializedData) {
        capturedMessages.add('[INFO] ' + message + ' | ' + serializedData);
    }

    @TestVisible public void warn(String message, String serializedData) {
        capturedMessages.add('[WARN] ' + message + ' | ' + serializedData);
    }

    @TestVisible public void error(String message, Exception ex, String serializedData) {
        String msg = message + (ex != null ? ' | ' + ex.getMessage() : '');
        capturedMessages.add('[ERROR] ' + msg + ' | ' + serializedData);
    }

    @TestVisible public void logRaw(String message) {
        capturedMessages.add('[RAW] ' + message);
    }

    @TestVisible public Map<String, Object> debugSnapshot() {
        return context.clone();
    }

    @TestVisible public List<String> getCaptured() {
        return capturedMessages;
    }
}
