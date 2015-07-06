@isTest
private class TestOtherActivitiesController
{
       public static Account acc{get;set;}
    	public static Contact co{get;set;}
       static void testData()
       {
         RecordType[] rt = [Select Id,  Name, SobjectType from RecordType where  SobjectType ='Account' and Name ='Business Account'];
         acc = new Account();
         acc.Name = 'TestAccount';
         acc.RecordTypeId = rt[0].Id;
         insert acc;
           
        RecordType[] rec = [Select Id,  Name, SobjectType from RecordType where  SobjectType ='Contact' and Name ='EP'];
    	co = new Contact();
    	co.RecordTypeId=rec[0].Id;
    	co.LastName = 'TestLastName';
    	co.FirstName = 'TestFirstName';   
    	co.Accountid = acc.Id;
     	insert co;
       
       }
       static testMethod void myUnitTest1() 
       {
        
          testData();
          Other_Activity__c obj = new Other_Activity__c();
          obj.Activity_Report_Date__c = system.today();
          obj.Activity_Type__c = 'General';
          obj.Activity_Sub_Type__c = 'Test';
          obj.Activity_Time_HRS__c =  0.25;
          obj.Hospital__c = acc.Name;
          obj.AccountId__c = acc.Id;
          obj.Physician__c = co.Name;
          obj.PhysicianID__c = co.Id;
          obj.JDE_JJHCS_Number__c = 'JDEE/1234';
          obj.Comments__c = 'TestComments';
          insert obj;
          
          Apexpages.currentPage().getParameters().put('id',obj.id);
          //Apexpages.currentPage().getParameters().put('clone','1');
          ApexPages.StandardController stdContr = new ApexPages.StandardController(obj); 
          OtherActivitiesController otherActivityCntrl = new OtherActivitiesController(stdContr); 
          
          otherActivityCntrl.save();
          otherActivityCntrl.saveNew();
          
       }
       
       static testMethod void myUnitTest2() 
       {
           testData();
             
           Other_Activity__c obj = new Other_Activity__c();
          obj.Activity_Report_Date__c = system.today();
          obj.Activity_Type__c = 'ASP';
          obj.Activity_Sub_Type__c = 'Test';
          obj.Activity_Time_HRS__c =  0.25;
          obj.Hospital__c = null;
          insert obj;
          
          Apexpages.currentPage().getParameters().put('id',obj.id);
          ApexPages.StandardController stdContr = new ApexPages.StandardController(obj); 
          OtherActivitiesController otherActivityCntrl = new OtherActivitiesController(stdContr); 
          
          otherActivityCntrl.save();
        
       }
       static testMethod void myUnitTest3() 
       {
           testData();
             
           Other_Activity__c obj = new Other_Activity__c();
          obj.Activity_Report_Date__c = system.today();
          obj.Activity_Type__c = 'Test1';
          obj.Activity_Sub_Type__c = 'Test2';
          obj.Activity_Time_HRS__c =  0.50;
          obj.Hospital__c = acc.Name;
          obj.AccountId__c = acc.Id;

          obj.JDE_JJHCS_Number__c = 'JDEE/1234';
          obj.Comments__c='Hi';
          insert obj;
          
          Apexpages.currentPage().getParameters().put('id',obj.id);
          Apexpages.currentPage().getParameters().put('clone','1');

          ApexPages.StandardController stdContr = new ApexPages.StandardController(obj); 
          OtherActivitiesController otherActivityCntrl = new OtherActivitiesController(stdContr); 
          
          otherActivityCntrl.save();
          otherActivityCntrl.saveNew();
          otherActivityCntrl.clearHospitalJDE();

        
       }
static testMethod void myUnitTest4() 
       {
           testData();
             
           Other_Activity__c obj = new Other_Activity__c();
          obj.Activity_Report_Date__c = system.today();
          obj.Activity_Type__c = 'Admin';
          obj.Activity_Sub_Type__c = 'Test2';
          obj.Activity_Time_HRS__c =  0.75;
          obj.Hospital__c = acc.Name;
          obj.JDE_JJHCS_Number__c = 'JDEE/2345';
          obj.Comments__c='demo';
          insert obj;
          
          Apexpages.currentPage().getParameters().put('id',obj.id);
          ApexPages.StandardController stdContr = new ApexPages.StandardController(obj); 
          OtherActivitiesController otherActivityCntrl = new OtherActivitiesController(stdContr); 
          
          otherActivityCntrl.save();
          otherActivityCntrl.saveNew();

        
       }

        static testMethod void myUnitTest5() 
       {
           testData();
             
           Other_Activity__c obj = new Other_Activity__c();
          obj.Activity_Report_Date__c = system.today();
          obj.Activity_Type__c = 'Test1';
          obj.Activity_Sub_Type__c = 'Test2';
          obj.Activity_Time_HRS__c =  0.50;
          obj.Hospital__c = null;
          obj.AccountId__c = acc.Id;
          obj.Comments__c='Hi';
          insert obj;
          
          Apexpages.currentPage().getParameters().put('id',obj.id);
          Apexpages.currentPage().getParameters().put('clone','1');

          ApexPages.StandardController stdContr = new ApexPages.StandardController(obj); 
          OtherActivitiesController otherActivityCntrl = new OtherActivitiesController(stdContr); 
          
          otherActivityCntrl.save();
          otherActivityCntrl.saveNew();
          otherActivityCntrl.clearHospitalJDE();

        
       }

}