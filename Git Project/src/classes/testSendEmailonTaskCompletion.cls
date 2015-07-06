@istest
public class testSendEmailonTaskCompletion
{
  static testmethod void testTaskEmail()
  {
    Account a = new Account(Name='Test Account');
    insert a;
    Opportunity o = new Opportunity(Name='Test Opp',accountid=a.id,Opportunity_Type__c='Gain - Other',StageName='Opportunity Identification',CloseDate = system.today());
    insert o;
    Contact c = new Contact(FirstName = 'Test', LastName = 'Test');
    insert c;
    Task t =new Task(subject='test', ActivityDate=Date.Today(),whoid=c.id,whatid=o.id,Status='Not Started',description='Test task',Priority='Normal');
    insert t;
    Task t1 = [Select id from Task where subject = 'test'];
    t1.status='Completed';
    update t1;
    
  }
}