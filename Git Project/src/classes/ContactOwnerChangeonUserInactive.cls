public class ContactOwnerChangeonUserInactive
{
  @future
  public static void ChangeOwner(Set<id> inactiveUsersList) {
  
  List<Contact> toUpdateContactOwner = [SELECT id,ownerid from Contact where ownerid in : inactiveUsersList];
  List<Contact> UpdateContactOwner = new List<Contact>();
  Contact_Owner__c owner = Contact_Owner__c.getInstance('owner');
  String ownerid = owner.UserId__c;
      if(toUpdateContactOwner.size()>0)
      {
        for(Contact c : toUpdateContactOwner)
        {
        c.ownerid = ownerid;
        UpdateContactOwner.add(c);
        
        }
  
  update UpdateContactOwner;
      }

  
  }
  
}