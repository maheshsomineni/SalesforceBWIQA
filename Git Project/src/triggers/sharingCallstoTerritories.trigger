trigger sharingCallstoTerritories on Call__c (after insert,after update) {

 List<Call__Share> callstoShare = new List<Call__Share>();
  set<string> territoryCode = new set<string>();
   Call__Share cShare;
   for(Call__c call : Trigger.new)
        {
       
            territoryCode.add(call.Territory__c);
             
        }
  
  List<Territory> territoryList = [select Id,Name,External_Territory_Id__c,DeveloperName from Territory where External_territory_id__c IN :territoryCode];
  
   map<string,territory> mapTerritories =  new map<string,Territory> (); 
      
      for(Call__c  objCall : trigger.new)
      {
       
          for(Territory objTerr : territoryList )
          {
                 
              if(objCall.Territory__c == objTerr.External_territory_id__c)
              {
              
                  mapTerritories .put(objCall.Territory__c, objTerr );
                 
              }
          }
      }
      
      List<string> lstTerritoryDeveloperNames  = new List<string>();
      for(Territory objTerritory : territoryList )
      {
          lstTerritoryDeveloperNames.add(objTerritory.DeveloperName);
      }
    
      
      List<group> lstGroups = [select Id,Name,DeveloperName from Group where Type='Territory' and DeveloperName IN :lstTerritoryDeveloperNames ];
      map<String,group> mapTerritoryGroup = new map<String,Group>();
      
        for(Territory objTerritory : territoryList)
          {
          for(group objGroup : lstGroups)
          {
              if(objGroup.DeveloperName == objTerritory.DeveloperName)
              {    
                  mapTerritoryGroup.put(objTerritory.External_Territory_Id__c,objGroup);
              }
          }
      }
      
      for(Call__c callshare : trigger.new){
      
      cShare = new Call__Share();
      
      // Set the ID of record being shared.
      cShare .ParentId = callshare .Id;
      
       // Set the ID of user or group being granted access.
       
      Group objGroup= mapTerritoryGroup.get(callshare.territory__c);
      cShare.UserOrGroupId = objGroup.Id;
      
      // Set the access level.
      cShare.AccessLevel = 'Read';
        
      // Set rowCause to 'manual' for manual sharing.
      // This line can be omitted as 'manual' is the default value for sharing objects.
      cShare.RowCause = Schema.Call__Share.RowCause.sharing_between_territory__c;
      
      callstoShare.add(cShare);
      
      }
      
      // Insert the sharing record and capture the save result. 
      // The false parameter allows for partial processing if multiple records passed 
      // into the operation.
      Database.SaveResult[] csr = Database.insert(callstoShare,false);
      
          // Create counter
        Integer i=0;
        
        // Process the save results
        for(Database.SaveResult sr : csr){
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
                    trigger.newMap.get(callstoShare[i].ParentId).
                      addError(
                       'Unable to grant sharing access due to following exception: '
                       + err.getMessage() +  err.getFields() + err.getStatusCode() );
                }
            }
            i++;
        }   
    }