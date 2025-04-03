/**
 * @name        RecordHelper
 * @since       2025-04-01
 * @access      public
 * @type        utility class
 * @author      MambaDev
 * @description
 *  Utility class for dynamic SObject record retrieval.
 *  Allows querying any object by Id with custom fields using dynamic SOQL.
 * 
 *  Use when working with flexible or generic logic (e.g., metadata-driven processes).
 */
public class RecordHelper {

    /**
     * @name        getById
     * @access      public static
     * @description
     *  Retrieves a record of the given SObjectType using dynamic SOQL.
     *
     * @param       sobjectType     The object type to query (e.g., Account, Contact)
     * @param       recordId        The Id of the record to retrieve
     * @param       queryFields     Comma-separated list of fields to retrieve
     * @return      SObject         The found record, or null if not found or input invalid
     */
    public static SObject getById(Schema.SObjectType sobjectType, Id recordId, String queryFields) {
        if (recordId == null || String.isBlank(queryFields) || sobjectType == null) {
            return null;
        }

        String objectName = sobjectType.getDescribe().getName();
        String query = 'SELECT ' + queryFields + ' FROM ' + objectName + ' WHERE Id = :recordId LIMIT 1';

        List<SObject> records = Database.query(query);
        return records.isEmpty() ? null : records[0];
    }
}
