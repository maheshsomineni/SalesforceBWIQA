@isTest
public class Test_cls_ext_ContactDetails
{
    static testMethod void MyTestData()
    {              
  list<Id> contactlist=new list<Id>();
 
   Profile p = [select id from profile where name='System Administrator'];
       User uc = new User(alias = 'uzero', email='unit.test@unit.test.com',
       emailencodingkey='UTF-8', lastname='Unit Test',
      languagelocalekey='en_US',
      localesidkey='en_GB', profileid = p.Id,
      timezonesidkey='Europe/London',
      username='unit.testzeroxxxxx@unit.test.com');
      
      System.runAs(uc)
      {
        Profile p1 = [select id from profile where name='Territory Manager'];
       User vc = new User(alias = 'uone', email='unitunit.test@unit.test.com',
       emailencodingkey='UTF-8', lastname='Unitone Test',
      languagelocalekey='en_US',
      localesidkey='en_GB', profileid = p1.Id,
      timezonesidkey='Europe/London',
      username='unitone.testoneyyyyy@unitone.test.com');
      
      System.runAs(vc)                     
      
   {
       Account acc=new Account();       
       acc.Name = 'TestNewAcc';
       acc.Territory__c='GL_MNT_MN';       
       acc.External_Id__c = '12345';
       insert acc;
   
   
       Contact con1 = new Contact();
       RecordType[] rectype1 =[Select Id,  Name, SobjectType from RecordType where  SobjectType ='Contact' and Name ='EP Fellow'];
       ApexPages.currentPage().getParameters().put('RecordType',rectype1[0].Id);  
       Con1.AccountId=acc.id;
       Con1.RecordTypeId = rectype1[0].Id;
       Con1.LastName = 'Test Contact1';
       Con1.External_Id__c = '12345';
       insert con1;       
       contactlist.add(con1.id);
      
       Contact con2 = new Contact();
       RecordType[] rectype2 =[Select Id,  Name, SobjectType from RecordType where  SobjectType ='Contact' and Name ='EP'];
       con2.RecordTypeId = rectype2[0].Id;
       con2.LastName = 'Test Contact2';
       con2.External_Id__c = '56789';
       insert con2;
       //contactlist.add(con2.id);
       
       
       Contact con3 = new Contact();
       RecordType[] rectype3 =[Select Id,  Name, SobjectType from RecordType where  SobjectType ='Contact' and Name ='Cardiologist'];
       con3.RecordTypeId = rectype3[0].Id;
       con3.LastName = 'Test Contact3';
       con3.External_Id__c = '13579';
       insert con3;       
       //contactlist.add(con3.id);
       
       Contact con4 = new Contact();
       RecordType[] rectype4 =[Select Id,  Name, SobjectType from RecordType where  SobjectType ='Contact' and Name ='Other'];
       con4.RecordTypeId = rectype4[0].Id;
       con4.LastName = 'Test Contact4';
       con4.External_Id__c = '24680';
       insert con4;
       //contactlist.add(con4.id);
       
       
       Call__c c = new Call__c();
       c.Actual_Start_Date__c = system.today();
       c.Accounts__c = acc.Name;
       c.Physicians__c = con1.LastName;
       c.Fellow__c=con1.LastName;     
       c.AccountId__c =acc.Id;
       c.Account_test__c = acc.Id;
       c.PhysicianId__c =con1.Id;
       c.Physician__c = con1.Id;
       c.contact__c=con1.Id;
       c.fellowId__c=con1.Id;
       c.Case_type__c ='Case Support - CARTO';
       c.Case_Sub_Type__c='A-Flutter Left Side';
       c.Technology_Type__c = 'BWT-001;BWT-002;BWT-008;';
       c.BWI_Ablation_Catheter__c = 'BWA-003;BWA-005;BWA-007;BWA-008;BWA-009;BWA-010;';
       c.Other_BWI_Catheter__c ='BWO-100;BWO-101;';
       c.Competetive_Products__c = 'BRD-004;STJ-004;';
       insert c;
       
       System.debug('callll' + c.id );
       
       Other_Activity__c otheractivity=new Other_Activity__c();
       otheractivity.Account__c=acc.id;
       otheractivity.Contact__c=con1.id;
       otheractivity.Activity_Report_Date__c=system.today();
       otheractivity.Activity_Time_HRS__c=10;
       otheractivity.Activity_Type__c='Training';
       otheractivity.Activity_Sub_Type__c='Attend CTK';
       insert otheractivity;
      
       
   
   Apexpages.StandardController stdController1 = new Apexpages.StandardController(con1); 
   Apexpages.StandardController stdController2 = new Apexpages.StandardController(con2); 
   Apexpages.StandardController stdController3 = new Apexpages.StandardController(con3); 
   Apexpages.StandardController stdController4 = new Apexpages.StandardController(con4); 
   
     cls_ext_ContactDetails ct1 =new cls_ext_ContactDetails(stdController1);  
     cls_ext_ContactDetails ct2 =new cls_ext_ContactDetails(stdController2);   
     cls_ext_ContactDetails ct3 =new cls_ext_ContactDetails(stdController3);    
     cls_ext_ContactDetails ct4 =new cls_ext_ContactDetails(stdController4);   
     
    cls_ext_UpdateContactNew testController1 = new cls_ext_UpdateContactNew(stdController1);
    cls_ext_UpdateContactNew testController2 = new cls_ext_UpdateContactNew(stdController2);
    cls_ext_UpdateContactNew testController3 = new cls_ext_UpdateContactNew(stdController3);
    cls_ext_UpdateContactNew testController4 = new cls_ext_UpdateContactNew(stdController4);
        
        testController1.SaveCustom();
        testController2.SaveCustom();
        testController3.SaveCustom();
        testController4.SaveCustom();
       
       
       /*Apexpages.currentPage().getParameters().put('id',c.id);
       ApexPages.StandardController stdContr = new ApexPages.StandardController(c); 
       CallController cllext = new CallController(stdContr); 
       
       c.External_Resource_Used__c='Per Diem';
       update c;
       cllext = new CallController(stdContr); 
      
       cllext.searchAcc();                 
       cllext.searchPhysicians();
        cllext.searchFellows();*/       
     
       System.debug('Contactlistss' + contactlist );
       updatePhysiciansonContactNameChange.changeName(contactlist);
  
      try
      {
       delete con1;
       update con4;
      delete con3;
      
      }
      catch(Exception e)
      {
      
      System.assertEquals('FIELD_CUSTOM_VALIDATION_EXCEPTION' , 
                                 e.getDmlStatusCode(0) );
     }   
   
   }
    }
    }
    }