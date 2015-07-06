trigger trgPriceBookEntry on Product2 (after insert) {

 List<Pricebook2> stdPrice = [Select id from Pricebook2 ];
 List<PriceBookEntry> pbeList = new List<PriceBookEntry>();
 //List<PriceBookEntry> listPbe = [Select id,product2id from Pricebookentry];
 List<Product2> lstProducts = Trigger.new;
 
 for(Product2 listProducts  : lstProducts)
 {
 System.debug('Entered into product for loop');
 for(Pricebook2 pb2 : stdPrice)
 {
  System.debug('Entered into pricebookentry for loop');
  PriceBookEntry pbe=new PriceBookEntry();
   pbe.Product2Id = listProducts.Id;
   pbe.IsActive = true;
   pbe.UnitPrice = 0.00;
   pbe.PriceBook2Id = pb2.Id;
   pbe.useStandardPrice = false;
   pbeList.add(pbe);
 }
 }
  System.debug('before insert');
 insert pbeList;
  System.debug('after insert');

}