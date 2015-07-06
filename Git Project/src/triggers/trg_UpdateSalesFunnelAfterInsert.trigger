trigger trg_UpdateSalesFunnelAfterInsert on OpportunityLineItem (after Insert) {

 

 
 List<string> lstOppIds =  new List<string>(); 

 set<string> stTerr= new set<string>();
 set<string> stProductTypes= new set<string>();  
 
 map<Id,string> mapOppLineItemProductType  = new Map<Id,String>(); 
 set<string> stProductIds =  new set<string>(); 
 
 
 map<Id,string> mapProductType = new map<Id,string>(); 
 
 try
 {
 for(OpportunityLineItem objLineItem  : Trigger.new) 
 {
     lstOppIds.add(objLineItem.OpportunityId); 
    
     if(!stProductTypes.contains(objLineItem.Product_type__c))
     stProductTypes.add(objLineItem.Product_type__c);
     
     //Adding Product type Disposable,NAV/TX and other combination 
    // system.debug('Gaurang:Product Type of OppLineItem:'+mapProductType.get(objLineItem.id));
    
         if(!stProductTypes.contains('NAV/TX'))
         stProductTypes.add('NAV/TX');
    
    
         if(!stProductTypes.contains('LSS/DX'))
         stProductTypes.add('LSS/DX');
    
     
         if(!stProductTypes.contains('DISPOSABLES'))
         stProductTypes.add('DISPOSABLES');
     
     //Total
     
         if(!stProductTypes.contains('TOTAL'))
         stProductTypes.add('TOTAL');
         
     if(! stProductIds.contains(objLineItem.Id))
        stProductIds.add(objLineItem.Id);
         
       
     
     
 }
 system.debug('Gaurang:we got size of ProductIds'+stProductIds); 
  List<Opportunity> lstOpp =  [select Id,Name,Account.Territory__c,Probability from Opportunity where Id IN : lstOppIds and Isclosed=false ];
  map<Id,Opportunity> mapOppLineOpp = new map<Id,Opportunity>(); 

  for(OpportunityLineItem oopLInternal : [select Id,PricebookEntry.Product2.Product_Type__c from OpportunityLineItem where Id IN : stProductIds])
     {
                //OppLineItem.Product_Type__c= oopLInternal.PricebookEntry.Product2.Product_Type__c;
                if(oopLInternal.Id!=null)
                {
                    mapProductType.put(oopLInternal.Id,oopLInternal.PricebookEntry.Product2.Product_Type__c); 
                
                    if(!stProductTypes.contains(oopLInternal.PricebookEntry.Product2.Product_Type__c))
                     stProductTypes.add(oopLInternal.PricebookEntry.Product2.Product_Type__c);
                 }
     }
 


 for(OpportunityLineItem objLineItem : trigger.new) 
 {
      for(Opportunity objOpp : lstOpp)
      {
          if(objOpp.Id== objLineItem .OpportunityId)
          mapOppLineOpp.put(objLineItem .Id,objOpp);
          
          if(! stTerr.contains(objOpp.Account.Territory__c))
          {
              stTerr.add(objOpp.Account.Territory__c);
             
              string[] arrTerr=objOpp.Account.Territory__c.split('_'); 
              if(arrTerr.size()>2) 
              {
                  stTerr.add(arrTerr[0]); //adding area level info
                  stTerr.add(arrTerr[0]+'_'+arrTerr[1]); //adding Region level 
              }
               if(!stTerr.contains('BWI Admin'))
                 stTerr.add('BWI Admin');
          
          }
          
          
          
          
          
      } 
    
 }
 
 List<sale__c> lstSale= [select Id,Name,Product_Type__c,Territory__c,SalesFunnel__c from Sale__c where Territory__c IN :stTerr and Product_Type__c IN :stProductTypes];
 system.debug('Gaurang list of sale'+ lstSale.size());

 
 for(OpportunityLineItem objOppLineItem : Trigger.New) 
 {
  
     for(Sale__c objsale : lstSale)
     {
    
        Opportunity objOpp =  mapOppLineOpp.get(objOppLineItem.id); 
     
         if(objOpp != null)
         {
             system.debug('Gaurang:got product type from map'+mapProductType.get( objOppLineItem .Id));
             system.debug('Gaurang: product type of sale'+objsale.Product_type__c); 
             system.debug('Gaurang: product type of OppLineItem'+mapProductType.get( objOppLineItem .Id)); 
              
             system.debug('Gaurang:condition for conttains'+(objsale.Product_type__c.contains( mapProductType.get( objOppLineItem.Id))));
             if( IsParentTerritory(objSale.Territory__c,objOpp.Account.Territory__c)   && (objsale.Product_type__c.contains( mapProductType.get( objOppLineItem.Id))))
             {
                 //update 
                 
                   
                 
                 Decimal RiskAdjustedAddOn= (objOppLineItem.TotalPrice * objOpp.Probability /100)  ;
                 system.debug('Gaurang: got value of diff'+RiskAdjustedAddOn);
                
                 objSale.SalesFunnel__c = objSale.SalesFunnel__c + RiskAdjustedAddOn; 
                 
                 
                 
                 
                 
             }
             //updating total.
             if( IsParentTerritory(objSale.Territory__c,objOpp.Account.Territory__c)   && (objsale.Product_type__c =='TOTAL' ))
             {
                 //update 
                
                   Decimal RiskAdjustedAddOn= (objOppLineItem.TotalPrice * objOpp.Probability /100)  ;
                 system.debug('Gaurang: got value of diff'+RiskAdjustedAddOn);
                
                 objSale.SalesFunnel__c = objSale.SalesFunnel__c + RiskAdjustedAddOn; 
                 
                 
                 
                 
                 
             }
             //updating disposal 
              if( IsParentTerritory(objSale.Territory__c,objOpp.Account.Territory__c)   && (objsale.Product_type__c =='DISPOSABLES' ) && (objOppLineItem.Product_type__c!='HSS' ) )
             {
                 //update 
                
                   Decimal RiskAdjustedAddOn= (objOppLineItem.TotalPrice * objOpp.Probability /100)  ;
                 system.debug('Gaurang: got value of diff'+RiskAdjustedAddOn);
                
                 objSale.SalesFunnel__c = objSale.SalesFunnel__c + RiskAdjustedAddOn; 
           
                 
             }
              //updating BWI Admin Normal and Product Combinations.
              //
            //  if( IsParentTerritory(objSale.Territory__c,objOpp.Account.Territory__c)   && (objsale.Product_type__c =='BWI Admin' )  )
              if( (objSale.Territory__c=='BWI Admin') && (objsale.Product_type__c.contains(mapProductType.get( objOppLineItem.id))))
             {
               
                
                  Decimal RiskAdjustedAddOn= (objOppLineItem.TotalPrice * objOpp.Probability /100)  ;
                 system.debug('Gaurang: got value of diff'+RiskAdjustedAddOn);
                
                 objSale.SalesFunnel__c = objSale.SalesFunnel__c + RiskAdjustedAddOn; 
           
                 
             }
             //updating BWI DISPOSABLE
              if( (objSale.Territory__c=='BWI Admin') && (objsale.Product_type__c =='DISPOSABLES' ) && (objOppLineItem.Product_type__c!='HSS'))
             {
                 //update 
                
                   Decimal RiskAdjustedAddOn= (objOppLineItem.TotalPrice * objOpp.Probability /100)  ;
                 system.debug('Gaurang: got value of diff'+RiskAdjustedAddOn);
                
                 objSale.SalesFunnel__c = objSale.SalesFunnel__c + RiskAdjustedAddOn; 
           
                 
             }
              //updating BWI TOTAL
              if( (objSale.Territory__c=='BWI Admin') && (objsale.Product_type__c =='TOTAL' ) )
             {
                 //update 
                
                   Decimal RiskAdjustedAddOn= (objOppLineItem.TotalPrice * objOpp.Probability /100)  ;
                 system.debug('Gaurang: got value of diff'+RiskAdjustedAddOn);
                
                 objSale.SalesFunnel__c = objSale.SalesFunnel__c + RiskAdjustedAddOn; 
           
                 
             }
             
         }
     } 
 }
 update lstSale; 
 }
 catch(Exception e)
 {
  EmailforException.notifyDevelopersOf(e,'trg_UpdateSalesFunnelAfterInsert');
 }
 
 //custom functions starts from here
 public boolean IsParentTerritory(string SaleTerritory,string OppTerritory)
            {
                boolean result= false;
                string[] arrSale = SaleTerritory.split('_'); 
                string[] arrOpp = OppTerritory.split('_');
                if (SaleTerritory == OppTerritory) 
                {
                    result = true;
                }
                else if(arrSale.size()>1 && arrOpp.size()>2) 
                {
                   if((arrSale[0]== arrOpp[0]) &&( arrSale[1] == arrOpp[1])     )
                   {
                       if(arrSale.size()== 2)
                       result=true;
                       
                   }
                   
                }
                else if(arrSale.size()==1 && arrOpp.size()>2)
                {
                    if(arrSale[0]== arrOpp[0])
                    {
                        result = true;
                    }
                }
                return result;
            }

}