global class TouchRecords implements Database.Batchable<sObject>{
    private String query;

    global TouchRecords(String query) {
        this.query = query;
    }

    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Other_Activity__c> scope){
        update scope;
    }

    global void finish(Database.BatchableContext BC){
    }
}