// on [API Name]
// before/after is when the trigger fires relative to DML operation
trigger Timesheet on Timesheet__c (before update, after insert) {
    // always check context
    if (Trigger.isBefore && Trigger.isUpdate) {
        TimesheetRejectionCounter.incrementRejectionCountOnRejection(Trigger.new, Trigger.oldMap);
    } else if (Trigger.isAfter && Trigger.isInsert) {
        TimesheetReminderGenerator generator = new TimesheetReminderGenerator();
        generator.sendSubmissionReminder(Trigger.new);
    }
}