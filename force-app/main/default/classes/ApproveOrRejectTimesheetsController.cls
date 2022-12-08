public with sharing class ApproveOrRejectTimesheetsController {
    @AuraEnabled(cacheable=true)
    public static List<Timesheet__c> getTimesheetsByProject(Id projectId) {
        return [
            SELECT Id, Name, Employee__c, Total_Hours__c, Employee__r.Name, Status__c
            FROM Timesheet__c
            WHERE Project__c = :projectId
        ];
    }

    @AuraEnabled
    public static void rejectTimesheets(List<Timesheet__c> timesheets) {
        try {
            for (Timesheet__c timesheet : timesheets) {
                timesheet.Status__c = 'Rejected';
            }

            update timesheets;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void approveTimesheets(List<Timesheet__c> timesheets) {
        try {
            for (Timesheet__c timesheet : timesheets) {
                timesheet.Status__c = 'Approved';
            }

            update timesheets;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
