/****
Name        : PersonAccountTerritoryUpdate 
Usage       : Deleting the appended territory in Person account when the associated affiliation is deleted.
Created Date: 11/26/2012
****/

trigger PersonAccountTerritoryUpdate on Affiliation__c (before delete) {
/*    List<Account> lstContact = new List<Account>();
    List<Affiliation__c> LstAff = new List<Affiliation__c>();
    map<String,List<Affiliation__c>> conAffMap = new map<String,List<Affiliation__c>>();
    set<Id> setConId = new set<Id>();
    set<Id> setAffId = new set<Id>();
       for(Affiliation__c aff:trigger.old){
           setConId.add(aff.Physician1__c);
           setAffId.add(aff.id);
    }
    system.debug(setAffId + '********Affiliation Id****');
    lstContact  =[select id, Territory__c from Account where id in :setConId];
    for(Affiliation__c aff :[select Id,Physician1__c,Hospital__r.Territory__c from Affiliation__c where Physician1__c in:setConId]){
       if(conAffMap.containsKey(aff.Physician1__c)){
          List<Affiliation__c> LstAff1 = new List<Affiliation__c>();
          LstAff1.addAll(conAffMap.get(aff.Physician1__c));
          LstAff1.add(aff);
          conAffMap.put(aff.Physician1__c,LstAff1);
       }else {
        LstAff.add(aff);
        conAffMap.put(aff.Physician1__c,LstAff);
       }
    }
    
    List<Account> accList = new List<Account>();
      for(Account Con :lstContact){
         String str='';
         system.debug('******con**'+con+'******con map****'+conAffMap);
         if(conAffMap.containsKey(Con.id)){
             for(Affiliation__c aff :conAffMap.get(Con.id)){
                if(!setAffId.contains(aff.id))
                str=str+';'+ aff.Hospital__r.Territory__c;
             }
         }
         if(str.contains(';'))
         con.Territory__c=str.substringAfter(';'); 
         else
         con.Territory__c=str;  
         accList.add(con);
    }
    update accList;*/
}