global class Scorm_Result_Schedulable implements Schedulable {

	global void execute(SchedulableContext SC) {
		Scorm_Run_Batch ScormBatch = new Scorm_Run_Batch();
		Database.executeBatch(ScormBatch, 1);
	}

}