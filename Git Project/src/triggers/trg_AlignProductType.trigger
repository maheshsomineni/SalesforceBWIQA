trigger trg_AlignProductType on OpportunityLineItem (after insert,after update) 
{
	if(!OpportunityTriggerHelper.hasAlreadyCreatedFollowUpTasks())
  	{
    	List<OpportunityLineItem> olis = [SELECT Id FROM OpportunityLineItem WHERE Id IN: Trigger.newMap.keySet()];
  		List<OpportunityLineItem> toUpdate = new  List<OpportunityLineItem>();
        
        for(OpportunityLineItem OppLineItem : olis ) 
        {
           // OppLineItem.Product_Type__c='HSS';
           // OppLineItem.Quantity =3;
           //product objProduct = [select Product_Type__c from Product where ID=:OppLineItem.PricebookEntry.Product2ID];
           for(OpportunityLineItem oopLInternal : [select PricebookEntry.Product2.Product_Type__c from OpportunityLineItem where Id=:OppLineItem.Id ])
           {
				OppLineItem.Product_Type__c= oopLInternal.PricebookEntry.Product2.Product_Type__c;
           }
           toUpdate.add(OppLineItem);           
        }
         
        OpportunityTriggerHelper.setAlreadyCreatedFollowUpTasks();
        update toUpdate;
    }

}