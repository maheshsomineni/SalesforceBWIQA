@isTest
private class TestPersonAccountTerritoryUpdate {
  /* static testMethod void myUnitTest() {
   Account acc = new Account();
   RecordType[] rt =[Select Id,  Name, SobjectType from RecordType where  SobjectType ='Account' and Name ='BWI Person Account']; 
   acc.RecordTypeId = rt[0].Id;
   acc.LastName = 'Test';
   insert acc;  

    Account acc2 = new Account();
    acc2.Name = 'Test';
    RecordType[] rt2 = [Select Id,  Name, SobjectType from RecordType where  SobjectType ='Account' and Name ='Business Account'];
    acc2.RecordTypeId =rt2[0].Id;
    insert acc2;
    
   Account con = [select Id,Name,LastName from Account where id=:acc.Id];
    system.debug('****Con id*****'+con.Id);
          
    Affiliation__c aff = new Affiliation__c();
    aff.Hospital__c =acc2.Id;
    aff.Physician1__c = con.Id;
    insert aff;
    
    delete aff;
   }*/
}