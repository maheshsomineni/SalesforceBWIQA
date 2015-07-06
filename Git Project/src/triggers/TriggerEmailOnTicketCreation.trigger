trigger TriggerEmailOnTicketCreation on Case (before update,before insert,after insert) {
List<Case> ticketList = Trigger.new;
//if (!RecursiveTriggerHelper.isAlreadyModified() ) 
  //          {
    //            RecursiveTriggerHelper.setAlreadyModified();
if(Trigger.isbefore)
{   
   for(Case c:Trigger.new)
   {
      if(c.Assigned_To__c==null)
      c.Assigned_To__c=System.UserInfo.getUserId();
   }
}
/*
else if(Trigger.isafter)
{
  System.debug('Entered after update');
   
     List<Id> ids= new List<Id>();
     String urllink;
     
     for(Case t : ticketList)
     {
       ids.add(t.Assigned_To__c);
     }
     System.debug('Entered after update'+ids);
     Map<Id,User> userMap =new Map<Id,User>([Select id,email,FirstName,LastName from User where id in : ids]); 
     System.debug('Entered after update'+userMap);
     for(Case t : ticketList )
     {
     System.debug('Entered for');
       if(userMap!=null)
       {
       System.debug('Entered if null');
       if(t.status =='Closed' )
       {       
       User u = userMap.get(t.Assigned_To__c);
         Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
          mail.setToAddresses(new String[] {u.email});          
            mail.setSubject(t.CaseNumber+' is closed');    
            urllink =   URL.getSalesforceBaseUrl().toExternalForm();
            String body = '<html><body>Hi ' + u.FirstName + ', <br><br></body></html>';
              body += '<html><body>The Ticket '+t.CaseNumber+' is closed<br><br></body></html>';  
              body+='<html><body>Ticket Summary '+t.Subject+' <br></body></html>'; 
              body+='<html><body>Ticket Description '+t.Description+' <br></body></html>'; 
              body+='<html><body>For more details, click the following link:<br></body></html>';
        body+='<HTML><br><a href="'+urllink+'/'+t.id+'">'+urllink+'/'+t.id+'</a></HTML>';
        mail.setHtmlBody(body);
        mail.saveAsActivity = false;
    
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
       }
       
          if(t.status =='New' )
       {
       System.debug('Entered for'+t);
        User u = userMap.get(t.Assigned_To__c);
         Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
          mail.setToAddresses(new String[] {u.email});          
            mail.setSubject(t.CaseNumber+' is created');    
            urllink =   URL.getSalesforceBaseUrl().toExternalForm();
            String body = '<html><body>Hi ' + u.FirstName + ', <br><br></body></html>';
              body += '<html><body>The Ticket '+t.CaseNumber+' is created<br><br></body></html>'; 
              body+='<html><body>Ticket Summary: '+t.Subject+' <br></body></html>'; 
              body+='<html><body>Ticket Description: '+t.Description+' <br></body></html>'; 
              body+='<html><body>For more details, click the following link:<br></body></html>';
              
        body+='<HTML><br><a href="'+urllink+'/'+t.id+'">'+urllink+'/'+t.id+'</a></HTML>';
        mail.setHtmlBody(body);
        mail.saveAsActivity = false;
    
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        System.debug('Entered for'+mail);
       }
       
       
     }
// }

   
}    
}
  */
     
}