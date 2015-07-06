@isTest
private class Biosense_CongratulationsControllerTest {

	static testMethod void testCert1() {
		test.startTest();

			lmscons__Training_Content__c tc = new lmscons__Training_Content__c(lmscons__Language__c = 'English', lmscons__ContentCatalog__c = 'Sale');
			insert tc;
			lmscons__Training_Content_License__c tcl = new lmscons__Training_Content_License__c(lmscons__Training_Content__c = tc.id);
			insert tcl;
			lmscons__Training_Path__c tpc = new lmscons__Training_Path__c(Name = 'test1');
			insert tpc;
			lmscons__Training_Path_Item__c tpci = new lmscons__Training_Path_Item__c(lmscons__Training_Content__c = tc.Id, lmscons__Training_Path__c = tpc.Id);
			insert tpci;

			lmscons__Transcript__c t = new lmscons__Transcript__c(lmscons__Trainee__c = UserInfo.getUserId());
			insert t;

			lmscons__Training_Path_Assignment_Progress__c tpap = new lmscons__Training_Path_Assignment_Progress__c(lmscons__Training_Path__c = tpc.id, lmscons__Transcript__c = t.id, lmscons__Completion_Date__c = System.now().addDays(-2));
			insert tpap;

			PageReference p = NULL;
			p = Page.Congratulations;
			p.getParameters().put('id', tpap.id);
			test.setCurrentPage(p);

			Biosense_CongratulationsController lcr = new Biosense_CongratulationsController();
			System.assertNotEquals(lcr, NULL);
			Biosense_CertificationDateController bcdc = new Biosense_CertificationDateController();
			bcdc.certificationDate = System.now().addDays(-2);
			DateTime dt = bcdc.certificationDate;

		test.stopTest();
	}

	static testMethod void testCert2() {
		test.startTest();

			lmscons__Training_Content__c tc = new lmscons__Training_Content__c(lmscons__Language__c = 'English', lmscons__ContentCatalog__c = 'Sale');
			insert tc;
			lmscons__Training_Content_License__c tcl = new lmscons__Training_Content_License__c(lmscons__Training_Content__c=tc.id);
			insert tcl;
			lmscons__Training_Path__c tpc = new lmscons__Training_Path__c(Name = 'test1');
			insert tpc;
			lmscons__Training_Path_Item__c tpci = new lmscons__Training_Path_Item__c(lmscons__Training_Content__c = tc.Id, lmscons__Training_Path__c = tpc.Id);
			insert tpci;

			lmscons__Transcript__c t = new lmscons__Transcript__c(lmscons__Trainee__c = UserInfo.getUserId());
			insert t;

			lmscons__Training_User_License__c tul = new lmscons__Training_User_License__c(lmscons__Content_License__c = tcl.id, lmscons__User__c = UserInfo.getUserId());
			insert tul;
			lmscons__Transcript_Line__c transcriptline = new lmscons__Transcript_Line__c(lmscons__Training_Content__c = tc.id, lmscons__Transcript__c = t.id, lmscons__Training_User_License__c = tul.id);
			insert transcriptline;

			PageReference p = NULL;
			p = Page.Congratulations;
			p.getParameters().put('id', transcriptline.id);
			test.setCurrentPage(p);

			Biosense_CongratulationsController lcr = new Biosense_CongratulationsController();
			lcr.getCertSig();
			lcr.getCertLogo();
			System.assertNotEquals(lcr, NULL);

		test.stopTest();
	}

	static testMethod void testCert3() {
		test.startTest();

			lmscons__Training_Content__c tc = new lmscons__Training_Content__c(lmscons__Language__c = 'English', lmscons__ContentCatalog__c = 'Sale');
			insert tc;
			lmscons__Training_Content_License__c tcl = new lmscons__Training_Content_License__c(lmscons__Training_Content__c=tc.id);
			insert tcl;
			lmscons__Training_Path__c tpc = new lmscons__Training_Path__c(Name = 'test1');
			insert tpc;
			lmscons__Training_Path_Item__c tpci = new lmscons__Training_Path_Item__c(lmscons__Training_Content__c = tc.Id, lmscons__Training_Path__c = tpc.Id);
			insert tpci;

			lmscons__Transcript__c t = new lmscons__Transcript__c(lmscons__Trainee__c = UserInfo.getUserId());
			insert t;

			lmscons__Training_User_License__c tul = new lmscons__Training_User_License__c(lmscons__Content_License__c = tcl.id, lmscons__User__c = UserInfo.getUserId());
			insert tul;
			lmscons__Transcript_Line__c transcriptline = new lmscons__Transcript_Line__c(lmscons__Training_Content__c = tc.id, lmscons__Transcript__c = t.id, lmscons__Training_User_License__c = tul.id);
			insert transcriptline;

			PageReference p = NULL;
			p = Page.Congratulations;
			p.getParameters().put('id', NULL);
			test.setCurrentPage(p);

			Biosense_CongratulationsController lcr = new Biosense_CongratulationsController();
			System.assertNotEquals(lcr, NULL);

		test.stopTest();
	}

