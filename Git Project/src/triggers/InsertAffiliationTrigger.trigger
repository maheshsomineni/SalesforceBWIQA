/****
Name         : InsertAffiliationTrigger 
Usage        : When we create a New Person Account then Affiliation 
               should be created based on The primary Hospital.
Created Date : 11/26/2012
****/


trigger InsertAffiliationTrigger on Account (after insert, after update) {
/*
List<Affiliation__c> listAffiliationToInsert = new List<Affiliation__c>();
List<Account> accLst = new List<Account>();
List<Id> idset = new List<Id> ();
for (Account a : Trigger.new){
    If (a.IsPersonAccount == True)
    {     
       idset.add(a.id);
       //acountObjMap.put(a.id,a);
    }
}
system.debug('**********idset*****'+idset +'***size*' + idset.size());
accLst  = [Select Id, Account__c from Account where Id IN :idset];
system.debug('**********accLst  *****'+idset +'***size*' + accLst.size());
for(Account AccObj :accLst){
    Affiliation__c aff = new Affiliation__c();
    aff.Hospital__c = AccObj.Account__c;
    aff.Physician1__c = AccObj.Id;
    listAffiliationToInsert.add(aff);
}
system.debug('**********listAffiliationToInsert1*****'+listAffiliationToInsert +'***size*1' + listAffiliationToInsert.size());
try {
       if(!TriggerRecursiveHelper.hasAlreadyExecutedTrigger('accountTrigger')){
           TriggerRecursiveHelper.setAlreadyExecuted('accountTrigger'); 
            if (listAffiliationToInsert.size()!=0)
            {
                insert listAffiliationToInsert; 
             }   
        }
        system.debug('**********listAffiliationToInsert2*****'+listAffiliationToInsert +'***size2**' + listAffiliationToInsert.size());
    } catch (Dmlexception e) {
        system.debug ('++++exception error'+e);
    }
*/
 
 }