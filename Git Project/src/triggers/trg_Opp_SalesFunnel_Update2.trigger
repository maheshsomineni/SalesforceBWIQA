trigger trg_Opp_SalesFunnel_Update2 on OpportunityLineItem (after insert, after update) {
    
    
   
  /* List<string> lstProductTypes =  new List<string>();
    List<string> lstTerritory = new List<string>();
   
        //find out List of Sales where  Product Type = selected product type and T1= T 
       // system.debug('Gaurang: trigger executed for Record'+ Opp.Name); 
       boolean HasTotalAdded = false; 
       boolean HasDisposableAdded = false; 
        for(OpportunityLineItem OppLineItem:Trigger.New )
        {
            lstProductTypes.add('%' +OppLineItem.Product_Type__c+'%');
            if(!HasTotalAdded)
            {
                lstProductTypes.add('%TOTAL%');
                HasTotalAdded=true;
            }
            if( !HasDisposableAdded ) 
            {
              lstProductTypes.add('%DISPOSABLES%');  
              HasDisposableAdded =true;
            }
           
           OpportunityLineItem objOpportunity =[select Id,Opportunity.Account.Territory__c from OpportunityLineItem where Id=:OppLineItem.Id ];
             lstTerritory.add(objOpportunity.Opportunity.Account.Territory__c);
             
             try
             {
                 string[]  arrTerr = objOpportunity.Opportunity.Account.Territory__c.split('_');
                 
                 if(arrTerr.size()>2)
                 {
                  lstTerritory.add(arrTerr[0]+'_'+ arrTerr[1] );
                   lstTerritory.add(arrTerr[0] );
                  
                 }
             }
             catch(exception ae) 
             {
             }
             
             
            system.debug('Gaurang: '+ objOpportunity.Opportunity.Account.Territory__c);
           
            
        }
        
   
     List<Sale__c> lstSale = [select Id,Name from Sale__c where product_type__c LIKE  : lstProductTypes  and territory__c IN :lstTerritory ];
     system.debug('Gaurang: we found count of lstTerritory'+ lstTerritory.size()); 
       system.debug('Gaurang: we found count of lstProductTypes'+ lstProductTypes.size()); 
       system.debug('Gaurang: we found count of sale'+ lstSale.size()); 
       if(lstSale.size()>0)
       {
           update lstSale ;
       } 
*/
}