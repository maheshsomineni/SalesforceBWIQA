trigger trg_UpdatesSalesFunnel on Sale__c (after insert,after update) {       
     
 /*  if(Trigger.New.size()< 100) 
    { 
            if(!cls_SalesFunnel.inFutureContext )
            {
            
                 List<Id> lstIdTopass =  new List<Id>(); 
                 
                 for(sale__c objSale : Trigger.new)
                 {
                     lstIdToPass.add(objSale.Id);
                 }
                 //checkRecursive.stopTrigger();
                 cls_SalesFunnel.CalculateSalesFunnel(lstIdToPass);   
            
           } 
     
     }*/
         
        
         
         
    
    
          
       
            
}