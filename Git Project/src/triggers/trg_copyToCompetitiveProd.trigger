trigger trg_copyToCompetitiveProd on Product2 (after insert,after update) {
System.debug('Trigger fired');
System.debug('first Run'+HelperClass.firstRun);
 if(HelperClass.firstRun)
 {
System.debug('first Run'+HelperClass.firstRun);
List<Product2> lstProducts = Trigger.new;


//set<Competative_Product__c> stCompetitveProductToInsert = new set<Competative_Product__c>();
List<Competative_Product__c> lstCompetitveProductToInsert = new List<Competative_Product__c>();
Map<string,Competative_Product__c> mapToInsert = new map<string,Competative_Product__c>();

//fetch all products, copying in Competitve product
for(Product2 objProduct : lstProducts)
{
System.debug('for loop starting'+objProduct);
if(objProduct .Is_Competitive_Product__c == true){     
    Competative_Product__c objCompetitive =  new Competative_Product__c();
    objCompetitive.ExternalProductID__c = objProduct.ExternalProductID__c;
    objCompetitive.Family__c= objProduct.Family;
 System.debug('for loop middle');
    objCompetitive.Name =objProduct.Name;
    objCompetitive.Product_Code__c =objProduct.ProductCode; 
    objCompetitive.Product_Type__c =objProduct.Product_Type__c;
    objCompetitive.Product_Sub_Types__c =objProduct.Product_Sub_Types__c;
     objCompetitive.HSS_Child_Subtypes__c =objProduct.HSS_Child_Subtypes__c;
    
    
   /* if(!stCompetitveProductToInsert.contains(objCompetitive))
    stCompetitveProductToInsert.add(objCompetitive);*/ 
    
    if(! mapToInsert.Keyset().contains(objProduct.ProductCode))
    mapToInsert.put(objCompetitive.Product_Code__c ,objCompetitive);
 System.debug('for loop ending');
}
}   

//coverting set to list (for DML support) 

system.debug('count of map values'+mapToInsert.size());
 system.debug('list of elements'+ mapToInsert.values());

      insert mapToInsert.values();
      HelperClass.firstRun=false;
      System.debug('first Run'+HelperClass.firstRun);
      
 }
    
}