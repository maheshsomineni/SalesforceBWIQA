@isTest
public class TestContactsListController
{
  static testMethod void allContacts()
  {
    
    //Call that newly created method here.
    allAccounts();
    ContactsListController c = new ContactsListController();
    Contact con = new Contact();
     ApexPages.StandardController stdContr = new ApexPages.StandardController(con);     
    //cls_ext_ContactDetails c1 = new cls_ext_ContactDetails();
    //cls_ext_UpdateContactNew c2 = new cls_ext_UpdateContactNew();
   
  }
  //Method to insert Accounts,Contacts and Affiliation
  static void allAccounts()
  {
    
    RecordType[] rt1 = [Select Id,  Name, SobjectType from RecordType where  SobjectType ='Account' and Name ='Business Account'];
    test.startTest();
   Account act = new Account();
   act.Name = 'TestNewAcc';
   act.Territory__c='GL_MNT_MN';
   act.RecordTypeId = rt1[0].Id;
   act.External_Id__c = '12345';
  
   insert act;
   //update act;
   
    RecordType[] rec = [Select Id,  Name, SobjectType from RecordType where  SobjectType ='Contact' and Name ='EP'];
    Contact co = new Contact();
    co.RecordTypeId=rec[0].Id;
    co.LastName = 'TestLastName';
    co.FirstName = 'TestFirstName';   
    co.Accountid = act.Id;
     
    insert co;
   // update co;
   // delete co;
    
  }
}