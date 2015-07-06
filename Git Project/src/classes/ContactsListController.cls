public class ContactsListController{
List<Contact> Contact {get;set;}
public transient List<str_Contact> lstContact {get;set;} 

Public Boolean renderProfile {get;set;}
Public Id userId {get;set;}
public transient List<Account> allAcc = new List<Account>();
public transient List<Affiliation__c> aff = new List<Affiliation__c>();
    public ContactsListController() {
        String userProfileName = [select u.Profile.Name, id, UserType from User u where u.id = :Userinfo.getUserId()].Profile.Name;
        userId = Userinfo.getUserId();
        
        if(userProfileName == 'Sales Operations'||userProfileName == 'BWI Marketing User')
        {
          renderProfile =  false;
        }
        else
        {
          renderProfile = true;
        }
        
        //calling below function
        getContacts();
    }


    public List<Contact> getContacts(){
    allAccounts a = new allAccounts();
      allAcc = a.acc();
      List<Id> ids = new List<Id>();
      List<id> physids = new List<Id>();
      for(Account ac :allAcc)
      {
        ids.add(ac.id);
      }
       
       aff = [Select id,Hospital__c,Hospital__r.Name,physician__c from affiliation__c where Hospital__c in : ids];
       
       Map<Id,List<Account>> mapConAcc = new Map<Id,List<Account>>(); 
       for(affiliation__c af :aff)
      {
        
        physids.add(af.physician__c);
        
        if(mapConAcc.get(af.physician__c ) != null  )
        {    
            
            List<Account> lstIds = mapConAcc.get(af.physician__c );
           
           Account objAcc = new Account(); 
           objAcc.Name=af.Hospital__r.Name; 
           objAcc.Id = af.Hospital__c; 
            
            lstIds.add(objAcc);
            
            mapConAcc.put(af.physician__c, lstIds  ); 
        }
        else
        {
            List<Account> lstIds = new List<Account>(); 
            
           Account objAcc = new Account(); 
           objAcc.Name=af.Hospital__r.Name; 
           objAcc.Id = af.Hospital__c; 
            
            lstIds.add(objAcc);
            
            mapConAcc.put(af.physician__c, lstIds  ); 
        }
        
      }
        
       
        
        List<Contact> lstCotnactTemp =[SELECT Id,Name,FirstName,LastName,RecordType.Name,Account.Name,AccountId,Title,Email,BirthDate,LastModifiedDate FROM Contact where id in :physids OR createdBYID =:userId ORDER BY LastName];
        
      
      lstContact = new List<str_Contact>();
      
      system.debug('Gaurang:**: got list of contact'+lstCotnactTemp.size() ); 
        for(Contact objContactTemp : lstCotnactTemp )
        {
         
         
           str_Contact objContact = new str_Contact(); 
           
           objContact.ContactId = objContactTemp.Id;
           objContact.Name=objContactTemp .Name; 
           objContact.FirstName=objContactTemp .FirstName; 
           objContact.LastName= objContactTemp .LastName; 
           objContact.RecordType = objContactTemp .RecordType.Name; 
           objContact.Email = objContactTemp .Email;
           objContact.Title = objContactTemp.Title;
          objContact.LastModifiedDate = objContactTemp.LastModifiedDate ;
          
          
          List<Account> lstAccounts = mapConAcc.get(objContactTemp .Id);
          
          if(lstAccounts != null )
          {
              if(lstAccounts.size()> 0)
              {
                        objContact.AccountId  =lstAccounts[0].Id;
                  objContact.AccountName = lstAccounts[0].Name;
                  
              }
              
          }
          

           
           
          lstContact.add(objContact); 
           
           
        }
         return [SELECT Id,FirstName,LastName,RecordType.Name,AccountId,Title,Email,BirthDate,LastModifiedDate FROM Contact where id in :physids OR createdBYID =:userId ORDER BY LastName];
        
    }
    Public class str_Contact
    {
        public string Name {get;set;}
        public Id AccountId {get;set;}
        public Id ContactId {get;set;}

       public string AccountName {get;set;}
       
        public string FirstName {get;set;}
        public string LastName {get;set;}
    
        public string RecordType {get;set;}
        public string Title {get;set;}
        public string Email {get;set;}
        public DateTime LastModifiedDate {get;set;}
        

    }
    
 }