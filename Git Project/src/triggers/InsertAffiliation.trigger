/****
Name         : InsertAffiliation 
Usage        : When we create a Contact then Affiliation 
               should be created based on The primary Hospital.
Created Date : 06/27/2014
****/


trigger InsertAffiliation on Contact (after insert, after update) 
{

List<Affiliation__c> listAffiliationToInsert = new List<Affiliation__c>();
List<Contact> accLst = new List<Contact>();

for(Contact c :Trigger.new){
    Affiliation__c aff = new Affiliation__c();
    aff.Hospital__c = c.AccountId;
    aff.Physician__c = c.Id;
    listAffiliationToInsert.add(aff);
}
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
     
     System.debug('inserted'+listAffiliationToInsert);
           
 }