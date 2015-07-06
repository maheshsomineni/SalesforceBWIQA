@isTest
public class CFSP_TestMethods {

    public static testMethod void CustomLoginControllerTest() {
        Test.startTest();
        ApexPages.currentPage().getParameters().put('m', 'true');
        CustomLoginController controllerInstanse = new CustomLoginController();
        controllerInstanse.username = 'UserName';
        controllerInstanse.password = 'password';
        controllerInstanse.forwardToCustomAuthPage();
        Boolean messages = controllerInstanse.pageHasMessages;
        String severity = controllerInstanse.severity;
        controllerInstanse.login();
        Test.stopTest();
    }

    public static testMethod void CustomLandingControllerTest() {
        Test.startTest();
        CustomLandingController controllerInstanse = new CustomLandingController();
        Profile profile1 = [SELECT Id FROM profile WHERE name ='Guest License User' LIMIT 1];
        Profile profile2 = [SELECT Id FROM Profile WHERE name !='Guest License User' LIMIT 1];
        List<User> userList = new List<User> {
            new User(alias = 'test10', email='test1@gmail.com', lastname='lastName10', profileid = profile1.Id, username='testProd10@gmail.com', TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US'),
            new User(alias = 'test20', email='test2@gmail.com', lastname='lastName20', profileid = profile2.Id, username='testProd20@gmail.com', TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US', EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US')
        };
        insert userList;
        System.RunAs(userList[0]) {
            controllerInstanse.forwardToCustomAuthPage();
        }
        System.RunAs(userList[1]) {
            controllerInstanse.forwardToCustomAuthPage();
        }
        Test.stopTest();
    }

}