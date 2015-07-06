public class cls_ext_ContactDetails
{
    public Contact objContact  {get;set;}
    public string Id {get;set;}
    public boolean IsContactDetailsVisible {get;set;}
    public  cls_ext_ContactDetails(apexpages.standardcontroller objCon) 
    {
        IsContactDetailsVisible =false;
           
       objContact=  (Contact)objCon.getRecord();
       
        List<Contact> lstCon = [select Id,Name,AccountId from Contact where Id=:objContact.Id  ];
        if(lstCon != null) 
        {
            objContact= lstCon[0];
        } 
        
        //Let's check either currently logged in user is system admin or not. 
        
        IsContactDetailsVisible  =   cls_GetAccountWithSharing.IsCurrenlyLoggedInUserIsAdmin(Userinfo.getprofileId());
        
        if(IsContactDetailsVisible ==false)
        {
            //Currently logged in user is not system admin/ BWI admin 
             
            IsContactDetailsVisible = cls_GetAccountWithSharing.CheckAffiliation(objContact.AccountId,objContact.Id);
        }
        
       
    }
    
    
}