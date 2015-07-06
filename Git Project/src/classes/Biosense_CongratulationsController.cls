public with sharing class Biosense_CongratulationsController {
	public static final String COMPLETED = 'Completed';
	private final String COMPLETED_OBJECT;
	private static final Decimal COMPLETED_STATUS;
	public Boolean GOT_ERRORS {get;set;}
	public Boolean showDateComponentOnPage {get;set;}
	static {
		COMPLETED_STATUS = 100.00;
	}

	public Biosense_CongratulationsController() {
		showDateComponentOnPage = true;
		this.GOT_ERRORS = false;
		Id gid = NULL;
		try {
			gid = ApexPages.currentPage().getParameters().get('id');
		}
		catch (System.StringException parseException) {
			showDateComponentOnPage = false;
			ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR, Label.lmscons.Sorry_but_ID_is_invalid));
		}
		if (gid == NULL) {
			showDateComponentOnPage = false;
			ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR, Label.lmscons.Please_enter_a_valid_ID));
			return;
		}

		String prefix = String.valueOf(gid);
		ID USER_ID = Userinfo.getUserId();
		String keyPrefix = prefix.substring(0, 3);
		Boolean Record_Exist = true;
			if(lmscons__Training_Path_Assignment_Progress__c.SObjectType.getDescribe().getKeyPrefix().Equals(keyPrefix)){
				List<lmscons__Training_Path_Assignment_Progress__c>  PathProgress = [SELECT Id, lmscons__Training_Path__r.Name, lmscons__Transcript__r.lmscons__Trainee__r.Name, lmscons__Completion_Date__c
													FROM lmscons__Training_Path_Assignment_Progress__c
													WHERE Id = :gid AND lmscons__Transcript__r.lmscons__Trainee__c = : USER_ID AND lmscons__Training_Path__r.lmscons__Enable_Certificate__c = true
													//AND Progress_Training_Path__c = :COMPLETED_STATUS
													AND lmscons__StatusPicklist__c = :COMPLETED
													LIMIT 1];
				if (!PathProgress.isEmpty()) {
					this.CompletionDate = PathProgress[0].lmscons__Completion_Date__c;
					this.UserName = PathProgress[0].lmscons__Transcript__r.lmscons__Trainee__r.Name;
					this.Title = PathProgress[0].lmscons__Training_Path__r.Name;
				}
				else { Record_Exist = false; }

			}
			else if(lmscons__Transcript_Line__c.SObjectType.getDescribe().getKeyPrefix().Equals(keyPrefix)){
				List<lmscons__Transcript_Line__c>  TrcLine = [SELECT Id, lmscons__Transcript__r.lmscons__Trainee__r.Name, lmscons__Quiz__c, lmscons__Training_Content__c, lmscons__Content_Title__c, lmscons__Completion_Date__c, lmscons__Trainee__c, lmscons__Score__c, lmscons__Completed_Date__c
													FROM lmscons__Transcript_Line__c
													WHERE Id = :gid
													AND lmscons__Transcript__r.lmscons__Trainee__c = : USER_ID
													AND lmscons__Percent_Complete__c =:COMPLETED_STATUS AND lmscons__Training_User_License__r.lmscons__Content_License__r.lmscons__Training_Content__r.lmscons__Enable_Certificate__c = true AND lmscons__Status__c != 'Failed'
													LIMIT 1];
				if(!TrcLine.isEmpty()) {
					this.CompletionDate = TrcLine[0].lmscons__Completion_Date__c;
					this.UserName = TrcLine[0].lmscons__Transcript__r.lmscons__Trainee__r.Name;
					this.Title = TrcLine[0].lmscons__Content_Title__c;
				} else { Record_Exist = false; }

			}
			else if(lmscons__Learning_Path_Assignment__c.SObjectType.getDescribe().getKeyPrefix().Equals(keyPrefix)){
				List<lmscons__Learning_Path_Assignment__c>  LPAssign = [SELECT Id, lmscons__Transcript__r.lmscons__Trainee__r.Name, lmscons__Learning_Path__r.Name, lmscons__Completion_Date__c
													FROM lmscons__Learning_Path_Assignment__c
													WHERE Id = :gid
							 						AND lmscons__Transcript__r.lmscons__Trainee__c = : USER_ID AND lmscons__Learning_Path__r.lmscons__Enable_Certificate__c  = true
													//AND lmscons__Learning_Path_Progress__c = :COMPLETED_STATUS
													AND lmscons__Status__c = :COMPLETED
													LIMIT 1];
				if(!LPAssign.isEmpty()) {
					this.CompletionDate = LPAssign[0].lmscons__Completion_Date__c;
					this.UserName = LPAssign[0].lmscons__Transcript__r.lmscons__Trainee__r.Name;
					this.Title = LPAssign[0].lmscons__Learning_Path__r.Name;
				} else { Record_Exist = false; }

			}
			else if(lmscons__Curriculum_Assignment__c.SObjectType.getDescribe().getKeyPrefix().Equals(keyPrefix)){
				List<lmscons__Curriculum_Assignment__c>  CrcAssign = [SELECT Id, lmscons__Transcript__r.lmscons__Trainee__r.Name, lmscons__Curriculum__r.Name, lmscons__Completion_Date__c
													FROM lmscons__Curriculum_Assignment__c
													WHERE Id = :gid
													AND lmscons__Transcript__r.lmscons__Trainee__c = : USER_ID AND lmscons__Curriculum__r.lmscons__Enable_Certificate__c = true
													//AND Curriculum_Progress__c = :COMPLETED_STATUS
													AND lmscons__Status__c = :COMPLETED
													LIMIT 1];
				if(!CrcAssign.isEmpty()) {
					this.CompletionDate = CrcAssign[0].lmscons__Completion_Date__c;
					this.UserName = CrcAssign[0].lmscons__Transcript__r.lmscons__Trainee__r.Name;
					this.Title = CrcAssign[0].lmscons__Curriculum__r.Name;
				} else { Record_Exist = false; }

			}
			else {
				this.GOT_ERRORS = true;
				showDateComponentOnPage = false;
				ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.WARNING, 'Label.lmscons.Invalid_ID'));
			}

			if (!Record_Exist) {
				this.GOT_ERRORS = true;
				showDateComponentOnPage = false;
				ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.WARNING, 'Label.lmscons.Invalid_ID'));
			}
	}


	public String getCertSig() {
		return 'Joanne_sig.png';
	}

	public String getCertLogo() {
		return 'wgrd_logo_4clr2.gif';
	}
	public lmscons__Transcript_Line__c returncert;
	//Get data set for Certificate

	public DateTime CompletionDate {get; set;}
	public String UserName {get; set;}
	public String Title {get; set;}
	public String Id {get; set;}

}