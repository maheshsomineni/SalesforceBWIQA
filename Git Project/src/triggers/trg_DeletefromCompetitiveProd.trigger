//Delete competitive products when a product is deleted and it s family is Competitive Catheters
trigger trg_DeletefromCompetitiveProd on Product2 (after delete) {
List<Competative_Product__c> lstcompetitiveProducts = new List<Competative_Product__c>();

List<String> prodCodes = new List<String>();
    for(Product2 product : Trigger.old){
    System.debug('for loop delete');
        if(product.Is_Competitive_Product__c == true){
            System.debug('if loop condition');
             prodCodes.add(product.ProductCode);
    }
}

List<Competative_Product__c> compList = [Select Id FROM Competative_Product__c WHERE Product_Code__c IN:prodCodes ];
    if(compList != null && !compList.isEmpty()){
        System.debug('Values to be deleted'+compList);
        System.debug('if loop delete');
        delete compList ; 
        System.debug('deleted'+compList);
        }

}