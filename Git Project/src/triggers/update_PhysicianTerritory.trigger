trigger update_PhysicianTerritory on Account (before insert) {

 /*   List<account> accPhysLst=new List<account>();
   
    String bfreUpdateTerr{get;set;}
    String aftrUpdateTerr {get;set;}
    String newTerrOfAccount {get;set;}
    List<Affiliation__c> lstAff = new List<Affiliation__c>();
    
    List<String> phyIds = new List<String>();
    
   try{   
        
    List<Account> accountlist = trigger.new;
                        //Get all affliations related to the corresponding business account
               List<Affiliation__c> affiliationlist = [Select physician1__c,physician1__r.territory__c,hospital__c,Hospital__r.territory__c from Affiliation__c where hospital__c IN: accountlist];
      for(Account a:accountlist)  // For every Account that has been updated
      {
         
         Account beforeUpdate = System.Trigger.oldMap.get(a.Id); 
         bfreUpdateTerr =  beforeUpdate.territory__c;
         newTerrOfAccount=a.Territory__c;
         if(bfreUpdateTerr!=newTerrOfAccount){
            if(a.IsPersonAccount == false)
           {   
                            
              for(Affiliation__c aff:affiliationlist)
              {
                  if(aff.physician1__c!=null)
                {
                      aftrUpdateTerr = aff.Hospital__r.territory__c; 
                    phyIds.add(aff.physician1__c); // The list contains the physician ids of the corresponding affliation 
           
                 }
               }
           }
         }
       }
       if(phyIds!=null && phyIds.size()>0)    // Find all the affliations of the physician
       {
           List<Account> accounts = [Select id,territory__c  from Account where id IN:phyIds];
           List<Affiliation__c> affiliations = [Select physician1__c,physician1__r.territory__c,hospital__c,Hospital__r.territory__c from Affiliation__c where physician1__c IN : accounts];
            
          for(Account phys: accounts)
          {
             String territory ='';
             for(Affiliation__c aff:affiliations) 
             {
                if(phys.id == aff.physician1__c)
                {
                   if(territory!='' && territory!=null && aff.Hospital__r.territory__c!=null && !(territory.contains(aff.Hospital__r.territory__c)))
                      territory = territory+';'+aff.Hospital__r.territory__c;
                   else if(aff.Hospital__r.territory__c == null)
                       territory = territory;     
                   else
                   {
                     if(phys.territory__c !=null && !(phys.territory__c.contains(aff.Hospital__r.territory__c)))
                       territory = aff.Hospital__r.territory__c; 
                     else
                       territory = aff.Hospital__r.territory__c;   
                       
                   }  
                }
            } 
            phys.territory__c  = territory ;
            accPhysLst.add(phys);  
                         
         }   
          update accPhysLst;
       }        
     
     }
     catch(Exception e)
     {
         system.debug('Exception in person acc territory update'+e.getMessage());
     } */
}