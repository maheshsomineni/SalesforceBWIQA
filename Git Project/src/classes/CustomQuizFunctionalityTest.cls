/*=============================================================
Test class for custom Quiz functionality classes:
    Controller_lmsiltQuiz
    lmsconsQuizDetailExt_ctrl
    lmsconsQuizNewQuestion_ctrl
    lmsconsQuizAddQuestion_ctrl
    lmsconsQuizContentDetailExt_ctrl
============================================================*/
@isTest (seeAllData=false)
                    
private class CustomQuizFunctionalityTest {

    static testMethod void runTest() {
        //create test data
        lmscons__Quiz__c testQuiz = new lmscons__Quiz__c (lmscons__show_100_if_fail__c=true,
                                         lmscons__Description__c='test quiz', lmscons__Language__c='en_US',
                                         lmscons__Max_Attempts__c=2, lmscons__Passing_Score__c=50);
        insert testQuiz;
        
        lmscons__Training_Content__c testModule = new lmscons__Training_Content__c (lmscons__Test_Course__c=true,
                                                        lmscons__Quiz__c=testQuiz.Id);
        insert testModule;
        
        lmscons__Question__c testQuestion = new lmscons__Question__c (
                                                           lmscons__Difficulty__c='Easy', lmscons__Question__c='test question',
                                                           lmscons__Type__c='True/False');
        lmscons__Question__c testQuestion2 = new lmscons__Question__c (
                                                           lmscons__Difficulty__c='Easy', lmscons__Question__c='test question2',
                                                           lmscons__Type__c='Free Text');
        lmscons__Question__c testQuestion3 = new lmscons__Question__c (Name = 'Page Break',
                                                           lmscons__Difficulty__c='Easy', lmscons__Question__c='test question3');                                                   
        lmscons__Question__c testQuestion4 = new lmscons__Question__c (
                                                           lmscons__Difficulty__c='Easy', lmscons__Question__c='test question4',
                                                           lmscons__Type__c='Free Text');
        lmscons__Question__c testQuestion5 = new lmscons__Question__c (Name = 'Page Break',
                                                           lmscons__Difficulty__c='Easy', lmscons__Question__c='test question5'); 
                                                                                                                                                                         
        insert new List<lmscons__Question__c>{testQuestion, testQuestion2, testQuestion3, testQuestion4, testQuestion5};
        
        lmscons__Answer__c testQuestionAnswer = new lmscons__Answer__c(lmscons__Correct_incorrect__c=true,
                                                      lmscons__Question__c=testQuestion.Id,
                                                      lmscons__Answer__c='test answer');
        lmscons__Answer__c testQuestionAnswer4 = new lmscons__Answer__c(lmscons__Correct_incorrect__c=true,
                                                      lmscons__Question__c=testQuestion4.Id,
                                                      lmscons__Answer__c='test answer4');
        lmscons__Answer__c testQuestionAnswer5 = new lmscons__Answer__c(lmscons__Correct_incorrect__c=true,
                                                      lmscons__Question__c=testQuestion5.Id,
                                                      lmscons__Answer__c='test answer5');                                                                                                            
        insert new List<lmscons__Answer__c> {testQuestionAnswer, testQuestionAnswer4, testQuestionAnswer5};
                                                       
        lmscons__Quiz_Question__c testQuizQuestion = new lmscons__Quiz_Question__c(lmscons__Quiz__c=testQuiz.Id,
                                                               lmscons__Question__c=testQuestion.Id);  
        lmscons__Quiz_Question__c testQuizQuestion4 = new lmscons__Quiz_Question__c(lmscons__Quiz__c=testQuiz.Id,
                                                               lmscons__Question__c=testQuestion4.Id);
        lmscons__Quiz_Question__c testQuizQuestion5 = new lmscons__Quiz_Question__c(lmscons__Quiz__c=testQuiz.Id,
                                                               lmscons__Question__c=testQuestion5.Id);                                                                                                                              
        insert new List<lmscons__Quiz_Question__c>{testQuizQuestion, testQuizQuestion4, testQuizQuestion5};
                                                                                                                
        System.currentPageReference().getParameters().put('qid', testQuiz.id);
        ApexPages.StandardController sc = new ApexPages.StandardController(testQuiz);
        lmsconsQuizContentDetailExt_ctrl testController1 = new lmsconsQuizContentDetailExt_ctrl(sc);
        lmsconsQuizNewQuestion_ctrl testController2 = new lmsconsQuizNewQuestion_ctrl(sc);        

        Test.startTest();
        testController1.testLink();
        testController1.doSave();
        testController2.saveNew();
        testController2.save();
        System.currentPageReference().getParameters().put('id', testQuiz.id);
        lmsconsQuizAddQuestion_ctrl testController3 = new lmsconsQuizAddQuestion_ctrl();
        testController3.previous();
        testController3.next();
        testController3.searchByString();
        testController3.AddQuestions();
        System.currentPageReference().getParameters().put('retURL', '/'+testQuiz.id);
        Controller_lmsiltQuiz testController4 = new Controller_lmsiltQuiz();
        testController4.checkAllFields();
        try{testController4.SaveResult();}catch(Exception ex){}
        testController4.SaveResultForTestQuiz();
        testController4.Back();
        try{testController4.DoReview();}catch(Exception ex){}
        testController4.ReturnToSource();
        testController4.goNext();
        testController4.goPrevious();
        testController4.TemporarySave();
        /*testController4.ReturnToQuizDetail();*/
        lmsconsQuizDetailExt_ctrl testController5 = new lmsconsQuizDetailExt_ctrl(sc);
        testController5.addToMyTraining();
        testController5.AddPageBreak();
        System.assert([SELECT Id FROM lmscons__Quiz_Question__c].size()>0);
        Test.stopTest();
    }
}