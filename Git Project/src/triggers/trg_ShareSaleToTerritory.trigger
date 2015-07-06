trigger trg_ShareSaleToTerritory on Sale__c (after insert, before update) {

if(trigger.isInsert ||trigger.isUpdate  ){
        // Create a new list of sharing objects for Job
        List<Sale__Share> jobShrs  = new List<Sale__Share>();
        
  
        // Declare variables for recruiting and hiring manager sharing
        Sale__Share Test;
        
       /* List<User> lstUsers = [select Id,Department from User where Id IN (select OwnerId from Call__c where ID IN :trigger.newmap.keyset())];
        map<id,User> mapOfUser =  new map<id,User>();
        
        for(User ObjUser : lstUsers)
        {
         mapOfUser.put(objUser.Id,objUser);
        }*/ 
        List<Territory> lstTerritory =  [select Id,Name,External_Territory_Id__c,DeveloperName from Territory  ];
        List<Group> lstGroup = [select Id,DeveloperName from group where Type ='Territory' ];
        map<Id,Territory> mapTerritory = new map<Id,Territory>();
        map<Id,Group> mapGroup =  new map<Id,Group>();
        
        for(Sale__c objSale : trigger.new)
        {
            for(Territory objTerritory :lstTerritory)
            {
                if(objSale.Territory__c != null ) 
                {
                     if(objSale.Territory__c == objTerritory.External_Territory_Id__c)
                     {
                         mapTerritory.put(objSale.Id,objTerritory);
                     } 
                 }
            }
          
        }
        for(Territory objTerritory : mapTerritory.values())
        {
            for(Group objGroup : lstGroup)
            {
               if(objTerritory.DeveloperName == objGroup.DeveloperName)
               {
                   mapGroup.put(objTerritory.Id,objGroup);
               } 
            }
        }
        
        
        for(Sale__c objSale : trigger.new){
            
            //get the territoryid of of the opportuity 
                
             
                        
                                
                                 // Instantiate the sharing objects
                        Test = new Sale__Share();
                                  
                        // Set the ID of record being shared
                        Test.ParentId = objSale.Id;
                                  
                        // Set the ID of user or group being granted access
                      //  Territory objTerritory = [select Id,Name,DeveloperName from Territory where External_Territory_Id__c =:objSale.Territory__c limit 1];
                      
                       Territory objTerritory = mapTerritory.get(objSale.Id);
                    if(objTerritory != null)
                      {
                        system.debug('we got value of territory'+objTerritory.Name);
                       // group objGroup= [select Id from group where DeveloperName=:objTerritory.DeveloperName limit 1];
                       group objGroup= mapGroup.get(objTerritory.Id);
                        Test.UserOrGroupId =objGroup.Id;  //objUT.TerritoryId;
                        
                        
                        // Set the access level
                        Test.AccessLevel = 'read';
                        
                        
                        // Set the Apex sharing reason for hiring manager and recruiter
                        //Test.RowCause = Schema.Call__Share.RowCause.Recruiter__c;
                        // Test.RowCause =Schema.Sale__Share.RowCause.sharing_in_territories__c;
                       
                        
                        // Add objects to list for insert
                        jobShrs.add(Test);
                                
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
                                               &&  err.getMessage().contains('AccessLevel')))
               {
                    // Throw an error when the error is not related to trivial access level.
                    /* trigger.newMap.get(jobShrs[i].ParentId).
                      addError(
                       'Unable to grant sharing access due to following exception: '
                       + err.getMessage() +  err.getFields() + err.getStatusCode() );*/
                        }
            }
            i++;
        }   
    }



}