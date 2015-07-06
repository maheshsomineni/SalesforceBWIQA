trigger trg_SharingCallsAfterUpdate on Call__c(after update) {
    
    if(trigger.isupdate){
        // Create a new list of sharing objects for Job
        List<Call__Share> jobShrs  = new List<Call__Share>();
        
      
      
    
      
      
        // Declare variables for recruiting and hiring manager sharing
        Call__Share Test;
        
        List<User> lstUsers = [select Id,Department from User where Id IN (select OwnerId from Call__c where ID IN :trigger.newmap.keyset())];
      set<string> lstDepartment = new set<string>();
       
       for(User objUser : lstUsers )
       {
           if(! lstDepartment.contains(objUser.Department)&& (objUser.Department!=null) )
           {
               lstDepartment.add(objUser.Department);
           }
       }
      List<Territory> lstTerritory = [select Id,Name,External_Territory_Id__c,DeveloperName from Territory where External_territory_id__c IN :lstDepartment ];
      
      map<Id,Territory> mapUserTerritory  = new map<Id,Territory>();
      
      
      for(User objUser : lstUsers)
      {
          for(Territory objTerritory : lstTerritory)
          {
              if( objTerritory.External_territory_Id__c == objUser.Department)
              mapUserTerritory.put(objUser.Id,objTerritory);
          }
      }
      
      List<string> lstTerritoryDeveloperNames  = new List<string>();
      for(Territory objTerritory : lstTerritory)
      {
          lstTerritoryDeveloperNames.add(objTerritory.DeveloperName);
      }
    
      
      List<group> lstGroups = [select Id,Name,DeveloperName from Group where Type='Territory' and DeveloperName IN :lstTerritoryDeveloperNames ];
      map<Id,group> mapTerritoryGroup = new map<Id,Group>();
      
      for(Territory objTerritory : lstTerritory)
      {
          for(group objGroup : lstGroups)
          {
              if(objGroup.DeveloperName == objTerritory.DeveloperName)
              {    
                  mapTerritoryGroup.put(objTerritory.Id,objGroup);
              }
          }
      }
      
       
       
        map<id,User> mapOfUser =  new map<id,User>();
        
        for(User ObjUser : lstUsers)
        {
         mapOfUser.put(objUser.Id,objUser);
        }
        
        for(Call__c job : trigger.new){
            
            //get the territoryid of of the opportuity 
                
                User objUser = mapOfUser.get(job.OwnerId);
                
                if(objUser.Department != null && objUser.Department!= '' )
                {
                    
                    
                                 // Instantiate the sharing objects
                        Test = new Call__Share();
                                  
                        // Set the ID of record being shared
                        Test.ParentId = job.Id;
                                  
                        // Set the ID of user or group being granted access
                        Territory objTerritory = mapUserTerritory.get(objUser.Id);
                        
                        if(objTerritory != null)
                        {                        
                               // system.debug('we got value of territory'+objTerritory.Name);
                                group objGroup= mapTerritoryGroup.get(objTerritory.Id);
                                Test.UserOrGroupId =objGroup.Id;  //objUT.TerritoryId;
                                                     
                                // Set the access level
                                Test.AccessLevel = 'read';
                                
                                
                                // Set the Apex sharing reason for hiring manager and recruiter
                                //Test.RowCause = Schema.Call__Share.RowCause.Recruiter__c;
                                 Test.RowCause =Schema.Call__Share.RowCause.sharing_between_territory__c;
                               
                                
                                // Add objects to list for insert
                                jobShrs.add(Test);
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
                    trigger.newMap.get(jobShrs[i].ParentId).
                      addError(
                       'Unable to grant sharing access due to following exception: '
                       + err.getMessage() +  err.getFields() + err.getStatusCode() );
                }
            }
            i++;
        }   
    }
    
}