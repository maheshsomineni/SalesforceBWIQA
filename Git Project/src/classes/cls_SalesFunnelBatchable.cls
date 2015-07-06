global class cls_SalesFunnelBatchable implements Database.Batchable<SObject>
{
    
 //  string query='select Id,Name,Account.Territory__c,Risk_Adjusted_Opportunity_del__c ,Probability,(select Id,Product_Type__c,TotalPrice  from OpportunityLineItems where Product_Type__c!=null  ) from Opportunity where IsClosed=False';
  string query='';
  public cls_SalesFunnelBatchable(string strquery)
  {
     query = strquery;
  }
    global Database.QueryLocator start(Database.BatchableContext BC){
      
      List<sale__c> lstSale = [select Id,Name,SalesFunnel__c from sale__c ]; 
      for(Sale__c objSale:lstSale) 
      {
         objSale.SalesFunnel__c=0; 
      }
      update lstSale;
      
      return Database.getQueryLocator(query);
   }
   
   
   global void execute(Database.BatchableContext BC, List<Opportunity> scope){
     /*for(sobject s : scope){
     s.put(Field,Value); 
     }
     update scope;*/ 
     
     set<string> stTerritories =  new set<string>(); 
     set<string> stProductTypes= new set<string>(); 
     Map<string,decimal> mapSaelsFunnel = new map<string,decimal>(); 
     string key = ''; 
     for(Opportunity objOpp : scope)
     {
         for(OpportunityLineItem objLineItem : objOpp.OpportunityLineItems)
         {
            
            
            
             key=objLineItem.Product_Type__c+'_'+objOpp.Account.Territory__c; 
          
              if(! mapSaelsFunnel .keyset().contains(key))
              {
                  mapSaelsFunnel .put(key, ((objLineItem .TotalPrice * objOpp.Probability)/100  )  );
              }
              else
              {
                  Decimal ExistingRiskAdjusted = mapSaelsFunnel.get(key);
                   ExistingRiskAdjusted = ExistingRiskAdjusted + ((objLineItem .TotalPrice * objOpp.Probability)/100 );
                   mapSaelsFunnel .put(key, ExistingRiskAdjusted );
                   
              }
              
              //Add Child Territories Code 
              // ******************************** code started to update combination ********************* 
              
              //************ starting updating Disposable *****************************************
              
                   string DispoKey='DISPOSABLES'+'_'+ objOpp.Account.Territory__c;
                        if(objLineItem.Product_type__c !='HSS' )
                        {
                             if(! mapSaelsFunnel.keyset().contains(DispoKey))
                                mapSaelsFunnel .put(DispoKey, ((objLineItem .TotalPrice * objOpp.Probability  )/100)  );
                              else
                              {
                                  Decimal value= mapSaelsFunnel.get(DispoKey);
                                  value= value + ((objLineItem .TotalPrice * objOpp.Probability)/100);
                                  mapSaelsFunnel .put(DispoKey, value);
                                  
                              }
                            
                            
                        }
              
              
              //*************End of updating Disposable *******************************************
              
              
                //************ starting updating TOTAL *****************************************
              
                       string TOTALKey='TOTAL'+'_'+ objOpp.Account.Territory__c;
                        
                             if(! mapSaelsFunnel.keyset().contains(TOTALKey))
                                mapSaelsFunnel .put(TOTALKey, ((objLineItem .TotalPrice * objOpp.Probability  )/100)  );
                              else
                              {
                                  Decimal value= mapSaelsFunnel.get(TOTALKey);
                                  value= value + ((objLineItem .TotalPrice * objOpp.Probability)/100);
                                  mapSaelsFunnel .put(TOTALKey, value);
                                  
                              }
                            
                            
                       
              
              
              //*************End of updating TOTAL *******************************************
              
                   string[] arrProductTypes = new string[] {'NAV/TX','LSS/DX' };
                 
                      for(string type : arrProductTypes ) 
                      {
                         string ComKey=type+'_'+ objOpp.Account.Territory__c;
                        if(type.contains(objLineItem.Product_type__c))
                        {
                             if(! mapSaelsFunnel.keyset().contains(ComKey))
                                mapSaelsFunnel .put(ComKey, ((objLineItem .TotalPrice * objOpp.Probability  )/100)  );
                              else
                              {
                                  Decimal value= mapSaelsFunnel.get(ComKey);
                                  value= value + ((objLineItem .TotalPrice * objOpp.Probability)/100);
                                  mapSaelsFunnel .put(ComKey, value);
                                  
                              }
                            
                            
                        }
                      }
              
              
             //*********************************** end of code to update combination **********************
              
              string[] arrChild = objOpp.Account.Territory__c.split('_'); 
              if(arrChild.size()>=3) 
              {
                  //updating are level information
                  string RegionKey='';
                  string AreaKey=''; 
                  RegionKey= objLineItem .Product_Type__c+ '_' +arrChild[0]+'_'+arrChild[1];
                  AreaKey= objLineItem .Product_Type__c+ '_' +arrChild[0];
                  if(! mapSaelsFunnel.keyset().contains(RegionKey))
                    mapSaelsFunnel .put(Regionkey, ((objLineItem .TotalPrice * objOpp.Probability  )/100)  );
                  else
                  {
                      Decimal value= mapSaelsFunnel.get(RegionKey);
                      value= value + ((objLineItem .TotalPrice * objOpp.Probability) /100);
                      mapSaelsFunnel .put(Regionkey, value );
                      
                  }
                  
                  //Disposable calculation for Disposables Region
                      string DispoKeyRegion='DISPOSABLES'+'_'+ arrChild[0]+'_'+arrChild[1];
                        if(objLineItem.Product_type__c !='HSS' )
                        {
                             if(! mapSaelsFunnel.keyset().contains(DispoKeyRegion))
                                mapSaelsFunnel .put(DispoKeyRegion, ((objLineItem .TotalPrice * objOpp.Probability  )/100)  );
                              else
                              {
                                  Decimal value= mapSaelsFunnel.get(DispoKeyRegion);
                                  value= value + ((objLineItem .TotalPrice * objOpp.Probability)/100);
                                  mapSaelsFunnel .put(DispoKeyRegion, value);
                                  
                              }
                            
                            
                        }
                        
                       //Disposable calculation for Area
                      string DispoKeyArea='DISPOSABLES'+'_'+  arrChild[0];
                        if(objLineItem.Product_type__c !='HSS' )
                        {
                             if(! mapSaelsFunnel.keyset().contains(DispoKeyArea))
                                mapSaelsFunnel .put(DispoKeyArea, ((objLineItem .TotalPrice * objOpp.Probability  )/100)  );
                              else
                              {
                                  Decimal value= mapSaelsFunnel.get(DispoKeyArea);
                                  value= value + ((objLineItem .TotalPrice * objOpp.Probability)/100);
                                  mapSaelsFunnel .put(DispoKeyArea, value);
                                  
                              }
                            
                            
                        } 
                    //Calculating TOTAL for Region    
                    string TOTALKeyRegion='TOTAL'+'_'+ arrChild[0]+'_'+arrChild[1];
                       
                             if(! mapSaelsFunnel.keyset().contains(TOTALKeyRegion))
                                mapSaelsFunnel .put(TOTALKeyRegion, ((objLineItem .TotalPrice * objOpp.Probability  )/100)  );
                              else
                              {
                                  Decimal value= mapSaelsFunnel.get(TOTALKeyRegion);
                                  value= value + ((objLineItem .TotalPrice * objOpp.Probability)/100);
                                  mapSaelsFunnel .put(TOTALKeyRegion, value);
                                  
                              }
                            
                            
                       
                        //Calculating TOTAL for Area   
                    string TOTALKeyArea='TOTAL'+'_'+ arrChild[0];
                        
                             if(! mapSaelsFunnel.keyset().contains(TOTALKeyArea))
                                mapSaelsFunnel .put(TOTALKeyArea, ((objLineItem .TotalPrice * objOpp.Probability  )/100)  );
                              else
                              {
                                  Decimal value= mapSaelsFunnel.get(TOTALKeyArea);
                                  value= value + ((objLineItem .TotalPrice * objOpp.Probability)/100);
                                  mapSaelsFunnel .put(TOTALKeyArea, value);
                                  
                              }
                            
                            
                             
                        
                  
                  
                  
                   //updating area level information 
                  if(! mapSaelsFunnel.keyset().contains(AreaKey))
                    mapSaelsFunnel .put(AreaKey, ((objLineItem .TotalPrice * objOpp.Probability  )/100)  );
                  else
                  {
                      Decimal value= mapSaelsFunnel.get(AreaKey);
                      value= value + ((objLineItem .TotalPrice * objOpp.Probability)/100);
                      mapSaelsFunnel .put(AreaKey, value);
                      
                  }
                  
                 
                  
                  
                  //Updating combination of product type. 
                   //string[] arrProductTypes = new string[] {'NAV/TX','LSS/DX' };
                   string[] arrTerrToIterate = new string[] {arrChild[0],arrChild[0]+'_'+arrChild[1] };
                 
                   for(string Terr : arrTerrToIterate ) 
                   {
                       for(string type : arrProductTypes ) 
                      {
                         string ComKey=type+'_'+ Terr ;
                        if(type.contains(objLineItem.Product_type__c))
                        {
                             if(! mapSaelsFunnel.keyset().contains(ComKey))
                                mapSaelsFunnel .put(ComKey, ((objLineItem .TotalPrice * objOpp.Probability  )/100)  );
                              else
                              {
                                  Decimal value= mapSaelsFunnel.get(ComKey);
                                  value= value + ((objLineItem .TotalPrice * objOpp.Probability)/100);
                                  mapSaelsFunnel .put(ComKey, value);
                                  
                              }
                            
                            
                        }
                      }
                           
                   }
                      
                     
                  
                  
                    
                  
              }
              
             
              
         
         }
     }
     
     List<Sale__c> lstSale = [select Id,Name,Product_type__c,Territory__c,SalesFunnel__c from sale__c]; 
     List<Sale__c> lstSaleToUpdate = new List<Sale__c>(); 
     for(sale__c objSale : lstSale)
     {
         key = objSale.Product_Type__c+'_'+objSale.Territory__c; 
         
         Decimal dcSalesFunnel  = mapSaelsFunnel.get(key); 
         if(dcSalesFunnel  != null) 
         {
             if(objSale.SalesFunnel__c != null) 
             objSale.SalesFunnel__c = objSale.SalesFunnel__c  +  dcSalesFunnel  ; 
             else            
             objSale.SalesFunnel__c= dcSalesFunnel  ; 
             lstSaleToUpdate.add(objSale);
             
         }
         
         
         
     } 
     update lstSaleToUpdate ; 
     
     
     
     
    }
   
   global void finish(Database.BatchableContext info){     
       
       
        List<Sale__c> lstBWISale= [select Id,Name,Territory__c,Product_type__c from Sale__c where Territory__c='BWI Admin']; 
        List<Sale__c> lstAreaSale = [select Id,Name,Product_Type__c,SalesFunnel__c,Territory__c from Sale__c where IsArea__c=true and Territory__c!='BWI Admin' ];
        
        List<Sale__C> lstSaleToUpdate= new List<Sale__c>(); 
        
        for(Sale__c objBWISale : lstBWISale) 
        {
            Decimal Salesfunnel = 0; 
            system.debug('Gaurang: we are inside BWISAle'); 
            for(Sale__c objAreaSale : lstAreaSale) 
            {
                if(( objBWISale.Product_type__c == objAreaSale.Product_type__c)) 
                {
                     if(objAreaSale.Salesfunnel__c != null) 
                   Salesfunnel = Salesfunnel + objAreaSale.Salesfunnel__c;  
                    system.debug('Gaurang: we are inside AreaSale'+objAreaSale.Salesfunnel__c); 
                }
            }
            objBWISale.Salesfunnel__c= Salesfunnel; 
              system.debug('Gaurang: before updating salesfunel.'+ objBWISale.Salesfunnel__c); 
            lstSaleToUpdate.add(objBWISale); 
            
            
        }
        update lstBWISale; 
     
       
   
   } 
    
    
}