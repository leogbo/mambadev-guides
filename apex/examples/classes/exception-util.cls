/**
 * @name        ExceptionUtil
 * @since       2025-04-01
 * @access      public
 * @author      MambaDev
 * @description
 *  Static utility for enforcing validation rules in Apex logic.
 *  Use to replace repetitive null/blank checks with clean, declarative guard clauses.
 */
public class ExceptionUtil {

    /**
     * Throws AppValidationException if the given object is null.
     */
    public static void throwIfNull(Object obj, String message) {
        if (obj == null) {
            throw new AppValidationException(message);
        }
    }

    /**
     * Throws AppValidationException if the given String is null or blank.
     */
    public static void throwIfBlank(String value, String message) {
        if (String.isBlank(value)) {
            throw new AppValidationException(message);
        }
    }

    /**
     * Throws AppValidationException if the given condition is true.
     */
    public static void throwIf(Boolean condition, String message) {
        if (condition) {
            throw new AppValidationException(message);
        }
    }

    /**
     * Throws AppValidationException if the given condition is false.
     * Inverted logic for readability.
     */
    public static void require(Boolean condition, String message) {
        if (!condition) {
            throw new AppValidationException(message);
        }
    }

    /**
     * Throws AppValidationException unconditionally.
     */
    public static void fail(String message) {
        throw new AppValidationException(message);
    }
}
