@isTest
public class Test_trg_ShareSaleToTerritory
{
    static testMethod void TestData()
    {
       Profile p = [select id from profile where name='System Administrator'];
        User u = new User(alias = 'utest2', email='unit.test2@unit.test.com',
      emailencodingkey='UTF-8', lastname='Unit Test2',
      languagelocalekey='en_US',
      localesidkey='en_GB', profileid = p.Id,
      timezonesidkey='Europe/London',
      username='unit.test2@unit.test.com');
      
                 
System.runAs(u)
{
         
         Territory testTerritory = new Territory();
         testTerritory.Name='GL';
         testTerritory.External_Territory_Id__c = 'GL_MID_MIN';
         testTerritory.DeveloperName = 'Area_Director';
         insert testTerritory;
         
         Territory testTerritory1 = new Territory();
         testTerritory1.Name='GL';
         testTerritory1.External_Territory_Id__c = 'GL_MID';
         testTerritory1.DeveloperName = 'Area_Director1';
         insert testTerritory1;
         
       /*  Group testGroup = new Group();
         testGroup.DeveloperName = 'Area_Director';
         testGroup.Type='Territory';
         insert testGroup;*/
        
        
        List<Sale__c> lstSaleToInsert = new List<sale__c>();
         Sale__c testSale = new  Sale__c();
         testSale.Territory__c='GL_MID_MIN';
         testSale.External_Sales_Id__c = '1000';
         testSale.Fiscal_Period__c='201402';
         testSale.Product_type__c='NAV';
         lstSaleToInsert.add(testSale); 
         
         //LSS/DX
         
         Sale__c testSale1 = new  Sale__c();
         testSale1.Territory__c='GL_MID';
         testSale1.Fiscal_Period__c='201402';
         testSale1.External_Sales_Id__c = '1001';
         testSale1.Product_type__c='LSS/DX';
         
         lstSaletoInsert.add(testSale1);
         insert lstSaletoInsert;
         
         
         
    }
    }
}