public class SendEmailonTaskStatusChange {
   public static void sendEmailOnChangeOfStatus(List<Task> newList,
                                                    Map<Id,Task> oldMap)
    {
        Map<Id,User> mapUser = new Map<Id,user>([Select id,firstname,lastname,email from user]); 
   Map<Id,Contact> mapContact = new Map<Id,Contact>([Select id,name from Contact]); 
   Map<Id,Opportunity> mapOpportunity = new Map<Id,Opportunity>([Select id,name from Opportunity]); 
  
   String urllink;
   String contactName=null;
   String opportunityName=null;
   	for(Task t : newList){
        Task oldTask = oldMap.get(t.id);
       if(t.Status!=oldTask.Status)
       {                  
         Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
         User u = mapUser.get(t.createdbyid); 
         User y = mapUser.get(t.ownerid);
         Contact c = mapContact.get(t.whoid);
         Opportunity o = mapOpportunity.get(t.whatid);
         if(c!=null)
         {
             contactName = c.Name;
         }          
          if(o!=null)
          {
              opportunityName = o.Name;
          }         
     String sm = u.Email;   
       
     if(sm.contains('.prod'))
     {
         u.Email=sm.substringBefore('.prod');         
     }
    mail.setToAddresses(new String[] {u.email});          

    mail.setSubject(t.Subject);    
    urllink =   URL.getSalesforceBaseUrl().toExternalForm();
    
    String body = '<html><body>Hi ' + u.FirstName + ', <br><br></body></html>';
    body += '<html><body>The status of assigned task to '+y.FirstName+' is '+t.Status+'<br><br></body></html>';   
    body+='<html><body>Subject: '+t.Subject+'<br></body></html>';    
    body+='<html><body>Contact: '+contactName+'<br></body></html>'; 
    body+='<html><body>Opportunity: '+opportunityName+'<br></body></html>';    
    body+='<html><body>Due Date: '+t.ActivityDate+'<br></body></html>';
    body+='<html><body>Priority: '+t.Priority+'<br></body></html>';
    body+='<html><body>Comments: '+t.Description+'<br></body></html>';
    body+='<html><body>Status: '+t.Status+'<br><br></body></html>';
    body+='<html><body>For more details, click the following link:<br></body></html>';
    body+='<HTML><br><a href="'+urllink+'/'+t.id+'">'+urllink+'/'+t.id+'</a></HTML>';
    mail.setHtmlBody(body);
    mail.saveAsActivity = false;
    system.debug('Task is '+t);
    system.debug('Mail is'+mail);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
       }  
     }

    }
}