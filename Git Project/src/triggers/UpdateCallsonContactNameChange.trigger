trigger UpdateCallsonContactNameChange on Contact (before update) {
  
  if(system.isBatch() || system.isFuture())
  {
  }
  else
  {
    List<ID> ContactIds = new List<ID>();        
   Map<Id, string> oldcontactidcheck=new Map<Id, string>();
  
        for(Contact item1: Trigger.old)
        {                     
          oldcontactidcheck.put(item1.id,item1.FirstName +' '+ item1.LastName);          
        }
      
       for(Contact newCon : Trigger.New)
       {
        String oldConName = oldcontactidcheck.get(newCon.id);
        String newConName = newCon.FirstName + ' ' + newCon.LastName;
        System.debug('New Name '+newConName);
        System.debug('Old Name'+oldConName);
        if(oldConName!=newConName)
        {
          ContactIds.add(newCon.id);
        }
       }
        System.debug('contact ids'+ContactIds);
        updatePhysiciansonContactNameChange.changeName(ContactIds); 
  
  }
   
}