@isTest
private class Test_Biosense_RegisterController {

    static testmethod void Test_Biosense_RegisterController() {

        Profile profile = [SELECT Id FROM profile WHERE Name = 'System Administrator' LIMIT 1];

        String Email = UserInfo.getUserEmail();
        String domain = email.substring(email.indexOf('@')+1, email.length());
        Id orgid = UserInfo.getOrganizationId();
        Email='test'+String.valueof(orgid).substring(10)+'@'+domain;
        Email=(Email.length()>32) ? Email.substring(Email.length()-32,Email.length()) : Email;
        String TestEmail = Email;

        User u = new User(FirstName = 'Boris', LastName = 'Blade', LanguageLocaleKey = 'ja', Email = TestEmail, Alias = 'Beijing', Username = 'Boris@TheBlade.org', CommunityNickname = 'TheBlade', TimeZoneSidKey = 'America/New_York', LocaleSidKey = 'zh_MO', EmailEncodingKey = 'EUC-JP', ProfileId = profile.Id);
        insert u;

        System.runAs(u) {
            Test.startTest();

                Biosense_RegisterController.Field testField = new Biosense_RegisterController.Field();
                testField.index = 1;
                testField.objectName = 'testObjectName';
                testField.field = 'testField';
                testField.operator = '+';

                Biosense_RegisterController.LogicFields testLogicFields = new Biosense_RegisterController.LogicFields();
                testLogicFields.logic = 'testLogic';
                testLogicFields.fields = new List<Biosense_RegisterController.Field>{testField};

                Biosense_RegisterController.RegistrationItem testRegistrationItem = new Biosense_RegisterController.RegistrationItem();
                testRegistrationItem.emailDomain = 'testEmailDomain';
                testRegistrationItem.AccountId = 'testAccountId';
                testRegistrationItem.AccountName = 'testAccountName';

                Biosense_RegisterController.RegistrationSettingsClass testRegClass = new Biosense_RegisterController.RegistrationSettingsClass();
                testRegClass.items = new List<Biosense_RegisterController.RegistrationItem>{testRegistrationItem};
                testRegClass.portalUserProfileId = 'testPortalUserProfileId';
                testRegClass.enableEmailNotificationNewUser = true;
                testRegClass.logicFields = testLogicFields;

                Account account = new Account(Name = 'TestAccount', Owner = u);
                insert account;
                
                Contact testContact = new Contact(
                    FirstName = 'Test',
                    Lastname = 'McTesty',
                    AccountId = account.Id,
                    Email = System.now().millisecond() + 'test@test.com'
                );
                insert testContact;

                cfsp__CFSP_Config__c config = new cfsp__CFSP_Config__c(
                    cfsp__Name__c = 'Registration',
                    cfsp__Data__c = '{"portalUserProfileId":"'+profile.Id+'","portalAccountId":"'+account.Id+'","logicFields":{"logic":"1","fields":[{"operator":"=","objectName":null,"instance":{"value":{"attributes":{"type":"Contact"},"FirstName":"Santa"},"objectName":null,"field":"FirstName"},"index":1,"field":"FirstName.STRING"},{"operator":null,"objectName":null,"instance":null,"index":2,"field":null},{"operator":null,"objectName":null,"instance":null,"index":3,"field":null},{"operator":null,"objectName":null,"instance":null,"index":4,"field":null},{"operator":null,"objectName":null,"instance":null,"index":5,"field":null}]},"limitSelfRegistrationSOQL":"FirstName=\'Santa\'","limitSelfRegistration":false,"items":[{"emailDomain":"vrpinc.com","AccountName":"TestAcc","AccountId":"'+account.Id+'"}],"enableEmailNotificationNewUser":false,"enableEmailNotificationNewLead":null,"enableEmailMapping":false,"enableCreateLead":false,"allowUnknownUsers":false}'
                );

                insert config;

                cfsp__CFSP_Config__c config2 = new cfsp__CFSP_Config__c(
                    cfsp__Name__c = 'Register',
                    cfsp__Data__c = '[]'
                );

                insert config2;
                
                cfsp__CFSP_Config__c config3 = new cfsp__CFSP_Config__c(
                    cfsp__Name__c = 'Common',
                    cfsp__Data__c = '{"timeOffsetToStartChangeEventTrainingUnitUsageStatus":"0","templatePage":"c__BiosenseTemplate","showMessageForUnregisterUser":false,"showDescription":["FindLearning","MyLearning","DevelopmentPlans","CompletedLearning"],"selectAllCatalogs":true,"redirectRegisterPage":"cfsp__CFSP_Login","enabledAnonymousRedirectUrl":false,"defaultLearningSubTab":"MyLearning","communityId":"0DBc000000000E3","anonymousSearching":false,"anonymousRedirectUrl":""}'
                );

                insert config3;

                Biosense_RegisterController regController = new Biosense_RegisterController();
                regController.company = 'TestCompany';
                regController.email = 'test@gmail.com';
                regController.confirmEmail = 'test@gmail.com';
                regController.firstName = 'TestFirstname';
                regController.lastName = 'TestLastname';
                String severityTest = regController.severity;
                regController.username = 'tester@tester.com';
                regController.inputCaptcha = regController.codeByCaptchaNumber.get(regController.getCaptchaNumber());
                regController.getDynamicTemplate();
                regController.getRedirectRegisterPage();

                /*Usual registration*/
                regController.registerUser();

                /*"limitSelfRegistration": "true"*/
                config.cfsp__Data__c = '{"portalUserProfileId":"'+profile.Id+'","portalAccountId":"'+account.Id+'","logicFields":{"logic":"1","fields":[{"operator":"=","objectName":null,"instance":{"value":{"attributes":{"type":"Contact"},"FirstName":"Santa"},"objectName":null,"field":"FirstName"},"index":1,"field":"FirstName.STRING"},{"operator":null,"objectName":null,"instance":null,"index":2,"field":null},{"operator":null,"objectName":null,"instance":null,"index":3,"field":null},{"operator":null,"objectName":null,"instance":null,"index":4,"field":null},{"operator":null,"objectName":null,"instance":null,"index":5,"field":null}]},"limitSelfRegistrationSOQL":"FirstName=\'Santa\'","limitSelfRegistration":true,"items":[{"emailDomain":"vrpinc.com","AccountName":"TestAcc","AccountId":"'+account.Id+'"}],"enableEmailNotificationNewUser":false,"enableEmailNotificationNewLead":null,"enableEmailMapping":false,"enableCreateLead":false,"allowUnknownUsers":false}';
                update config;

                regController.registerUser();

                Biosense_RegisterController.sendWorkflowEmailNotificationNewUser(account.Id, u.Id);
                regController.updateContact(testContact);
                regController.updateUser(u);

                System.assertNotEquals(NULL, regController);
            Test.stopTest();
        }
    }


