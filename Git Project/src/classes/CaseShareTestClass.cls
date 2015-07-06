@isTest 
private class CaseShareTestClass {
    static testMethod void validateCaseShare() {
      Case c = new Case();
      c.Application__c = 'Case Management';
      c.Status = 'New';
      c.Type = 'Incident';
      c.Environment__c = 'Production';
      c.Priority = 'High';
        c.Subject = 'Test ticket';
        c.Description = 'testing ticket tool';
        insert c;
    }
}