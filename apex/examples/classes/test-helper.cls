/**
 * @name        TestHelper
 * @since       2025-04-01
 * @author      MambaDev
 * @description
 *  Utility class for test data generation and validation.
 *  Provides safe fake IDs, randomized field generators, and assertion helpers 
 *  to ensure consistent, reusable, and isolated test environments.
 * 
 *  Use this class in all unit tests to reduce boilerplate and follow DRY principles.
 */
public class TestHelper {

    /**
     * @name        generateFakeId
     * @access      public static
     * @description
     *  Generates a safe, non-destructive fake Id for the given SObjectType.
     *  Attempts to mutate a real record's Id if available.
     *  Falls back to synthetic Id using key prefix.
     *
     * @param       type    The Schema.SObjectType to generate a fake Id for.
     * @return      Id      A fake but syntactically valid Salesforce Id.
     */
    @TestVisible
    public static Id generateFakeId(Schema.SObjectType type) {
        if (type == null) return null;

        try {
            String objectName = type.getDescribe().getName();
            String query = 'SELECT Id FROM ' + objectName + ' LIMIT 1';
            List<SObject> records = Database.query(query);

            if (records.isEmpty()) {
                String prefix = type.getDescribe().getKeyPrefix();
                return Id.valueOf(prefix + '000000000000ZZZ');
            }

            Id realId = records[0].Id;
            return Id.valueOf(String.valueOf(realId).substring(0, 12) + 'ZZZ');

        } catch (Exception ex) {
            System.debug('⚠️ generateFakeId failed: ' + ex.getMessage());
            return null;
        }
    }

    /**
     * @name        randomEmail
     * @access      public static
     * @description
     *  Generates a random, valid email address in the format userXXXXXX@test.com.
     */
    @TestVisible
    public static String randomEmail() {
        Integer suffix = Math.mod(Math.abs(Crypto.getRandomInteger()), 1000000);
        return 'user' + String.valueOf(suffix) + '@test.com';
    }

    /**
     * @name        fakeCnpj
     * @access      public static
     * @description
     *  Generates a dummy CNPJ in the format 76.999.774/0001-XX.
     *  Use only for UI and layout test validation.
     */
    @TestVisible
    public static String fakeCnpj() {
        Integer digit = Math.mod(Math.abs(Crypto.getRandomInteger()), 90);
        String dv = digit < 10 ? '0' + String.valueOf(digit) : String.valueOf(digit);
        return '76.999.774/0001-' + dv;
    }

    /**
     * @name        fakePhone
     * @access      public static
     * @description
     *  Generates a Brazilian mobile phone number (e.g., 5521999XXXXXX) for test use.
     */
    @TestVisible
    public static String fakePhone() {
        return '5521999' + randomDigits(6);
    }

    /**
     * @name        randomDigits
     * @access      public static
     * @description
     *  Returns a random numeric string of the specified length.
     *
     * @param       length  Desired number of digits.
     * @return      String  Random digit string.
     */
    @TestVisible
    public static String randomDigits(Integer length) {
        String result = '';
        while (result.length() < length) {
            result += String.valueOf(Math.abs(Crypto.getRandomInteger()));
        }
        return result.substring(0, length);
    }

    /**
     * @name        randomString
     * @access      public static
     * @description
     *  Returns a random alphanumeric string of the specified length.
     *
     * @param       length  Desired string length.
     * @return      String  Random alphanumeric string.
     */
    @TestVisible
    public static String randomString(Integer length) {
        final String charset = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
        String result = '';
        while (result.length() < length) {
            Integer r = Math.mod(Math.abs(Crypto.getRandomInteger()), charset.length());
            result += charset.substring(r, r + 1);
        }
        return result;
    }

    /**
     * @name        assertMissingTestSetup
     * @access      public static
     * @description
     *  Fails the test explicitly if a required record was not created.
     *
     * @param       objectLabel   A label or name for the expected object.
     */
    @TestVisible
    public static void assertMissingTestSetup(String objectLabel) {
        System.assert(false, '❌ Required test record of type "' + objectLabel + '" was not created via TestDataSetup.');
    }
}
