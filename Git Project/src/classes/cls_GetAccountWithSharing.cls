public with sharing class cls_GetAccountWithSharing
{
   public static boolean IsCurrenlyLoggedInUserIsAdmin(Id ProfileId) 
   {
       boolean result= false;
       
      set<string> profilenames= new set<string>(); 
      
      //** IMP **// 
      //Later on we will move this strings into custom setting.
      
      profilenames.add('System Administrator');
      profilenames.add('BWI Administrator'); 
      profilenames.add('Fellows Administration'); 
      
     List<Profile> lstProfile = [select Id,Name from Profile where Id=:ProfileId ]; 
     if(lstProfile != null) 
     {
         if(lstProfile.size()>0) 
         {
             if(profilenames.Contains(lstProfile[0].Name))
             result =true;     
         }
     }
     
       
       return result;
   }
    public static boolean CheckAffiliation(Id AccountId,Id ContactId)
    {
        boolean result = false; 
        List<Account> lstAccount = new List<Account>(); 
        
        lstAccount = [select Id,Name from Account where Id=:AccountId ]; 
        
        if(lstAccount.size()>0)
        {
            //Users has access to it. 
            system.debug('Gaurang: ** Got List of Account more than one');
            result=true; 
        }
        else
        {
           //User dont have access directly with Account. 
           //Time to check affiliation. 
           
           
           List<Affiliation__c> lstAff  =[select Id,Name from Affiliation__c where Physician__c=:ContactId ];
           
           if(lstAff != null) 
           {
               if(lstAff.size()>0)
               result=true;
               
           }
        }
        
        
        return result;
        
    }
   
   
}