trigger trg_StopDeleteCotnact on Contact(before delete)  {

//not bulkifiying trigger  

   Contact objContact = Trigger.old[0]; 
    
     if(! cls_GetAccountWithSharing.IsCurrenlyLoggedInUserIsAdmin(Userinfo.getprofileId()))
     {
        Contact objContTemp = [select Id,Name,RecordType.Name  from contact where Id=:objContact .Id  limit 1  ];
        
        if(objContTemp.RecordType != null)
        {
            if(objContTemp.RecordType.Name != 'Other')
            {
                objContact.adderror('you cannot delete this contact.');        
            }
        }
        
    }


    


}