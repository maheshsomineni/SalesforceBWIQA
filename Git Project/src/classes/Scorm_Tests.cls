@isTest
private class Scorm_Tests {

	static testMethod void myUnitTest() {

		Profile profile1 = [SELECT Id FROM profile WHERE name ='Guest License User' LIMIT 1];
		List<User> userList = new List<User> {
			new User(alias = 'test10', email='12345amunoz19=its.jnj.com@example.com', lastname='lastName10', profileid = profile1.Id,
				username='test10@gmail.com1243523gdsg', TimeZoneSidKey = 'America/Los_Angeles', LocaleSidKey = 'en_US',
				EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US')
		};
		insert userList;

		////Training_Content__c  Module
		List<lmscons__Training_Content__c> Training_ContentList = new List<lmscons__Training_Content__c>{
			new lmscons__Training_Content__c(lmscons__Title__c = 'Training_Content__c1',
				lmscons__Cornerstone_ID__c = '6fafcf48-7b8f-4a7c-b50c-a3f500891214')
		};
		insert Training_ContentList;

		////Training_Content_License__c
		List<lmscons__Training_Content_License__c> Training_Content_LicenseList = new List<lmscons__Training_Content_License__c>{
			new lmscons__Training_Content_License__c (lmscons__Training_Content__c = Training_ContentList[0].Id )
		};
		insert Training_Content_LicenseList;

		///// Transcript__c
		List<lmscons__Transcript__c> TranscriptList = new List<lmscons__Transcript__c>{
			new lmscons__Transcript__c(lmscons__Trainee__c = userList[0].Id)
		};
		insert TranscriptList;

		////Training_User_License__c
		List<lmscons__Training_User_License__c> Training_User_LicenseList = new List<lmscons__Training_User_License__c>{
			new lmscons__Training_User_License__c (lmscons__Content_License__c = Training_Content_LicenseList[0].Id )
		};
		insert Training_User_LicenseList;

		///// Training_Content_Assignment__c
		List<lmscons__Transcript_Line__c> Training_Content_AssignmentList = new List<lmscons__Transcript_Line__c>{
			new lmscons__Transcript_Line__c(
				lmscons__Transcript__c = TranscriptList[0].Id,
				lmscons__Training_Content__c = Training_ContentList[0].Id,
					lmscons__Training_User_License__c = Training_User_LicenseList[0].Id,
				lmscons__Status__c = 'InCompleted'
			)
		};
		insert Training_Content_AssignmentList;

		List<SCORM_Quiz_Result__c> SQRList = new List<SCORM_Quiz_Result__c>();
		SCORM_Quiz_Result__c ScormResultItem = new SCORM_Quiz_Result__c();
		ScormResultItem.Answer__c = 'af';
		ScormResultItem.Assignment__c = NULL;
		ScormResultItem.Number_Question__c = 1;
		SQRList.add(ScormResultItem);
		insert SQRList;

		Test.startTest();

			Scorm_SettingController Controller = new Scorm_SettingController();
			//Controller.stopSchedulable();
			Controller.startSchedulable();
			Controller.stopSchedulable();
			Controller.startBatch();

			Scorm_Run_Batch ScormBatch1 = new Scorm_Run_Batch();
			ScormBatch1.Status = 'Error';
			Database.executeBatch(ScormBatch1, 1);

			SCORM_Quiz_Result__c ScormResultItem1 = new SCORM_Quiz_Result__c();
			ScormResultItem1.Assignment__c = Training_Content_AssignmentList[0].Id;
			ScormResultItem1.Number_Question__c = 1;
			List<SCORM_Quiz_Result__c> SQRList1 = new List<SCORM_Quiz_Result__c>();
			SQRList1.add(ScormResultItem1);

			Scorm_Result_Batch ScormResultBatch = new Scorm_Result_Batch(SQRList1);
			ScormResultBatch.Action = 'insert';
			Database.executeBatch(ScormResultBatch, 1);
//          ScormResultBatch = new Scorm_Result_Batch(SQRList);
//          ScormResultBatch.Action = 'delete';
//          Database.executeBatch(ScormResultBatch, 1);

		Test.stopTest();

	}
}