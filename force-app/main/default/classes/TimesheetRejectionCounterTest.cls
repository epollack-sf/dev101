@isTest
private with sharing class TimesheetRejectionCounterTest {
    
    // sample test method
    @isTest
    static void methodUnderTest_given_should() {}

    @isTest
    static void updateTimesRejectedOnRejection_givenRejectedTimesheets_shouldIncrementCount() {
        Account testAccount = new Account(Name='Test Account');
        insert testAccount;

        Contact testEmployee = new Contact(AccountId=testAccount.Id,
                                            LastName='Test',
                                            RecordTypeId='0123t000000BTrlAAG');
        insert testEmployee;

        Timesheet__c testTimesheet = new Timesheet__c(Employee__c=testEmployee.Id,
                                                        Status__c='Draft',
                                                        Number_of_Times_Rejected__c=0);
        insert testTimesheet; // testTimesheet.Id = Id

        // resets governor limits to get accurate idea of what you're doing
        // assumes that the DML operations used during data load will not be called in a real use case
        test.startTest();
        
        // actual test scenario

        testTimesheet.Status__c = 'Rejected';
        update testTimesheet;
        
        // will pause until all async processing stops
        test.stopTest();

        testTimesheet = [SELECT Number_of_Times_Rejected__c
                            FROM Timesheet__c
                            WHERE Id = :testTimesheet.Id
                            LIMIT 1];

        System.assertEquals(1, testTimesheet.Number_of_Times_Rejected__c, 
                            'Rejection Count should have been incremented...');
        
    }

    @isTest
    static void updateTimesRejectedOnRejection_givenApprovedTimesheet_shouldNotIncrement() {
        Account testAccount = new Account(Name='Test Account');
        insert testAccount;

        Contact testEmployee = new Contact(AccountId=testAccount.Id,
                                            LastName='Test',
                                            RecordTypeId='0123t000000BTrlAAG');
        insert testEmployee;

        Timesheet__c testTimesheet = new Timesheet__c(Employee__c=testEmployee.Id,
                                                        Status__c='Draft',
                                                        Number_of_Times_Rejected__c=0);
        insert testTimesheet;

        test.startTest();
        
        // actual test scenario

        testTimesheet.Status__c = 'Approved';
        update testTimesheet;
        
        // will pause until all async processing stops
        test.stopTest();

        testTimesheet = [SELECT Number_of_Times_Rejected__c
                            FROM Timesheet__c
                            WHERE Id = :testTimesheet.Id
                            LIMIT 1];

        System.assertNotEquals(1, testTimesheet.Number_of_Times_Rejected__c, 
                            'Rejection Count shouldn\'t have been incremented...');
    }

    @isTest
    static void updateTimesRejectedOnRejection_givenNullCounter_shouldSetCounterToZero() {
        Account testAccount = new Account(Name='Test Account');
        insert testAccount;

        Contact testEmployee = new Contact(AccountId=testAccount.Id,
                                            LastName='Test',
                                            RecordTypeId='0123t000000BTrlAAG');
        insert testEmployee;

        Timesheet__c testTimesheet = new Timesheet__c(Employee__c=testEmployee.Id,
                                                        Status__c='Draft');
        insert testTimesheet; // testTimesheet.Id = Id

        // resets governor limits to get accurate idea of what you're doing
        // assumes that the DML operations used during data load will not be called in a real use case
        test.startTest();
        
        // actual test scenario

        testTimesheet.Status__c = 'Rejected';
        update testTimesheet;
        
        // will pause until all async processing stops
        test.stopTest();

        testTimesheet = [SELECT Number_of_Times_Rejected__c
                            FROM Timesheet__c
                            WHERE Id = :testTimesheet.Id
                            LIMIT 1];

        System.assertEquals(0, testTimesheet.Number_of_Times_Rejected__c, 
                            'Rejection Count should have been set to 0...'); 
    }
}
