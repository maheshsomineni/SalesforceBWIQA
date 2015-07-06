@isTest
public class Test_trg_AlignAccountLookup
{
 static void testData1()
 {
   Account a1 = new Account();
   RecordType[] rectype =[Select Id,  Name, SobjectType from RecordType where  SobjectType ='Account' and Name ='Business Account'];
   a1.RecordTypeId = rectype[0].Id;
   a1.Name = 'Test Account1';
   a1.External_Id__c = '999999';
   insert a1;
  
   SalesByAccount__c sba1 = new SalesByAccount__c();
   sba1.ExternalAccountID__c = '999999';
   sba1.External_SalesByAccount_Id__c = 'test1';
   insert sba1;   
 }
 static void testData2()
 {
   Account a2 = new Account();
   RecordType[] rectype =[Select Id,  Name, SobjectType from RecordType where  SobjectType ='Account' and Name ='Business Account'];
   a2.RecordTypeId = rectype[0].Id;
   a2.Name = 'Test Account2';
   a2.External_Id__c = '234';
   insert a2;
  
   SalesByAccount__c sba2 = new SalesByAccount__c();
   sba2.ExternalAccountID__c='00000';
   sba2.External_SalesByAccount_Id__c = 'test2';
   insert sba2;
 }
 
 static testMethod void myUnitTestOne()
 {
   testData1();
   Account lstAcc1 = [SELECT Name FROM Account WHERE External_Id__c = '999999'];
   SalesByAccount__c lstSBA1 = [SELECT Account__c FROM SalesByAccount__c WHERE ExternalAccountID__c = '999999'];
 }
  
 static testMethod void myUnitTestTwo()
 {
   testData2();
   Account lstAcc2 = [SELECT Name FROM Account WHERE External_Id__c = '234'];
   SalesByAccount__c lstSBA2 = [SELECT Account__c FROM SalesByAccount__c WHERE ExternalAccountID__c = '00000'];
   System.assertNotEquals(lstSBA2.Account__c, lstAcc2.Name);
 }
}