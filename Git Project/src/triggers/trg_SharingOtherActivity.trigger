trigger trg_SharingOtherActivity on Other_Activity__c(after insert,after update) {
    
    if(trigger.isInsert || trigger.isupdate ){
        // Create a new list of sharing objects for Job
        List<Other_Activity__Share> jobShrs  = new List<Other_Activity__Share>();

        // Declare variables for recruiting and hiring manager sharing
        Other_Activity__Share Test;
        
      List<User> lstUsers = [select Id,Department from User where Id IN (select OwnerId from Other_Activity__c where ID IN :trigger.newmap.keyset())];
      set<string> lstDepartment = new set<string>();
       
       for(User objUser : lstUsers )
       {
           if(! lstDepartment.contains(objUser.Department)&& (objUser.Department!=null) )
           {
               lstDepartment.add(objUser.Department);
           }
       }
       
       system.debug('Gaurang: before entering into trigger ');
       List<string> lstJDENumbers =  new List<string>();
       for(Other_Activity__c callList : Trigger.new)
        {
       
            lstJDENumbers.add(callList.JDE_JJHCS_Number__c);
            // system.debug('Gaurang : got Territory'+callList.Account_Territory__c); 
        }
        List<Account> lstAccount = [select Id,Name,Territory__c,JDE_JJHCS_Number__c  from Account where JDE_JJHCS_Number__c IN :lstJDENumbers ];
        Map<string,Account> mapJDEAccount = new Map<string,Account>(); 
        for(Account objAccount : lstAccount) 
        {
            mapJDEAccount.put(objAccount.JDE_JJHCS_Number__c , objAccount);
            lstDepartment.add(objAccount.Territory__c);
        } 
        
        
      system.debug('Gaurang : list of territories'+lstDepartment); 
      
      List<Territory> lstTerritory = [select Id,Name,External_Territory_Id__c,DeveloperName from Territory where External_territory_id__c IN :lstDepartment ];
      
      map<Id,Territory> mapUserTerritory  = new map<Id,Territory>();
      
      map<string,account> mapAccountTerritory  = new map<string,Account>([select Territory__c,Id,Name from Account]);
      
      map<string,territory> mapTerrExtId =  new map<string,Territory> (); 
      
      for(Other_Activity__c objOhterActivity : trigger.new)
      {
          for(Territory objTerr : lstTerritory)
          {    
               Account objAccount = mapJDEAccount.get(objOhterActivity.JDE_JJHCS_Number__c); 
               if(objAccount != null) 
               {
                       
                      if(objAccount .Territory__c== objTerr.External_territory_id__c)
                      {
                         
                          mapTerrExtId.put(objAccount .Territory__c, objTerr );
                      }
                   
               }
             
          }
      }
      
      
      
      
      for(User objUser : lstUsers)
      {
          for(Territory objTerritory : lstTerritory)
          {
              if( objTerritory.External_territory_Id__c == objUser.Department)
              {
                  List<Territory> lstTerritoryToAssign =  new List<Territory>(); 
                  lstTerritoryToAssign .add(objTerritory); 
                  
                 
              
              
               mapUserTerritory.put(objUser.Id,objTerritory);   
              }
              
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
      system.debug('Gaurang: value of map'+mapTerritoryGroup);
       
       
        map<id,User> mapOfUser =  new map<id,User>();
        
        for(User ObjUser : lstUsers)
        {
         mapOfUser.put(objUser.Id,objUser);
        }
        
        for(Other_Activity__c job : trigger.new){
            
            //get the territoryid of of the opportuity 
                
                User objUser = mapOfUser.get(job.OwnerId);
                
                
                if(objUser.Department != null && objUser.Department!= '' )
                {
                    
                                 // ------------------------------ Sharing with Secondary Territory ------------------------- 
                                 
                                 Account objAccount = mapJDEAccount.get(job.JDE_JJHCS_Number__c); 
                                 if(objAccount != null) 
                                 {
                                         
                                                     if(objUser.Department != objAccount.Territory__c )
                                             {
                                                 
                                                  Territory objTerritorySec = mapTerrExtId.get(objAccount.Territory__c  ); 
                                                  
                                                 if(objTerritorySec != null)
                                                 {
                                                             Test = new Other_Activity__Share ();
                                                                      
                                                            // Set the ID of record being shared
                                                            Test.ParentId = job.Id;
                                                                      
                                                            // Set the ID of user or group being granted access
                                                           
                                                        
                                                            //system.debug('we got value of territory'+objTerritory.Name);
                                                            system.debug('Gaurang : got TerritoryId' + objTerritorySec.id);
                                                            group objGroup= mapTerritoryGroup.get(objTerritorySec.Id);
                                                            Test.UserOrGroupId =objGroup.Id;  //objUT.TerritoryId;
                                                                                 
                                                            // Set the access level
                                                            Test.AccessLevel = 'read';
                                                            
                                                            
                                                            // Set the Apex sharing reason for hiring manager and recruiter
                                                            //Test.RowCause = Schema.Call__Share.RowCause.Recruiter__c;
                                                             //Test.RowCause =Schema.Call__Share.RowCause.sharing_between_territory__c;
                                                           
                                                            
                                                            // Add objects to list for insert
                                                            jobShrs.add(Test);
                                                 }
                                                      
                                                    
                                                      
                                                 
                                                  
                                               
                                                 
                                             }
                                             
                                             
                                             //--------------------------------end of sharing with secondary territory -------------------
                                 
                                 }
                                 
                    
                    
                               
                        
                               Territory objTerritory = mapUserTerritory.get(objUser.Id); 
                        
                            
                                     if(objTerritory != null)
                                    {
                                        
                                          // Instantiate the sharing objects
                                        Test = new Other_Activity__Share ();
                                                  
                                        // Set the ID of record being shared
                                        Test.ParentId = job.Id;
                                                  
                                        // Set the ID of user or group being granted access
                                       
                                    
                                        //system.debug('we got value of territory'+objTerritory.Name);
                                        group objGroup= mapTerritoryGroup.get(objTerritory.Id);
                                        Test.UserOrGroupId =objGroup.Id;  //objUT.TerritoryId;
                                                             
                                        // Set the access level
                                        Test.AccessLevel = 'read';
                                        
                                        
                                        // Set the Apex sharing reason for hiring manager and recruiter
                                        //Test.RowCause = Schema.Call__Share.RowCause.Recruiter__c;
                                        // Test.RowCause =Schema.Call__Share.RowCause.sharing_between_territory__c;
                                       
                                        
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