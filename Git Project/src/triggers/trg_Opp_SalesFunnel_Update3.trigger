trigger trg_Opp_SalesFunnel_Update3 on OpportunityLineItem (after delete) {
    
    
  /* system.debug('salesfunnel3 trigger got executed.');
    List<string> lstProductTypes =  new List<string>();
    List<string> lstTerritory = new List<string>();
   
        //find out List of Sales where  Product Type = selected product type and T1= T 
       // system.debug('Gaurang: trigger executed for Record'+ Opp.Name); 
       boolean HasTotalAdded = false; 
       boolean HasDisposableAdded = false; 
        
        
        List<OpportunityLineItem> listOppLineItem = trigger.oldmap.values(); 
        system.debug('Gaurang: Map values '+ listOppLineItem );
        
        
        
        for(OpportunityLineItem OppLineItem:Trigger.old )
        {
          
        
            system.debug('we are inside trigger.old');
           
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
           
            Opportunity objOpportunity = [select Id,Name,Account.Territory__c from Opportunity where Id=:OppLineItem.OpportunityId ];
           
           // OpportunityLineItem objOpportunity =[select Id,Opportunity.Account.Territory__c from OpportunityLineItem  where    Id=:OppLineItem.Id and isdeleted =true ];
             lstTerritory.add(objOpportunity.Account.Territory__c);
             
             try
             {
                 string[]  arrTerr = objOpportunity.Account.Territory__c.split('_');
                 
                 if(arrTerr.size()>2)
                 {
                  lstTerritory.add(arrTerr[0]+'_'+ arrTerr[1] );
                   lstTerritory.add(arrTerr[0] );
                  
                 }
             }
             catch(exception ae) 
             {
             }
             
            // lstTerritory.add(OppLineItem.Opportunity.Account.Territory__c);
            // system.debug('we got territory from delete'+OppLineItem.Opportunity.Account.Territory__c);
            // system.debug('we got territory'+OppLineItem.Opportunity.Account.Territory__c);
           // system.debug('Gaurang: '+ objOpportunity.Opportunity.Account.Territory__c);
           
            
        }
        
   
   system.debug('we got list of territory for area'+ lstTerritory);
     List<Sale__c> lstSale = [select Id,Name from Sale__c where territory__c IN :lstTerritory ];
     system.debug('Gaurang from Delete : we found count of lstTerritory'+ lstTerritory.size()); 
       system.debug('Gaurang from Delete:  we found count of lstProductTypes'+ lstProductTypes.size()); 
       system.debug('Gaurang from Delete: we found count of sale'+ lstSale.size()); 
       if(lstSale.size()>0)
       {
           update lstSale ;
       } 
*/
}