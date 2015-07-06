public with sharing class lmsconsQuizContentDetailExt_ctrl {
    public lmscons__Training_Content__c Module {get;set;}
    
    //update users based functionality
    
    public PageReference testLink(){
        //Module.lmscons__verified__c=false; //commented by Jinesh
        Module.lmscons__Test_Course__c=true;
        update Module;
        PageReference page = new PageReference('/apex/NewQuiz?id='+this.Quiz.Id);
        //page.setRedirect(true); //commented by JG on 1 April
        return page;
    }
    
    //updated by JG (Appirio) on 7 April' 2015
    public PageReference doSave(){
        Module.lmscons__verified__c = true; //added by Jinesh
        update Module; //added by Jinesh
        return (new PageReference('/apex/NewQuizDetail?id='+this.Quiz.Id+'&verified=1'+''));
    }
    
    public list<lmscons__Quiz_Question__c> ListQuestions{get;set;}
    public boolean isConsumerUser{get;set;}
    public boolean isConsumerAdmin{get;set;}
    public lmscons__Quiz__c Quiz {get;set;}
    
    public lmsconsQuizContentDetailExt_ctrl(ApexPages.StandardController controller){
        this.Quiz = (lmscons__Quiz__c)controller.getRecord();
        ListQuestions =new  list<lmscons__Quiz_Question__c>();
        
        ListQuestions = [Select l.lmscons__Quiz__c, l.lmscons__Question__r.lmscons__Type__c, l.lmscons__Question__r.lmscons__Difficulty__c, 
                l.lmscons__Question__r.CreatedById, l.lmscons__Question__r.Name, l.lmscons__Question__c, l.lmscons__Order__c 
                /*From lmscons__Quiz_Question__c l where l.lmscons__Quiz__c!=:Quiz.Id];*/
                From lmscons__Quiz_Question__c l where l.lmscons__Quiz__c =:Quiz.Id]; //changed by Jinesh
        
        Module = [Select l.lmscons__verified__c, l.lmscons__Title__c,l.lmscons__Test_Course__c, l.lmscons__Status_Progress__c, 
                         l.lmscons__Score__c, l.lmscons__Quiz__c, l.lmscons__Description__c,l.lmscons__Percent_Complete__c,
                         l.lmscons__Quiz__r.lmscons__Show_Score__c, l.Name, l.Id From lmscons__Training_Content__c l 
                   where l.lmscons__Quiz__c=:Quiz.Id limit 1];
        
        isConsumerUser=true;
        isConsumerAdmin=true;
    }
}