trigger trg_Sales_Update on OpportunityLineItem (after insert) {
 
  List<OpportunityLineItem> listOppProducts = Trigger.new;
  System.debug('Trigger fired'+listOppProducts);
    List<Id> OppIds = new List<Id>();
    List<String> TerrIds =  new List<String>();
  try
  {
    for(OpportunityLineitem lop : listOppProducts)
    {
        System.debug('Opportunity Ids');
        OppIds.add(lop.OpportunityId);
    }
    System.debug('OppIds'+OppIds);
  List<Opportunity> listOpps = [SELECT Id,AccountId,TerritoryId,Territory_Name__c,Probability,(select Id from OpportunityLineItems) from Opportunity where Id IN : OppIds];
    Map<Id,Opportunity> mapOppLineOpp = new map<Id,Opportunity>();
    Map<String,Territory> mapTerrName = new Map<String,Territory>();
    for(Opportunity Opp : listOpps)
    {
        System.debug('Opportunity for loop'+opp);
        for(OpportunityLineItem OppLineItem : Opp.OpportunityLineItems)
        {
        System.debug('Opportunity Line Items'+OppLineItem);
            mapOppLineOpp.put(OppLineItem.id,Opp);
        System.debug('map'+mapOppLineOpp);
        }
    }
    
  for(Opportunity opps : listOpps)
  {
      TerrIds.add(opps.Territory_Name__c);
  }
  System.debug('Territory Ids List'+TerrIds);
  
    Set<Sale__c> updateSales = new Set<Sale__c>();
    List<Sale__c> updateListSales = new List<Sale__c>();
    List<Territory> TerritoryCode = [SELECT Name,External_Territory_Id__c FROM Territory where Name IN : TerrIds];
    
    System.debug('Territory Code'+TerritoryCode);
    
    for(Territory t : TerritoryCode)
    {
      mapTerrName.put(t.Name,t);
    }
    System.debug('map Territory Code'+mapterrName);
    List<String> terrCodes = new List<String>();
    for(Territory t : TerritoryCode)
    {
     terrCodes.add(t.External_Territory_Id__c);
    }
    System.debug(' Territory Codes list'+terrCodes);
   List<Sale__c> listSales = [SELECT Id,Product_Type__c,SalesFunnel__c,Territory__c from Sale__c where Territory__c IN : terrCodes ];
   System.debug('list Sales'+listSales);
   
  for(OpportunityLineItem lstOppProducts : listOppProducts)
  {
    System.debug('opl for loop'+lstOppProducts);
            Opportunity objOpp = mapOppLineOpp.get(lstOppProducts.id);
            
            Territory objTerr = mapTerrName.get(objOpp.Territory_Name__c);
            
               for(Sale__c lstSales : listSales)
               {
                
               System.debug('Sales for loop'+lstSales+' territory sales '+lstSales.Territory__c+'Opp territory'+objOpp.Territory_Name__c);
                  if(lstSales.Territory__c == objTerr.External_Territory_id__c)
                  {
                   
                  System.debug('Sales if loop'+lstSales.Territory__c+'   '+objOpp.Territory_Name__c);
                  System.debug('Sales if loop 2'+lstSales.Product_Type__c+'   '+lstOppProducts.Product_Type__c);
                   if(lstSales.Product_Type__c==lstOppProducts.Product_Type__c)
                   {
                   System.debug('Sales if loop 3'+lstSales.Product_Type__c+'   '+lstOppProducts.Product_Type__c);
                   System.debug('Sales funnel value'+lstSales.SalesFunnel__c);
                   lstSales.SalesFunnel__c = lstSales.SalesFunnel__c+((lstOppProducts.TotalPrice*objOpp.Probability)/100);
                   }                   
                   System.debug('Sales funnel value'+lstSales.SalesFunnel__c);
                  }
                  if(!updateSales.contains(lstSales))
                  {
                   updateSales.add(lstSales); 
                  }
               }
               
   }
    updateListSales.addAll(updateSales);
    System.debug('update atlast'+updateListSales);
    update updateListSales;
    }
    catch(Exception e)
     {
      EmailforException.notifyDevelopersOf(e,'trg_Sales_Update');
     }
     
}