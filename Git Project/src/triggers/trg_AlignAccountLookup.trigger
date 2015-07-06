trigger trg_AlignAccountLookup on SalesByAccount__c (before insert,before update) {


    List<string> lstExternalId = new List<string>();
    for(SalesByAccount__c objSalesByAccount : trigger.new)
    {
      lstExternalId.add(objSalesByAccount.ExternalAccountID__c);
    }
    
    List<Account> lstAccount = [select Id,Name,External_Id__c from account where External_Id__c IN :lstExternalId ];
    Map<string,Id> mapAccount = new map<string,Id>();
    for(SalesByAccount__c objSalesByAccount : trigger.new)
    {
         for(Account objAccount : lstAccount)
         {
             if(objAccount.External_Id__c  == objSalesByAccount.ExternalAccountID__c)
             {
                  if(! mapAccount.keyset().contains(objAccount.External_Id__c))
                  {
                   mapAccount.put(objAccount.External_Id__c,objAccount.Id);
                  }
                  
             }
           
         }
    }
    
    for(SalesByAccount__c objSales : trigger.new)
    {
        objSales.Account__c =  mapAccount.get(objSales.ExternalAccountID__c) ;
    }
    
    

}