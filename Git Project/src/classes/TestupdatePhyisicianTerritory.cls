@isTest
private class TestupdatePhyisicianTerritory
{
  /* static Account personAcc;
   static Account businessAcc;
   
   static void testData()
   {
       personAcc = new Account();
       RecordType[] rect =[Select Id,  Name, SobjectType from RecordType where  SobjectType ='Account' and Name ='BWI Person Account']; 
       personAcc.RecordTypeId = rect[0].Id;
       personAcc.LastName = 'Test Person Account';
       insert personAcc;  
       
       businessAcc = new Account();
       RecordType[] rectype =[Select Id,  Name, SobjectType from RecordType where  SobjectType ='Account' and Name ='Business Account']; 
       businessAcc.RecordTypeId = rectype[0].Id;
       businessAcc.Name= 'Test Business Account';
       insert businessAcc;
       
       Affiliation__c aff = new Affiliation__c();
       aff.Hospital__c =businessAcc.Id;
       aff.Physician1__c = personAcc.Id;
       insert aff;
   }
   
   
   static testMethod void myUnitTestOne()
   {
  
       testData();
         test.startTest();
       businessAcc.Territory__c = 'SE_AL_ALG';
       update businessAcc;
       Account acc = [SELECT Territory__c FROM Account WHERE Id = :businessAcc.Id];  
       System.assertEquals('SE_AL_ALG', acc.Territory__c);
       
      
       personAcc.Territory__c =  acc.Territory__c;
       update personAcc;
       
       Account updatedAcc = [SELECT Territory__c FROM Account WHERE Id = :personAcc.Id];   
       System.assertEquals('SE_AL_ALG', updatedAcc.Territory__c);
       test.stopTest();
      
   }
   
   static testMethod void myUnitTestTwo()
   {
   test.startTest();
      testData();
      businessAcc.Territory__c = null;
      
       update businessAcc;
       Account acc = [SELECT Territory__c FROM Account WHERE Id = :businessAcc.Id];  
       System.assertEquals(null, acc.Territory__c);
       
       
       personAcc.Territory__c =  acc.Territory__c;
       update personAcc;
       
       Account updatedAcc = [SELECT Territory__c FROM Account WHERE Id = :personAcc.Id];   
       System.assertEquals(null, updatedAcc.Territory__c);
       test.stopTest(); 
   }*/
}