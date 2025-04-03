/**
 * @name        RestServiceHelper
 * @since       2025-04-01
 * @type        abstract
 * @access      public
 * @author      MambaDev
 * @description
 *  REST-layer helper for implementing robust Apex APIs.
 * 
 *  ✅ Standardized response contract: JSON with HTTP code
 *  ✅ Semantic exceptions: 400, 401, 404, 406, 500
 *  ✅ Safe access token validation (Bearer/Token pattern)
 *  ✅ Request body parsing with null/format guards
 *  ✅ Optional field mapping from JSON to SObject
 *  ✅ Logs via `Logger` with `.setClass()`, `.setMethod()`, `.setCategory()`
 * 
 *  All REST controllers must call these methods instead of raw response handling.
 */
public abstract class RestServiceHelper {

    // ============= ENVIRONMENT & LOGGING SUPPORT =============
    @TestVisible private static final String environment = Label.ENVIRONMENT;
    @TestVisible private static final String log_level = Label.LOG_LEVEL;
    private static final String className = 'RestServiceHelper';
    private static final String logCategory = 'REST';

    // ============= TEST SUPPORT =============
    @TestVisible private static String lastExceptionMessage;

    // ============= CUSTOM EXCEPTIONS =============
    public class AccessException extends Exception {}
    public class BadRequestException extends Exception {}
    public class NotFoundException extends Exception {}
    public class ConflictException extends Exception {}

    // ============= STANDARDIZED RESPONSES =============
    @TestVisible public static void unauthorized(String message) {
        sendResponse(401, message);
    }

    @TestVisible public static void unauthorized(String message, Object details) {
        sendResponse(401, message, details);
    }

    @TestVisible public static void badRequest(String message) {
        sendResponse(400, message);
    }

    @TestVisible public static void badRequest(String message, Object details) {
        sendResponse(400, message, details);
    }

    @TestVisible public static void notFound(String message) {
        sendResponse(404, message);
    }

    @TestVisible public static void notFound(String message, Object details) {
        sendResponse(404, message, details);
    }

    @TestVisible public static void notAcceptable(String message) {
        sendResponse(406, message);
    }

    @TestVisible public static void notAcceptable(String message, Object details) {
        sendResponse(406, message, details);
    }

    @TestVisible public static void internalServerError(String message) {
        sendResponse(500, message);
    }

    @TestVisible public static void internalServerError(String message, Object details) {
        sendResponse(500, message, details);
    }

    @TestVisible public static void accepted(String message) {
        sendResponse(202, message);
    }

    @TestVisible public static void accepted(String message, Object details) {
        sendResponse(202, message, details);
    }

    // ============= CORE RESPONSE HANDLER =============
    @TestVisible public static void sendResponse(Integer statusCode, String message) {
        sendResponse(statusCode, message, null);
    }

    @TestVisible public static void sendResponse(Integer statusCode, String message, Object details) {
        RestContext.response.addHeader('Content-Type', 'application/json');
        RestContext.response.statusCode = statusCode;

        Map<String, Object> response = new Map<String, Object> {
            'message' => message
        };

        if (details != null) {
            response.put('details', details);
        }

        RestContext.response.responseBody = Blob.valueOf(JSON.serializePretty(response));

        logResponse(statusCode, message, response);
    }

    @TestVisible private static void logResponse(Integer statusCode, String message, Map<String, Object> response) {
        Logger logger = new Logger()
            .setClass(className)
            .setMethod('sendResponse')
            .setCategory(logCategory);

        logger.info('Response sent: ' + message, JSON.serializePretty(response));
    }

    // ============= ACCESS TOKEN VALIDATION =============
    @TestVisible public static void validateAccessToken(String headerName, String expectedTokenPrefix) {
        String accessToken = RestContext.request.headers.get(headerName);
        if (accessToken == null || !accessToken.startsWith(expectedTokenPrefix)) {
            throw new AccessException('Invalid or missing access token.');
        }
    }

    // ============= REQUEST PARSING =============
    @TestVisible public static Map<String, Object> getRequestBody() {
        RestRequest req = RestContext.request;
        if (req.requestBody == null || String.isBlank(req.requestBody.toString())) {
            lastExceptionMessage = 'Request body is empty.';
            throw new BadRequestException(lastExceptionMessage);
        }

        try {
            return (Map<String, Object>) JSON.deserializeUntyped(req.requestBody.toString());
        } catch (Exception e) {
            throw new BadRequestException('Failed to parse request body.');
        }
    }

    // ============= FIELD MAPPING =============
    @TestVisible public static void mapFieldsFromRequest(Map<String, Object> requestBody, SObject record, String objectName) {
        Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();
        Schema.SObjectType objectType = globalDescribe.get(objectName.toLowerCase());

        if (objectType == null) {
            throw new IllegalArgumentException('Invalid object: ' + objectName);
        }

        Map<String, Schema.SObjectField> fieldMap = objectType.getDescribe().fields.getMap();

        for (String fieldName : requestBody.keySet()) {
            if (fieldMap.containsKey(fieldName)) {
                Object fieldValue = requestBody.get(fieldName);
                if (fieldValue != null) {
                    record.put(fieldName, fieldValue);
                }
            } else {
                logIgnoredField(fieldName, objectName);
            }
        }
    }

    @TestVisible private static void logIgnoredField(String fieldName, String objectName) {
        Logger logger = new Logger()
            .setClass(className)
            .setMethod('mapFieldsFromRequest')
            .setCategory(logCategory);

        logger.warn('Ignored field: ' + fieldName + ' (not found in object ' + objectName + ')', null);
    }
}
