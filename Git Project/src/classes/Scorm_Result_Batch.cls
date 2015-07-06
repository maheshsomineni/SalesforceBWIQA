global class Scorm_Result_Batch implements Database.Batchable<SCORM_Quiz_Result__c> {
	global list<SCORM_Quiz_Result__c> QueryResultItems;

	public String Action = 'insert';
	public String ScormBatchId;
	public Integer CountItems = 0;
	public List<Scorm_Quiz_Result__c> ScormQuizDeleteList = new List<Scorm_Quiz_Result__c>();
	public Scorm_Batch__c ScormBatch = new Scorm_Batch__c();


	global Scorm_Result_Batch(list<SCORM_Quiz_Result__c> Items) {
		QueryResultItems = items;
		this.CountItems += items.size();
	}

	global Iterable<SCORM_Quiz_Result__c> start(Database.BatchableContext BC) {
		return QueryResultItems;
	}

	global void execute(Database.BatchableContext BC, List<SCORM_Quiz_Result__c> ListSObjects) {
		if (Action == 'insert') {
			insert ListSObjects;
		}
		else if (Action == 'delete'){
			delete ListSObjects;
		}

	}

	global void finish(Database.BatchableContext BC) {
		List<Scorm_Batch__c> ScormBatchList = [
			SELECT Id, Name, Number_Deleted_Records__c, Number_Insert_Records__c
			FROM Scorm_Batch__c
			WHERE Id = :ScormBatchId
			LIMIT 1
		];
		if (!ScormBatchList.isEmpty()) {
			if (Action == 'insert' ) {
				if (this.CountItems > 0) {
					ScormBatchList[0].Number_Insert_Records__c += this.CountItems;
					update ScormBatchList;
				}

				Scorm_Result_Batch SRBDelete = new Scorm_Result_Batch(ScormQuizDeleteList);
				SRBDelete.Action = 'delete';
				SRBDelete.ScormBatchId = ScormBatchId;
				Database.executeBatch(SRBDelete, 200);
			}
			else if (Action == 'delete'  && this.CountItems > 0){
				ScormBatchList[0].Number_Deleted_Records__c += this.CountItems;
				update ScormBatchList;
			}
		}

	}
}