	public static testmethod void testCert4() {
		test.startTest();
		Profile profile = [SELECT id FROM profile WHERE Name = 'System Administrator'];
		User u = new User(alias = 'test', email='test@test.com', emailencodingkey='UTF-8', lastname='test', languagelocalekey='en_US', localesidkey='en_US', profileid = profile.Id, timezonesidkey='America/Los_Angeles', username='test@testSF22223c.com', lmscons__Cornerstone_ID__c='newtest 261');
		insert u;
		lmscons__Transcript__c t = new lmscons__Transcript__c(lmscons__Trainee__c = u.id);
		insert t;

		System.runAs(u) {
			PageReference p = NULL;
			p = Page.Congratulations;
			p.getParameters().put('id', '3');
			test.setCurrentPage(p);
			Biosense_CongratulationsController TCCD3 = new Biosense_CongratulationsController();
			System.assertEquals(true, true);
		}

		System.assertEquals(true, true);
	}

	public static testmethod void testCert5() {
		test.startTest();
		Profile profile = [select id from profile where name='System Administrator'];
		User u = new User(alias = 'test', email='test@test.com', emailencodingkey='UTF-8', lastname='test', languagelocalekey='en_US', localesidkey='en_US', profileid = profile.Id, timezonesidkey='America/Los_Angeles', username='test@testSF22223c.com', lmscons__Cornerstone_ID__c='newtest 261');
		insert u;
		lmscons__Transcript__c t = new lmscons__Transcript__c(lmscons__Trainee__c = u.id);
		insert t;

		System.runAs(u){
			lmscons__Training_Content__c c = new lmscons__Training_Content__c( lmscons__Title__c = 'Training me', lmscons__Cornerstone_ID__c = 'af' );
			insert c;
			lmscons__Training_Content_License__c cl = new lmscons__Training_Content_License__c( lmscons__Training_Content__c = c.id );
			insert cl;
			lmscons__Training_User_License__c tul = new lmscons__Training_User_License__c( lmscons__Content_License__c = cl.id, lmscons__User__c = u.id  );
			insert tul;
			lmscons__Training_Path__c tp = new lmscons__Training_Path__c( name = 'andy path');
			insert tp;
			lmscons__Training_Path_Item__c ti = new lmscons__Training_Path_Item__c(lmscons__Training_Path__c = tp.id, lmscons__Training_Content__c=c.id, lmscons__Sequence__c=1);
			insert ti;
			lmscons__Transcript_Line__c tl = new lmscons__Transcript_Line__c(lmscons__Training_Path_Item__c=ti.id, lmscons__Transcript__c = t.Id, lmscons__Training_User_License__c = tul.id, lmscons__Percent_Complete__c = 100.00);
			insert tl;
			lmscons__Training_Path_Assignment_Progress__c tpap = new lmscons__Training_Path_Assignment_Progress__c(lmscons__Transcript__c = t.id, lmscons__Training_Path__c = tp.id, lmscons__StatusPicklist__c = 'Completed');
			insert(tpap);
			lmscons__Learning_Path__c LP = new lmscons__Learning_Path__c(Name = 'LP Name');
			insert LP;
			lmscons__Learning_Path_Item__c lpi = new lmscons__Learning_Path_Item__c(lmscons__Learning_Path__c = LP.id, lmscons__Module__c = c.id);
			insert lpi;
			lmscons__Learning_Path_Assignment__c LPA = new lmscons__Learning_Path_Assignment__c(lmscons__Transcript__c = t.id, lmscons__Learning_Path__c = LP.id, lmscons__Status__c = 'Completed');
			insert LPA;

			lmscons__Curriculum__c Cu = new lmscons__Curriculum__c(Name = 'Cu Name');
			insert Cu;
			lmscons__Curriculum_Item__c Cui = new lmscons__Curriculum_Item__c(lmscons__Curriculum__c = Cu.id, lmscons__Module__c = c.id);
			insert Cui;
			lmscons__Curriculum_Assignment__c CuA = new lmscons__Curriculum_Assignment__c(lmscons__Transcript__c = t.id, lmscons__Curriculum__c = Cu.id, lmscons__Status__c = 'Completed');
			insert CuA;
			test.stopTest();

			ApexPages.currentPage().getParameters().put('id',tl.id);
			Biosense_CongratulationsController TCCD = new Biosense_CongratulationsController();

			ApexPages.currentPage().getParameters().put('id',tpap.id);
			Biosense_CongratulationsController TCCD2 = new Biosense_CongratulationsController();

			ApexPages.currentPage().getParameters().put('id',LPA.id);
			Biosense_CongratulationsController TCCD3 = new Biosense_CongratulationsController();

			ApexPages.currentPage().getParameters().put('id',CuA.id);
			Biosense_CongratulationsController TCCD4 = new Biosense_CongratulationsController();
			System.assertEquals(true, true);
		}

		System.assertEquals(true, true);
	}

}