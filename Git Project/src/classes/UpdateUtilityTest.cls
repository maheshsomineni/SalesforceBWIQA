@isTest
private  class UpdateUtilityTest {
    //Positive test
    static testMethod void myUnitTest() {
        Opportunity op=new Opportunity(name='Test Opportunity',StageName='Closed won',closeDate=Date.Today());       
        
        insert op;
        String odjName=Utility.whichObject(op.id);
        
        System.assertEquals('Opportunity',odjName);
    }
    //Negative test
    static testMethod void myUnitTest1() {
        Account ac=new Account(name='Test Account');
        insert ac;
        String odjName=Utility.whichObject(ac.id);
        // TO DO: implement unit test
        System.assertNotEquals('Opportunity',odjName);
    }
    
    //Positive test
    static testMethod void myUnitTestNotes() {
        Opportunity op=new Opportunity(name='Test Opportunity',StageName='Closed won',closeDate=Date.Today());       
           insert op;
        Note n=new Note(ParentId=op.id,Title='Test Notes');
        insert n;
        try {
            update n;
        }catch (DmlException e) {
            System.debug('Exception raised');
          //  System.assertEquals(e.getDmlMessage(0),'You cannot edit notes.');
        }
    }
    //Negative test
    static testMethod void myUnitTestNotes1() {
        Account ac=new Account(name='Test Account');
        insert ac;
        Note n=new Note(ParentId=ac.id,Title='Test Notes');
        insert n;
        update n;
    }
    
}