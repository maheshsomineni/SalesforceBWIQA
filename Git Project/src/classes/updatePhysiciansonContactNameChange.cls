global class updatePhysiciansonContactNameChange
{
 Public static Boolean RecursiveFlag = true;
 @future 
 public static void changeName(List<ID> ids)
  {
     //Map<Id, Contact> mapcontact = new Map<Id, Contact>();
     List<Contact> conids=new List<Contact>([Select Id,FirstName,LastName from Contact where Id in: ids ]);
     
     list<Call__c> listcall = [select Id,Physicians__c,Physicianid__c,Fellowid__c,Fellow__c from call__c where Physicianid__c in:Ids or Fellowid__c In:ids];
     System.debug('list .... Call '+listcall);
     List<Call__c> updateCalls = new List<Call__c>();
  
     list<Other_Activity__c> otheractivitylist = [select id,Physician__c,Contact__c,Account__c from Other_Activity__c where Contact__c in:Ids];
     list<Other_Activity__c> updateotheractivity=new list<Other_Activity__c>();
     
     
  For(Contact con:conids){  
  

      for(Call__c casrecord: listcall){
          if(casrecord.Physicianid__c==con.id)
              {                       
                    casrecord.Physicians__c=con.FirstName+' '+con.LastName;
                }
                else if(casrecord.Fellowid__c==con.id)
                {
                       casrecord.Fellow__c=con.FirstName+' '+con.LastName;
                 }
                       updateCalls.add(casrecord);      
               
              }
              
      for(Other_Activity__c otheractivityrecord: otheractivitylist){
  
          otheractivityrecord.Physician__c=con.FirstName+' '+con.LastName;
          
          updateotheractivity.add(otheractivityrecord);
          
           
              }
      
      }
      Update updateCalls;
      Update updateotheractivity;
      
      
  
     system.debug('update Calls cc'+updateCalls);
  
  RecursiveFlag=False;
  }
      
  
  
  }