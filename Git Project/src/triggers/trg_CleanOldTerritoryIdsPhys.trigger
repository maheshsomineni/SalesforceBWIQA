trigger trg_CleanOldTerritoryIdsPhys on Account (before update) {
/*
List<account> lstAccount = new List<account>(); 
for(Account objAccount : trigger.new)
{
    if(objAccount.IsPersonAccount)
    lstAccount.add(objAccount);
}
    List<territory> lstTerritory = [select Id,External_territory_Id__c from Territory];
    map<string,Territory> mapExTrSfdcId = new Map<string,Territory>();
    for(Territory objTerr : lstTerritory )
    {
        mapExTrSfdcId.put(objTerr.External_territory_Id__c,objTerr);
    }
    
    
    for(account objAccount : lstAccount)
    {
        string strToUpdate = '';
        if(objAccount.Territory__c != null)
        {
            string[] arrTrr = objAccount.Territory__c.split(';');        
            
            for(string str : arrTrr)
            {
               if(mapExTrSfdcId.keyset().contains(str))
               {
                   if(strToUpdate != '')
                   strToUpdate = strToUpdate +';' +str;
                   else
                   strToUpdate = str;
               }
               
            }
        }
        objAccount.Territory__c = strToUpdate;
        
    }*/
}