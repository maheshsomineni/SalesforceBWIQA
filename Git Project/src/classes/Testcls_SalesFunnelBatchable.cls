@isTest
public class Testcls_SalesFunnelBatchable
{
     
    public static Id CreateOpty()
    {
      Account acc2 = new Account();
    acc2.Name = 'Test';
    acc2.territory__c='GL_MNT_MIN';
    //RecordType[] rt2 = [Select Id,  Name, SobjectType from RecordType where  SobjectType ='Account' and Name ='Business Account'];
    //acc2.RecordTypeId =rt2[0].Id;
    insert acc2;
    
    Opportunity Opp = new Opportunity();
    Opp.Name='test';
    Opp.StageName='Opportunity Identification';
    Opp.CloseDate=Date.Valueof('2014-04-24T20:58:55.000+0000');
    
    
    Opp.AccountId= acc2.Id;
   insert Opp;
    
   
    
    List<OpportunityLineItem> oppLineItems = new List<OpportunityLineItem>();
    
    //************* code for inserting pricebook and product *********************** 
    
        /* Pricebook2 pbe = new Pricebook2(Name = 'Standard', Description = 'Price Book 2009 Products', IsActive = true);
        insert pbe ;
         
        Product2 product = new Product2();
        product.Name='Test Product';
        product.IsActive=true;
        product.ExternalProductID__c='56554';
       // product.StandardPrice=1;
        insert product ;
        
        // Create a pricebook entry for custom pricebook
        PricebookEntry pEntry = new PricebookEntry();
        pEntry .UseStandardPrice = false;
        pEntry .Pricebook2Id=pbe.id;
        pEntry .Product2Id=product.id;
        pEntry .IsActive=true;
        pEntry .UnitPrice=99;
        insert pEntry ;*/ 
        
    
    //************ End of code for inserting pricebook and prioduct ****************
    
    
    PriceBookEntry pbe = [Select Id from PriceBookEntry where IsActive=true limit 1];
    
    
    
    Period fc = [Select Id from Period limit 1];
    
    for(integer i=1;i<5;i++)
    {
    OpportunityLineItem OppLineItem = new OpportunityLineItem();
    OppLineItem.OpportunityId = Opp.Id;
    // OppLineItem.TotalPrice = i*1000;
    
    OppLineItem.UnitPrice = 1000;
    OppLineItem.Quantity = 1;
    if(i==1)
    OppLineItem.Product_Type__c = 'HSS';
    else if(i==2)
    OppLineItem.Product_Type__c = 'NAV';
    else if(i==3)
    OppLineItem.Product_Type__c = 'DX';
    else if(i==4)
    OppLineItem.Product_Type__c = 'TX';
    OppLineItem.PriceBookEntryId=pbe.id;
    
    oppLineItems.add(OppLineItem);
    }
    
    
    
    insert oppLineItems;
    
    
     Opp.StageName= 'Closed/Lost';
    Opp.Reason_for_Close_and_Lost__c = 'Service/Support';
    
     update Opp;
     
     delete oppLineItems;
    
    
   // insert Acc2;
    
   /* PriceBook2 pb = new PriceBook2();
    pb.name= 'Standard';
    pb.IsActive = true;
    
    insert pb;
    
    Product2 prod = new Product2();
    prod.Name = 'test prod';
    prod.ProductCode = 'BWI-10';
   
    
    insert prod;
    
    PriceBookEntry pbe = new PriceBookEntry();
    pbe.PRODUCT2ID = prod.id;
    pbe.PRICEBOOK2ID = pb.id;
    pbe.unitprice = 0;
    pbe.UseStandardPrice = true;
    
    
    insert pbe;
*/
      
    
    OpportunityLineItem OppLineItem = new OpportunityLineItem();
    OppLineItem.OpportunityId = Opp.Id;
    OppLineItem.TotalPrice = 20000;
    OppLineItem.Quantity = 1;
    OppLineItem.Product_Type__c = 'HSS';
    OppLineItem.PriceBookEntryId=pbe.id;
    insert OppLineItem;
    
      return OppLineItem.Id;
   
    }
    public static void CreateSales()
    {
    
        List<Sale__c> lstInsert = new List<Sale__c>();
        Sale__c objSale = new Sale__c();
        objSale.Product_type__c ='HSS';
        objSale.Territory__c='GL_MNT_MIN';
        objSale.Fiscal_period__c='201403';
        objSale.Salesfunnel__c =0;
        //External_Sales_Id__c
        objSale.External_Sales_Id__c='GL_MID_MID';
        
        Sale__c objSale1 = new Sale__c();
        objSale1.Product_type__c ='HSS';
        objSale1.Territory__c='GL_MNT_MIN';
        objSale1.Fiscal_period__c='201403';
        objSale1.External_Sales_Id__c='GL_MID_MID_HSS';
        objSale1.Salesfunnel__c =0;
        lstInsert.add(objSale);
        lstInsert.add(objSale1);
        
         Sale__c objSale2 = new Sale__c();
        objSale2.Product_type__c ='HSS';
        objSale2.Territory__c='GL_MNT';
        objSale2.Fiscal_period__c='201403';
        objSale2.External_Sales_Id__c='GL_MID';
        objSale2.Salesfunnel__c =0;
        lstInsert.add(objSale2);
        
        
          Sale__c objSale3 = new Sale__c();
        objSale3.Product_type__c ='NAV/TX';
        objSale3.Territory__c='GL_MNT';
        objSale3.Fiscal_period__c='201403';
        objSale3.External_Sales_Id__c='GL_MID_NAV_TX_1';
        objSale3.Salesfunnel__c =0;
        lstInsert.add(objSale3);
        List<Id> ids = new List<Id>();
        
        for(Sale__c ss : lstInsert)
        {
          ids.add(ss.id);
        }
        cls_SalesFunnel.CalculateSalesFunnel(ids);
  
        
        insert lstInsert;
        update lstInsert;
        
        
    }
@isTest(SeeAllData=true)
public static void testSchedule()
{
  
  
   //cls_SalesfunnelScheduler cs = new  cls_SalesfunnelScheduler();
   //cs.execute(SchedulableContext ScMain);
   
 // if(!Test.isRunningTest())
      Id objOppLineId; 
      objOppLineId  =   CreateOpty();
      OpportunityLineItem oppLineItem1 = [select Id from OpportunityLineItem where Id =:objOppLineId]; 
     
        
    
        CreateSales();
        
     test.startTest();
           
         string query='select Id,Name,Account.Territory__c,Risk_Adjusted_Opportunity_del__c ,Probability,(select Id,Product_Type__c,TotalPrice  from OpportunityLineItems where Product_Type__c!=null  ) from Opportunity where IsClosed=False limit 10';
         Id batchInstanceId = Database.executeBatch(new cls_SalesFunnelBatchable (query), 10);        
         
       test.stopTest();
       
       if(Test.isRunningTest() && Limits.getFutureCalls() >= Limits.getLimitFutureCalls())
     {
      System.debug('Skip to call');
      
     }
     else
     {
       delete oppLineItem1 ;
       
       }
            
         
   //  cls_SalesFunnelBatchable csb = new cls_SalesFunnelBatchable();
    // Database.executeBatch(csb);
    
 
 }
}