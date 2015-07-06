trigger updatePhysicianTerritory on Account (after update) 
{

  /*  List<account> accPhysLst=new List<account>();
   
    String bfreUpdateTerr{get;set;}
    String aftrUpdateTerr {get;set;}
    String newTerrOfAccount {get;set;}
    List<Affiliation__c> lstAff = new List<Affiliation__c>();
    
    List<String> phyIds = new List<String>();
    
   try{   
        
     
      for(Account a:trigger.new)  // For every Account that has been updated
      {
         
         Account beforeUpdate = System.Trigger.oldMap.get(a.Id); 
         bfreUpdateTerr =  beforeUpdate.territory__c;
         newTerrOfAccount=a.Territory__c;
         if(bfreUpdateTerr!=newTerrOfAccount){
            if(a.IsPersonAccount == false)
             {                                               //Get all affliations related to the corresponding business account
                for(Affiliation__c aff:[Select physician1__c,physician1__r.territory__c,hospital__c,Hospital__r.territory__c from Affiliation__c where hospital__c=:a.id])
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
          for(Account phys:[Select id,territory__c  from Account where id IN:phyIds])
          {
             String territory ='';
             for(Affiliation__c aff:[Select physician1__c,physician1__r.territory__c,hospital__c,Hospital__r.territory__c from Affiliation__c where physician1__c=:phys.id]) 
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
     }*/
}