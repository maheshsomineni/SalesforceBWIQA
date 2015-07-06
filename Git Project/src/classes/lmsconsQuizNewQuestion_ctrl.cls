public with sharing class lmsconsQuizNewQuestion_ctrl {
    public boolean noerrors{get;set;}
    public String Qid{get;set;}
    public boolean isNew{get;set;}
    public boolean trueAnswer{get;set;}
    public boolean falseAnswer{get;set;}
    public lmscons__Quiz_Question__c qQuestion{get;set;}
    public lmscons__Question__c Question {get;set;}
    public String Quizid;  
    public String Questionid;
    public String url{get;set;}
    
    public lmsconsQuizNewQuestion_ctrl(ApexPages.StandardController controller){
        isNew=true;
        qQuestion = new lmscons__Quiz_Question__c();
        Quizid = ApexPages.currentPage().getParameters().get('qid');
        system.debug('*********'+ Quizid);
        Question = new lmscons__Question__c();
        trueAnswer = true;
        falseAnswer = false;
    }
    
    public void saveNew(){
        Question.Name = Question.lmscons__Question__c;      
        insert Question;
        createAnswersForTrueFalseTypeQuestions(Question);
        //close the pop up
        system.debug('*********'+ Quizid);      
        qQuestion.lmscons__Quiz__c = Quizid;
        qQuestion.lmscons__Question__c = Question.id;
        insert qQuestion;
        qQuestion = new lmscons__Quiz_Question__c();
        Question = new lmscons__Question__c();      
    }
    
    public void save(){
        Question.Name = Question.lmscons__Question__c;
        try{
        insert Question;
        createAnswersForTrueFalseTypeQuestions(Question);       
        //close the pop up
        system.debug('*********'+ Quizid);      
        qQuestion.lmscons__Quiz__c = Quizid;
        qQuestion.lmscons__Question__c = Question.id;
        insert qQuestion;
        noerrors = true;
        }
        catch(Exception e)
        {
            noerrors = false;
        }
    //url='https://lmscons.cs14.visual.force.com/apex/QuizQuestionDetail?id='+Question.id+'&sfdc.override=1';
    //https://lmscons.cs14.visual.force.com/apex/QuizQuestionDetail?id=a0qc0000000WDC4&qid=a0tc0000002FilLAAS&sfdc.override=1
    //PageReference reRend = new PageReference('apex/QuizQuestionDetail?id='+Question.id+'&sfdc.override=1');
    //PageReference reRend = new PageReference('/'+Question.id);
    //reRend.setRedirect(true);
    //return reRend;        
    }
    
    //create Answers for True/False type question
    private void createAnswersForTrueFalseTypeQuestions (lmscons__Question__c qstn) {               
        if (qstn.lmscons__Type__c == 'True/False'){
            lmscons__Answer__c ansTrue = new lmscons__Answer__c (lmscons__Question__c = qstn.Id, lmscons__Order__c=1,
                                                    Name='True', lmscons__Correct_incorrect__c=true,
                                                    lmscons__Answer__c='True');
            lmscons__Answer__c ansFalse = new lmscons__Answer__c (lmscons__Question__c = qstn.Id, lmscons__Order__c=2,
                                                    Name='False', lmscons__Correct_incorrect__c=false,
                                                    lmscons__Answer__c='False');            
            insert new List<lmscons__Answer__c> {ansTrue, ansFalse};
        }
    }
    
}