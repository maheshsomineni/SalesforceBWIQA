/****
Name         : aINS_updateTerritory 
Usage        : When Create a New Affiliation then hospital's territory should be assign to Physician .
Created Date : 11/26/2012
****/

trigger aINS_updateTerritory on Affiliation__c (after insert) {
/*    list<id> accHospids=new list<id>();
    list<id> accPhysids=new list<id>();
    
    list<account> accHospLst=new list<account>();
    list<account> accPhysLst=new list<account>();
    list<account> accUpdateLst=new list<account>();
    string ids;
    for(Affiliation__c aff:trigger.new){
        accHospids.add(aff.hospital__c);
        system.debug('-physician--'+aff.physician1__c);
        accPhysids.add(aff.physician1__c);
        //ids=aff.physician__c;
       // accPhysLst=[select id,territory__c from account where id=:aff.physician__c];

    }
    accHospLst=[select id,territory__c from account where id IN:accHospids];
    accPhysLst=[select id,territory__c from account where id IN:accPhysids];
   
    for(Affiliation__c aff:trigger.new){
        for(account hosp:accHospLst){
        system.debug('--inside hospital');
            if(hosp.id==aff.Hospital__c){
            system.debug('--inside hospital if');
                for(account phys:accPhysLst){
                    if(phys.id ==aff.physician1__c){
                        string territory=phys.territory__c;
                        if(territory==null)
                        {
                        if(hosp.territory__c!=null)
                        {territory=hosp.territory__c;
                        }
                        }else
                        
if(hosp.territory__c!=null){
                        territory=territory+';'+hosp.territory__c;
                        }

                        phys.territory__c= territory;
                        system.debug('--try--'+territory);
                        accUpdateLst.add(phys);   
                    }
                }
            }
        }
    }
    if(!TriggerRecursiveHelper.hasAlreadyExecutedTrigger('Affiliation')){
           TriggerRecursiveHelper.setAlreadyExecuted('Affiliation'); 

    update accUpdateLst;
    }*/
}