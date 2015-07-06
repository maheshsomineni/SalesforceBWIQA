//To make the list price of all the products to zero
trigger trg_listPrice_default_zero on Opportunity (before insert) 
{
    Opportunity opp= Trigger.new[0];
    try
    {
        PriceBook2 objPricebook = [SELECT Id FROM Pricebook2 WHERE Name='Standard'];
    
        List<PricebookEntry> pbEntryList = [SELECT UnitPrice 
                                              FROM PricebookEntry
                                             WHERE Pricebook2Id=:objPricebook.id 
                                               AND ISACTIVE=TRUE ];
    
        List<PricebookEntry> lstToUpdate=  new List<PricebookEntry>();
        
        for(PricebookEntry  objPricebookEntry : pbEntryList )
        {
            objPricebookEntry.UnitPrice= 0;
            lstToUpdate.add(objPricebookEntry);
        }
        
        if(lstToUpdate.size()>0)
        update lstToUpdate;
    }
    catch(Exception ae)
    {
    }
}