trigger ValidatePrivacyBox on Attachment (before insert) {
  List<Attachment> at = Trigger.new;
    List<Id> contactIds = new List<Id>();
    for(Attachment att : at)
    {
        contactIds.add(att.ParentId);
    }
    Map<Id,Contact> mapContact = new Map<Id,Contact>([Select Id,Privacy_Consent__c from contact where id in : contactIds]);
   for(Attachment a : at)
   {        
       if(string.valueOf(a.parentid).startsWith('003'))
       {
           Contact c1 = mapContact.get(a.ParentId);
           if((c1.Privacy_Consent__c == false))
              a.addError('You cant add attachment when privacy box is unchecked');
     }
   }
}