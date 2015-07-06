trigger trg_UpdateAllPhyscianTerritory on Account (after update) {

/*List<Account> lstAccount = new List<Account>(); 

for(Account objAccount : trigger.new)
{
    if(!objAccount.IsPersonAccount)
       lstAccount.add(objAccount);
}

List<affiliation__c> lstAff = [select Id,Name, physician1__c,physician1__r.territory__c,hospital__c,Hospital__r.territory__c from affiliation__c where hospital__c IN : lstAccount ];

map<Id,List<affiliation__c>> mapAccAff= new map<Id,List<affiliation__c>>();
List<Id> lstPhyId =  new List<Id>();
for(Account objAccount : lstAccount)
{
    List<affiliation__c> lstAffIn =  new List<Affiliation__c>();
    for(Affiliation__c objAff : lstAff) 
    {
       if(objAff.hospital__c == objAccount.Id)
       {
           lstAffIn.add(objAff);
           lstPhyId.add(objAff.physician1__c);
       }
    }
    mapAccAff.put(objAccount.Id,lstAffIn);
}


List<Account> lstPhy = [select Id,Territory__c from Account where Id IN :lstPhyId ];

//system.debug('*****-- got size of phy '+ lstPhy.size());
map<Id,list<account>> mapAccCon = new map<Id,list<Account>>();




for(Account  objAccount :lstAccount)
{
    list<Account> lstPhy1 = new list<account>();
    for(Affiliation__c objAff : lstAff)
    {
        
        for(Account objPerAcc : lstPhy)
        {
            if(objPerAcc.Id == objAff.physician1__c)
            {
                lstPhy1.add(objPerAcc);
            }
        }
    }
   // system.debug('*****1-- got size of phy '+ lstPhy1.size());
    mapAccCon.put(objAccount.Id,lstPhy1);
}

set<Account> toUpdate = new set<Account>();


Map<Id,Account> mapPersonAccountToUpdate = new Map<Id,Account>();
Map<Id,string> mapPersonAccountTerritories = new Map<Id,string>();
for(Account objAccount : lstAccount)
{
  if(objAccount.territory__c != null)
  {
      List<Account> lstPhyToUpdate = mapAccCon.get(objAccount.Id);
    for(Account objCon : lstPhyToUpdate)
    {
    
    
         if(objCon.territory__c != ''&& objCon.Territory__c != null )
        {
            if(! objCon.Territory__c.contains(objAccount.Territory__c))
             objCon.territory__c = objCon.territory__c+';'+ objAccount.Territory__c;
        }
        else
        {
              objCon.territory__c =  objAccount.Territory__c;
        }
         
         //Addning into set 
         if(! toUpdate.contains(objCon))
         toUpdate.add(objCon);
         if(! mapPersonAccountToUpdate.keyset().contains(objCon.Id))
         {
             mapPersonAccountToUpdate.put(objCon.Id,objCon);
             mapPersonAccountTerritories.put(objCon.Id,objCon.territory__c);
         }
         else
         {
             //we are going to update Territory code again. 
             //first get the PhyTerritory
             Account objConTemp = mapPersonAccountToUpdate.get(objCon.Id);
             
             if(objConTemp != null)
             {
                //Again Update territory 
                    objConTemp.territory__c = mapPersonAccountTerritories.get(objCon.Id);
                
                    if(objConTemp .territory__c != ''&& objConTemp .Territory__c != null )
                    {
                        if(! objConTemp.Territory__c.contains(objAccount.Territory__c))
                         objConTemp .territory__c = objConTemp .territory__c+';'+ objAccount.Territory__c;
                    }
                    else
                    {
                          objConTemp.territory__c =  objAccount.Territory__c;
                    }
                    
                //update main map now     
                 mapPersonAccountToUpdate.put(objCon.Id,objConTemp);
                 mapPersonAccountTerritories.put(objCon.Id,objConTemp.territory__c);
                
                
                
             }
             
         }
        
    }
  
  }
  
    
}

update mapPersonAccountToUpdate.values();

List<Account> lstAccountToUpdate = new List<Account>();
for(Account objAccount:toUpdate)
{
    lstAccountToUpdate.add(objAccount);
}
update lstAccountToUpdate;

for(Account objAccount : lstAccount)
{
    List<Affiliation__c> lstAffInternal = mapAccAff.get(objAccount.Id);
    
    for(Affiliation__c objAff : lstAffInternal)
    {
        if( objAff.physician1__r.territory__c != null)
          {
              if(! objAff.physician1__r.territory__c.contains(objAccount.territory__c))
              {
                  List<Account> lstPerAccount = mapAccCon.get(objAccount.Id);
                  
                  for(Account objCon : lstPerAccount)
                  {
                      if(objCon.territory__c != '')
                       objCon.territory__c = objCon.territory__c+';'+ objAff.Hospital__r.Territory__c;
                       else
                        objCon.territory__c =  objAff.Hospital__r.Territory__c;
                        
                        toUpdate.add(objCon);
                  }
              }
          }
    }
}


*/

}