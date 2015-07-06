public with sharing class CallController{

    ApexPages.StandardController stdController;
    public boolean showios{get;set;}
    public Call__c clls{get;set;}
    public List<Event> evLst {get;set;}
    public List<Event> evLst2 {get;set;}
    public String resourceSelected ;
    public list<Product2> pLst {get;set;}
    public list<Account> aLst {get;set;}
    public String state{get; set;}
    public String city{get; set;}
    public String NewPageId {get;set;}
    public String hospital{get; set;} 
    public String accName{get; set;}
    public String physician{get; set;}
    public Boolean saveAndNew {get;set;}
    public String phyFName{get; set;}
    public String phyLName{get; set;}
    String invalidHospMsg{get;set;}
    String invalidPhyMsg{get;set;}
    String invalidJDENoMsg{get;set;}

    public List<Call__c> cllslst{get;set;}
    public string temp;
    public String Accid{get;set;}
    public Boolean showResults {get; set;}
    public Boolean showError {get; set;}
    public Boolean showResults1 {get; set;}
    public Boolean showPerDiem {get; set;}
    public Boolean isException {get;set;}
    public Boolean isHospSelected {get;set;}
    public Boolean hideCallCredit {get;set;}
    public static String getUserName{get;set;}
    Public String AccountPop {get;set;}
    Public String AccountIdPop {get;set;}
    
           
    public List<Account> acctsList {get; set;}
   
    public List<Affiliation__c> physicianList {get; set;}
    
    List<String> selectedBWIProds = new List<String> ();
    
    List<String> selectedOtherProds  = new List<String> ();
    
    List<String> selectedCompProds  = new List<String> ();
    
    List<String> selectedTechs = new List<String> ();

    public String parentPage{get;set;}
    public Integer flag;
    
  
  
    
    public CallController(ApexPages.StandardController controller) {  
    NewPageId = Apexpages.currentPage().getParameters().get('save_new'); 
    
        
        this.clls = (Call__c)controller.getRecord(); 
        AccountPop = Apexpages.currentPage().getParameters().get('Accountname');
        AccountIdPop = Apexpages.currentPage().getParameters().get('AccountId');
        this.stdController = controller; 
         if(AccountPop!=null)
        {
        clls.Accounts__c = AccountPop;
        clls.AccountId__c = AccountIdpop;
        }
        Id recordId = controller.getId();

       if(recordId == null)
       {
        hideCallCredit = false;
        
        }
     else 
     {
        hideCallCredit = true;
        
     }
     
    

    List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
    String MyProfileName = PROFILE[0].Name;


        
        showPerDiem = false;
        showResults = false;
        showResults1 = false;
        saveAndNew = false;
        showError = false;
        isHospSelected = true;
        getSelectedTechs();     

    
    if(clls != null && clls.Id != null){
        clls = [Select Id ,Actual_Start_Date__c, Travel_Time_HRS__c,JDE_No__c,Case_Type__c,External_Resource_Used__c,JDE_JJHCS_Number__c,Call_Credit__c,Call_Credit_User__c,Call_Credit_Date_Time__c,lastmodifieddate,lastmodifiedby.Name,PhysicianId__c,Procedure_Time_HRS__c,Case_Sub_Type__c, Accounts__c,AccountId__c,Call_Outcome__c ,Physicians__c, Referring_Physician__c, Resource_Name__c, Notes__c,Technology_Type__c,Fellow__c,FellowId__c,Xarelto_Discussion__c from Call__c where id =:clls.Id];
        
        if(Apexpages.currentPage().getParameters().get('clone') == '1')
        {
       clls.Actual_Start_Date__c = null;
      
       
        }
        
       
        
                                      
              if(clls.External_Resource_Used__c=='Per Diem' || clls.External_Resource_Used__c =='Territory Manager'){
             showPerDiem = True;
        }else{
            showPerDiem = False;
        }
          
       }
        productNameIFRAME();
     
    }
    Public string FinalProductName {get;set;}
    Public string FinalOtherBWIName {get;set;}
    Public string FinalCompetetiveName {get;set;}
    Public string FinalTechnoName {get;set;}
    
    //For display the product name on detail page
    Public void productNameIFRAME(){
        List<call__c> CallLst  = new List<call__c>();
         ID Cid = Apexpages.currentPage().getParameters().get('id'); 
         CallLst  = [select Id,BWI_Ablation_Catheter__c,Other_BWI_Catheter__c,Competetive_Products__c,Technology_Type__c from Call__c where id =: Cid ];
         string[] productCode = new string[]{};
         string[] OtherBWI= new string[]{};
         string[] CompetetiveProducts = new string[]{};
         string[] TechnoProducts = new string[]{};
          
         for(call__c cal:CallLst){
           if(cal.BWI_Ablation_Catheter__c != null){
             productCode = cal.BWI_Ablation_Catheter__c.split(';');
          }
         if(cal.Other_BWI_Catheter__c != null){
             OtherBWI = cal.Other_BWI_Catheter__c.split(';');
          }
          if(cal.Competetive_Products__c !=null){
           CompetetiveProducts = cal.Competetive_Products__c.split(';');
          }
          if(cal.Technology_Type__c != null){
            TechnoProducts = cal.Technology_Type__c.split(';');
          }
         }
         if(productCode.size()>0){
         string productName ='';
         for(product2 prod:[Select Name, ProductCode from Product2 where ProductCode  in : productCode]){
            productName = productName + prod.Name+';';
        }
        FinalProductName = productName;
       }
       
        if(OtherBWI.size()>0){
         string OtherBWIName='';
         for(product2 prod:[Select Name, ProductCode from Product2 where ProductCode  in : OtherBWI]){
            OtherBWIName = OtherBWIName + prod.Name+';';
        }
        FinalOtherBWIName = OtherBWIName;
       }
       
       if(CompetetiveProducts.size()>0){
         string CompetetiveName ='';
         for(product2 prod:[Select Name, ProductCode from Product2 where ProductCode  in : CompetetiveProducts]){
            CompetetiveName = CompetetiveName + prod.Name+';';
        }
        FinalCompetetiveName = CompetetiveName;
       }
       
       if(TechnoProducts.size()>0){
         string TechnoName ='';
         for(product2 prod:[Select Name, ProductCode from Product2 where ProductCode  in : TechnoProducts]){
            TechnoName = TechnoName + prod.Name+';';
        }
        FinalTechnoName  = TechnoName ;
       }
      }
   
   
   //Search for Hospital/Account
    public void searchAcc(){
    
        parentPage = Apexpages.currentPage().getParameters().get('comingFrm');
        system.debug('Parent page-->'+parentPage); 
        
        String query = 'Select a.ShippingCity, a.ShippingCountry, a.JDE_JJHCS_Number__c, a.ShippingState, a.ShippingStreet, a.Id, a.Name, a.RecordTypeId, a.RecordType.Id, a.RecordType.Name from Account a where a.RecordType.Name = \'Business Account\' AND Active__c=true ';
        if(!String.isBlank(state) && state != 'None'){
        
             query = query + ' AND a.ShippingState = \'' + state.trim().toUpperCase() + '\'' ;
                   
        }
        
        if(!String.isBlank(city)){
        
             query = query + ' AND a.ShippingCity like  \'%'+ city.trim().toUpperCase() + '%\'' ;
                   
        }
        
        if(!String.isBlank(hospital)){
        
             query = query + ' AND a.Name like \'%' + String.escapeSingleQuotes(hospital.trim().toUpperCase()) + '%\'' ;
          
                   
        }
        acctsList = Database.query(query + ' order by a.Name limit 999');
        if(acctsList.size() > 0){
        
            showResults = true;
            
        }else{
        
            showResults = false;
        }
    }
    

  
    // for Physician/Contact based on selected Hospital/Account
    public void searchFellows(){
    
    isHospSelected = true;
    Accid = ApexPages.currentPage().getParameters().get('accid');
    if(Accid!= null && Accid!='' && !String.isBlank(accName)) // Query only if a hospital is selected
    {                
       
        String query = 'Select a.Id, a.Hospital__r.Name, a.Name, a.Hospital__r.RecordTypeId, a.Physician__r.FirstName, a.Physician__r.LastName, a.Physician__r.Name,a.Physician__r.RecordType.Name,Physician__c from Affiliation__c a where a.Hospital__r.Name != Null AND a.Physician__r.RecordType.Name = \'EP Fellow\' AND a.Hospital__c = \''+ Accid.subString(0,15) +'\'';
        
        if(!String.isBlank(accName)){
          
           query = query +' AND a.Hospital__r.Name like \'%' + String.escapeSingleQuotes(accName.trim().toUpperCase()) + '%\'' ;            
                   
        }
        
        if(!String.isBlank(phyFName)){
        
             query = query + ' AND a.Physician__r.FirstName like \'%' + String.escapeSingleQuotes(phyFName.trim().toUpperCase()) + '%\'' ;
             
                   
        }
        
        if(!String.isBlank(phyLName)){
        
            query = query + ' AND a.Physician__r.LastName like \'%' + String.escapeSingleQuotes(phyLName.trim().toUpperCase()) + '%\'' ;
                   
        }
        
        physicianList = Database.query(query +' order by a.Physician__r.Name limit 999');
     
        if(physicianList.size() > 0){
            showResults1 = true;
            showError = false;
            
        }else{
            showResults1 = false;
            showError = true;
           
        }
      }
      else
          isHospSelected = false; 
   
    }
    public void searchPhysicians(){
    
    isHospSelected = true;
    Accid = ApexPages.currentPage().getParameters().get('accid');
    if(Accid!= null && Accid!='' && !String.isBlank(accName)) // Query only if a hospital is selected
    {                
       
        String query = 'Select a.Id, a.Hospital__r.Name, a.Name, a.Hospital__r.RecordTypeId, a.Physician__r.FirstName, a.Physician__r.LastName, a.Physician__r.Name,a.Physician__r.RecordType.Name,Physician__c from Affiliation__c a where a.Hospital__r.Name != Null AND a.Physician__r.RecordType.Name = \'EP\' AND a.Hospital__c = \''+ Accid.subString(0,15) +'\'';
        
        if(!String.isBlank(accName)){
          
           query = query +' AND a.Hospital__r.Name like \'%' + String.escapeSingleQuotes(accName.trim().toUpperCase()) + '%\'' ;            
                   
        }
        
        if(!String.isBlank(phyFName)){
        
             query = query + ' AND a.Physician__r.FirstName like \'%' + String.escapeSingleQuotes(phyFName.trim().toUpperCase()) + '%\'' ;
             
                   
        }
        
        if(!String.isBlank(phyLName)){
        
            query = query + ' AND a.Physician__r.LastName like \'%' + String.escapeSingleQuotes(phyLName.trim().toUpperCase()) + '%\'' ;
                   
        }
        
        physicianList = Database.query(query +' order by a.Physician__r.Name limit 999');
     
        if(physicianList.size() > 0){
            showResults1 = true;
            showError = false;
            
        }else{
            showResults1 = false;
            showError = true;
           
        }
      }
      else
          isHospSelected = false; 
   
    }
    public void searchContactsforOtherActivities(){
    
    isHospSelected = true;
    Accid = ApexPages.currentPage().getParameters().get('accid');
    if(Accid!= null && Accid!='' && !String.isBlank(accName)) // Query only if a hospital is selected
    {                
       
        String query = 'Select a.Id, a.Hospital__r.Name, a.Name, a.Hospital__r.RecordTypeId, a.Physician__r.FirstName, a.Physician__r.LastName, a.Physician__r.Name,a.Physician__r.RecordType.Name,Physician__c from Affiliation__c a where a.Hospital__r.Name != Null AND a.Hospital__c = \''+ Accid.subString(0,15) +'\'';
        
        if(!String.isBlank(accName)){
          
           query = query +' AND a.Hospital__r.Name like \'%' + String.escapeSingleQuotes(accName.trim().toUpperCase()) + '%\'' ;            
                   
        }
        
        if(!String.isBlank(phyFName)){
        
             query = query + ' AND a.Physician__r.FirstName like \'%' + String.escapeSingleQuotes(phyFName.trim().toUpperCase()) + '%\'' ;
             
                   
        }
        
        if(!String.isBlank(phyLName)){
        
            query = query + ' AND a.Physician__r.LastName like \'%' + String.escapeSingleQuotes(phyLName.trim().toUpperCase()) + '%\'' ;
                   
        }
        
        physicianList = Database.query(query +' order by a.Physician__r.Name limit 999');
     
        if(physicianList.size() > 0){
            showResults1 = true;
            showError = false;
            
        }else{
            showResults1 = false;
            showError = true;
           
        }
      }
      else
          isHospSelected = false; 
   
    }
    
    
    
     public PageReference save() {
     PageReference pf ;
     String temp1 = '';
     invalidHospMsg = null;
     invalidPhyMsg = null;
     invalidJDENoMsg = null;
      List<String> retainTechs = new List<String>();
      List<String> retainBWIProds = new List<String>();
      List<String> retainOtherProds= new List<String>();
      List<String> retainCompProds= new List<String>();
     Id retainId  = apexpages.currentpage().getparameters().get('id');
     if(retainId!=null&&Apexpages.currentPage().getParameters().get('clone') != '1')
     {
     Call__c callstR = [Select c.Id, c.Technology_Type__c,c.BWI_Ablation_Catheter__c,c.Other_BWI_Catheter__c,c.Competetive_Products__c from Call__c c where c.Id =: retainId];
     
           
            if( callstR.Technology_Type__c!=null)
            {
                String[] techArrR = callstR.Technology_Type__c.split(';');
                List<String> techListR = new List<String> ();
                for(integer count=0; count< techArrR.size(); count++){
                
                    techListR.add(techArrR[count]);
                
                }
                
                List<Product2> proListR = [Select Name, ProductCode from Product2 where Family = 'Technology' AND ProductCode in :techListR AND isActive = false];
                for(integer count2=0; count2 < proListR.size(); count2++){
                
                    retainTechs.add(proListR[count2].ProductCode);
                
                }
                
           }
            if( callstR.BWI_Ablation_Catheter__c!=null)
            {
                String[] techArrRBWI = callstR.BWI_Ablation_Catheter__c.split(';');
                List<String> techListRBWI = new List<String> ();
                for(integer count=0; count< techArrRBWI.size(); count++){
                
                    techListRBWI.add(techArrRBWI[count]);
                
                }
                
                List<Product2> proListRBWI = [Select Name, ProductCode from Product2 where Family = 'BWI Ablation Catheters' AND ProductCode in :techListRBWI AND isActive = false];
                for(integer count2=0; count2 < proListRBWI.size(); count2++){
                
                    retainBWIProds.add(proListRBWI[count2].ProductCode);
                
                }
                
           }
           if( callstR.Other_BWI_Catheter__c!=null)
            {
                String[] techArrROther = callstR.Other_BWI_Catheter__c.split(';');
                List<String> techListROther = new List<String> ();
                for(integer count=0; count< techArrROther.size(); count++){
                
                    techListROther.add(techArrROther[count]);
                
                }
                
                List<Product2> proListROther = [Select Name, ProductCode from Product2 where Family = 'BWI Other Catheters' AND ProductCode in :techListROther AND isActive = false];
                for(integer count2=0; count2 < proListROther.size(); count2++){
                
                    retainOtherProds.add(proListROther[count2].ProductCode);
                
                }
                
           }
            if( callstR.Competetive_Products__c !=null)
            {
                String[] techArrRComp = callstR.Competetive_Products__c .split(';');
                List<String> techListRComp = new List<String> ();
                for(integer count=0; count< techArrRComp.size(); count++){
                
                    techListRComp.add(techArrRComp[count]);
                
                }
                
                List<Product2> proListRComp = [Select Name, ProductCode from Product2 where Family = 'Competitive Catheters' AND ProductCode in :techListRComp AND isActive = false];
                for(integer count2=0; count2 < proListRComp.size(); count2++){
                
                    retainCompProds.add(proListRComp[count2].ProductCode);
                
                }
                
           }

     }
      for(String technology :selectedTechs){
              temp1 = temp1 + ';' +technology;
      }
      if(!retainTechs.isempty())
      {
      for(String tech : retainTechs)
      {
             temp1 = temp1 + ';' +tech;
      }
      }
      clls.Technology_Type__c = temp1;
 
      String temp2 = '';
      for(String bwi :selectedBWIProds){
              temp2 = temp2 + ';' +bwi ;   
      }
      if(!retainBWIProds.isempty())
      {
      for(String retainBWI : retainBWIProds)
      {
             temp2 = temp2 + ';' +retainBWI;
      }
      }
      clls.BWI_Ablation_Catheter__c = temp2;
     
      String temp3 = '';
      for(String others :selectedOtherProds){
              temp3 = temp3 + ';' +others ;   
      }
       if(!retainOtherProds.isempty())
      {
      for(String retainOther : retainOtherProds)
      {
             temp3 = temp3 + ';' +retainOther;
      }
      }
      
      clls.Other_BWI_Catheter__c = temp3;
     
      String temp4 = '';
      for(String comps :selectedCompProds){
              temp4 = temp4+ ';' +comps ;   
      }
       if(!retainCompProds.isempty())
      {
      for(String retainComp : retainCompProds)
      {
             temp4 = temp4 + ';' +retainComp;
      }
      }
      
      clls.Competetive_Products__c =temp4 ;
      
      clls.External_Resource_Used__c = this.resourceSelected;
     
      try{
          
          List<Account> actLst = new List<Account>();
          List<Account> AcctLst2= new List<Account>();
          
          actLst =[select id, Name,External_Id__c,JDE_JJHCS_Number__c from Account where Id=:clls.AccountId__c];
        
          List<Call__c> cllsLst = new  List<Call__c>();
          List<Call__c> cllsLst2= new  List<Call__c>();
          if(actLst.size()== 0)
          {                 
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.ERROR, 'Please select valid Hospital Name ');
            invalidHospMsg = myMsg.getDetail();
            ApexPages.addMessage(myMsg);    
            return null;            
          }
          else
          {
            if(clls.JDE_JJHCS_Number__c!=null)
            {
               for(Account acc:actLst)
               {
                 if(clls.JDE_JJHCS_Number__c!=acc.JDE_JJHCS_Number__c)
                 {
                   ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.ERROR, 'Invalid JDE/ JJHCS Number ');
                   invalidJDENoMsg =  myMsg.getDetail();
                   ApexPages.addMessage(myMsg);    
                   return null;   
                 }
               }
            }
          } 
          List<Affiliation__c> AffLst = new  List<Affiliation__c>();
          AffLst = [Select a.Id, a.Hospital__r.Name, a.Name, a.Hospital__r.RecordTypeId, a.Physician__r.FirstName, a.Physician__r.LastName, a.Physician__r.Name from Affiliation__c a where a.Physician__r.Id =:clls.PhysicianId__c];
           
          if(AffLst.size()== 0)
          {                 
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.ERROR, 'Please select valid Physician Name ');
            invalidPhyMsg =  myMsg.getDetail();
            ApexPages.addMessage(myMsg);    
            return null;            
           } 
          if(AffLst.size()!= 0 && actLst.size()!= 0 && Apexpages.currentPage().getParameters().get('clone') == null )
          { 
             for(Account ac :actLst){
              if(clls.AccountId__c == ac.Id){
            
              clls.JDE_No__c = ac.External_Id__c;
              
              }
             } 
           
               upsert clls;
               pf = new PageReference('/'+clls.id);
               User user = [select id from User where id = :UserInfo.getUserId()];
               evLst = new List<Event>();
               String id = Apexpages.currentPage().getParameters().get('id');
               evLst = [select Subject,id,StartDateTime,WhatId,EndDateTime from Event where WhatId =:id];
                
               evLst2 = new List<Event>();
                if(evLst.size()== 0 || id=='' || id==null)
               {
                
                 Event e= new Event();
                 e.Subject='Call';
                 e.OwnerId=user.Id;
                 e.StartDateTime=clls.Actual_Start_Date__c;
                 e.EndDateTime= clls.Actual_Start_Date__c;
                 e.ActivityDateTime=clls.Actual_Start_Date__c;
                 e.Whatid = clls.Id;
                 insert e;   
                
               }else{
            
                 for(Event e :evLst)
                   {
                      e.StartDateTime=clls.Actual_Start_Date__c;
                      e.EndDateTime= clls.Actual_Start_Date__c;
                      e.IsPrivate = false;
                      evLst2.add(e);
                   }
                 update evLst2;
              
               }
         }
         //clone the Call
          else if(Apexpages.currentPage().getParameters().get('clone') == '1' && AffLst.size()!= 0 && actLst.size()!= 0)
          {
              Call__c c =clls.clone(false);
              for(Account ac :actLst){
                  if(c.AccountId__c == ac.Id){
                
                  c.JDE_No__c = ac.External_Id__c;                  
                  
                  }
               }
           
              insert c;
              pf = new PageReference('/'+c.id);
              User user = [select id from User where id = :UserInfo.getUserId()];
              evLst = new List<Event>();
              evLst = [select Subject,id,StartDateTime,WhatId,EndDateTime from Event where WhatId =:c.id];
              evLst2 = new List<Event>();
              if(evLst.size()== 0)
              {
                
                 Event e= new Event();
                 e.Subject='Call';
                 e.OwnerId=user.Id;
                 e.StartDateTime=clls.Actual_Start_Date__c;
                 e.EndDateTime= clls.Actual_Start_Date__c;
                 e.ActivityDateTime=clls.Actual_Start_Date__c;
                 e.Whatid = c.Id;
                 insert e;
              }
              else{
               for(Event e :evLst)
               {
                  e.StartDateTime=clls.Actual_Start_Date__c;
                  e.EndDateTime= clls.Actual_Start_Date__c;
                  evLst2.add(e);
               }
               update evLst2;
             }
          }
               User user = [select id from User where id = :UserInfo.getUserId()];
               evLst = new List<Event>();
               String id = Apexpages.currentPage().getParameters().get('id');
               evLst = [select Subject,id,StartDateTime,WhatId,EndDateTime from Event where WhatId =:clls.id];
               evLst2 = new List<Event>();
               if(evLst.size()== 0 )
               {
                 Event e= new Event();
                 e.Subject='Call';
                 e.OwnerId=user.Id;
                 e.StartDateTime=clls.Actual_Start_Date__c;
                 e.EndDateTime= clls.Actual_Start_Date__c;
                 e.ActivityDateTime=clls.Actual_Start_Date__c;
                 e.Whatid = clls.Id;
                 insert e;    
               }else{
                 for(Event e :evLst)
                   {
                      e.StartDateTime=clls.Actual_Start_Date__c;
                      e.EndDateTime= clls.Actual_Start_Date__c;
                      evLst2.add(e);
                   }
                 update evLst2;
               }
       }catch(dmlException e){
        isException =true;
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, e.getMessage().split(',').get(1).split(':').get(0)));   
        return null;
     }
      if(Apexpages.currentPage().getParameters().get('newAndSave') == 'newAndSave'){
       saveAndNew = true;
      }
     return pf;
    }
    public void showTextBox(){
    
        if(resourceSelected =='Per Diem' || resourceSelected =='Territory Manager'){
             showPerDiem = True;
        }else{
            showPerDiem = False;
            clls.Resource_Name__c ='';
        }
    }
 
    
    public String getResourceSelected(){
        try{
        
            Id id = ApexPages.currentPage().getParameters().get('id');
        
            Call__c callObj = [Select c.Id, c.External_Resource_Used__c from Call__c c where id =:stdController.getRecord().Id];
    
            resourceSelected = callObj.External_Resource_Used__c;
        }catch(Exception e){
        
        
        }
        
        
        return resourceSelected;
    }
    
    public List<SelectOption> getResources() {
            List<SelectOption> resources = new List<SelectOption>();
            resources.add(new SelectOption('',''));
            resources.add(new SelectOption('Per Diem','Per Diem'));
            resources.add(new SelectOption('Territory Manager','Territory Manager'));
            return resources;
    }

    
    public List<SelectOption> getTechs() {
    
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('', '- None -'));

            for (Product2 tech : [Select Name, ProductCode from Product2 where Family = 'Technology' and IsActive=true order by Name]) {
     
                if(tech != null){
                    
                    if(tech.ProductCode != null && tech.Name != null){
                        
                        options.add(new SelectOption(tech.ProductCode ,tech.Name));
                    }
                }
                
            }
       
            return options;
        }
 
   
    public List<SelectOption> getBwiProds() {
           
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('', '- None -'));

            for (Product2 prod_bwi : [Select Name, ProductCode from Product2 where Family = 'BWI Ablation Catheters' AND IsActive=true order by Name]) {
            
                if(prod_bwi != null){
                    if(prod_bwi.ProductCode != null && prod_bwi.Name != null){
                    
                        options.add(new SelectOption(prod_bwi.ProductCode ,prod_bwi.Name));
                       
                    }
                }
            }
            
            return options;
        }
        
        
      
    public List<SelectOption> getOtherProds() {
    
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('', '- None -'));

            for (Product2 prod_other : [Select Name, ProductCode from Product2 where Family = 'BWI Other Catheters' AND IsActive=true order by Name]) {
     
                if(prod_other != null){
                    
                    if(prod_other.ProductCode != null && prod_other.Name != null){
                        
                        options.add(new SelectOption(prod_other.ProductCode ,prod_other.Name));
                    }
                }
            }
            return options;
    }
        
    public List<SelectOption> getCompProds() {
           List<SelectOption> options = new List<SelectOption>();
             options.add(new SelectOption('', '- None -'));
            
            for (Product2 prod_comp : [Select Name, ProductCode from Product2 where Family = 'Competitive Catheters' AND IsActive=true order by Name]) {
     
                if(prod_comp != null){
                    
                    if(prod_comp.ProductCode != null && prod_comp.Name != null){
                        
                        options.add(new SelectOption(prod_comp.ProductCode ,prod_comp.Name));
                    }
                }
                
            }
            return options;
     }
        
    
    public List<String> getSelectedTechs () {
    
       try{
            Call__c calls1 = [Select c.Id, c.Technology_Type__c from Call__c c where c.Id =: stdController.getRecord().Id];
            if( calls1.Technology_Type__c!=null)
            {
                String[] techArr = calls1.Technology_Type__c.split(';');
                List<String> techList = new List<String> ();
                for(integer count=0; count< techArr.size(); count++){
                
                    techList.add(techArr[count]);
                
                }
                
                List<Product2> proList = [Select Name, ProductCode from Product2 where Family = 'Technology' AND ProductCode in :techList];
                for(integer count2=0; count2 < proList.size(); count2++){
                
                    selectedTechs.add(proList[count2].ProductCode);
                
                }
             }  
           }catch(Exception e){
           
           
           }
           return selectedTechs ;
        }


    public List<String> getSelectedBWIProds() {
    
        try{
            Call__c calls1 = [Select c.Id, c.BWI_Ablation_Catheter__c from Call__c c where c.Id =: stdController.getRecord().Id];
            if( calls1.BWI_Ablation_Catheter__c!=null)
            {
                String[] bwiArr = calls1.BWI_Ablation_Catheter__c.split(';');
                List<String> bwiList = new List<String> ();
                for(integer count=0; count< bwiArr.size(); count++){
                
                    bwiList.add(bwiArr[count]);
                
                }
                
                List<Product2> proList = [Select Name, ProductCode from Product2 where Family = 'BWI Ablation Catheters' AND ProductCode in :bwiList];
               
                for(integer count2=0; count2< proList.size(); count2++){
                
                    selectedBWIProds.add(proList[count2].ProductCode);
                }
             }   
         }catch(Exception e){
           
         }
         return selectedBWIProds ;
    }
    
    public List<String> getSelectedOtherProds() {
            
        try{
            Call__c calls1 = [Select c.Id, c.Other_BWI_Catheter__c from Call__c c where c.Id =: stdController.getRecord().Id];
            if(calls1.Other_BWI_Catheter__c !=null)
            {
                String[] otherArr = calls1.Other_BWI_Catheter__c.split(';');
                List<String> otherList = new List<String> ();
                for(integer count=0; count< otherArr.size(); count++){
                
                    otherList.add(otherArr[count]);
                }
                
                List<Product2> proList = [Select Name, ProductCode from Product2 where Family = 'BWI Other Catheters' AND ProductCode in :otherList];
                for(integer count2=0; count2< proList.size(); count2++){
                
                    selectedOtherProds.add(proList[count2].ProductCode);
                }
            }    
        }catch(Exception e){
           
           
        }
        return selectedOtherProds  ;
    }
    
    public List<String> getSelectedCompProds() {
            
          try{
                Call__c calls1 = [Select c.Id, c.Competetive_Products__c from Call__c c where c.Id =: stdController.getRecord().Id];
                if(calls1.Competetive_Products__c !=null)
                {
                    String[] compArr = calls1.Competetive_Products__c.split(';');
                    List<String> compList = new List<String> ();
                    for(integer count=0; count< compArr.size(); count++){
                
                        compList.add(compArr[count]);
                
                    }
    
                    List<Product2> proList = [Select Name, ProductCode from Product2 where Family = 'Competitive Catheters' AND ProductCode in :compList];
                    for(integer count2=0; count2< proList.size(); count2++){
                
                        selectedCompProds.add(proList[count2].ProductCode);
                    }
                }    
           }catch(Exception e){
           
           }
            return selectedCompProds;
    }       
            
     public void setResourceSelected(String resourceSelected) {
            this.resourceSelected  = resourceSelected  ;
    }
    
    public void setSelectedTechs(List<String>  selectedTechs) {
            this.selectedTechs = selectedTechs ;
    }
    
    public void setSelectedBWIProds (List<String>  selectedBWIProds ) {
            this.selectedBWIProds = selectedBWIProds ;
    }
        
         
    public void setSelectedCompProds   (List<String>  selectedCompProds  ) {
            this.selectedCompProds  = selectedCompProds  ;
    }
        
            
    public void setSelectedOtherProds   (List<String>  selectedOtherProds  ) {
            this.selectedOtherProds  = selectedOtherProds  ;
    }
    
  
       public List<SelectOption> getStates() {
           
            List<SelectOption> options = new List<SelectOption>();
            
            List<State_City__c> statesList = [Select State__c from State_City__c ];
 
            statesList.sort(); 
         
            Set<State_City__c> statesSet = new  Set<State_City__c> ();
            List<State_City__c> resultList = new List<State_City__c>();
            options.add(new SelectOption('None' ,'None'));
            for (State_City__c st: statesList) {
            
                if(st != null){
                    if(st.State__c != null){
                        
                        options.add(new SelectOption(st.State__c ,st.State__c));
                    }
                }
            }
            
            return options;
        }
       

       public PageReference callMe(){
            
           this.accName =apexpages.currentpage().getparameters().get('hospName');
           return null;
       }
       public pagereference Savenew(){
           PageReference pf;
           isException=false;
           saveAndNew =true;
           save();
     
           if(isException || invalidHospMsg!= null || invalidPhyMsg!=null || invalidJDENoMsg!=null)
              return pf;   // Return a empty pageReference if there is an exception or any error
           else
               return new PageReference('/'+stdController.getRecord().getSObjectType().getDescribe().getKeyPrefix()+'/e?&returl=/'+stdController.getRecord().getSObjectType().getDescribe().getKeyPrefix());
       
       }
        public pagereference show()
        {
          showios=false;
          return null;
        }
}