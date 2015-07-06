trigger trg_UpdateAccountLookUp on Call__c (before insert,before update) {



for(Call__c objCall : trigger.New)
{
    objCall.Account_test__c = objCall.AccountId__c;
    objCall.Physician__c = objCall.PhysicianId__c;
    objCall.Contact__c = objCall.FellowId__c;
    
}
//update lstCall;



}