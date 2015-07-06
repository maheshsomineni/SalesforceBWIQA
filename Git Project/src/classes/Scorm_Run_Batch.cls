global class Scorm_Run_Batch implements Database.Batchable<Object>, Database.AllowsCallouts, Database.Stateful {

    public Integer countIterate = 1;
    public Map<String,Object> parameterMap;
    public List<SCORM_Quiz_Result__c> ScormQuizInsertList = new List<SCORM_Quiz_Result__c>();
    public List<SCORM_Quiz_Result__c> ScormQuizDeleteList = new List<SCORM_Quiz_Result__c>();
    public Scorm_Batch__c ScormBatch = new Scorm_Batch__c();
    public String Status = 'Completed';
    public String Message = 'Success. The Scorm quiz results have been received';
    public Date StartDate;
    public Date EndPeriod;
    public Integer Cycle = 0;
    public String ScormBatchId = '';

    global Scorm_Run_Batch() {

        this.StartDate = getStartDate();
        this.EndPeriod = Date.today().addDays(1);

    }

    global Iterable<Object> start(Database.BatchableContext context) {
        return new IObjectIterable(countIterate);
    }

    global void execute(Database.BatchableContext context, List<Object> scope) {
        Scorm_Result ScormResutl = new Scorm_Result();
        ScormResutl.StartDate = this.StartDate;
        ScormResutl.EndDate = this.StartDate.addDays(1);
        ScormResutl.saveResult();
        if (ScormResutl.Status == 'Error') {
            Status = ScormResutl.Status;
            Message = ScormResutl.Message;
        }
        else {
            ScormQuizInsertList = ScormResutl.getScormQuizResult();
            ScormQuizDeleteList = ScormResutl.getScormQuizDelete();
        }

    }

    global void finish(Database.BatchableContext Context) {

        Set<String> AssignmentIdInsertSet = new Set<String>();
        Set<String> AssignmentIdDeleteSet = new Set<String>();
        Integer CountScormQuizInsertAssignment = 0;
        Integer CountScormQuizDeleteAssignment = 0;

        List<Scorm_Batch__c> ScormBatchList = [
            SELECT Id, Name, Number_Deleted_Records__c, Number_Insert_Records__c,
                Start_Period__c, End_Period__c, Date__c,Number_New_Results__c,
                Number_Update_Results__c, Status__c, Message__c
            FROM Scorm_Batch__c
            WHERE Id = :ScormBatchId
            LIMIT 1
        ];
        if (!ScormBatchList.isEmpty()) {
            ScormBatch = ScormBatchList[0];
        }

        if (Status == 'Completed') {

            if (!ScormQuizInsertList.isEmpty()) {

                for (SCORM_Quiz_Result__c Item : ScormQuizInsertList) {
                    if (!AssignmentIdInsertSet.equals(Item.Assignment__c)) {
                        AssignmentIdInsertSet.add(Item.Assignment__c);
                    }
                }

            }
            if (!AssignmentIdInsertSet.isEmpty()) {
                CountScormQuizInsertAssignment = AssignmentIdInsertSet.size();

                for (SCORM_Quiz_Result__c Item : ScormQuizDeleteList) {
                    if (!AssignmentIdDeleteSet.equals(Item.Assignment__c)) {
                        AssignmentIdDeleteSet.add(Item.Assignment__c);
                    }
                }
                if (!AssignmentIdDeleteSet.isEmpty()) {
                    CountScormQuizDeleteAssignment = AssignmentIdDeleteSet.size();
                    CountScormQuizInsertAssignment = CountScormQuizInsertAssignment - CountScormQuizDeleteAssignment;
                }

            }
            List<SCORM_Quiz_Result__c> ScormQuizWithEmptyAssignment = [
                SELECT Id, Name, Assignment__c
                FROM SCORM_Quiz_Result__c
                WHERE Assignment__c = NULL
            ];
            if (!ScormQuizWithEmptyAssignment.isEmpty()) {
                ScormQuizDeleteList.addAll(ScormQuizWithEmptyAssignment);
            }

            if (this.StartDate.addDays(1) < this.EndPeriod) {
                this.Status = 'Processing';
                this.Message = '';
            }

            if (ScormBatch.Id == NULL) {
                ScormBatch = new Scorm_Batch__c();
                ScormBatch.Start_Period__c = this.StartDate;
                ScormBatch.End_Period__c = this.EndPeriod;
                ScormBatch.Date__c = Datetime.now();
                ScormBatch.Number_Insert_Records__c = 0;
                ScormBatch.Number_Deleted_Records__c = 0;
                ScormBatch.Number_New_Results__c = CountScormQuizInsertAssignment;
                ScormBatch.Number_Update_Results__c = CountScormQuizDeleteAssignment;
                ScormBatch.Status__c = Status;
                ScormBatch.Message__c = Message;
                insert ScormBatch;
            }
            else {
                if (CountScormQuizInsertAssignment > 0
                    || CountScormQuizDeleteAssignment > 0
                    || this.Status != 'Processing'
                ) {
                    ScormBatch.Number_New_Results__c += CountScormQuizInsertAssignment;
                    ScormBatch.Number_Update_Results__c += CountScormQuizDeleteAssignment;
                    ScormBatch.Status__c = Status;
                    ScormBatch.Message__c = Message;
                    update ScormBatch;
                }

            }

            if (this.ScormBatch.Id != NULL) {

                launchScormResultBatch(this.ScormQuizInsertList, this.ScormQuizDeleteList, this.ScormBatch);

                if (this.StartDate.addDays(1) < this.EndPeriod && !Test.isRunningTest()) {
                    launchScormRunBatch(this.StartDate.addDays(1), this.EndPeriod, this.ScormBatch, 0);
                }

            }
        }
        else {
            if (ScormBatch.Id == NULL) {
                ScormBatch = new Scorm_Batch__c();
                ScormBatch.End_Period__c = this.EndPeriod;
                ScormBatch.Start_Period__c = this.StartDate;
                ScormBatch.Date__c = Datetime.now();
                ScormBatch.Number_Insert_Records__c = 0;
                ScormBatch.Number_Deleted_Records__c = 0;
                ScormBatch.Number_New_Results__c = 0;
                ScormBatch.Number_Update_Results__c = 0;
                ScormBatch.Status__c = 'Processing';
                ScormBatch.Message__c = '';
                insert ScormBatch;
            }
            if (this.Cycle < 100 && !Test.isRunningTest()) {
                this.Cycle++;
                launchScormRunBatch(this.StartDate, this.EndPeriod, this.ScormBatch, this.Cycle);
            }
            else {
                ScormBatch.Status__c = 'Failed';
                update ScormBatch;
            }


        }


    }

    global class IObjectIterable implements Iterable<Object>, Iterator<Object>{

        List<Object> iObjects {get; set;}
        Integer i {get; set;}

        global IObjectIterable(Integer batchCount){
            this.iObjects = new List<Object>();
            this.iObjects.add(new Contact());
            i = batchCount;
        }

        global Iterator<Object> iterator() {
            return this;
        }

        global Boolean hasNext() {
            return (i != 0);
        }

        global Object next() {
            i--;
            return iObjects[0];
        }
    }

    private Date getStartDate() {
        Date StartDate;
        List<Scorm_Batch__c> ScormBatchList = [
            SELECT Id, Name, End_Period__c
            FROM Scorm_Batch__c
            WHERE Status__c = 'Completed'
            ORDER BY CreatedDate DESC
            lIMIT 1
        ];
        if (!ScormBatchList.isEmpty()) {
            if (ScormBatchList[0].End_Period__c < Date.today()) {
                StartDate = ScormBatchList[0].End_Period__c;
            }
            else {
                StartDate = Date.today();
            }
        }
        else {
            List<lmscons__Transcript_Line__c> TranscriptLineList = [
                SELECT Id, lmscons__Last_Launched_Date__c
                FROM lmscons__Transcript_Line__c
                WHERE lmscons__Last_Launched_Date__c != NULL
                ORDER BY lmscons__Last_Launched_Date__c ASC
                LIMIT 1
            ];
            if (!TranscriptLineList.isEmpty()) {
                StartDate = TranscriptLineList[0].lmscons__Last_Launched_Date__c.date().addDays(-1);
            }
            else {
                StartDate = Date.today().addDays(-1);
            }
        }
        return StartDate;
    }

    private void launchScormRunBatch(Date StartDate, Date EndPerion, Scorm_Batch__c ScormBatch, Integer Cycle) {
        Scorm_Run_Batch ScormRunBatch = new Scorm_Run_Batch();
        ScormRunBatch.StartDate = StartDate;
        ScormRunBatch.EndPeriod = EndPerion;
        ScormRunBatch.ScormBatchId = ScormBatch.Id;
        ScormRunBatch.Cycle = Cycle;

        Map<Id, AsyncApexJob> ActiveScheduledJobs = new Map<Id, AsyncApexJob>([
            SELECT Id
            FROM AsyncApexJob
            WHERE JobType = 'BatchApex'
            AND Status in ('Queued', 'Preparing', 'Processing')
        ]);
        if (ActiveScheduledJobs.size() < 4) {
            Database.executeBatch(ScormRunBatch, 1);
        }
        else {
            ScormBatch.Status__c = 'Failed';
            ScormBatch.Message__c = 'There are too many jobs queued to run.';
            update ScormBatch;
        }
    }

    private void launchScormResultBatch(
            List<SCORM_Quiz_Result__c> ScormQuizInsertList,
            List<SCORM_Quiz_Result__c> ScormQuizDeleteList,
            Scorm_Batch__c ScormBatch
    ) {
        Scorm_Result_Batch SRBInsert = new Scorm_Result_Batch(ScormQuizInsertList);
        SRBInsert.Action = 'insert';
        SRBInsert.ScormQuizDeleteList.addAll(ScormQuizDeleteList);
        SRBInsert.ScormBatchId = ScormBatch.Id;

        Map<Id, AsyncApexJob> ActiveScheduledJobs = new Map<Id, AsyncApexJob>([
            SELECT Id
            FROM AsyncApexJob
            WHERE JobType = 'BatchApex'
            AND Status in ('Queued', 'Preparing', 'Processing')
        ]);
        if (ActiveScheduledJobs.size() < 4) {
            Database.executeBatch(SRBInsert, 200);
        }
        else {
            ScormBatch.Status__c = 'Failed';
            ScormBatch.Message__c = 'There are too many jobs queued to run.';
            update ScormBatch;
        }
    }
}