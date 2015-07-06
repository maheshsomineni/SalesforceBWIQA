@isTest(SeeAllData=true)
public class Test_TouchRecords
{
static testMethod void OtherTest()
{
   test.startTest();
           
         string query='select Id from Other_Activity__c limit 1';
         Id batchInstanceId = Database.executeBatch(new TouchRecords (query), 1);        
         
       test.stopTest();
}
}