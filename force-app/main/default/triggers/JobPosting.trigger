trigger JobPosting on Job_Posting__c (before insert) {
    Job_Posting__c[] jobsToClone = [SELECT Id FROM Job_Posting__c where Id in :Trigger.old];
    Job_Posting__c[] clonesToAdd = new List<Job_Posting__c>();
    for (Job_Posting__c jp : jobsToClone){
        
    }
}