    static testmethod void Test_Biosense_RegisterController2() {

        Profile profile = [SELECT Id FROM profile WHERE Name = 'System Administrator' LIMIT 1];

        String Email = UserInfo.getUserEmail();
        String domain = email.substring(email.indexOf('@')+1, email.length());
        Id orgid = UserInfo.getOrganizationId();
        Email='test'+String.valueof(orgid).substring(10)+'@'+domain;
        Email=(Email.length()>32) ? Email.substring(Email.length()-32,Email.length()) : Email;
        String TestEmail = Email;


        User u = new User(FirstName = 'Boris', LastName = 'Blade', LanguageLocaleKey = 'ja', Email = TestEmail, Alias = 'Beijing', Username = 'Boris@TheBlade.org', CommunityNickname = 'TheBlade', TimeZoneSidKey = 'America/New_York', LocaleSidKey = 'zh_MO', EmailEncodingKey = 'EUC-JP', ProfileId = profile.Id);
        insert u;

        Account account = new Account(Name = 'TestAccount', Owner = u);
        insert account;

        cfsp__CFSP_Config__c config = new cfsp__CFSP_Config__c(
            cfsp__Name__c = 'Registration',
            cfsp__Data__c = '{"portalUserProfileId":"'+profile.Id+'","portalAccountId":"'+account.Id+'","logicFields":{"logic":"1","fields":[{"operator":"=","objectName":null,"instance":{"value":{"attributes":{"type":"Contact"},"FirstName":"Santa"},"objectName":null,"field":"FirstName"},"index":1,"field":"FirstName.STRING"},{"operator":null,"objectName":null,"instance":null,"index":2,"field":null},{"operator":null,"objectName":null,"instance":null,"index":3,"field":null},{"operator":null,"objectName":null,"instance":null,"index":4,"field":null},{"operator":null,"objectName":null,"instance":null,"index":5,"field":null}]},"limitSelfRegistrationSOQL":"FirstName=\'Santa\'","limitSelfRegistration":false,"items":[{"emailDomain":"vrpinc.com","AccountName":"TestAcc","AccountId":"'+account.Id+'"}],"enableEmailNotificationNewUser":false,"enableEmailNotificationNewLead":null,"enableEmailMapping":false,"enableCreateLead":false,"allowUnknownUsers":false}'
        );
        insert config;

        cfsp__CFSP_Config__c registerConfig = new cfsp__CFSP_Config__c(
            cfsp__Name__c = 'Register',
            //cfsp__Data__c = '{"userFields":[{"objectName":"User","label":"Country","instance":null,"fieldType":"STRING","field":"Country","enabled":true}],"contactFields":[{"objectName":"Contact","label":"Email","instance":null,"fieldType":"EMAIL","field":"Email","enabled":true}]}'
            cfsp__Data__c = '[{"sequence":0,"required":false,"objectName":"User","label":"Country","instance":null,"fieldType":"STRING","field":"Country","enabled":true}]'
        );

        cfsp__CFSP_Email_Domain_To_Account__c accountEmailDomain = new cfsp__CFSP_Email_Domain_To_Account__c(
            cfsp__Account__c = account.Id,
            cfsp__Email_Domain__c = 'gmail.com'
        );
        insert accountEmailDomain;

        insert registerConfig;

        System.runAs(u) {
            Test.startTest();

                Biosense_RegisterController regController = new Biosense_RegisterController();

                regController.company = 'TestCompany';
                regController.email = 'test@gmail.com';
                regController.confirmEmail = 'test@gmail.com';
                regController.firstName = 'TestFirstname';
                regController.lastName = 'TestLastname';
                String severityTest = regController.severity;
                regController.username = 'tester@tester.com';
                regController.inputCaptcha = regController.codeByCaptchaNumber.get(regController.getCaptchaNumber());

                regController.registerUser();

                /*enableEmailMapping":true*/
                config.cfsp__Data__c = '{"portalUserProfileId":"'+profile.Id+'","portalAccountId":"'+account.Id+'","logicFields":{"logic":"1","fields":[{"operator":"=","objectName":null,"instance":{"value":{"attributes":{"type":"Contact"},"FirstName":"Santa"},"objectName":null,"field":"FirstName"},"index":1,"field":"FirstName.STRING"},{"operator":null,"objectName":null,"instance":null,"index":2,"field":null},{"operator":null,"objectName":null,"instance":null,"index":3,"field":null},{"operator":null,"objectName":null,"instance":null,"index":4,"field":null},{"operator":null,"objectName":null,"instance":null,"index":5,"field":null}]},"limitSelfRegistrationSOQL":"FirstName=\'Santa\'","limitSelfRegistration":false,"items":[{"emailDomain":"vrpinc.com","AccountName":"TestAcc","AccountId":"'+account.Id+'"}],"enableEmailNotificationNewUser":false,"enableEmailNotificationNewLead":null,"enableEmailMapping":true,"enableCreateLead":false,"allowUnknownUsers":true}';
                update config;

                regController.registerUser();

                /*"enableEmailMapping":true,"enableCreateLead":true,"allowUnknownUsers":true*/
                config.cfsp__Data__c = '{"portalUserProfileId":"'+profile.Id+'","portalAccountId":"'+account.Id+'","logicFields":{"logic":"1","fields":[{"operator":"=","objectName":null,"instance":{"value":{"attributes":{"type":"Contact"},"FirstName":"Santa"},"objectName":null,"field":"FirstName"},"index":1,"field":"FirstName.STRING"},{"operator":null,"objectName":null,"instance":null,"index":2,"field":null},{"operator":null,"objectName":null,"instance":null,"index":3,"field":null},{"operator":null,"objectName":null,"instance":null,"index":4,"field":null},{"operator":null,"objectName":null,"instance":null,"index":5,"field":null}]},"limitSelfRegistrationSOQL":"FirstName=\'Santa\'","limitSelfRegistration":false,"items":[{"emailDomain":"vrpinc.com","AccountName":"TestAcc","AccountId":"'+account.Id+'"}],"enableEmailNotificationNewUser":false,"enableEmailNotificationNewLead":false,"enableEmailMapping":true,"enableCreateLead":true,"allowUnknownUsers":true}';
                update config;

                regController.registerUser();

                accountEmailDomain.cfsp__Profile__c = profile.Id;
                update accountEmailDomain;
                regController.registerUser();

                System.assertNotEquals(NULL, regController);
            Test.stopTest();
        }
    }

