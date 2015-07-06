public with sharing class Scorm_Result {

	public List<SCORM_Quiz_Result__c> ScormResultList {get;set;}
	public List<String> AssignmentIdList {get;set;}
	public String Status {get;set;}
	public String Message {get;set;}
	public Date StartDate {get;set;}
	public Date EndDate {get;set;}

	public class Results {
		public String UserId {get;set;}
		public String UserEmail {get;set;}
		public String ModuleId {get;set;}
		public String State {get;set;}
		public String AssignmentId {get;set;}
		public List<InteractionList> AnswersList {get;set;}
		public String TranscriptId {get;set;}
	}

	public class TempData {
		public String ApplicationId {get;set;}
		public String CourseId {get;set;}
		public String State {get;set;}
		public String UserEmail {get;set;}
		public String UserId {get;set;}
	}

	public class State {
		public List<ActivitySessionList> ActivitySessionList {get;set;}
	}

	public class ActivitySessionList {
		public List<InteractionList> InteractionList {get;set;}
	}

	public class InteractionList {
		public String Response {get;set;}
		public String ResultCode {get;set;}
		public String Description {get;set;}
	}

	public void saveResult() {
		ScormResultList = new List<SCORM_Quiz_Result__c>();
		AssignmentIdList = new List<String>();

		HttpResponse Call = new HttpResponse();
		Call = callWebService();
		if (Call.getStatus() != 'OK' && Call.getStatusCode() != 200) {
			Status = 'Error';
			Message = Call.getStatus();
			return;
		}
		String json = Call.getBody();

		List<TempData> TempDataList = this.parserTempData(json);

		List<Results> ResultsList = new List<Results>();

		List<String> UserEmailsList = new List<String>();
		List<String> CourseIdsList = new List<String>();

		Map<String, Results> ResultsMap = new Map<String, Results>();
		Map<String, State> StateMap = new Map<String, State>();

		Map<String, String> TranscriptMap = new Map<String, String>();
		Map<String, Map<String,String>> AssignmentMap = new Map<String, Map<String,String>>();
		Set<String> TranscriptSet = new Set<String>();

		for (TempData Item : TempDataList) {
			Results ResultItem = new Results();
			ResultItem.UserId = Item.UserId;
			ResultItem.UserEmail = Item.UserEmail;
			ResultItem.ModuleId = Item.CourseId;
			ResultItem.State = Item.State;
			ResultItem.AnswersList = new List<InteractionList>();
			ResultsList.add(ResultItem);
			UserEmailsList.add(ResultItem.UserEmail);
			CourseIdsList.add(ResultItem.ModuleId);
		}

		TranscriptMap = getTranscriptIds(UserEmailsList);

		for (Results Item : ResultsList) {
			if (TranscriptMap.get(Item.UserEmail) != NULL) {
				Item.TranscriptId = TranscriptMap.get(Item.UserEmail);
				TranscriptSet.add(TranscriptMap.get(Item.UserEmail));
			}
		}

		AssignmentMap = getAssignmentId(CourseIdsList, TranscriptSet);

		for (Results Item : ResultsList) {
			State StateItem = this.parserState(Item.State);
			if (!StateItem.ActivitySessionList.isEmpty()) {
				if (StateItem.ActivitySessionList.size() > 1) {
					if (!StateItem.ActivitySessionList[1].InteractionList.isEmpty()) {
						Item.AnswersList.addAll(StateItem.ActivitySessionList[1].InteractionList);
					}
				}
			}
			if (String.isNotBlank(Item.TranscriptId) && String.isNotBlank(Item.ModuleId)) {
				if (AssignmentMap.get(Item.TranscriptId) != NULL) {
					if (AssignmentMap.get(Item.TranscriptId).get(Item.ModuleId) != NULL) {
						Item.AssignmentId = AssignmentMap.get(Item.TranscriptId).get(Item.ModuleId);
					}
				}
			}
		}

		for (Results Item : ResultsList) {
			if (!Item.AnswersList.isEmpty()) {
				Integer Num = 1;
				if (String.isNotBlank(Item.AssignmentId)) {
					for (InteractionList InteractionListItem : Item.AnswersList) {
						SCORM_Quiz_Result__c ScormResultItem = new SCORM_Quiz_Result__c();
//                      ScormResultItem.Answer__c = StringItem;
						ScormResultItem.Assignment__c = Item.AssignmentId;
						ScormResultItem.Number_Question__c = Num;
						ScormResultItem.Description__c = InteractionListItem.Description;
						ScormResultItem.Response__c = InteractionListItem.Response.replaceAll('_', ' ').replaceAll('\\[,\\]',',');
						ScormResultItem.Result_Code__c = InteractionListItem.ResultCode;
						ScormResultList.add(ScormResultItem);
						Num++;
					}
					AssignmentIdList.add(Item.AssignmentId);
				}
			}
		}

		Status = 'Success';
		Message = 'Completed. The Scorm quiz results have been received';
		return;
	}

	public List<SCORM_Quiz_Result__c> getScormQuizResult() {
		return ScormResultList;
	}

	public List<SCORM_Quiz_Result__c> getScormQuizDelete() {
		List<SCORM_Quiz_Result__c> QuizResultsList = new List<SCORM_Quiz_Result__c>();
		if (!AssignmentIdList.isEmpty()) {
			QuizResultsList = [
				SELECT Id, Name, Assignment__c
				FROM SCORM_Quiz_Result__c
				WHERE Assignment__r.Id IN : AssignmentIdList
			];
		}
		return QuizResultsList;
	}

	public Map<String, String> getTranscriptIds(List<String> userEmails) {
		Map<String, String> TranscriptMap = new Map<String, String>();
		List<lmscons__Transcript__c> transcriptList = [
			SELECT Id, lmscons__Trainee__r.email
			FROM lmscons__Transcript__c
			WHERE lmscons__Trainee__r.email IN : userEmails
		];
		for (lmscons__Transcript__c Item : transcriptList) {
			if (TranscriptMap.get(Item.lmscons__Trainee__r.email) == NULL) {
				TranscriptMap.put(Item.lmscons__Trainee__r.email, Item.Id);
			}
		}
		return TranscriptMap;
	}

	public Map<String, Map<String,String>> getAssignmentId(List<String> coursesId, Set<String> TranscriptSet) {
		Map<String, Map<String,String>> AssignmentMap = new Map<String, Map<String,String>>();
		Map<String, String> ModuleMap = new Map<String, String>();
		List<lmscons__Transcript_Line__c> TranscriptLinesList = [
			SELECT Id, IsDeleted, Name, lmscons__Transcript__c, lmscons__Training_Content__r.lmscons__Cornerstone_ID__c
			FROM lmscons__Transcript_Line__c
			WHERE lmscons__Training_Content__r.lmscons__Cornerstone_ID__c IN : coursesId
		];
		for (lmscons__Transcript_Line__c Item : TranscriptLinesList) {
			if (TranscriptSet.contains(Item.lmscons__Transcript__c)) {
				if (AssignmentMap.get(Item.lmscons__Transcript__c) == NULL) {
					ModuleMap = new Map<String, String>();
					ModuleMap.put(Item.lmscons__Training_Content__r.lmscons__Cornerstone_ID__c, Item.Id);
					AssignmentMap.put(Item.lmscons__Transcript__c, ModuleMap);
				}
				else {
					AssignmentMap.get(Item.lmscons__Transcript__c).put(Item.lmscons__Training_Content__r.lmscons__Cornerstone_ID__c, Item.Id);
				}
			}
		}
		return AssignmentMap;
	}

	public List<TempData> parserTempData(String Json) {
		JSONParser parser = System.JSON.createParser(Json);
		List<TempData> TempDataList = new List<TempData>();
		TempData TempDataItem = new TempData();

		while (parser.nextToken() != JSONToken.END_ARRAY) {
			if (parser.getCurrentToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'ApplicationId') {
							TempDataItem.ApplicationId = parser.getText();
						} else if (text == 'CompletionDate') {
							parserEmptyField(parser);
						} else if (text == 'CompletionStatus') {
							parserEmptyField(parser);
						} else if (text == 'CourseId') {
							TempDataItem.CourseId = parser.getText();
						} else if (text == 'CourseType') {
							parserEmptyField(parser);
						} else if (text == 'CourseVersionId') {
							parserEmptyField(parser);
						} else if (text == 'ExternalId') {
							parserEmptyField(parser);
						} else if (text == 'Progress') {
							parserEmptyField(parser);
						} else if (text == 'Score') {
							parserEmptyField(parser);
						} else if (text == 'State') {
							TempDataItem.State = parser.getText();
						} else if (text == 'SuccessStatus') {
							parserEmptyField(parser);
						} else if (text == 'UserEmail') {
							TempDataItem.UserEmail = parser.getText();
						} else if (text == 'UserId') {
							TempDataItem.UserId = parser.getText();
						} else {

						}
					}
				}
			}
			else {
				TempDataList.add(TempDataItem);
				TempDataItem = new TempData();
			}
		}
		return TempDataList;
	}

	public State parserState(String Json) {
		JSONParser parser = System.JSON.createParser(Json);
		State StateItem = new State();

		while (parser.nextToken() != JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != JSONToken.VALUE_NULL) {
					if (text == 'LearnerId') {
						parserEmptyField(parser);
					} else if (text == 'ContentPackageId') {
						parserEmptyField(parser);
					} else if (text == 'CurrentActivityId') {
						parserEmptyField(parser);
					} else if (text == 'SuspendedActivityId') {
						parserEmptyField(parser);
					} else if (text == 'Timestamp') {
						parserEmptyField(parser);
					} else if (text == 'ActivitySessionList') {
						StateItem.ActivitySessionList = new List<ActivitySessionList>();
						while (parser.nextToken() != JSONToken.END_ARRAY) {
							StateItem.ActivitySessionList.add(parserActivitySessionList(parser));
						}
					} else if (text == 'CompletedAt') {
						parserEmptyField(parser);
					} else if (text == 'IsFinished') {
						parserEmptyField(parser);
					} else {

					}
				}
			}
		}

		return StateItem;
	}

	public ActivitySessionList parserActivitySessionList(JSONParser parser) {
		ActivitySessionList ActivitySessionItem = new ActivitySessionList();

			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != JSONToken.VALUE_NULL) {
						if (text == 'ManifestActivityId') {
							parserEmptyField(parser);
						} else if (text == 'AttemptAt') {
							parserEmptyField(parser);
						} else if (text == 'CompletedAt') {
							parserEmptyField(parser);
						} else if (text == 'Scaled') {
							parserEmptyField(parser);
						} else if (text == 'Raw') {
							parserEmptyField(parser);
						} else if (text == 'Min') {
							parserEmptyField(parser);
						} else if (text == 'Max') {
							parserEmptyField(parser);
						} else if (text == 'TotalTimeTicks') {
							parserEmptyField(parser);
						} else if (text == 'Location') {
							parserEmptyField(parser);
						} else if (text == 'SuspendData') {
							parserEmptyField(parser);
						} else if (text == 'ProgressMeasure') {
							parserEmptyField(parser);
						} else if (text == 'Attempted') {
							parserEmptyField(parser);
						} else if (text == 'ScoreProgressMeasure') {
							parserEmptyField(parser);
						} else if (text == 'AttemptCompletionStatus') {
							parserEmptyField(parser);
						} else if (text == 'AttemptProgressStatus') {
							parserEmptyField(parser);
						} else if (text == 'RollupAttemptCompletionStatus') {
							parserEmptyField(parser);
						} else if (text == 'RollupAttemptProgressStatus') {
							parserEmptyField(parser);
						} else if (text == 'ActivityProgressStatus') {
							parserEmptyField(parser);
						} else if (text == 'IsActive') {
							parserEmptyField(parser);
						} else if (text == 'IsSuspended') {
							parserEmptyField(parser);
						} else if (text == 'ObjectivesList') {
							parserEmptyField(parser);
						} else if (text == 'InteractionList') {
							ActivitySessionItem.InteractionList = new List<InteractionList>();
							while (parser.nextToken() != JSONToken.END_ARRAY) {
								ActivitySessionItem.InteractionList.add(parseInteractionList(parser));
							}
						} else if (text == 'LearnerCommentList') {
							parserEmptyField(parser);
						} else if (text == 'LearnerPreferenceList') {
							parserEmptyField(parser);
						} else if (text == 'CompletionStatusChangedDuringRuntime') {
							parserEmptyField(parser);
						} else {

						}
					}
				}
			}
		return ActivitySessionItem;
	}


	public InteractionList parseInteractionList(JSONParser parser) {
		InteractionList InteractionListItem = new InteractionList();

		while (parser.nextToken() != JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != JSONToken.VALUE_NULL) {
					if (text == 'Timestamp') {
						parserEmptyField(parser);
					} else if (text == 'Weighting') {
						parserEmptyField(parser);
					} else if (text == 'Response') {
						InteractionListItem.Response = parser.getText();
					} else if (text == 'ResultCode') {
						InteractionListItem.ResultCode = parser.getText();
					} else if (text == 'Latency') {
						parserEmptyField(parser);
					} else if (text == 'Description') {
						InteractionListItem.Description = parser.getText();
					} else if (text == 'ManifestObjectiveId') {
						parserEmptyField(parser);
					} else if (text == 'ManifestId') {
						parserEmptyField(parser);
					} else if (text == 'TypeCode') {
						parserEmptyField(parser);
					} else if (text == 'TransitionKey') {
						parserEmptyField(parser);
					} else if (text == 'InteractionToObjectiveList') {
						parserEmptyField(parser);
					} else if (text == 'InterationCorrectResponseList') {
						parserEmptyField(parser);
					} else {

					}
				}
			}
		}

		return InteractionListItem;
	}

	private HTTPResponse callWebService() {
		String EndPoint = '';

		if (Test.isRunningTest()) {
			EndPoint = 'example.com?token=ddgdsghdgsh';
		}
		else if (Scorm_Service_Settings__c.getOrgDefaults().Id == NULL) {
			HttpResponse resp = new HttpResponse();
			resp.setStatusCode(200);
			resp.setBody('[]');
			return resp;
		}
		else {
			Scorm_Service_Settings__c ScormSetting = Scorm_Service_Settings__c.getOrgDefaults();
			EndPoint = ScormSetting.End_Point__c;
		}

		EndPoint += '&startDate=' + this.StartDate.format() + '&endDate=' + this.EndDate.format();

		Http http = new Http();
		HttpRequest req = new HttpRequest();
		HttpResponse res;

		req.setEndpoint(EndPoint);
		req.setMethod('GET');
		req.setTimeout(100000);
		if (!Test.isRunningTest()) {
			res = http.send(req);
		}
		else {
			res = new HttpResponse();
//          res.setBody('[{\"CourseId\":\"6fafcf48-7b8f-4a7c-b50c-a3f500891214\",\"UserEmail\":\"amunoz19=its.jnj.com@example.com\",\"State\":\"{\\\"ActivitySessionList\\\":[{\\\"SuspendData\\\":\\\"\\\"},{\\\"SuspendData\\\":\\\"2duG7080i0j0o0g0p0d0q0l0f0k0c0n0r0h0b0m0e090a0~2w2~2s21001012~2h2110111011111101121110113111011411101151110116111011711101181110119111011a111011b111011c111011d111011e111011f111011g111011h111011i111011j111001012B100v_player.6nFk7giaqY3.6cQmcoy1hlC000~2eq~2aqEi03040106020j0b07080c0d090a0g0h0f00050e0~2w1cb101021010103Fe1Mj7920o0c1118_default649o0o2649o000649o0C0649o0O1r0p03tA0gf7w20118_default00000~231cb1010015151038e1jf7830118_default248rp038e1gf7w20118_default000000~231cb1010210101138e1j248f7820118_defaultr0p038e1gf7w20118_default00000~2k1cb1010210101238e1A248649o0R1f7820118_default649o0D0248r0p038e1gf7w20118_default00000~2i1cb1010210101038e1yj7920o0c1118_default649o000649o0C0r0p038e1gf7w20118_default00000~2l1cb1010210101138e1B649o0e1j7920o000118_default649o0D0248r0p031$0gf7w20118_default00000~2k1cb1010015151038e1Bj7930o0u1118_default649o000649o0C0248qo02nlgf7w20118_default000000~2l1cb1010210101038e1Bj7920o0c1118_default649o000649o0C0248r0p038e1gf7w20118_default00000~2b1cb101021010113Ee1r649o0C0j7920o000118_defaultr0p038e1gf7w20118_default00000~221cb1010015151138e1j248f7830118_defaultqo02Mugf7w20118_default000000~2b1cb101001515103Ee1r248568012248568011248568010rp038e1gf7w20118_default000000~2p1cb1010210101238e1F649o0C0649o0O1j7920o000118_default649o0c1r0p038e1gf7w20118_default00000~231cb1010210101138e1j248f7820118_defaultr0p038e1gf7w20118_default00000~2k1cb1010015151038e1Bj7930o0O1118_default649o000248649o0C0qo02Khgf7w20118_default000000~2g1cb101021010103Ee1xj7920o0c1118_default248649o000248q0o02kkgf7w20118_default00000~281cb1010015151238e1p248248f7830118_default248qo02qmgf7w20118_default000000~221cb1010015151138e1j248f7830118_defaultqo02Xmgf7w20118_default000000~231cb1010210101138e1j248f7820118_defaultr0p03XL0gf7w20118_default00000~2h1cb1010210101138e1y649o0c1j7920o000118_default649o0C0q0o02qmgf7w20118_default00000~2h1cb1010210101038e1yj7920o0c1118_default649o000649o0C0q0o02figf7w20118_default0000002110\\\"}]}\"}]');
			res.setBody('[{\"ApplicationId\":\"12aec642-597c-4856-9511-a277013ce5c0\",\"CompletionDate\":null,\"CompletionStatus\":\"incomplete\",\"CourseId\":\"6fafcf48-7b8f-4a7c-b50c-a3f500891214\",\"CourseType\":2,\"CourseVersionId\":\"08d99dbd-ec4a-4a63-98cf-3a5c4e59f4bf\",\"ExternalId\":\"d227e6a4-9988-414e-abd0-878a253f5bf9\",\"Progress\":0,\"RecentlyViewedAt\":\"/Date(1418914971000+0000)/\",\"Score\":0.80000,\"State\":\"{\\\"LearnerId\\\":\\\"e6f8d806-2ec3-464e-8e31-a277013ce52f\\\",\\\"ContentPackageId\\\":\\\"d227e6a4-9988-414e-abd0-878a253f5bf9\\\",\\\"CurrentActivityId\\\":\\\"\\\",\\\"SuspendedActivityId\\\":\\\"\\\",\\\"Timestamp\\\":null,\\\"ActivitySessionList\\\":[{\\\"ManifestActivityId\\\":\\\"ST128.001_Leads_Process_Training_ORG\\\",\\\"AttemptAt\\\":null,\\\"CompletedAt\\\":null,\\\"Scaled\\\":null,\\\"Raw\\\":null,\\\"Min\\\":null,\\\"Max\\\":null,\\\"TotalTimeTicks\\\":16583800000,\\\"Location\\\":null,\\\"SuspendData\\\":\\\"\\\",\\\"ProgressMeasure\\\":null,\\\"Attempted\\\":1,\\\"ScoreProgressMeasure\\\":null,\\\"AttemptCompletionStatus\\\":false,\\\"AttemptProgressStatus\\\":true,\\\"RollupAttemptCompletionStatus\\\":false,\\\"RollupAttemptProgressStatus\\\":true,\\\"ActivityProgressStatus\\\":true,\\\"IsActive\\\":false,\\\"IsSuspended\\\":true,\\\"ObjectivesList\\\":[{\\\"Scaled\\\":0.8,\\\"Raw\\\":null,\\\"Min\\\":null,\\\"Max\\\":null,\\\"ProgressMeasure\\\":null,\\\"CompletionCode\\\":null,\\\"Description\\\":null,\\\"ManifestObjectiveId\\\":null,\\\"IsPrimary\\\":true,\\\"SatisfiedStatus\\\":false,\\\"ProgressStatus\\\":true,\\\"MapInfoList\\\":[],\\\"RollupSatisfiedStatus\\\":false,\\\"RollupProgressStatus\\\":true,\\\"RollupScaled\\\":0.8}],\\\"InteractionList\\\":[],\\\"LearnerCommentList\\\":[],\\\"LearnerPreferenceList\\\":[],\\\"CompletionStatusChangedDuringRuntime\\\":false},{\\\"ManifestActivityId\\\":\\\"ST128.001_Leads_Process_Training_SCO\\\",\\\"AttemptAt\\\":\\\"2014-12-18T14:55:49.8596915+00:00\\\",\\\"CompletedAt\\\":null,\\\"Scaled\\\":0.8,\\\"Raw\\\":80.0,\\\"Min\\\":0.0,\\\"Max\\\":100.0,\\\"TotalTimeTicks\\\":16583800000,\\\"Location\\\":null,\\\"SuspendData\\\":\\\"2ue~281D0B0k0G0I0d0n0E0e0p0o0f0r0q050g0M03060708090J0H0L0l0h0m0a0C0i0b0K0F0c0j0~254~214101191310~2Q301011012110131101411015110161101711018110191101a1101b1101c1101d1101e1101f1101g1101h1101i1101j1101k1101l1101m1101n1101o111101310111131011213101131310114131011513101161310117131011813101191310010141101310111131011213101131310114131011513101191310~2l111d5ZKjmSwqvmQ26010101010101010N_player.6HycJO0zBQr26.6l5TnRAEwR426.6WW2QwjRyvu261000000~2o7~2k7k60500030801040907020Jcb101001a1a1$38e1e24oak47164M2_$20000702642M2Ecb101001a1a1$38e1jf7830118_default248000Jcb1010210101$38e1e24oak471C354_$20000702C3254Ecb101001a1a1$38e1jf7830118_default248000_cb101001a1a1$3De1Fj7930o0R0118_default649o0G1649o0v2649o000000rcb1010210101$38e16568011000Kcb101001a1a1$38e1p240240f7030118_default240000ucb101001a1a1$38e19860040123000Ecb101001a1a1$38e1jf7030118_default240000_cb101001a1a1$38e1F641o0G1j7130o000118_default641o0v2641o0R0000cb03xb10021102110\\\",\\\"ProgressMeasure\\\":null,\\\"Attempted\\\":1,\\\"ScoreProgressMeasure\\\":null,\\\"AttemptCompletionStatus\\\":false,\\\"AttemptProgressStatus\\\":true,\\\"RollupAttemptCompletionStatus\\\":false,\\\"RollupAttemptProgressStatus\\\":true,\\\"ActivityProgressStatus\\\":true,\\\"IsActive\\\":false,\\\"IsSuspended\\\":true,\\\"ObjectivesList\\\":[{\\\"Scaled\\\":0.8,\\\"Raw\\\":null,\\\"Min\\\":null,\\\"Max\\\":null,\\\"ProgressMeasure\\\":null,\\\"CompletionCode\\\":null,\\\"Description\\\":null,\\\"ManifestObjectiveId\\\":null,\\\"IsPrimary\\\":true,\\\"SatisfiedStatus\\\":false,\\\"ProgressStatus\\\":false,\\\"MapInfoList\\\":[],\\\"RollupSatisfiedStatus\\\":false,\\\"RollupProgressStatus\\\":false,\\\"RollupScaled\\\":0.8}],\\\"InteractionList\\\":[{\\\"Timestamp\\\":\\\"2014-12-18T18:00:46\\\",\\\"Weighting\\\":1.0,\\\"Response\\\":\\\"Rectangular_Hotspot_1\\\",\\\"ResultCode\\\":\\\"correct\\\",\\\"Latency\\\":null,\\\"Description\\\":\\\"CLICK ON THE CORRECT AREA: Where would you click to change the Lead Owner Name if the lead is too far away from your territory?\\\",\\\"ManifestObjectiveId\\\":null,\\\"ManifestId\\\":\\\"Scene1_QuestionDraw01_Slide7_HotSpot_0_0\\\",\\\"TypeCode\\\":\\\"choice\\\",\\\"TransitionKey\\\":\\\"1f03e1ca-fa8e-43ce-92c5-50eb0024a68c\\\",\\\"InteractionToObjectiveList\\\":[{\\\"ManifestObjectiveId\\\":\\\"ST128.001_Leads_Process_Knowledge_Check\\\",\\\"Seq\\\":0}],\\\"InterationCorrectResponseList\\\":[{\\\"Pattern\\\":\\\"Rectangular_Hotspot_1\\\",\\\"Seq\\\":0}]},{\\\"Timestamp\\\":\\\"2014-12-18T18:00:46\\\",\\\"Weighting\\\":1.0,\\\"Response\\\":\\\"true\\\",\\\"ResultCode\\\":\\\"correct\\\",\\\"Latency\\\":null,\\\"Description\\\":\\\"TRUE OR FALSE: If the Lead Status is changed to closed the Closed Lead Reason is a required field and should be completed.\\\",\\\"ManifestObjectiveId\\\":null,\\\"ManifestId\\\":\\\"Scene1_QuestionDraw01_Slide6_TrueFalse_0_0\\\",\\\"TypeCode\\\":\\\"true-false\\\",\\\"TransitionKey\\\":\\\"a7aa1ebb-3451-411c-b4a4-818bec2ac1ac\\\",\\\"InteractionToObjectiveList\\\":[{\\\"ManifestObjectiveId\\\":\\\"ST128.001_Leads_Process_Knowledge_Check\\\",\\\"Seq\\\":0}],\\\"InterationCorrectResponseList\\\":[{\\\"Pattern\\\":\\\"true\\\",\\\"Seq\\\":0}]},{\\\"Timestamp\\\":\\\"2014-12-18T18:00:46\\\",\\\"Weighting\\\":1.0,\\\"Response\\\":\\\"Incorrect\\\",\\\"ResultCode\\\":\\\"incorrect\\\",\\\"Latency\\\":null,\\\"Description\\\":\\\"CLICK ON THE CORRECT AREA: Where would you click to begin the Leads Process?\\\",\\\"ManifestObjectiveId\\\":null,\\\"ManifestId\\\":\\\"Scene1_QuestionDraw01_Slide1_HotSpot_0_0\\\",\\\"TypeCode\\\":\\\"choice\\\",\\\"TransitionKey\\\":\\\"bdb46fdd-a64f-447b-8182-bd684a2f93fe\\\",\\\"InteractionToObjectiveList\\\":[{\\\"ManifestObjectiveId\\\":\\\"ST128.001_Leads_Process_Knowledge_Check\\\",\\\"Seq\\\":0}],\\\"InterationCorrectResponseList\\\":[{\\\"Pattern\\\":\\\"Rectangular_Hotspot_1\\\",\\\"Seq\\\":0}]},{\\\"Timestamp\\\":\\\"2014-12-18T18:00:46\\\",\\\"Weighting\\\":1.0,\\\"Response\\\":\\\"true\\\",\\\"ResultCode\\\":\\\"correct\\\",\\\"Latency\\\":null,\\\"Description\\\":\\\"TRUE OR FALSE: Account Executives are not responsible for entering leads, but are responsible for updating the lead and qualifying or un-qualifying the lead.\\\",\\\"ManifestObjectiveId\\\":null,\\\"ManifestId\\\":\\\"Scene1_QuestionDraw01_Slide4_TrueFalse_0_0\\\",\\\"TypeCode\\\":\\\"true-false\\\",\\\"TransitionKey\\\":\\\"7bc19f23-7d8e-4bad-b7f5-a262a72de458\\\",\\\"InteractionToObjectiveList\\\":[{\\\"ManifestObjectiveId\\\":\\\"ST128.001_Leads_Process_Knowledge_Check\\\",\\\"Seq\\\":0}],\\\"InterationCorrectResponseList\\\":[{\\\"Pattern\\\":\\\"true\\\",\\\"Seq\\\":0}]},{\\\"Timestamp\\\":\\\"2014-12-18T18:00:46\\\",\\\"Weighting\\\":1.0,\\\"Response\\\":\\\"My_Leads\\\",\\\"ResultCode\\\":\\\"correct\\\",\\\"Latency\\\":null,\\\"Description\\\":\\\"SELECT THE CORRECT RESPONSE: From the dropdown box which of the following options should you select to view your leads?\\\",\\\"ManifestObjectiveId\\\":null,\\\"ManifestId\\\":\\\"Scene1_QuestionDraw01_Slide9_MultiChoice_0_0\\\",\\\"TypeCode\\\":\\\"choice\\\",\\\"TransitionKey\\\":\\\"c37255ec-d500-4b02-ac99-790dcf3db357\\\",\\\"InteractionToObjectiveList\\\":[{\\\"ManifestObjectiveId\\\":\\\"ST128.001_Leads_Process_Knowledge_Check\\\",\\\"Seq\\\":0}],\\\"InterationCorrectResponseList\\\":[{\\\"Pattern\\\":\\\"My_Leads\\\",\\\"Seq\\\":0}]},{\\\"Timestamp\\\":\\\"2014-12-18T18:00:46\\\",\\\"Weighting\\\":1.0,\\\"Response\\\":\\\"1\\\",\\\"ResultCode\\\":\\\"incorrect\\\",\\\"Latency\\\":null,\\\"Description\\\":\\\"ENTER A NUMBER: How many types of leads are there in Salesforce.com?\\\",\\\"ManifestObjectiveId\\\":null,\\\"ManifestId\\\":\\\"Scene1_QuestionDraw01_Slide2_Numeric_0_0\\\",\\\"TypeCode\\\":\\\"fill-in\\\",\\\"TransitionKey\\\":\\\"8bf29161-72ed-421f-839d-5b501b60bce3\\\",\\\"InteractionToObjectiveList\\\":[{\\\"ManifestObjectiveId\\\":\\\"ST128.001_Leads_Process_Knowledge_Check\\\",\\\"Seq\\\":0}],\\\"InterationCorrectResponseList\\\":[{\\\"Pattern\\\":\\\"Correct Response is equal to 2\\\",\\\"Seq\\\":0}]},{\\\"Timestamp\\\":\\\"2014-12-18T18:00:46\\\",\\\"Weighting\\\":1.0,\\\"Response\\\":\\\"Un-qualified\\\",\\\"ResultCode\\\":\\\"correct\\\",\\\"Latency\\\":null,\\\"Description\\\":\\\"SELECT THE CORRECT RESPONSE: Which of the following would you choose if the contact was not the decision maker at the account or they are not interested in our product?\\\",\\\"ManifestObjectiveId\\\":null,\\\"ManifestId\\\":\\\"Scene1_QuestionDraw01_Slide5_MultiChoice_0_0\\\",\\\"TypeCode\\\":\\\"choice\\\",\\\"TransitionKey\\\":\\\"6007d813-b33f-40de-920f-68cfc8c8c6ab\\\",\\\"InteractionToObjectiveList\\\":[{\\\"ManifestObjectiveId\\\":\\\"ST128.001_Leads_Process_Knowledge_Check\\\",\\\"Seq\\\":0}],\\\"InterationCorrectResponseList\\\":[{\\\"Pattern\\\":\\\"Un-qualified\\\",\\\"Seq\\\":0}]},{\\\"Timestamp\\\":\\\"2014-12-18T18:00:46\\\",\\\"Weighting\\\":1.0,\\\"Response\\\":\\\"1,Click_on_the_box_to_the_left_of_the_record_you_want_to_change.,2,Click__Change_Status_.,3,Choose_the_correct_status_of_the_lead.,4,Click__Save_.\\\",\\\"ResultCode\\\":\\\"correct\\\",\\\"Latency\\\":null,\\\"Description\\\":\\\"SEQUENCE: Place the following events to change the status of a lead in the order that they occur:\\\",\\\"ManifestObjectiveId\\\":null,\\\"ManifestId\\\":\\\"Scene1_QuestionDraw01_Slide10_SequenceDragDrop_0_0\\\",\\\"TypeCode\\\":\\\"sequencing\\\",\\\"TransitionKey\\\":\\\"528c0158-d9d6-4f2e-8f07-80b4d4fc2279\\\",\\\"InteractionToObjectiveList\\\":[{\\\"ManifestObjectiveId\\\":\\\"ST128.001_Leads_Process_Knowledge_Check\\\",\\\"Seq\\\":0}],\\\"InterationCorrectResponseList\\\":[{\\\"Pattern\\\":\\\"1,Click_on_the_box_to_the_left_of_the_record_you_want_to_change.,2,Click__Change_Status_.,3,Choose_the_correct_status_of_the_lead.,4,Click__Save_.\\\",\\\"Seq\\\":0}]},{\\\"Timestamp\\\":\\\"2014-12-18T18:00:46\\\",\\\"Weighting\\\":1.0,\\\"Response\\\":\\\"true\\\",\\\"ResultCode\\\":\\\"correct\\\",\\\"Latency\\\":null,\\\"Description\\\":\\\"TRUE OR FALSE: Any contact you have with a lead such as phone calls, meetings, and tasks should be recorded using Open Activities in the Lead Detail.\\\",\\\"ManifestObjectiveId\\\":null,\\\"ManifestId\\\":\\\"Scene1_QuestionDraw01_Slide8_TrueFalse_0_0\\\",\\\"TypeCode\\\":\\\"true-false\\\",\\\"TransitionKey\\\":\\\"5c928776-5974-45e4-9f8d-8883711919bc\\\",\\\"InteractionToObjectiveList\\\":[{\\\"ManifestObjectiveId\\\":\\\"ST128.001_Leads_Process_Knowledge_Check\\\",\\\"Seq\\\":0}],\\\"InterationCorrectResponseList\\\":[{\\\"Pattern\\\":\\\"true\\\",\\\"Seq\\\":0}]},{\\\"Timestamp\\\":\\\"2014-12-18T18:00:46\\\",\\\"Weighting\\\":1.0,\\\"Response\\\":\\\"Campaign_Leads\\\",\\\"ResultCode\\\":\\\"correct\\\",\\\"Latency\\\":null,\\\"Description\\\":\\\"SELECT THE CORRECT RESPONSE: This type of lead can come from trade shows, advertisements, articles and mass mailings.\\\",\\\"ManifestObjectiveId\\\":null,\\\"ManifestId\\\":\\\"Scene1_QuestionDraw01_Slide3_MultiChoice_0_0\\\",\\\"TypeCode\\\":\\\"choice\\\",\\\"TransitionKey\\\":\\\"3e03d7e1-6c2d-4846-8636-e3185db2f721\\\",\\\"InteractionToObjectiveList\\\":[{\\\"ManifestObjectiveId\\\":\\\"ST128.001_Leads_Process_Knowledge_Check\\\",\\\"Seq\\\":0}],\\\"InterationCorrectResponseList\\\":[{\\\"Pattern\\\":\\\"Campaign_Leads\\\",\\\"Seq\\\":0}]}],\\\"LearnerCommentList\\\":[],\\\"LearnerPreferenceList\\\":[{\\\"DeliverySpeed\\\":0.0,\\\"Language\\\":null,\\\"AudioLevel\\\":0.0}],\\\"CompletionStatusChangedDuringRuntime\\\":true}],\\\"CompletedAt\\\":null,\\\"IsFinished\\\":false}\",\"SuccessStatus\":null,\"UserEmail\":\"12345amunoz19=its.jnj.com@example.com\",\"UserId\":\"e6f8d806-2ec3-464e-8e31-a277013ce52f\"},{\"ApplicationId\":\"12aec642-597c-4856-9511-a277013ce5c0\",\"CompletionDate\":null,\"CompletionStatus\":\"incomplete\",\"CourseId\":\"6fafcf48-7b8f-4a7c-b50c-a3f500891214\",\"CourseType\":2,\"CourseVersionId\":\"66855f6e-304f-4ce3-a903-3b87b1182e7f\",\"ExternalId\":\"5e18e3dd-3009-4261-ba1e-d9cbca2ce207\",\"Progress\":0,\"RecentlyViewedAt\":\"/Date(1418920909000+0000)/\",\"Score\":0,\"State\":\"{\\\"LearnerId\\\":\\\"7a50df41-606d-4f6c-a10a-a404008b6435\\\",\\\"ContentPackageId\\\":\\\"5e18e3dd-3009-4261-ba1e-d9cbca2ce207\\\",\\\"CurrentActivityId\\\":\\\"\\\",\\\"SuspendedActivityId\\\":\\\"\\\",\\\"Timestamp\\\":null,\\\"ActivitySessionList\\\":[{\\\"ManifestActivityId\\\":\\\"ST147.001_Consignment_Billing_Process_Training_10.28.14_ORG\\\",\\\"AttemptAt\\\":null,\\\"CompletedAt\\\":null,\\\"Scaled\\\":null,\\\"Raw\\\":null,\\\"Min\\\":null,\\\"Max\\\":null,\\\"TotalTimeTicks\\\":713900000,\\\"Location\\\":null,\\\"SuspendData\\\":\\\"\\\",\\\"ProgressMeasure\\\":null,\\\"Attempted\\\":2,\\\"ScoreProgressMeasure\\\":null,\\\"AttemptCompletionStatus\\\":false,\\\"AttemptProgressStatus\\\":true,\\\"RollupAttemptCompletionStatus\\\":false,\\\"RollupAttemptProgressStatus\\\":true,\\\"ActivityProgressStatus\\\":true,\\\"IsActive\\\":false,\\\"IsSuspended\\\":true,\\\"ObjectivesList\\\":[{\\\"Scaled\\\":null,\\\"Raw\\\":null,\\\"Min\\\":null,\\\"Max\\\":null,\\\"ProgressMeasure\\\":null,\\\"CompletionCode\\\":null,\\\"Description\\\":null,\\\"ManifestObjectiveId\\\":null,\\\"IsPrimary\\\":true,\\\"SatisfiedStatus\\\":false,\\\"ProgressStatus\\\":true,\\\"MapInfoList\\\":[],\\\"RollupSatisfiedStatus\\\":false,\\\"RollupProgressStatus\\\":true,\\\"RollupScaled\\\":null}],\\\"InteractionList\\\":[],\\\"LearnerCommentList\\\":[],\\\"LearnerPreferenceList\\\":[],\\\"CompletionStatusChangedDuringRuntime\\\":false},{\\\"ManifestActivityId\\\":\\\"ST147.001_Consignment_Billing_Process_Training_September_2014_SCO\\\",\\\"AttemptAt\\\":\\\"2014-12-18T16:41:44.0757757+00:00\\\",\\\"CompletedAt\\\":null,\\\"Scaled\\\":null,\\\"Raw\\\":null,\\\"Min\\\":null,\\\"Max\\\":null,\\\"TotalTimeTicks\\\":713900000,\\\"Location\\\":null,\\\"SuspendData\\\":\\\"\\\",\\\"ProgressMeasure\\\":null,\\\"Attempted\\\":2,\\\"ScoreProgressMeasure\\\":null,\\\"AttemptCompletionStatus\\\":false,\\\"AttemptProgressStatus\\\":true,\\\"RollupAttemptCompletionStatus\\\":false,\\\"RollupAttemptProgressStatus\\\":true,\\\"ActivityProgressStatus\\\":true,\\\"IsActive\\\":false,\\\"IsSuspended\\\":true,\\\"ObjectivesList\\\":[{\\\"Scaled\\\":null,\\\"Raw\\\":null,\\\"Min\\\":null,\\\"Max\\\":null,\\\"ProgressMeasure\\\":null,\\\"CompletionCode\\\":null,\\\"Description\\\":null,\\\"ManifestObjectiveId\\\":null,\\\"IsPrimary\\\":true,\\\"SatisfiedStatus\\\":false,\\\"ProgressStatus\\\":false,\\\"MapInfoList\\\":[],\\\"RollupSatisfiedStatus\\\":false,\\\"RollupProgressStatus\\\":false,\\\"RollupScaled\\\":null}],\\\"InteractionList\\\":[],\\\"LearnerCommentList\\\":[],\\\"LearnerPreferenceList\\\":[{\\\"DeliverySpeed\\\":0.0,\\\"Language\\\":null,\\\"AudioLevel\\\":0.0}],\\\"CompletionStatusChangedDuringRuntime\\\":true}],\\\"CompletedAt\\\":null,\\\"IsFinished\\\":false}\",\"SuccessStatus\":null,\"UserEmail\":\"12345amunoz19=its.jnj.com@example.com\",\"UserId\":\"7a50df41-606d-4f6c-a10a-a404008b6435\"}]');
			res.setStatus('OK');
			res.setStatusCode(200);
		}
		return res;
	}

	public void parserEmptyArray(JSONParser parser) {
		if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
			while (parser.nextToken() != JSONToken.END_ARRAY) {
				if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
					parserEmptyArray(parser);
				}
				if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
					parserEmptyObject(parser);
				}
			}
		}

	}

	public void parserEmptyObject(JSONParser parser) {
		if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
			while (parser.nextToken() != JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
					parserEmptyArray(parser);
				}
				if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
					parserEmptyObject(parser);
				}
			}
		}
	}

	public void parserEmptyField(JSONParser parser) {
		if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
			parserEmptyObject(parser);
		}
		if (parser.getCurrentToken() == JSONToken.START_ARRAY) {
			parserEmptyArray(parser);
		}
	}

}