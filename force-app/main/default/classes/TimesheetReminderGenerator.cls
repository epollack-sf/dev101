public with sharing class TimesheetReminderGenerator {
    public void sendSubmissionReminder(List<Timesheet__c> insertedTimesheets) {
        Task[] generatedReminders = new List<Task>();
        
        for (Timesheet__c timesheet : insertedTimesheets) {
            Task reminderTask = new Task(Subject='Reminder: Submit your timesheet!', 
                                        WhatId=timesheet.Id,
                                        ActivityDate=Date.today().addDays(7));
            
            generatedReminders.add(reminderTask);
        }
        
        insert generatedReminders;
    }
}