    static testmethod void Test_Biosense_RegisterController3() {

        Profile profile = [SELECT Id FROM profile WHERE Name = 'System Administrator' LIMIT 1];

        String Email = UserInfo.getUserEmail();
        String domain = email.substring(email.indexOf('@')+1, email.length());
        Id orgid = UserInfo.getOrganizationId();
        Email='test'+String.valueof(orgid).substring(10)+'@'+domain;
        Email=(Email.length()>32) ? Email.substring(Email.length()-32,Email.length()) : Email;
        String TestEmail = Email;

        User u = new User(FirstName = 'Boris', LastName = 'Blade', LanguageLocaleKey = 'ja', Email = TestEmail, Alias = 'Beijing', Username = 'Boris@TheBlade.org', CommunityNickname = 'TheBlade', TimeZoneSidKey = 'America/New_York', LocaleSidKey = 'zh_MO', EmailEncodingKey = 'EUC-JP', ProfileId = profile.Id);
        insert u;

        Account account = new Account(Name = 'TestAccount', Owner = u);
        insert account;

        cfsp__CFSP_Config__c config = new cfsp__CFSP_Config__c(
            cfsp__Name__c = 'Registration',
            cfsp__Data__c = '{"portalUserProfileId":"'+profile.Id+'","portalAccountId":"'+account.Id+'","logicFields":{"logic":"1","fields":[{"operator":"=","objectName":null,"instance":{"value":{"attributes":{"type":"Contact"},"FirstName":"Santa"},"objectName":null,"field":"FirstName"},"index":1,"field":"FirstName.STRING"},{"operator":null,"objectName":null,"instance":null,"index":2,"field":null},{"operator":null,"objectName":null,"instance":null,"index":3,"field":null},{"operator":null,"objectName":null,"instance":null,"index":4,"field":null},{"operator":null,"objectName":null,"instance":null,"index":5,"field":null}]},"limitSelfRegistrationSOQL":"FirstName=\'Santa\'","limitSelfRegistration":false,"items":[{"emailDomain":"vrpinc.com","AccountName":"TestAcc","AccountId":"'+account.Id+'"}],"enableEmailNotificationNewUser":false,"enableEmailNotificationNewLead":null,"enableEmailMapping":false,"enableCreateLead":false,"allowUnknownUsers":false}'
        );
        insert config;
        cfsp__CFSP_Config__c registerConfig = new cfsp__CFSP_Config__c(
            cfsp__Name__c = 'Register',
            //cfsp__Data__c = '{"userFields":[{"objectName":"User","label":"Country","instance":null,"fieldType":"STRING","field":"Country","enabled":true}],"contactFields":[{"objectName":"Contact","label":"Email","instance":null,"fieldType":"EMAIL","field":"Email","enabled":true}]}'
            cfsp__Data__c = '[{"sequence":0,"required":false,"objectName":"User","label":"Country","instance":null,"fieldType":"STRING","field":"Country","enabled":true}]'
        );
        insert registerConfig;

        cfsp__CFSP_Email_Domain_To_Account__c accountEmailDomain = new cfsp__CFSP_Email_Domain_To_Account__c(
            cfsp__Account__c = account.Id,
            cfsp__Email_Domain__c = 'gunmail.com'
        );
        insert accountEmailDomain;

        System.runAs(u) {
            Test.startTest();

                Biosense_RegisterController regController = new Biosense_RegisterController();

                regController.company = 'TestCompany';
                regController.email = 'test@gmail.com';
                regController.confirmEmail = 'test@gmail.com';
                regController.firstName = 'TestFirstname';
                regController.lastName = 'TestLastname';
                String severityTest = regController.severity;
                regController.username = 'tester@tester.com';
                regController.inputCaptcha = regController.codeByCaptchaNumber.get(regController.getCaptchaNumber());

                regController.registerUser();

                /*enableEmailMapping*/
                config.cfsp__Data__c = '{"portalUserProfileId":"'+profile.Id+'","portalAccountId":"'+account.Id+'","logicFields":{"logic":"1","fields":[{"operator":"=","objectName":null,"instance":{"value":{"attributes":{"type":"Contact"},"FirstName":"Santa"},"objectName":null,"field":"FirstName"},"index":1,"field":"FirstName.STRING"},{"operator":null,"objectName":null,"instance":null,"index":2,"field":null},{"operator":null,"objectName":null,"instance":null,"index":3,"field":null},{"operator":null,"objectName":null,"instance":null,"index":4,"field":null},{"operator":null,"objectName":null,"instance":null,"index":5,"field":null}]},"limitSelfRegistrationSOQL":"FirstName=\'Santa\'","limitSelfRegistration":false,"items":[{"emailDomain":"vrpinc.com","AccountName":"TestAcc","AccountId":"'+account.Id+'"}],"enableEmailNotificationNewUser":false,"enableEmailNotificationNewLead":null,"enableEmailMapping":true,"enableCreateLead":false,"allowUnknownUsers":true}';
                update config;

                regController.registerUser();

                /*"enableEmailNotificationNewLead":false,"enableEmailMapping":true,"enableCreateLead":true,*/
                config.cfsp__Data__c = '{"portalUserProfileId":"'+profile.Id+'","portalAccountId":"'+account.Id+'","logicFields":{"logic":"1","fields":[{"operator":"=","objectName":null,"instance":{"value":{"attributes":{"type":"Contact"},"FirstName":"Santa"},"objectName":null,"field":"FirstName"},"index":1,"field":"FirstName.STRING"},{"operator":null,"objectName":null,"instance":null,"index":2,"field":null},{"operator":null,"objectName":null,"instance":null,"index":3,"field":null},{"operator":null,"objectName":null,"instance":null,"index":4,"field":null},{"operator":null,"objectName":null,"instance":null,"index":5,"field":null}]},"limitSelfRegistrationSOQL":"FirstName=\'Santa\'","limitSelfRegistration":false,"items":[{"emailDomain":"vrpinc.com","AccountName":"TestAcc","AccountId":"'+account.Id+'"}],"enableEmailNotificationNewUser":false,"enableEmailNotificationNewLead":false,"enableEmailMapping":true,"enableCreateLead":true,"allowUnknownUsers":true}';
                update config;

                regController.registerUser();

                /*enableEmailNotificationNewLead = true*/
                config.cfsp__Data__c = '{"portalUserProfileId":"'+profile.Id+'","portalAccountId":"'+account.Id+'","logicFields":{"logic":"1","fields":[{"operator":"=","objectName":null,"instance":{"value":{"attributes":{"type":"Contact"},"FirstName":"Santa"},"objectName":null,"field":"FirstName"},"index":1,"field":"FirstName.STRING"},{"operator":null,"objectName":null,"instance":null,"index":2,"field":null},{"operator":null,"objectName":null,"instance":null,"index":3,"field":null},{"operator":null,"objectName":null,"instance":null,"index":4,"field":null},{"operator":null,"objectName":null,"instance":null,"index":5,"field":null}]},"limitSelfRegistrationSOQL":"FirstName=\'Santa\'","limitSelfRegistration":false,"items":[{"emailDomain":"vrpinc.com","AccountName":"TestAcc","AccountId":"'+account.Id+'"}],"enableEmailNotificationNewUser":false,"enableEmailNotificationNewLead":true,"enableEmailMapping":true,"enableCreateLead":true,"allowUnknownUsers":true}';
                update config;

                regController.registerUser();

                cfsp__CFSP_EmailNotification__c emailNotification = new cfsp__CFSP_EmailNotification__c();
                insert emailNotification;

                List<String> recordIdsToDelete = new List<String>();
                recordIdsToDelete.add(emailNotification.Id);
                Biosense_RegisterController.deleteCompleteEmailNotificationRecords(recordIdsToDelete);

                System.assertNotEquals(NULL, regController);

            Test.stopTest();
        }
    }

