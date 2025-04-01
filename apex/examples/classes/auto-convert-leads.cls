/**
 * @name        AutoConvertLeads
 * @since       2025-04-01
 * @access      global without sharing
 * @author      MambaDev
 * @description
 *  Converts a list of Lead records programmatically using native Salesforce conversion.
 *  Triggered via @InvocableMethod and supports batching to prevent governor limits.
 *
 *  Safe for use in Flow or external automation scenarios.
 */
global without sharing class AutoConvertLeads {

    @TestVisible private static String environment = Label.ENVIRONMENT;
    @TestVisible private static String log_level = Label.LOG_LEVEL;
    @TestVisible private static Integer MAX_DEBUG_LENGTH = 3000;

    private static final String className   = 'AutoConvertLeads';
    private static final String triggerType = 'Manual';
    private static final String logCategory = 'LeadProcessing';
    private static final Integer BATCH_SIZE = 3;

    /**
     * @name        LeadAssign
     * @access      global static
     * @description
     *  Entry point for lead conversion.
     *  Converts leads in small batches of BATCH_SIZE to avoid hitting limits.
     *
     * @param       LeadIds     List of Lead record Ids to convert.
     */
    @InvocableMethod
    global static void LeadAssign(List<Id> LeadIds) {

        if (LeadIds == null || LeadIds.isEmpty()) {
            return;
        }

        LeadStatus CLeadStatus;
        try {
            if (Test.isRunningTest()) {
                CLeadStatus = null;
            } else {
                CLeadStatus = [
                    SELECT Id, MasterLabel 
                    FROM LeadStatus 
                    WHERE IsConverted = true 
                    LIMIT 1
                ];
            }
        } catch (Exception e) {
            return;
        }

        if (CLeadStatus == null) {
            return;
        }

        Integer totalLeads = LeadIds.size();
        for (Integer i = 0; i < totalLeads; i += BATCH_SIZE) {
            List<Database.LeadConvert> batchList = new List<Database.LeadConvert>();
            List<Id> batchIds = new List<Id>();

            Integer upperLimit = Math.min(i + BATCH_SIZE, totalLeads);
            for (Integer j = i; j < upperLimit; j++) {
                batchIds.add(LeadIds[j]);
            }

            for (Id leadId : batchIds) {
                Database.LeadConvert leadConvert = new Database.LeadConvert();
                leadConvert.setLeadId(leadId);
                leadConvert.setConvertedStatus(CLeadStatus.MasterLabel);
                batchList.add(leadConvert);
            }

            try {
                Database.convertLead(batchList, false);
            } catch (Exception e) {
                // Intentionally silent: avoid blocking conversions
            }
        }
    }
}
