public with sharing class ProjectDuplicateChecker {
    
    // params in annotation make it easier to find the functionality in flow
    @InvocableMethod(description='Return dupe projects.' label='Dupe Project Check' category='Project')
    public static List<Project__c> checkForDuplicateProjects(List<Id> projectIds) {
        List<Project__c> currentProjects = [SELECT Name FROM Project__c WHERE Id IN :projectIds];
        List<Project__c> duplicateProjects = new List<Project__c>();

        if (currentProjects.size() > 0) {
            duplicateProjects = [SELECT Name FROM Project__c WHERE Name = :currentProjects[0].Name AND Id != :currentProjects[0].Id];
        }

        return duplicateProjects;
    }
}
