public with sharing class Controller_lmsiltQuiz{
    public list<WrapperQuestion> Questions {get;set;}
    public lmscons__Quiz__c Qn {get;set;}
    public lmscons__Training_Content__c module {get;set;}
    public boolean isReviewMode {get;set;}
    public boolean isSubmit {get;set;}
    public boolean isPre {get;set;}
    public boolean returnToSource {get;set;}
    //public boolean isNotTest {get;set;}
    public boolean isEnableButtonOkForQuizTest {get;set;}
    public boolean notPassed {get;set;}
    public String Message {get;set;}
    public boolean isPassed {get;set;}
    public String CurrQuest {get;set;}
    public boolean isAllRequiredFieldsFilled {get;set;}
    private map<Id,list<lmscons__Answer__c>> mapCorrectAnswer = new map<Id,list<lmscons__Answer__c>>();
    private map<Id,lmscons__Answer__c> mapAnswer = new map<Id,lmscons__Answer__c>();
    public Integer pagesNo{get;set;}
    public Integer currentPage{get;set;}
    public Integer CountQuestions{get;set;}
    
    private map<Integer, WrapperQuestion> pageBreaks;
    private list<WrapperQuestion> mainQuestions;
    private map<Integer,list<WrapperQuestion>> Questions1;       
    
    //added by JG on 9 Dec' 2014
    public String returnURLValue {get;set;}
    //private List<lmscons__Quiz_Statistic__c> listQuizStats;   
    private DateTime quizStartTime;
    
    //added by JG on 23 March' 2015         
    //private transient Set<String> setQuestionIds = new Set<String> ();        
    private Set<String> setQuestionIds = new Set<String> ();        
    private String quizId = '';
    
    //added by JG on 8 April' 2015
    public Boolean reviewModeToSeeCorrectAnswers {get;set;}
    //added by JG on 28 April' 2015
    public Boolean maxAttemptsExceeded {get;set;}
    private Integer attemptsLeft;
    public PageReference redirectCustom (){
       PageReference pg = new PageReference (returnURLValue);
       //Commented by JG (Appirio) on 28 April' 2014
       //pg.setRedirect(true);
       return pg;
    }
    
    public Controller_lmsiltQuiz(){
        CountQuestions = 0;
        quizId = ApexPages.currentPage().getParameters().get('id');
        //set returnURL
        returnURLValue = ApexPages.currentPage().getParameters().get('retUrl');
        quizStartTime = DateTime.now();
        Questions = new list<WrapperQuestion>();
        mainQuestions = new list<WrapperQuestion>();
        Questions1 = new map<Integer,list<WrapperQuestion>>();
        pageBreaks = new map<Integer, WrapperQuestion>();
        //added by JG on 25 March' 2015
        isReviewMode = false;
        reviewModeToSeeCorrectAnswers = false;
        maxAttemptsExceeded = false;
        attemptsLeft = -1;
        
        Qn = [Select l.lmscons__show_100_if_fail__c, l.lmscons__review_answers__c, l.lmscons__isArchived__c, l.lmscons__Training_Unit__c,
                 l.lmscons__Show_Score__c, l.lmscons__Randomization__c, l.lmscons__Passing_Score__c, l.lmscons__Max_Attempts__c, 
                 l.lmscons__Maintain_correct_answers__c, l.lmscons__Language__c, l.lmscons__Enable_Certificate__c, l.lmscons__Duration__c, 
                 l.lmscons__DurationTime__c, l.lmscons__Description__c, l.Name, l.Id From lmscons__Quiz__c l where id=:quizId limit 1];
                
        //added transient keyword to avoid View Stage page size error
        /*transient*/ list<lmscons__Quiz_Question__c> lstQQ = [Select l.lmscons__Quiz__c, l.lmscons__Question__r.Image__c, l.lmscons__Question__r.lmscons__Type__c,
                            l.lmscons__Question__r.lmscons__Text_Type__c, l.lmscons__Question__r.lmscons__Randomization__c, l.lmscons__Question__r.lmscons__Question__c, 
                            l.lmscons__Question__r.lmscons__Difficulty__c, l.lmscons__Question__r.Id,  l.lmscons__Order__c From lmscons__Quiz_Question__c l
                            where lmscons__Quiz__c=:quizId
                            Order By lmscons__Order__c];                  
        
        //added by JG on 23 March' 2015
        for(lmscons__Quiz_Question__c quizQues : lstQQ){
            setQuestionIds.add(quizQues.lmscons__Question__c);
        }                                     
                            
        //added transient keyword to avoid View Stage page size error
        /*transient list<lmscons__Answer__c> tmpAnswers= [Select l.lmscons__Question__c, l.lmscons__Order__c, l.lmscons__Free_Text__c, l.lmscons__Correct_incorrect__c, 
                                            l.lmscons__Answer__c, l.lmscons__Question__r.lmscons__Type__c From lmscons__Answer__c l
                                            //added by JG on 31 March' 2015 to bring down the size of view state
                                            WHERE l.lmscons__Question__c IN :setQuestionIds];*/
        
        mapAnswer = new Map<Id, lmscons__Answer__c>([Select l.lmscons__Question__c, l.lmscons__Order__c, l.lmscons__Free_Text__c, l.lmscons__Correct_incorrect__c, 
                                            l.lmscons__Answer__c, l.lmscons__Question__r.lmscons__Type__c From lmscons__Answer__c l
                                            //added by JG on 31 March' 2015 to bring down the size of view state
                                            WHERE l.lmscons__Question__c IN :setQuestionIds]);
                                                                                 
                                            
        module = [Select l.lmsilt__Training_Unit_Cost__c, l.lmsilt__Module_Type__c, l.lmsilt__ILT_Title__c, l.lmsilt__Event__c, 
                                        l.lmsilt__Development_Plan_Task__c, l.lmscons__verified__c, l.lmscons__isArchived__c, l.lmscons__Version__c, l.lmscons__Used__c, l.lmscons__Upload__c, 
                                        l.lmscons__Training_Unit__c, l.lmscons__Title_col__c, l.lmscons__Title__c, l.lmscons__Test_Course__c, l.lmscons__Status_Progress__c, l.lmscons__StatusUpdate__c, 
                                        l.lmscons__Score__c, l.lmscons__Quiz__c, l.lmscons__Publisher__c, l.lmscons__Publisher_Course_Id__c, l.lmscons__Progress__c, l.lmscons__Products__c, 
                                        l.lmscons__Primary_Product__c, l.lmscons__Primary_Job_Role__c, l.lmscons__Percent_Complete__c, l.lmscons__Parent_Training_Content__c, l.lmscons__Object_Type__c, 
                                        l.lmscons__Object_Id__c, l.lmscons__Module_Type__c, l.lmscons__Language__c, l.lmscons__Keywords__c, l.lmscons__Job_Roles__c, l.lmscons__Is_Published__c, 
                                        l.lmscons__Enable_Certificate__c, l.lmscons__Duration__c, l.lmscons__DurationTime__c, l.lmscons__Description__c, l.lmscons__Delivery_Type__c, 
                                        l.lmscons__Default_Language_Module__c, l.lmscons__Cornerstone_ID__c, l.lmscons__ContentCatalog__c, l.lmscons__CFS_ID__c, l.Id From lmscons__Training_Content__c l where lmscons__Quiz__c=:Qn.Id limit 1 FOR UPDATE];                                        
        
        //added by JG(Appirio) on 18 March' 2015 
        //added transient keyword to avoid View Stage page size error
        /*transient*/ Map <String, Integer> mapQuestionToAnswersCount = new Map <String, Integer>();        
        for(lmscons__Answer__c ans : mapAnswer.values()){
        //for(lmscons__Answer__c ans :tmpAnswers){
            mapAnswer.put(ans.id,ans);
            if(ans.lmscons__Correct_incorrect__c == true || ans.lmscons__Question__r.lmscons__Type__c == 'Multi Select'){
                if(mapCorrectAnswer.containsKey(ans.lmscons__Question__c)){
                    mapCorrectAnswer.get(ans.lmscons__Question__c).add(ans);
                }
                else{
                    list<lmscons__Answer__c> lst= new list<lmscons__Answer__c>();
                    lst.add(ans);
                    mapCorrectAnswer.put(ans.lmscons__Question__c, lst);
                }
            }
            //added by JG(Appirio) on 18 March' 2015 
            if(!mapQuestionToAnswersCount.containsKey(ans.lmscons__Question__c))
                mapQuestionToAnswersCount.put(ans.lmscons__Question__c, 0);                
            
            mapQuestionToAnswersCount.put(ans.lmscons__Question__c, mapQuestionToAnswersCount.get(ans.lmscons__Question__c)+1);
        }
        
        if(lstQQ != null && lstQQ.size()>0){
            WrapperQuestion q;
            Question tmpQ;
            for(lmscons__Quiz_Question__c qq : lstQQ){
                q = new WrapperQuestion();
                tmpQ = new Question();
                q.Type = qq.lmscons__Question__r.lmscons__Type__c;
                tmpQ.Type = qq.lmscons__Question__r.lmscons__Type__c;
                
                if(qq.lmscons__Order__c != null && qq.lmscons__Order__c > 0){
                    tmpQ.orderNo = qq.lmscons__Order__c;
                }

                tmpQ.NameQ = qq.lmscons__Question__r.lmscons__Question__c;
                tmpQ.sObj = qq;
                tmpQ.AnswerOptions = new list<SelectOption>();
                //updated by JG (Appirio) on 3 March' 2015 for I-149972
                Boolean maintainOrderOfAnswers = true;
                System.debug('++++++++qq the original question '+qq);
                for(lmscons__Answer__c ans : mapAnswer.values()){
                //for(lmscons__Answer__c ans :tmpAnswers){
                    if(ans.lmscons__Question__c == qq.lmscons__Question__c){
                        if(ans.lmscons__Order__c != null){
                          if(maintainOrderOfAnswers){
                            maintainOrderOfAnswers = false;
                            System.debug('++++++mapQuestionToAnswersCount.get(ans.lmscons__Question__c) '+mapQuestionToAnswersCount.get(ans.lmscons__Question__c));
                            tmpQ.AnswerOptions = new System.SelectOption[mapQuestionToAnswersCount.get(ans.lmscons__Question__c)];
                          }
                          tmpQ.AnswerOptions.set(Integer.valueOf(ans.lmscons__Order__c-1), new SelectOption(ans.id, ans.lmscons__Answer__c));                          
                        } else{
                            tmpQ.AnswerOptions.add(new SelectOption(ans.id, ans.lmscons__Answer__c));
                        }
                    }
                }
                System.debug('++++tmpQ.AnswerOptions '+tmpQ.AnswerOptions);
                tmpQ.Qid = qq.lmscons__Question__c;
                q.ques.add(tmpQ);
                
                if(qq.lmscons__Question__r.lmscons__Type__c != null && qq.lmscons__Question__r.lmscons__Type__c.equalsignorecase('Page Break')){
                    Integer ii = (Integer)(tmpQ.orderNo);
                    pageBreaks.put(ii, q);
                }else{
                    mainQuestions.add(q);
                }
            }
        }
        
        Integer pageNo = 0;
        Integer questionsize = 0; 
        for(WrapperQuestion q : mainQuestions){
            if(!Questions1.containsKey(pageNo)){
                Questions1.put(pageNo, new list<WrapperQuestion>());
            }
            Questions1.get(pageNo).add(q);
            questionsize++; 
            if(pageBreaks.containsKey(questionsize+1)){
                Questions1.get(pageNo).add(pageBreaks.get(questionsize+1));
                questionsize++;
                pageNo++;               
            }
        }
        pagesNo = Questions1.size()-1;
        currentPage = 0;    
        Questions = Questions1.get(currentPage);
        System.debug('+++++++test++++++++++++');
        //added by JG(Appirio) on 23 March' 2015
        if(ApexPages.currentPage().getParameters().get('reviewMode') != null
                && String.valueOf(ApexPages.currentPage().getParameters().get('reviewMode'))=='true'){                
            isReviewMode = true;
            isSubmit = true;
            reviewModeToSeeCorrectAnswers = true;
            //
            System.debug('+++++++setQuestionIds '+setQuestionIds);
            //
            checkAllFields();
        } 
        
        //added by JG (Appirio) on 28 April' 2015
        //check if maximum number of attemps has exceeded, if yes then do not allow to attempt the exam
        if (Qn.lmscons__Max_Attempts__c != null && setQuestionIds != null && setQuestionIds.size()>0
            && !isReviewMode && returnURLValue != null){
            List<lmscons__Quiz_Statistic__c> listLmsQS = [SELECT Id
                                                  FROM lmscons__Quiz_Statistic__c
                                                 WHERE lmscons__Quiz__c = :quizId
                                                   AND lmscons__Learner__c = :UserInfo.getName()];
           if(listLmsQS != null && (listLmsQS.size()/setQuestionIds.size() >= Qn.lmscons__Max_Attempts__c)){   
               maxAttemptsExceeded = true;                                          
               ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                  'Maximum number of attempts allowed exceeded.'));
               return;
           } else {
               //subtracting one to include the attempt being used
               attemptsLeft = Integer.valueOf(Qn.lmscons__Max_Attempts__c - listLmsQS.size()/setQuestionIds.size() - 1);
           }
        } 
        
    }
    
    public void TemporarySave(){}
    
    public void goPrevious(){
        currentPage--;      
        Questions = Questions1.get(currentPage);
        for(WrapperQuestion wq : Questions){
            for(Question ques : wq.ques)
                if(ques.Type != null && (!ques.Type.equalsIgnoreCase('Page Break')))
                    CountQuestions--;
        }       
    }
    
    public void goNext(){
        for(WrapperQuestion wq : Questions){
            for(Question ques : wq.ques)
                if(ques.Type != null && (!ques.Type.equalsIgnoreCase('Page Break')))
                    CountQuestions++;
        }
        currentPage++;
        Questions = Questions1.get(currentPage);
    }
    
    public PageReference ReturnToSource(){
        PageReference page = new PageReference('/apex/NewQuizDetail?id='+Qn.Id);
        page.setRedirect(true);
        return page;
        //PageReference page = new PageReference('https://lmscons.cs14.visual.force.com/apex/MyTraining?checkBox=false');
        //page.setRedirect(true);
       // return page;
    }
    
    public PageReference ReturnToQuizDetail(){
        PageReference pg = new PageReference('/apex/NewQuizDetail?id='+Qn.Id);
        System.debug('+++++++++++++pg '+pg);
        //page.setRedirect(true);
        return pg;
    }
    
    public void checkAllFields(){
        system.debug('==Questions=='+mainQuestions);
        system.debug('==mapCorrectAnswer=='+mapCorrectAnswer);
        system.debug('==setQuestionIds=='+setQuestionIds);
        isAllRequiredFieldsFilled = true; 
        
        //added by JG(Appirio) on 23 March' 2015
        Map<String, String> mapTempQuizStats = new Map<String, String> ();
        Map<String, String> mapTempQuizAns = new Map<String, String> ();
        Integer tempSize = (setQuestionIds != null ? setQuestionIds.size() : 0);
        for(lmscons__Quiz_Statistic__c lmsQS : [SELECT Id, lmscons__Long_Answer__c, lmscons__Question__c, lmscons__Answer__c,
                                                       lmscons__Question__r.lmscons__Type__c, lmscons__Temporary_Answer__c
                                                  FROM lmscons__Quiz_Statistic__c
                                                 WHERE lmscons__Quiz__c = :quizId
                                                   AND lmscons__Learner__c = :UserInfo.getName()
                                              ORDER BY CreatedDate DESC
                                                 LIMIT :tempSize]){                                                                
           mapTempQuizStats.put(lmsQS.lmscons__Question__c, lmsQS.lmscons__Temporary_Answer__c);        
           mapTempQuizAns.put(lmsQS.lmscons__Question__c, lmsQS.lmscons__Answer__c);                                           
        }
        //use above map only
        /*for(lmscons__Answer__c lmsAns : [SELECT Id, lmscons__Answer__c, lmscons__Question__c
                                           FROM lmscons__Answer__c
                                          WHERE lmscons__Question__c IN :setQuestionIds]){
            mapTempQuizAns.put(lmsAns.lmscons__Answer__c, lmsAns.Id);
        }*/
        System.debug('+++++++++++++ mapTempQuizStats '+mapTempQuizStats);
        System.debug('+++++++++++++ mainQuestions '+mainQuestions); 
        
        for(WrapperQuestion wq:mainQuestions){
            for(Question q:wq.ques){
                if(q.Type != null && q.Type.equalsignorecase('True/False')){
                    system.debug('==q.AnswerTrueFalse=='+q.AnswerTrueFalse);
                    if(q.AnswerTrueFalse == null ||(q.AnswerTrueFalse !=null && q.AnswerTrueFalse.equals(''))){
                        isAllRequiredFieldsFilled = false;
                    }
                    //added by JG on 23 March' 2015
                    System.debug('isReviewMode '+isReviewMode);               
                    if(isReviewMode){
                        //q.AnswerTrueFalse = mapTempQuizAns.get(mapTempQuizStats.get(q.Qid));
                        q.AnswerTrueFalse = findAnswerId(mapTempQuizStats.get(q.Qid));
                        q.isPassed =  mapTempQuizAns.get(q.Qid) == 'correct' ? true : false;
                        //added by JG on 8 April' 2015
                        for(lmscons__Answer__c tempAns : mapCorrectAnswer.get(q.Qid)){
                            q.correctAnswerInReviewMode += tempAns.lmscons__Answer__c;
                        }
                    } 
                    System.debug('q.AnswerTrueFalse '+q.AnswerTrueFalse);  
                }
                else if(q.Type != null && q.Type.equalsignorecase('Free Text')){
                    system.debug('==q.AnswerTrueFalse=='+q.AnswerFreeText);
                    if(q.AnswerFreeText== null ||(q.AnswerFreeText != null && q.AnswerFreeText.equals(''))){
                        isAllRequiredFieldsFilled = false;
                    }
                    //added by JG on 23 March' 2015
                    System.debug('isReviewMode '+isReviewMode);               
                    if(isReviewMode){
                        q.AnswerFreeText = mapTempQuizStats.get(q.Qid);
                        q.isPassed =  mapTempQuizAns.get(q.Qid) == 'correct' ? true : false;                        
                    } 
                }
                else if(q.Type != null && (q.Type.equalsignorecase('Single Select') || q.Type.equalsignorecase('One Select'))){
                    system.debug('==q.AnswerTrueFalse=='+q.AnswerOneSelect);
                    if(q.AnswerOneSelect == null || (q.AnswerOneSelect !=null && q.AnswerOneSelect.equals(''))){
                        isAllRequiredFieldsFilled = false;
                    }
                    //added by JG on 23 March' 2015              
                    if(isReviewMode){
                        //q.AnswerOneSelect = mapTempQuizAns.get(mapTempQuizStats.get(q.Qid));
                        q.AnswerOneSelect = findAnswerId(mapTempQuizStats.get(q.Qid));
                        q.isPassed =  mapTempQuizAns.get(q.Qid) == 'correct' ? true : false;  
                        //added by JG on 8 April' 2015
                        for(lmscons__Answer__c tempAns : mapCorrectAnswer.get(q.Qid)){
                            q.correctAnswerInReviewMode += tempAns.lmscons__Answer__c;
                        }               
                    } 
                }
                else if(q.Type != null && (q.Type.equalsignorecase('Multi Select') || q.Type.equalsignorecase('Multiple Choice'))){
                    system.debug('==q.AnswerMultiSelect=='+q.AnswerMultiSelect);
                    system.debug('==q.NameQ=='+q.NameQ);
                    if(q.AnswerMultiSelect == null || (q.AnswerMultiSelect != null && q.AnswerMultiSelect.size()==0)){
                        isAllRequiredFieldsFilled = false;
                    }
                    //added by JG on 23 March' 2015              
                    if(isReviewMode){
                        q.AnswerMultiSelect = findAnswerId(mapTempQuizStats.get(q.Qid)).split(';');
                        q.isPassed =  mapTempQuizAns.get(q.Qid) == 'correct' ? true : false;   
                        //added by JG on 8 April' 2015
                        for(lmscons__Answer__c tempAns : mapCorrectAnswer.get(q.Qid)){
                            q.correctAnswerInReviewMode += tempAns.lmscons__Answer__c+',';
                        }          
                        q.correctAnswerInReviewMode = q.correctAnswerInReviewMode.removeEnd(',');
                    } 
                }
            }
        } 
        system.debug('==isAllRequiredFieldsFilled=='+isAllRequiredFieldsFilled);
    //  isAllRequiredFieldsFilled=true;
        
        //added by JG on 23 March' 2015
        if(isReviewMode){return;} 
        
        if(isAllRequiredFieldsFilled){
            SaveResult();
        }
    }
    
    public void SaveResult(){
        system.debug('==Questions=='+mainQuestions);
        system.debug('==mapCorrectAnswer=='+mapCorrectAnswer);
        integer correctAnswer = 0;
        integer totalAnswer = 0;
        lmscons__Transcript_Line__c tempAssignmentUpdate; 
        //added by JG on 9 Dec' 2014
        //modified by JG on 31 March' 2014
        List<lmscons__Quiz_Statistic__c> listQuizStats = new List<lmscons__Quiz_Statistic__c> ();
        lmscons__Quiz_Statistic__c tempQuizStat; 
        for(WrapperQuestion wq : mainQuestions){
            for(Question q : wq.ques){                        
                list<lmscons__Answer__c> lst= mapCorrectAnswer.get(q.sObj.lmscons__Question__c);
                tempQuizStat = new lmscons__Quiz_Statistic__c ();   //added by JG
                tempQuizStat.lmscons__Question__c = q.Qid;          //added by JG    
                if(lst!=null || q.Type.equalsignorecase('Free Text')){ //added by JG
                    if(q.Type != null && q.Type.equalsignorecase('True/False')){ 
                        //added by JG                        
                        for(System.SelectOption option : q.AnswerOptions){
                            if(q.AnswerTrueFalse == option.getValue()){
                              tempQuizStat.lmscons__Long_Answer__c = option.getLabel();  
                              tempQuizStat.lmscons__Temporary_Answer__c = '{"'+option.getValue()+'":"'+option.getLabel()+'"}';
                            }
                        }                         
                        for(lmscons__Answer__c ans : lst){
                            if(ans.lmscons__Correct_incorrect__c && String.valueOf(ans.lmscons__Answer__c).equalsignorecase(mapAnswer.get(q.AnswerTrueFalse).lmscons__Answer__c)){
                                correctAnswer++;
                                q.isPassed=true;
                            }
                        }
                    }
                    else if(q.Type != null && q.Type.equalsignorecase('Free Text')){
                        system.debug('==q.AnswerFreeText=='+q.AnswerFreeText);
                        tempQuizStat.lmscons__Long_Answer__c = q.AnswerFreeText;
                        tempQuizStat.lmscons__Temporary_Answer__c = q.AnswerFreeText;                        
                        if(lst != null){//added by JG
                            for(lmscons__Answer__c ans : lst){
                                if(ans.lmscons__Correct_incorrect__c && String.valueOf(ans.lmscons__Answer__c).equalsignorecase(q.AnswerFreeText)){
                                    correctAnswer++;
                                    q.isPassed=true;
                                }
                            }
                        }
                    }
                    else if(q.Type != null && (q.Type.equalsignorecase('Single Select') || q.Type.equalsignorecase('One Select'))){
                        //added by JG                        
                        for(System.SelectOption option : q.AnswerOptions){
                            if(q.AnswerOneSelect == option.getValue()){
                              tempQuizStat.lmscons__Long_Answer__c = option.getLabel();  
                              tempQuizStat.lmscons__Temporary_Answer__c = '{"'+option.getValue()+'":"'+option.getLabel()+'"}';
                            }
                        } 
                        for(lmscons__Answer__c ans : lst){
                            if(ans.lmscons__Correct_incorrect__c && String.valueOf(ans.lmscons__Answer__c).equalsignorecase(mapAnswer.get(q.AnswerOneSelect).lmscons__Answer__c)){
                                correctAnswer++;
                                q.isPassed=true;
                            }
                        }
                    }
                    else if(q.Type != null && (q.Type.equalsignorecase('Multi Select') || q.Type.equalsignorecase('Multiple Choice'))){
                        tempQuizStat.lmscons__Long_Answer__c = '';                                              
                        boolean correct=false;
                        Boolean onceExecuted = false;
                        Integer correctAnswersCount = 0;
                        system.debug('==q.lst=='+lst);
                        system.debug('==q.AnswerMultiSelect=='+q.AnswerMultiSelect);
                        system.debug('==q.AnswerOptions=='+q.AnswerOptions);
                        //find the count of right answers
                        for(lmscons__Answer__c ans : lst){
                          if(ans.lmscons__Correct_incorrect__c) ++correctAnswersCount;
                        }
                        tempQuizStat.lmscons__Temporary_Answer__c = '{';
                        for(lmscons__Answer__c ans : lst){
                            for(String str : q.AnswerMultiSelect){  
                                //added by JG           
                                if(!onceExecuted){                                                                                  
                                    for(System.SelectOption option : q.AnswerOptions){
                                        if(str == option.getValue()){
                                          tempQuizStat.lmscons__Long_Answer__c = tempQuizStat.lmscons__Long_Answer__c+option.getLabel()+ ';';
                                          tempQuizStat.lmscons__Temporary_Answer__c += '"'+ option.getValue() +'":"'+option.getLabel()+'",';
                                        }  
                                    }                                       
                                }                           
                                if(ans.lmscons__Correct_incorrect__c && String.valueOf(ans.lmscons__Answer__c).equalsignorecase(mapAnswer.get(str).lmscons__Answer__c)){
                                    system.debug('==true==');
                                    system.debug('==ans.lmscons__Answer__c=='+ans.lmscons__Answer__c);
                                    system.debug('==mapAnswer.get(str).lmscons__Answer__c=='+mapAnswer.get(str).lmscons__Answer__c);
                                    correct=true;
                                }
                                else if(!ans.lmscons__Correct_incorrect__c && String.valueOf(ans.lmscons__Answer__c).equalsignorecase(mapAnswer.get(str).lmscons__Answer__c)){
                                    correct=false;
                                    system.debug('==false==');
                                }
                            }            
                            onceExecuted = true;                
                        }                        
                        //added by JG
                        tempQuizStat.lmscons__Temporary_Answer__c = tempQuizStat.lmscons__Temporary_Answer__c.subString(0,tempQuizStat.lmscons__Temporary_Answer__c.length()-1);
                        tempQuizStat.lmscons__Temporary_Answer__c += '}';
                        if(correctAnswersCount != q.AnswerMultiSelect.size()) {correct=false;}
                        tempQuizStat.lmscons__Long_Answer__c = tempQuizStat.lmscons__Long_Answer__c.subString(0,tempQuizStat.lmscons__Long_Answer__c.length()-1);
                        if(correct){
                            correctAnswer++;
                            q.isPassed=true;
                            system.debug('==correctAnswer=='+correctAnswer);
                        }
                    }
                }
                totalAnswer++;
                system.debug('==totalAnswer=='+totalAnswer);
                //added by JG on 9 Dec' 2014                                                
                tempQuizStat.lmscons__Quiz__c = Qn.Id;            
                if(q.isPassed && !(q.Type.equalsignorecase('Free Text'))){
                    tempQuizStat.lmscons__Answer__c = 'Correct';                    
                } else if(!q.Type.equalsignorecase('Free Text')){
                    tempQuizStat.lmscons__Answer__c = 'Incorrect';   
                }
                listQuizStats.add(tempQuizStat);
                //end of changes
            }
        }
        //added by JG on 9 Dec' 2014
        //delete quiz stats if 'Quiz Test' is being performed        
        if(returnURLValue == null){
            List<lmscons__Quiz_Statistic__c> listQuizStatsToDelete = [SELECT Id FROM lmscons__Quiz_Statistic__c
                                                                       WHERE lmscons__Quiz__c = :Qn.Id
                                                                         AND lmscons__Transcript__c = null
                                                                         ];
            if(listQuizStatsToDelete != null && listQuizStatsToDelete.size() > 0){
              //try-catch added by JG on 1 April' 2015
              try{
                delete listQuizStatsToDelete;     
              } catch(Exception ex){System.debug('exception occured : '+ ex.getMessage());}
            }                               
        }else{//populate Transcript and Assignment                 
            for(lmscons__Transcript_Line__c lmsTL : [SELECT Id, lmscons__STARTED_ON__c FROM lmscons__Transcript_Line__c
                                                      WHERE lmscons__Quiz__c = :Qn.Id 
                                                        //updated by JG(Appirio) for I-150505 
                                                        AND lmscons__Trainee__c = :UserInfo.getName()
                                                        LIMIT 1]){
              tempAssignmentUpdate = lmsTL;
              for(lmscons__Quiz_Statistic__c ls : listQuizStats){
                 ls.lmscons__Assignment__c = lmsTL.Id;
              }                                                 
            }            
            if(tempAssignmentUpdate != null && tempAssignmentUpdate.lmscons__STARTED_ON__c == null){tempAssignmentUpdate.lmscons__STARTED_ON__c = String.valueOf(quizStartTime);}
            tempAssignmentUpdate.lmscons__Last_Launched_Date__c = quizStartTime;
            tempAssignmentUpdate.lmscons__Completed_Date__c = Date.today();
            tempAssignmentUpdate.lmscons__Completion_Date__c = DateTime.now();
            for(lmscons__Transcript__c transcript : [SELECT Id FROM lmscons__Transcript__c
                                                      WHERE lmscons__Trainee__c = :UserInfo.getUserId()]){
               for(lmscons__Quiz_Statistic__c ls : listQuizStats){
                 ls.lmscons__Transcript__c = transcript.Id;
               }                                        
            }            
        }
        //insert quiz stats
        if(listQuizStats != null && listQuizStats.size() > 0){
            insert listQuizStats;           
        }
        //end of changes
        system.debug('==correctAnswer=='+correctAnswer);
        system.debug('==totalAnswer=='+totalAnswer);
        if(totalAnswer == null || totalAnswer == 0) return; //added by JG
        long flt=(correctAnswer*100)/totalAnswer;
        module.lmscons__Score__c = String.valueOf(flt);//added by Jinesh
        system.debug('==Qn.lmscons__Passing_Score__c=='+Qn.lmscons__Passing_Score__c);
        if(/*Qn.lmscons__Passing_Score__c !=null--changed by Jinesh -- 
           converted the condition from AND to OR*/Qn.lmscons__Passing_Score__c == null || Qn.lmscons__Passing_Score__c <= flt
            //added by JG (Appirio) on 8 April' 2015
            || Qn.lmscons__show_100_if_fail__c
            //added by JG (Appirio) on 29 April' 2015 - When all attempts are exhausted and failed
            || (!Qn.lmscons__show_100_if_fail__c && attemptsLeft == 0)){
                        
            //added by JG (Appirio) on 23 April' 2015
            if(Qn.lmscons__Passing_Score__c <= flt){
                module.lmscons__Status_Progress__c = 'Passed';
                isPassed=true;
                notPassed=false;                
            }else{
                module.lmscons__Status_Progress__c = 'Completed';
                isPassed=false;
                notPassed=true;                
            }
            module.lmscons__Test_Course__c=true;
            module.lmscons__Percent_Complete__c = 100;//added by Jinesh
            system.debug('==isPassed=='+isPassed);
        }
        else{
            isPassed=false;
            notPassed=true;
            module.lmscons__Status_Progress__c = 'Failed';
            module.lmscons__Test_Course__c=true; //added by Jinesh
            module.lmscons__Percent_Complete__c=0; //added by Jinesh            
            system.debug('==isPassed=='+isPassed);
        }
        system.debug('==flt=='+flt);
        if(isPassed){
            Message = 'Congratulations! You passed with a score of '+String.valueOf(flt)+'%';
        } 
        //added by JG (Appirio) on 29 April' 2015
        else if (!isPassed && !Qn.lmscons__show_100_if_fail__c && attemptsLeft > 0 && returnURLValue != null){        
            Message = 'Unfortunately, you failed with a score of '+String.valueOf(flt)+'% with a minimum requirement of '+Qn.lmscons__Passing_Score__c+'%. You have '+attemptsLeft+' attempts to pass the assessment. Please return to "My Learning" and launch assessment.';
        } else if (!isPassed && (Qn.lmscons__show_100_if_fail__c || attemptsLeft == 0) && returnURLValue != null){
            Message = 'Unfortunately, you failed with a score of '+String.valueOf(flt)+'% with a minimum requirement of '+Qn.lmscons__Passing_Score__c+'% You may review your assessment in "Completed Learning"';
        } else {
            Message = 'Unfortunately, your score of '+String.valueOf(flt)+'% does not meet the '+Qn.lmscons__Passing_Score__c+'% minimum passing score.';
        }
        system.debug('==Message=='+Message);
        isSubmit = true;
        isReviewMode = false;
        update module;
        //update Assignment - added by JG
        if(returnURLValue != null){
            tempAssignmentUpdate.lmscons__Status__c = module.lmscons__Status_Progress__c;
            //tempAssignmentUpdate.lmscons__Status__c = String.valueOf(isPassed);
            //added by JG (Appirio) on 28 April' 2015
            tempAssignmentUpdate.lmscons__Percent_Complete__c = module.lmscons__Percent_Complete__c;
            tempAssignmentUpdate.lmscons__Score__c = String.valueOf(flt);
            if(tempAssignmentUpdate != null) {update tempAssignmentUpdate;}
        }
    }
    
    public void SaveResultForTestQuiz(){
        isReviewMode = true;        
    }
    
    public PageReference Back(){
        //updated by JG (Appirio) on 18 March' 2015
        //return ReturnToQuizDetail();
        return redirectCustom();
    }
    
    public void DoReview(){
        isReviewMode = true;
        if(isPassed){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, Message));
        } else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, Message));
        }
    }
    
    /*public void initForUpdateLastLaunchDateAssignment(){
        
    }*/
    
    public class WrapperQuestion{
        public String Type {get;set;}
        public list<Question> ques{get;set;}
        public WrapperQuestion(){
            ques = new list<Question>();
        }
    }
    public Static Integer orderNoTmp = 0;
    public class Question{
        public String Type {get;set;}
        public boolean isPassed{get;set;}
        public String NameQ {get;set;}
        public list<SelectOption> AnswerOptions{get;set;}
        public String AnswerTrueFalse {get;set;}
        public String AnswerOneSelect {get;set;}
        public String Qid {get;set;}
        public String TypeText {get;set;}
        public String AnswerFreeText {get;set;}
        public String[] AnswerMultiSelect {get;set;}
        public lmscons__Quiz_Question__c sObj{get;set;}
        public Decimal orderNo{get;set;}        
        //added by JG (Appirio) on 8 April' 2015
        public String correctAnswerInReviewMode {get;set;}
        
        public Question(){
            AnswerOptions = new list<SelectOption>();
            Type='';
            isPassed = false;
            NameQ='';
            AnswerTrueFalse ='';
            AnswerOneSelect='';
            Qid='';
            TypeText='';
            AnswerFreeText='';
            AnswerMultiSelect=new list<String>();
            orderNo=orderNoTmp;
            orderNoTmp++;
            correctAnswerInReviewMode = '';
        }
    }
    
    //added by JG on 23 March' 2015
    private String findAnswerId (String inputTempAnswer){
        String returnValue = '';
        for(String temp : inputTempAnswer.split(',')){            
           returnValue += temp.substring(temp.indexOf('"')+1, temp.indexOf('"', temp.indexOf('"')+1))+';';           
        } 
        return (returnValue.removeEndIgnoreCase(';'));
    }
}