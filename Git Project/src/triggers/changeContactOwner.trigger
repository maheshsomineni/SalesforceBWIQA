trigger changeContactOwner on User (before update) {

  //List<User> UpdatedUserList = trigger.new;
  Set<id> inactiveUsersList = new Set<id>();
  for(User u : Trigger.new)
  {
    if(u.IsActive==false)
    {
    inactiveUsersList.add(u.id);
    }
    
  }
  if(inactiveUsersList.size()>0)
  {
      ContactOwnerChangeonUserInactive.ChangeOwner(inactiveUsersList);
  }
  
 

}