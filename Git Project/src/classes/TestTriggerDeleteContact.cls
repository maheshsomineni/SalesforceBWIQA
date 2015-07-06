@isTest
public class TestTriggerDeleteContact {

   static testMethod void MyTestData()
    {   
      Contact con1 = new Contact();
       RecordType[] rectype1 =[Select Id,  Name, SobjectType from RecordType where  SobjectType ='Contact' and Name ='EP Fellow'];
       ApexPages.currentPage().getParameters().put('RecordType',rectype1[0].Id);  
       Con1.RecordTypeId = rectype1[0].Id;
       Con1.LastName = 'Test Contact1';
       Con1.External_Id__c = '12345';
       insert con1;
       try
      {
       delete con1;             
      }
      catch(Exception e)
      {
      
      System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION' , 
                                 e.getDmlStatusCode(0) );
     }   
    }
}