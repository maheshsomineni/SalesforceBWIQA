//@Gaurang - to make changes on the coding to make it Dynamic

public class cls_ext_UpdateContactNew
{
    public Contact objContact {get;set;}
    public boolean IsContactDetailsVisible {get;set;}
    public boolean IsCardioVisible {get;set;}
    public boolean IsFellowVisible {get;set;}
    public boolean IsEPVisible {get;set;}
    public Id recordtypeids {get;set;}
    public string recordtypename {get;set;}
    public boolean IsOtherVisible {get;set;}
    
    public  cls_ext_UpdateContactNew (apexpages.standardcontroller objCon) 
    {
       objContact =     (Contact)objCon.getRecord();
       String userProfileName = [select u.Profile.Name, id, UserType from User u where u.id = :Userinfo.getUserId()].Profile.Name;
            
       
       
         objContact = [select Id,Practice_Name__c,CreatedById,LastModifiedById,Text__c,Mail__c,Email__c,Privacy_Consent__c,SAFE_HARBOR__c,Opt_In__c,Educational_Opportunities__c,Market_Research_Opportunities__c,Marketing_Sales_Programs__c,New_Product_Releases__c,MobilePhone ,NPI__c,Name,Proctor__c,EP_Profile__c,EP_Employment_Type__c,Year_started_AFIB__c,Year_started_EP__c,Fellowship_Status__c,Competitor_Technology_Used__c,Program_Start_Date__c ,Program_EndDate__c,Cardiology_Fellowship_Program__c,LinkedIn__c,BWI_Technology_Used__c,BWI_Training_Received__c,Program_Name__c,Salutation,Title,FirstName,LastName,Department,Description,LastCURequestDate,LastCUUpdateDate,RecordTypeid,RecordType.Name,AccountId,Phone,AssistantPhone,Email,AssistantName,Email_Status__c,Contact_Type__c,External_Id__c,MailingStreet,OtherStreet,MailingCity,OtherCity,MailingState,OtherState,MailingCountry,OtherCountry,OtherPostalCode,MailingPostalCode from Contact where id=:objCon.getRecord().Id limit 1 ];
        recordtypeids = ApexPages.currentPage().getParameters().get('RecordType');  
        //objContact.recordtypeid = recordtypeids;
       
         map<Id,RecordType> mapRecordType = new map<Id,RecordType>([select Id,Name from RecordType where SobjectType='Contact']);
        
        RecordType r = new RecordType();
        if(recordtypeids  != null )
        {
             r.Id= recordtypeids  ;
             
             RecordType temp = mapRecordType.get(r.Id); 
             r.Name = temp.Name;
             objContact.RecordTypeId=recordtypeids ;
            objContact.RecordType.Name= temp.Name;
        }
        
        
      /*  if(ApexPages.currentPage().getParameters().get('RecordType') != null)
        {
              r  = [Select Name from Recordtype where id =:ApexPages.currentPage().getParameters().get('RecordType') LIMIT 1];
               recordtypename=r.name;
        }*/ 
        
        
    system.debug('Gaurang::** Got recordType'+r.Id);
    //--------------Decide visiblity of Insufficient pri Error----------------------------
    
    
         
         
         IsContactDetailsVisible =false;     
     
       
        //Let's check either currently logged in user is system admin or not. 
        
        IsContactDetailsVisible  =   cls_GetAccountWithSharing.IsCurrenlyLoggedInUserIsAdmin(Userinfo.getprofileId());
        
        if(IsContactDetailsVisible ==false)
        {
            //Currently logged in user is not system admin/ BWI admin 
             
            IsContactDetailsVisible = cls_GetAccountWithSharing.CheckAffiliation(objContact.AccountId,objContact.Id);
        }
    
    //--------------------End of Scope of visibility of error message-------------------------
    
    
    //-------------------------- Decide Visiblity of Section ----------------------------- 
    

         
        IsFellowVisible =false;
         IsEPVisible =false;
          IsOtherVisible =false;
          
         system.debug('Current RecordType Name check' + objContact.RecordType.Name);
            system.debug('Current RecordType Name check111' + recordtypename);
            system.debug('Current RecordType Name check222' + recordtypeids );
            system.debug('Current RecordType Name check333' + r );            
            
       if(objContact.RecordType.Name=='EP')
      //if(objContact.recordtypeid=='012c00000000afJ')

       {
       if(userProfileName == 'Fellows Administration')
       {
         IsContactDetailsVisible = False;
       }
       else
       {
         
          /* IsEPVisible =true;
           IsFellowVisible =true;
           IsCardioVisible = false;*/ 
             IsEPVisible =true;
           IsFellowVisible =false;
           system.debug('EP True Here');
        }
          
       }       
       else if(objContact.RecordType.Name=='EP Fellow')
        //(objContact.recordtypeid=='012c00000000afE')
       {
          /*  IsFellowVisible =true;
            IsEPVisible =false;
            IsCardioVisible = false;*/ 
              IsFellowVisible =true;
            system.debug('EP Fellow True Here');
          
       }       
       else if(objContact.RecordType.Name=='Cardiologist')
        //(objContact.recordtypeid=='012c00000000bsx')
       {
          if(userProfileName == 'Fellows Administration')
       {
         IsContactDetailsVisible = False;
       }
       else
       {
            /*IsFellowVisible =false;
           IsEPVisible =false;
           IsCardioVisible=true;*/ 
             IsCardioVisible=true;
           system.debug('Cardiologist True Here');
        }   
         
       } else if(objContact.RecordType.Name=='Other')
       {
            IsOtherVisible =true;
       }
       
    
    
    //--------------------------End of Section's visibility------------------------------
    
    } 
    
    public PageReference SaveCustom()
    {
                PageReference objRef = new PageReference('/'+objContact.Id);
                try
                {
                       update objContact; 
                       system.debug('RRECORDTYPE NAME' + objContact.RecordType.Name);
                       system.debug('RRECORDTYPE ID' + objContact.recordtypeid);
                       
               }
               catch(Exception ae)
               {
                         ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,ae.getMessage());
                    string mymsg1 = string.valueOf(myMsg);
                    String mymsg2 = mymsg1.substringAfter(';');
                    ApexPages.Message myMsg3 = new ApexPages.Message(ApexPages.Severity.ERROR,mymsg2);
                 
                  ApexPages.addmessage(myMsg3); 
              objRef = null;                   
               }
               
              return objRef;
               
    }
}