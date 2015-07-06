trigger trg_StopUpdatingContact on Contact (before update,before delete) {


    //*** MUST READ ** before editing.
    //purpose of the trigger is to stop updating contact with CAS,RBD and other Territory level profile. 
    //Also, we are not bulkifying this trigger to keep in mind that, bulk operation will be initated by integration/Admin users only. 
    
    
    //check the currently logged in user's profile.
    if(Trigger.isUpdate)
    {
    if(! cls_GetAccountWithSharing.IsCurrenlyLoggedInUserIsAdmin(Userinfo.getProfileId()))
    {
        
       Contact objContact = Trigger.New[0]; 
       
       Contact objContact1= [select Id,Name,AccountId from contact where Id=:objContact.Id];
       
       if(! cls_GetAccountWithSharing.CheckAffiliation(objContact1.AccountId,objContact1.Id)) 
       objContact.addError('Oops ! you do not have edit permission on this record, please contact administrator.');
           
        
    }
    }
    else if(Trigger.isDelete)
    {
      if(! cls_GetAccountWithSharing.IsCurrenlyLoggedInUserIsAdmin(Userinfo.getProfileId()))
    {
        
       Contact objContact = Trigger.Old[0]; 
       
       Contact objContact1= [select Id,Name,AccountId from contact where Id=:objContact.Id];
       
       if(! cls_GetAccountWithSharing.CheckAffiliation(objContact1.AccountId,objContact1.Id)) 
       objContact.addError('Oops ! you do not have delete permission on this record, please contact administrator.');
           
        
    }
    }
    

}