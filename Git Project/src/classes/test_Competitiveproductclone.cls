@isTest(SeeAllData = True)
public class test_Competitiveproductclone{
 static testMethod  void addProduct(){
     Product2 product = new Product2();
     product.Name = 'Test Product 1';
     product.ProductCode = '65485454';
     product.ExternalProductID__c='BSX-016';
     product.Family = 'Competitive Catheters'; 
     Product.Is_Competitive_Product__c = true;
     product.IsActive=true;
     insert product;
     
     List<Pricebook2> stdPrice = [Select id from Pricebook2 ];
     
     List<PriceBookEntry> pbeList = new List<PriceBookEntry>();
     
     for(Pricebook2 pb2 : stdPrice)
     {
      System.debug('Entered into pricebookentry for loop');
      PriceBookEntry pbe=new PriceBookEntry();
       pbe.Product2Id = product.Id;
       pbe.IsActive = true;
       pbe.UnitPrice = 0.00;
       pbe.PriceBook2Id = pb2.Id;
       pbe.useStandardPrice = false;
       pbeList.add(pbe);
     }
     try
     {
      insert pbeList;
      }
      catch(Exception e)
      {
       System.assertEquals('DUPLICATE_VALUE', e.getDmlStatusCode(0));
      }
     
    delete product;
      }
    
     
     
}