trigger trg_UpdateAccountLookUpOnOA on Other_Activity__c (before insert,before update) 
{

    for(Other_Activity__c obj : trigger.New)
    {
        obj.Account__c= obj.AccountId__c;
        obj.Contact__c= obj.PhysicianID__c;
    
    }


}