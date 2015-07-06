@isTest
private class TestCallController{

   static testMethod void myUnitTest() {
   RecordType[] rt1 = [Select Id,  Name, SobjectType from RecordType where  SobjectType ='Account' and Name ='Business Account'];
    test.startTest();
   Account act = new Account();
   act.Name = 'TestNewAcc';
   act.Territory__c='GL_MNT_MN';
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

  
    
   Apexpages.currentPage().getParameters().put('accid',act.id);
       ApexPages.currentPage().getParameters().put('accname',act.name);
       Apexpages.currentPage().getParameters().put('accountname',act.name);
       Apexpages.currentPage().getParameters().put('accountid',act.id);
   
   
   Product2 p1 = new Product2();
   p1.ProductCode = 'BWO-100';
   p1.Name = 'ACUNAV Ultrasound';
   p1.Family = 'BWI Other Catheters';
   insert p1; 
   
   Product2 p2 = new Product2();
   p2.ProductCode = 'BWA-003';
   p2.Name = 'NAVISTAR Thermocool SF Bi-Dir';
   p2.Family = 'BWI Ablation Catheters';
   insert p2; 
   
   Product2 p3 = new Product2();
   p3.ProductCode = 'STJ-004';
   p3.Name = 'SJT-EnSite Array';
   p3.Family = 'Competitive Catheters';
   insert p3; 
   
   Product2 p4 = new Product2();
   p4.ProductCode = 'BWT-008';
   p4.Name = 'VISITAG';
   p4.Family = 'Technology';
   insert p4; 
   
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
   
   insert c;
   test.stopTest();
   

   Apexpages.currentPage().getParameters().put('id',c.id);
   ApexPages.StandardController stdContr = new ApexPages.StandardController(c); 
   CallController cllext = new CallController(stdContr); 
   
   c.External_Resource_Used__c='Per Diem';
   update c;
   cllext = new CallController(stdContr); 
  
   cllext.searchAcc();
   cllext.state='MN';
   cllext.city='MINNEAPOLIS';
   cllext.hospital = 'ABBOTT NORTHWESTERN HOSP';
   cllext.searchAcc();

   cllext.searchPhysicians();
    cllext.searchFellows();
    cllext.searchContactsforOtherActivities();
    
   cllext.phyLName = 'TestLastName';
   cllext.phyFName = 'TestFirstName';
   cllext.accName = act.Name;
   cllext.Accid=act.Id;
    Contact con = [select Id from Contact where id=:co.Id];          
   /* Affiliation__c aff = new Affiliation__c();
    aff.Hospital__c =act.Id;
    aff.Physician1__c = con.Id;
    insert aff;*/
    cllext.searchPhysicians();
    cllext.searchFellows();
   
   cllext.showTextBox();
    cllext.setResourceSelected('Territory Manager');
  // cllext.resourceSelected = 'Territory Manager';
   cllext.showTextBox();
   cllext.getResourceSelected();
   
   Product2 prod2 = new Product2();
   prod2.ProductCode = 'BWO-101';
   prod2.Name = 'AVAIL Fixed Curve Diagnostic';
   prod2.Family = 'BWI Other Catheters';
   insert prod2; 
   cllext.getOtherProds();
   
   prod2.Family = 'Competitive Catheters';
   prod2.ProductCode = 'BRD-004';
   update prod2;
   cllext.getCompProds();
   
   
   prod2.Family = 'Technology';
   prod2.ProductCode = 'BWT-001';
   update prod2;
   cllext.getSelectedTechs();  
   
   prod2.Family = 'BWI Ablation Catheters';
   prod2.ProductCode = 'BWA-005';
   update prod2;
   cllext.getCompProds();
   
  
   cllext.getSelectedBWIProds();
   cllext.getResources();
   cllext.getTechs();
   cllext.getBwiProds();
   cllext.getSelectedOtherProds();
   cllext.getSelectedCompProds();
   cllext.Savenew();
   
   cllext.getSelectedBWIProds();
   cllext.getResources();
   cllext.getTechs();
   cllext.getBwiProds();
   cllext.getSelectedOtherProds();
   cllext.getSelectedCompProds();
   
    cllext.save();
   
   
  
   State_City__c s = new State_City__c();
   s.State__c = 'MN';
   
   insert s;
  
   cllext.getStates(); 
  
  
   List<String> tech= new  List<String>();
   tech.add('BWT-001');
   cllext.setSelectedTechs(tech);
   cllext.setSelectedBWIProds (tech);
   cllext.setSelectedCompProds(tech);
   cllext.setSelectedOtherProds(tech);
   cllext.callMe();
  
  
   }
}