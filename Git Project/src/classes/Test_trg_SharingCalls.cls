@isTest(SeeAllData=true)
public class Test_trg_SharingCalls
{
static testmethod void testSharingCalls()
 {
    Profile p = [select id from profile where name='System Administrator' limit 1];
    System.debug('Profile id is '+p);
    User u = [Select id, department from user where isActive =true and department!=null limit 1];
        System.debug('User is '+u);
       /* User u = new User(alias = 'utest1', email='unit.test10@unit.test.com',
      emailencodingkey='UTF-8', lastname='Unit Test10',
      languagelocalekey='en_US',
      localesidkey='en_GB', profileid = p.Id,
      timezonesidkey='Europe/London',
      username='unit.test10@unit.test.com',department='GL_MI_MID');*/
      
                 
System.runAs(u)
{
      
      //List<Territory> terr = [select Id,Name,External_Territory_Id__c,DeveloperName from Territory limit 1];
         List<Group> grp = [select Id,Name,DeveloperName from Group where Type='Territory'];
           Territory terr = new Territory();
         terr.Name='GL';
         terr.External_Territory_Id__c = u.department;
         terr.DeveloperName = 'Area_Dir';
         insert terr;
          System.debug('Terr is '+terr);
      
      System.debug('Group is '+grp);
      
      RecordType[] rt1 = [Select Id,  Name, SobjectType from RecordType where  SobjectType ='Account' and Name ='Business Account'];
       Account act = new Account();
       act.Name = 'TestNewAcc';
       act.Area__c = 'GL';
       act.Region__c = 'GL_MID';
       act.Territory__c = u.department;
       act.RecordTypeId = rt1[0].Id;
       act.External_Id__c = '12345';
   
       insert act;
   
       RecordType[] rec = [Select Id,  Name, SobjectType from RecordType where  SobjectType ='Contact' and Name ='EP'];
    Contact co = new Contact();
    co.RecordTypeId=rec[0].Id;
    co.LastName = 'TestLastName';
    co.FirstName = 'TestFirstName';   
    co.Accountid = act.Id;
     
       insert co;
    
    
    RecordType[] recfellow = [Select Id,  Name, SobjectType from RecordType where  SobjectType ='Contact' and Name ='EP Fellow'];
    Contact cof = new Contact();
    cof.RecordTypeId=recfellow[0].Id;
    cof.LastName = 'testFellow';
    cof.FirstName = 'Fellow';
    cof.Accountid = act.Id;
     
       insert cof;
       
      /* Call__c c = new Call__c();
       c.Actual_Start_Date__c = system.today();
       c.Accounts__c = act.Name;
       c.Physicians__c = act2.LastName;
       c.AccountId__c =act.Id;
       c.PhysicianId__c =act2.Id;
       c.Case_type__c ='Case Support - CARTO';
       c.Case_Sub_Type__c='A-Flutter Left Side';
       c.Technology_Type__c = 'BWT-001;BWT-002;BWT-008;' ;
       c.BWI_Ablation_Catheter__c = 'BWA-003;BWA-005;BWA-007;BWA-008;BWA-009;BWA-010;';
       c.Other_BWI_Catheter__c ='BWO-100;BWO-101;';
       c.Competetive_Products__c = 'BRD-004;STJ-004;';
       //c.Territory__c = terr.External_Territory_Id__c;
       //c.Territory__c = terr[0].External_Territory_Id__c;
       System.debug('Call is '+c);*/
    Call__c c = new Call__c();
   c.Actual_Start_Date__c = system.today();
   c.Accounts__c = act.Name;
   c.Physicians__c = co.LastName;
   c.Fellow__c=cof.LastName;     
   c.AccountId__c =act.Id;
   c.Account_test__c = act.Id;
   c.PhysicianId__c =co.Id;
   c.Physician__c = co.Id;
   c.contact__c=cof.Id;
   c.fellowId__c=cof.Id;
   c.Case_type__c ='Case Support - CARTO';
   c.Case_Sub_Type__c='A-Flutter Left Side';
   c.Technology_Type__c = 'BWT-001;BWT-002;BWT-008;';
   c.BWI_Ablation_Catheter__c = 'BWA-003;BWA-005;BWA-007;BWA-008;BWA-009;BWA-010;';
   c.Other_BWI_Catheter__c ='BWO-100;BWO-101;';
   c.Competetive_Products__c = 'BRD-004;STJ-004;';
   
   
       test.startTest();
       insert c;
       System.debug('Call is '+c);
       update c;
       test.stopTest();
       /*Account personAcc = new Account();
       RecordType[] rect =[Select Id,  Name, SobjectType from RecordType where  SobjectType ='Account' and Name ='BWI Person Account']; 
       personAcc.RecordTypeId = rect[0].Id;
       personAcc.LastName = 'Test Person Account';
       insert personAcc;  
       System.debug('Person is '+personAcc);
       
       Account businessAcc = new Account();
       RecordType[] rectype =[Select Id,  Name, SobjectType from RecordType where  SobjectType ='Account' and Name ='Business Account']; 
       businessAcc.RecordTypeId = rectype[0].Id;
       businessAcc.Name= 'Test Business Account';
       insert businessAcc;
       System.debug('Hospital is '+businessAcc);
   
         Call__c testCall = new Call__c();
         testCall.Actual_Start_Date__c = System.now();
         testCall.Case_Type__c = 'Case Support - Non CARTO';
         testCall.Case_Sub_Type__c = 'AFib - Persistent'; 
         testCall.Accounts__c = 'BAY AREA MEDICAL CENTER';
         testCall.Physicians__c = 'Joseph Marie';
         testCall.AccountId__c = businessAcc.Id;
         testCall.PhysicianId__c  = personAcc.Id;
         testCall.Territory__c = terr[0].External_Territory_Id__c;
         System.debug('Call is '+testCall);
        
         insert testCall;
         System.debug('Call territory is '+testCall.Territory__c);*/
      
  }    
 }
         }