    static testmethod void Test_Biosense_RegisterControllerWrongDataRegistration() {

        Profile profile = [SELECT Id FROM profile WHERE Name = 'System Administrator' LIMIT 1];

        String Email = UserInfo.getUserEmail();
        String domain = email.substring(email.indexOf('@')+1, email.length());
        Id orgid = UserInfo.getOrganizationId();
        Email='test'+String.valueof(orgid).substring(10)+'@'+domain;
        Email=(Email.length()>32) ? Email.substring(Email.length()-32,Email.length()) : Email;
        String TestEmail = Email;

        User u = new User(FirstName = 'Boris', LastName = 'Blade', LanguageLocaleKey = 'ja', Email = TestEmail, Alias = 'Beijing', Username = 'Boris@TheBlade.org', CommunityNickname = 'TheBlade', TimeZoneSidKey = 'America/New_York', LocaleSidKey = 'zh_MO', EmailEncodingKey = 'EUC-JP', ProfileId = profile.Id);
        insert u;

        System.runAs(u) {
            Test.startTest();

                Account account = new Account(Name = 'TestAccount', Owner = u);
                insert account;

                cfsp__CFSP_Config__c config = new cfsp__CFSP_Config__c(
                    cfsp__Name__c = 'Registration',
                    cfsp__Data__c = '{"portalUserProfileId":"'+profile.Id+'","portalAccountId":"'+account.Id+'","logicFields":{"logic":"1","fields":[{"operator":"=","objectName":null,"instance":{"value":{"attributes":{"type":"Contact"},"FirstName":"Santa"},"objectName":null,"field":"FirstName"},"index":1,"field":"FirstName.STRING"},{"operator":null,"objectName":null,"instance":null,"index":2,"field":null},{"operator":null,"objectName":null,"instance":null,"index":3,"field":null},{"operator":null,"objectName":null,"instance":null,"index":4,"field":null},{"operator":null,"objectName":null,"instance":null,"index":5,"field":null}]},"limitSelfRegistrationSOQL":"FirstName=\'Santa\'","limitSelfRegistration":false,"items":[{"emailDomain":"vrpinc.com","AccountName":"TestAcc","AccountId":"'+account.Id+'"}],"enableEmailNotificationNewUser":false,"enableEmailNotificationNewLead":null,"enableEmailMapping":false,"enableCreateLead":false,"allowUnknownUsers":false}'
                );

                insert config;

                cfsp__CFSP_Config__c config2 = new cfsp__CFSP_Config__c(
                    cfsp__Name__c = 'Register',
                    cfsp__Data__c = '[]'
                );

                insert config2;

                PageReference pageRef = Page.Biosense_Register;
                Test.setCurrentPage(pageRef);
                ApexPages.CurrentPage().getParameters().put('hasError','true');
                Biosense_RegisterController regController = new Biosense_RegisterController();
                regController.firstName = '#';
                regController.lastName = '#';
                regController.username = '#';
                regController.email = '#';
                regController.confirmEmail = '#';
                regController.company = '';


                String severityTest = regController.severity;

                /*Usual registration*/
                regController.registerUser();

                regController.firstName = '';
                regController.lastName = '';
                regController.username = '';
                regController.email = '';

                regController.registerUser();
                Biosense_RegisterController.createConsumerUser(u.Id);

                regController.resetCaptcha();
                Integer captchaNumber = regController.getCaptchaNumber();

                System.assertNotEquals(NULL, regController);
            Test.stopTest();
        }
    }

}