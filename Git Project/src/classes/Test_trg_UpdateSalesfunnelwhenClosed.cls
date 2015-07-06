@isTest(SeeAllData=true)
public class Test_trg_UpdateSalesfunnelwhenClosed
{
    static testMethod void TestSalesFunnel()
    {
      Id objOppLineId; 
      objOppLineId  =   CreateOpty();
        CreateSales();
       //OpportunityLineItem oppLineItem1 = [select Id from OpportunityLineItem where Id =:objOppLineId]; 
       //delete oppLineItem1 ;
        
        
    }
    public static Id CreateOpty()
    { 
    
      Account acc2 = new Account();
    acc2.Name = 'Test';
    acc2.territory__c='GL_MID_MIN';
    RecordType[] rt2 = [Select Id,  Name, SobjectType from RecordType where  SobjectType ='Account' and Name ='Business Account'];
    acc2.RecordTypeId =rt2[0].Id;
    insert acc2;
    
    Opportunity Opp = new Opportunity();
    Opp.Name='test';
    Opp.StageName='Opportunity Identification';
    Opp.CloseDate=Date.Valueof('2014-04-24T20:58:55.000+0000');
    Opp.AccountId= acc2.Id;
   insert Opp;
   
   List<Opportunity> lstOpp =  [select Id,Name,Account.Territory__c,Probability,IsClosed from Opportunity where Id = :Opp.Id and IsClosed=false ];
    System.debug('list not empty'+lstOpp);
   
    
    List<OpportunityLineItem> oppLineItems = new List<OpportunityLineItem>();
    
    PriceBookEntry pbe = [Select Id from PriceBookEntry where IsActive=true limit 1];
    Period fc = [Select Id from Period limit 1];
    
    for(integer i=1;i<6;i++)
    {
    OpportunityLineItem OppLineItem = new OpportunityLineItem();
    OppLineItem.OpportunityId = lstOpp[0].Id;
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
    else if(i==5)
    OppLineItem.Product_Type__c = 'LSS';
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
        objSale.Territory__c='GL_MID_MIN';
        objSale.Fiscal_period__c='201403';
        //External_Sales_Id__c
        objSale.External_Sales_Id__c='GL_MID_MID';
        
        Sale__c objSale1 = new Sale__c();
        objSale1.Product_type__c ='HSS';
        objSale1.Territory__c='GL_MID_MIN';
        objSale1.Fiscal_period__c='201403';
        objSale1.External_Sales_Id__c='GL_MID_MID_HSS';
        lstInsert.add(objSale);
        lstInsert.add(objSale1);
        
         Sale__c objSale2 = new Sale__c();
        objSale2.Product_type__c ='HSS';
        objSale2.Territory__c='GL_MID';
        objSale2.Fiscal_period__c='201403';
        objSale2.External_Sales_Id__c='GL_MID';
        lstInsert.add(objSale2);
        
          Sale__c objSale3 = new Sale__c();
        objSale3.Product_type__c ='NAV/TX';
        objSale3.Territory__c='GL_MID';
        objSale3.Fiscal_period__c='201403';
        objSale3.External_Sales_Id__c='GL_MID_NAV_TX_1';
        lstInsert.add(objSale3);
        
        
        
        insert lstInsert;
        update lstInsert;
        
        try
        {
        String exe = '';
        String abc = exe.toLowerCase();
        }
        catch(Exception e)
        {
          EmailforException.notifyDevelopersOf(e,'trg_Sales_Update');
        }
        
        
    }

}