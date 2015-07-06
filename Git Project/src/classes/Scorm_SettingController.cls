public with sharing class Scorm_SettingController {

    public Boolean Scheduled {get;set;}
    public List<Scorm_Batch__c> ScormBatchList {get;set;}
    public String batchStatus { get; set; }
    public Id batchprocessid{ get; set; }

    public Scorm_SettingController() {
        checkSchedulable();
        ScormBatchList = getScormBatchList();
    }

    public void startSchedulable() {
        if (Scheduled == false) {
            Scorm_Result_Schedulable ScormSchedulable = new Scorm_Result_Schedulable();
            String sch = '0 0 0 * * ?';
            String jobID = system.schedule('Scorm Result Job', sch, ScormSchedulable);
        }
        checkSchedulable();
    }

    public void stopSchedulable() {
        List<CronTrigger> JobList =[
            SELECT Id
            FROM CronTrigger
            WHERE CronJobDetail.Name = 'Scorm Result Job'];
        if (!JobList.isEmpty()) {
            system.abortJob(JobList[0].Id);
        }
        checkSchedulable();
    }

    public void startBatch() {

        Map<Id, AsyncApexJob> ActiveScheduledJobs = new Map<Id, AsyncApexJob>([
            SELECT Id
            FROM AsyncApexJob
            WHERE JobType = 'BatchApex'
            AND Status in ('Queued', 'Preparing', 'Processing')
        ]);

        if (ActiveScheduledJobs.size() < 4) {
            Scorm_Run_Batch ScormBatch = new Scorm_Run_Batch();
            batchprocessid = Database.executeBatch(ScormBatch, 1);
        }
        else {
            ApexPages.addmessage(new ApexPages.message(ApexPages.Severity.ERROR, 'There are too many jobs queued to run.'));
        }

        if (batchprocessid != NULL) {
            batchStatusMethod();
        }
    }

    public PageReference batchStatusMethod () {
        checkSchedulable();
        List<AsyncApexJob> asyncBathJopList = new List<AsyncApexJob>();
        if (batchprocessid != NULL) {
            asyncBathJopList = [
                SELECT Id, JobItemsProcessed, TotalJobItems, Status, ExtendedStatus
                FROM AsyncApexJob
                WHERE Id = :batchprocessid
                LIMIT 1000
            ];
        }
        if (!asyncBathJopList.isEmpty()) {
            if (asyncBathJopList[0].Status == 'Queued' || asyncBathJopList[0].Status == 'Preparing' || asyncBathJopList[0].Status == 'Processing') {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'Scorm quiz return results are being processed. Please wait...'));
            }
            else if (asyncBathJopList[0].Status == 'Completed' && !String.isBlank(asyncBathJopList[0].ExtendedStatus)) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Error: ' + asyncBathJopList[0].ExtendedStatus));
            }
            else if (asyncBathJopList[0].Status == 'Completed') {
                //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'Completed. The Scorm quiz results have been received.'));
            }
            else if (asyncBathJopList[0].Status == 'Failed' || asyncBathJopList[0].Status == 'Aborted') {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Error: ' + asyncBathJopList[0].ExtendedStatus));
            }

        }

        ScormBatchList = getScormBatchList();
        return NULL;
    }


    private void checkSchedulable() {
        List<CronTrigger> JobList =[
            SELECT Id, State, NextFireTime
            FROM CronTrigger
            WHERE CronJobDetail.Name = 'Scorm Result Job'];
        if (!JobList.isEmpty()) {
            Scheduled = true;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'Service has been started. Next Scorm quiz return results: '+JobList[0].NextFireTime.format()));
        }
        else {
            Scheduled = false;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, 'Service for the Scorm return results has not been started.'));
        }
    }

    private List<Scorm_Batch__c> getScormBatchList() {
        List<Scorm_Batch__c> ScormBatch = [
            SELECT Id, Name, Date__c, Number_Deleted_Records__c, Number_Insert_Records__c,
                Number_New_Results__c, Number_Update_Results__c, End_Period__c, Status__c,
                Start_Period__c, Message__c
            FROM Scorm_Batch__c
            ORDER BY CreatedDate DESC
            LIMIT 50
        ];
        return ScormBatch;
    }

}