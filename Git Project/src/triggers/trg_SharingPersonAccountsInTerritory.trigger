trigger trg_SharingPersonAccountsInTerritory on Account(after insert,after update) {
    
    //***** IMPORTANT --- BLANK TRY CATCH 
    
  /* 
     List<AccountShare> jobShrs  = new List<AccountShare>();
        if(trigger.isInsert || trigger.isUpdate ){
        // Create a new list of sharing objects for Job
          
         List<Account> lstAccount = new List<account>(); 
         for(Account objAccount : trigger.new) 
         {
             if(objAccount.IsPersonAccount && objAccount.Territory__c != null )
             lstAccount.add(objAccount);
         }
         set<string> lstTerritories =  new set<string>(); 
         
         for(Account objAccount: lstAccount)
         {
               if(objAccount.Territory__c != null) 
               {
                   if(objAccount.Territory__c.contains(';'))
                   {
                       string[] arrTerr = objAccount.Territory__c.split(';');
                       for(string strTerr : arrTerr)
                       {
                          if(! lstTerritories.contains(strTerr))
                          lstTerritories.add(strTerr);
                       }
                   }  
                   else
                   {
                       if(! lstTerritories.contains(objAccount.Territory__c))
                              lstTerritories.add(objAccount.Territory__c);
                   }         
               }
               
             
         }
         List<Territory> lstTerritory = [select Id,Name,DeveloperName,External_Territory_Id__c from Territory where External_territory_Id__c IN :lstTerritories]; 
           
           
        List<string> lstTerrDeveloperName = new List<string>(); 
       
         for(Territory objTerr : lstTerritory )
         {
             lstTerrDeveloperName.add(objTerr.DeveloperName);
         }  
        
        List<group> lstGroup = [select Id,DeveloperName from Group where type='Territory' and DeveloperName IN :lstTerrDeveloperName ];   
        map<Id,Group> mapTerrGroup = new map<Id,Group>();    
        for(Territory objTerr : lstTerritory)
       {
           for(group  objGroup : lstGroup)
           {
               if(objTerr.DeveloperName== objGroup.DeveloperName)
               {
                   mapTerrGroup.put(objTerr.Id,objGroup);
               }
               
           }
       }
        
            
      
        
        map<string,Territory> mapExtrIdToTerr =  new map<string,Territory>(); 
        for(Territory objTerr : lstTerritory)
        {
            mapExtrIdToTerr.put(objTerr.External_territory_Id__c,objTerr); 
        }
        map<Id,List<Territory>> mapAccountTerr = new map<Id,List<Territory>>(); 
       
        for(Account objAccount : lstAccount) 
        {
            List<Territory> lstTerrPerAccount =  new List<Territory>();
            if(objAccount.Territory__c != null) 
            {
                if(objAccount.Territory__c.contains(';'))
                {
                    string[] arrTerr = objAccount.Territory__c.split(';');
                    for(string strTerr : arrTerr) 
                    {
                        Territory objTerr = mapExtrIdToTerr.get(strTerr);
                        lstTerrPerAccount.add(objTerr);
                    }
                    
                }
                else
                {
                    lstTerrPerAccount.add(mapExtrIdToTerr.get(objAccount.Territory__c));
                }
                
               mapAccountTerr.put(objAccount.Id,lstTerrPerAccount );
                
                
            }
        }
        
             
        
        for(Account job : lstAccount){
   
                
                if(job.Territory__c != null )
                {
                    
                    
                       // Instantiate the sharing objects
                       List<Territory> lstTerr = mapAccountTerr.get(job.Id); 
                       for(Territory objTerr : lstTerr)
                       {
                              AccountShare Test = new AccountShare();
                                          
                                // Set the ID of record being shared
                                Test.AccountId = job.Id;
                                          
                                // Set the ID of user or group being granted access
                                Territory objTerritory = objTerr;
                                if(objTerritory != null){
                                system.debug('we got value of territory'+objTerritory.Name);
                                group objGroup= mapTerrGroup.get(objTerritory.Id);
                                
                                Test.UserOrGroupId =objGroup.Id;  //objUT.TerritoryId;
                                                     
                                
                                
                                
                                jobShrs.add(Test);
                                
                                 }
                           
                       }
                                 
                        
                                
                            
                       
                    
                }
                
            
            
           
            
        }
        
        // Insert sharing records and capture save result 
        // The false parameter allows for partial processing if multiple records are passed 
        // into the operation 
        Database.SaveResult[] lsr = Database.insert(jobShrs,false);
        
        // Create counter
        Integer i=0;
        
        // Process the save results
        for(Database.SaveResult sr : lsr){
            if(!sr.isSuccess()){
                // Get the first save result error
                Database.Error err = sr.getErrors()[0];
                
                // Check if the error is related to a trivial access level
                // Access levels equal or more permissive than the object's default 
                // access level are not allowed. 
                // These sharing records are not required and thus an insert exception is 
                // acceptable. 
                if(!(err.getStatusCode() == StatusCode.FIELD_FILTER_VALIDATION_EXCEPTION  
                                               &&  err.getMessage().contains('AccessLevel'))){
                    // Throw an error when the error is not related to trivial access level.
                    trigger.newMap.get(jobShrs[i].AccountId).
                      addError(
                       'Unable to grant sharing access due to following exception: '
                       + err.getMessage() +  err.getFields() + err.getStatusCode() );
                }
            }
            i++;
        }   
    }
    
    
    */
    
}