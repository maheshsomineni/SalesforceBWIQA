trigger trg_UpdateSalesFunnelWhenClosed on Opportunity (after update) {

//description 
//when opportunity stage is changed from open to close,we need to update salesfunnel also. 
if(Trigger.new.size()<=1)
{
List<Id> lstId = new List<Id>(); 

Map<Id,Decimal> OppProbablity=  new Map<Id,Decimal>();
try
{
for(Opportunity objOpp : Trigger.New) 
{
    Opportunity OldOpp = Trigger.OldMap.get(objOpp.Id); 
    system.debug('Gaurang: got old & new Closed status '+ objOpp.IsClosed + OldOpp.IsClosed);
    if((OldOpp.IsClosed == false) &&( objOpp.IsClosed==true))
    {
        lstId.Add(objOpp.id);
    }
    OppProbablity.put(OldOpp.Id,OldOpp.probability);
}
//got the id for Opportunity list  
system.debug('Gaurang: get size of OppList'+lstId.size());
List<Opportunity> lstOppTemp = [select Id,Name ,Account.Territory__c, (select Id,Product_type__c,OpportunityId,TotalPrice from OpportunityLineItems ) from Opportunity where id IN : lstId and IsClosed=true ];

List<OpportunityLineItem> lstOppLineItem = new List<OpportunityLineItem>(); 

for(Opportunity objOpp : lstOppTemp ) 
{
    for(OpportunityLineItem objLineItem : objOpp.OpportunityLineItems)
    {
        lstOppLineItem.add(objLineItem);
    }
}

//*********************** Code start for updating *************************************

List<string> lstOppIds =  new List<string>(); 

 set<string> stTerr= new set<string>();
 set<string> stProductTypes= new set<string>();  
 for(OpportunityLineItem objLineItem  : lstOppLineItem) 
 {
     lstOppIds.add(objLineItem.OpportunityId); 
    
     if(!stProductTypes.contains(objLineItem.Product_type__c))
     stProductTypes.add(objLineItem.Product_type__c);
     
     //Adding Product type Disposable,NAV/TX and other combination 
     if(objLineItem.Product_Type__c =='NAV' || objLineItem.Product_type__c =='TX')
     {
         if(!stProductTypes.contains('NAV/TX'))
         stProductTypes.add('NAV/TX');
     }
     //LSS/DX
     if(objLineItem.Product_Type__c =='LSS' || objLineItem.Product_type__c =='DX')
     {
         if(!stProductTypes.contains('LSS/DX'))
         stProductTypes.add('LSS/DX');
     }
      //LSS/DX
     if(! (objLineItem.Product_Type__c =='HSS') )
     {
         if(!stProductTypes.contains('DISPOSABLES'))
         stProductTypes.add('DISPOSABLES');
     }
     //Total
     
         if(!stProductTypes.contains('TOTAL'))
         stProductTypes.add('TOTAL');
    
     
     
 }
 
 List<Opportunity> lstOpp =  [select Id,Name,Account.Territory__c,Probability from Opportunity where Id IN : lstOppIds and IsClosed=true ];
 map<Id,Opportunity> mapOppLineOpp = new map<Id,Opportunity>(); 
 

 for(OpportunityLineItem objLineItem : lstOppLineItem) 
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
 
 Map<Id,Decimal> mapLineItem  = new map<Id,Decimal>(); 
 for(Opportunity objLine : Trigger.Old)
 {
     mapLineItem.put(objLine.Id, objLine.probability); 
 }
 
 for(OpportunityLineItem objOppLineItem : lstOppLineItem) 
 {
  
     for(Sale__c objsale : lstSale)
     {
    
        Opportunity objOpp =  mapOppLineOpp.get(objOppLineItem.id); 
     
         if(objOpp != null)
         {
             if( IsParentTerritory(objSale.Territory__c,objOpp.Account.Territory__c)   && objsale.Product_type__c.contains(objOppLineItem .Product_type__c))
             {
                 //update 
                 system.debug('Gaurang: we are inside updating sale');
                    Decimal OldProb       = mapLineItem.get(objOpp .id);
                    //system.debug('Gaurang: got value of Old Total Price'+ objOldOppLineItem.TotalPrice + 'for Territory'+ objSale.Territory__c  );
                    system.debug('Gaurang****: got value of New Total Price'+ objOppLineItem.TotalPrice+ 'for Territory'+ objSale.Territory__c + 'Prorabability'+ OldProb   );
                 Decimal RiskAdjustedDiff=   (objOppLineItem.TotalPrice * OldProb /100);
                 system.debug('Gaurang: got value of diff'+RiskAdjustedDiff );
                
                 objSale.SalesFunnel__c = objSale.SalesFunnel__c - RiskAdjustedDiff; 
                 
                 
                 
                 
                 
             }
             //updating total.
             if( IsParentTerritory(objSale.Territory__c,objOpp.Account.Territory__c)   && (objsale.Product_type__c =='TOTAL' ))
             {
                 //update 
                
                    system.debug('Gaurang: we are inside updating sale');
                    Decimal OldProb       = mapLineItem.get(objOpp .id);
                    //system.debug('Gaurang: got value of Old Total Price'+ objOldOppLineItem.TotalPrice + 'for Territory'+ objSale.Territory__c  );
                    system.debug('Gaurang****: got value of New Total Price'+ objOppLineItem.TotalPrice+ 'for Territory'+ objSale.Territory__c + 'Prorabability'+ OldProb   );
                 Decimal RiskAdjustedDiff=   (objOppLineItem.TotalPrice * OldProb /100);
                 system.debug('Gaurang: got value of diff'+RiskAdjustedDiff );
                
                 objSale.SalesFunnel__c = objSale.SalesFunnel__c - RiskAdjustedDiff; 
                 
                 
                 
                 
                 
             }
             //updating disposal 
              if( IsParentTerritory(objSale.Territory__c,objOpp.Account.Territory__c)   && (objsale.Product_type__c =='DISPOSABLES' ) && (objOppLineItem.Product_type__c!='HSS' ) )
             {
                 //update 
                   system.debug('Gaurang: we are inside updating sale');
                    Decimal OldProb       = mapLineItem.get(objOpp .id);
                    //system.debug('Gaurang: got value of Old Total Price'+ objOldOppLineItem.TotalPrice + 'for Territory'+ objSale.Territory__c  );
                    system.debug('Gaurang****: got value of New Total Price'+ objOppLineItem.TotalPrice+ 'for Territory'+ objSale.Territory__c + 'Prorabability'+ OldProb   );
                 Decimal RiskAdjustedDiff=   (objOppLineItem.TotalPrice * OldProb /100);
                 system.debug('Gaurang: got value of diff'+RiskAdjustedDiff );
                
                 objSale.SalesFunnel__c = objSale.SalesFunnel__c - RiskAdjustedDiff; 
           
                 
             }
              //updating BWI Admin Normal and Product Combinations.
              //
            //  if( IsParentTerritory(objSale.Territory__c,objOpp.Account.Territory__c)   && (objsale.Product_type__c =='BWI Admin' )  )
              if( (objSale.Territory__c=='BWI Admin') && (objsale.Product_type__c.contains(objOppLineItem .Product_type__c)))
             {
                 //update 
                   system.debug('Gaurang: we are inside updating sale');
                    Decimal OldProb       = mapLineItem.get(objOpp .id);
                    //system.debug('Gaurang: got value of Old Total Price'+ objOldOppLineItem.TotalPrice + 'for Territory'+ objSale.Territory__c  );
                   system.debug('Gaurang****: got value of New Total Price'+ objOppLineItem.TotalPrice+ 'for Territory'+ objSale.Territory__c + 'Prorabability'+ OldProb   );
                 Decimal RiskAdjustedDiff=   (objOppLineItem.TotalPrice * OldProb /100);
                 system.debug('Gaurang: got value of diff'+RiskAdjustedDiff );
                
                 objSale.SalesFunnel__c = objSale.SalesFunnel__c - RiskAdjustedDiff; 
                 
             }
             //updating BWI DISPOSABLE
              if( (objSale.Territory__c=='BWI Admin') && (objsale.Product_type__c =='DISPOSABLES' ) && (objOppLineItem.Product_type__c!='HSS'))
             {
                 //update 
                
                      system.debug('Gaurang: we are inside updating sale');
                    Decimal OldProb       = mapLineItem.get(objOpp .id);
                    //system.debug('Gaurang: got value of Old Total Price'+ objOldOppLineItem.TotalPrice + 'for Territory'+ objSale.Territory__c  );
                    system.debug('Gaurang****: got value of New Total Price'+ objOppLineItem.TotalPrice+ 'for Territory'+ objSale.Territory__c + 'Prorabability'+ OldProb   );
                 Decimal RiskAdjustedDiff=   (objOppLineItem.TotalPrice * OldProb /100);
                 system.debug('Gaurang: got value of diff'+RiskAdjustedDiff );
                
                 objSale.SalesFunnel__c = objSale.SalesFunnel__c - RiskAdjustedDiff; 
           
                 
             }
              //updating BWI TOTAL
              if( (objSale.Territory__c=='BWI Admin') && (objsale.Product_type__c =='TOTAL' ) )
             {
                 //update 
                
                    system.debug('Gaurang: we are inside updating sale');
                    Decimal OldProb       = mapLineItem.get(objOpp .id);
                    //system.debug('Gaurang: got value of Old Total Price'+ objOldOppLineItem.TotalPrice + 'for Territory'+ objSale.Territory__c  );
                    system.debug('Gaurang****: got value of New Total Price'+ objOppLineItem.TotalPrice+ 'for Territory'+ objSale.Territory__c + 'Prorabability'+ OldProb   );
                 Decimal RiskAdjustedDiff=   (objOppLineItem.TotalPrice * OldProb /100);
                 system.debug('Gaurang: got value of diff'+RiskAdjustedDiff );
                
                 objSale.SalesFunnel__c = objSale.SalesFunnel__c - RiskAdjustedDiff; 
                 
             }
             
         }
     } 
 }
 update lstSale; 
 }
 catch(Exception e)
 {
   EmailforException.notifyDevelopersOf(e,'trg_UpdateSalesFunnelWhenClosed');
 }
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

//*********************** End code for updating ****************************************



}