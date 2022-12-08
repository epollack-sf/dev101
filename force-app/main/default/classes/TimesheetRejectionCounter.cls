public with sharing class TimesheetRejectionCounter {
    public static void incrementRejectionCountOnRejection(List<Timesheet__c> timesheetsAfterUpdate, Map<Id, Timesheet__c> timesheetsBeforeUpdate) {
        for (Timesheet__c timesheet : timesheetsAfterUpdate) {
            if (timesheet.Status__c == 'Rejected' && timesheet.Status__c != timesheetsBeforeUpdate.get(timesheet.Id).Status__c) {
                if (timesheet.Number_of_Times_Rejected__c == null) {
                    timesheet.Number_of_Times_Rejected__c = 0;
                }
                System.debug(timesheet.Id);
                timesheet.Number_of_Times_Rejected__c ++;
            }
        }
    }
}
