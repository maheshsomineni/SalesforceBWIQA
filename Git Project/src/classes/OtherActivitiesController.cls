public with sharing class OtherActivitiesController 
{
    public Other_Activity__c objActivities{get;set;}
    public Boolean isException{get;set;}
    List<Account> accLst{get;set;}
    String invalidHospMsg{get;set;}
    String invalidJDENoMsg{get;set;}
    
    ApexPages.StandardController stdController{get;set;}
    
    public OtherActivitiesController(ApexPages.StandardController controller) 
    {
       this.objActivities = (Other_Activity__c)controller.getRecord(); 
       stdController = controller;
       
       if(objActivities!=null && objActivities.id!=null)
       {
         objActivities = [Select Activity_Report_Date__c,AccountId__c ,Activity_Sub_Type__c,Activity_Time_HRS__c,Activity_Type__c,Comments__c,Hospital__c,Physician__c,PhysicianId__c,JDE_JJHCS_Number__c from Other_Activity__c  where id =: objActivities.id];
         if(Apexpages.currentPage().getParameters().get('clone') == '1')
         {
          objActivities.Activity_Report_Date__c = null;
         }
       }
    }

    public PageReference saveNew()
    {
       PageReference  pf;
       isException=false;
       save();
       if(isException || invalidHospMsg!=null || invalidJDENoMsg!=null)
           return pf;
       else    
           return new PageReference('/'+stdController.getRecord().getSObjectType().getDescribe().getKeyPrefix()+'/e?&returl=/'+stdController.getRecord().getSObjectType().getDescribe().getKeyPrefix());
    }
    
     public PageReference save()
     {
          PageReference pf;
          invalidHospMsg = null;
          invalidJDENoMsg = null;
         try{
             
              accLst =[select id, Name,External_Id__c,JDE_JJHCS_Number__c from Account where (Id =:objActivities.AccountId__c and Name=:objActivities.Hospital__c)];
              if(accLst.size()!= 0 && Apexpages.currentPage().getParameters().get('clone') == null)
              {
                if(objActivities.JDE_JJHCS_Number__c!=null)
                {
                       for(Account acc:accLst)
                       {
                         if(objActivities.JDE_JJHCS_Number__c!=acc.JDE_JJHCS_Number__c) //If the JDE Number entered is not a valid one then display a error message
                         {
                           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.ERROR, 'Invalid JDE/ JJHCS Number ');
                           invalidJDENoMsg =  myMsg.getDetail();
                           ApexPages.addMessage(myMsg);    
                           return null;   
                         }
                       }
                }
                
                
              }
              else if(Apexpages.currentPage().getParameters().get('clone') == '1')
              { 
                        if(accLst.size() == 0 && objActivities.Hospital__c!='' && objActivities.Hospital__c!=null)
                       {
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.ERROR, 'Please select valid Hospital Name ');
                        invalidHospMsg = myMsg.getDetail();
                        ApexPages.addMessage(myMsg);    
                        return null;
                       }  
                       if(objActivities.JDE_JJHCS_Number__c!=null)
                       {
                           for(Account acc:accLst)
                           {
                             if(objActivities.JDE_JJHCS_Number__c!=acc.JDE_JJHCS_Number__c) //If the JDE Number entered is not a valid one then display a error message
                             {
                               ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.ERROR, 'Invalid JDE/ JJHCS Number ');
                               invalidJDENoMsg =  myMsg.getDetail();
                               ApexPages.addMessage(myMsg);    
                               return null;   
                             }
                           }
                        }
                        
                         if((objActivities.Hospital__c =='' || objActivities.Hospital__c == null) && objActivities.AccountId__c!=null)
                          {
                             system.debug('Hospital empty--->');
                              objActivities.AccountId__c ='';
                              objActivities.JDE_JJHCS_Number__c ='';
                          }
                          
                   
                      Other_Activity__c activities =objActivities.clone(false);
                      insert activities;
                      pf = new PageReference('/'+activities.id);
                      return pf;
               }
               else
               {
                  
                  if(accLst.size() == 0 && objActivities.Hospital__c!='' && objActivities.Hospital__c!=null)
                  {
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.ERROR, 'Please select valid Hospital Name ');
                    invalidHospMsg = myMsg.getDetail();
                    ApexPages.addMessage(myMsg);    
                    return null;
                  }    
               }
              
               if((objActivities.Hospital__c =='' || objActivities.Hospital__c == null) && objActivities.AccountId__c!=null)
               {
                  objActivities.AccountId__c ='';
                  objActivities.JDE_JJHCS_Number__c ='';
               }
               upsert this.objActivities;
                pf = new PageReference('/'+objActivities.id); 
              
            }
            catch(DmlException e)
            {  
               isException = true;
               ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, e.getMessage().split(',').get(1).split(':').get(0)));   
               return null;
            }  
            return pf;
    }
    
    public void clearHospitalJDE()
    {
       if(objActivities.Hospital__c!=null && objActivities.Hospital__c!='' && Apexpages.currentPage().getParameters().get('clone') == '1')
       {
         List<Mandatory_Activity_Types__c> lstActTypes = Mandatory_Activity_Types__c.getall().values();  

         for(Integer i=0;i<lstActTypes.size();i++)
         {
            if(lstActTypes[i].Activity_Type__c !=null && !(lstActTypes[i].Activity_Type__c.equalsIgnoreCase(objActivities.Activity_Type__c)))
            {
             
              objActivities.Hospital__c ='';
              objActivities.JDE_JJHCS_Number__c ='';
            }
            
         }
       } 
                      
    }
}