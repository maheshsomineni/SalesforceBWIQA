public with sharing class lmsconsQuizDetailExt_ctrl {
    
    public boolean isConsumerUser {get;set;}
    public boolean isAdminUser {get;set;}
    public boolean hasQuizQuestions {get;set;}
    
    public lmscons__Training_Content__c Module {get;set;}
    public lmscons__Quiz__c quiz {get;set;}
    public lmsconsQuizDetailExt_ctrl(ApexPages.StandardController controller){
        this.quiz = (lmscons__Quiz__c)controller.getRecord();
        //added by Jinesh
        Module = [Select l.lmscons__verified__c, l.lmscons__Title__c,l.lmscons__Test_Course__c, l.lmscons__Status_Progress__c, 
                         l.lmscons__Score__c, l.lmscons__Quiz__c, l.lmscons__Description__c,l.lmscons__Percent_Complete__c,
                         l.lmscons__Quiz__r.lmscons__Show_Score__c, l.Name, l.Id From lmscons__Training_Content__c l 
                   where l.lmscons__Quiz__c=:Quiz.Id limit 1];
                   
        //check if consumer user -- added by Jinesh
        Set<String> setConsumerUserProfiles = new Set<String> ();
        for(String s : String.valueOf(System.Label.ConsumerUserProfiles).split(',')){
          setConsumerUserProfiles.add(s);
        }
        List<Profile> listProfiles = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
        String currentUserProfileName = listProfiles[0].Name;
        if(setConsumerUserProfiles.contains(currentUserProfileName)) {isConsumerUser=true;}
    }
    
    //updated by Jinesh
    public PageReference addToMyTraining(){
        lmscons__Training_User_License__c tempLicense;
        lmscons__Transcript__c tempTranscript;
        for(lmscons__Training_User_License__c l : [SELECT Id FROM lmscons__Training_User_License__c
                                                   WHERE lmscons__User__c = :UserInfo.getUserId()]){
            
            tempLicense = l;
        } 
        for(lmscons__Transcript__c l : [SELECT Id FROM lmscons__Transcript__c
                                        WHERE lmscons__Trainee__c = :UserInfo.getUserId()]){
            
            tempTranscript = l;
        } 
        
        //null check
        if(tempLicense == null || tempTranscript == null) {
            //return error
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 
                                             'Quiz cannot be assigned, Please contact your administrator');
            ApexPages.addMessage(errMsg);
            return null;
        }
        
        //check if assignment already exists
        String usrName = UserInfo.getFirstName() + ' ' + UserInfo.getLastName();
        for(lmscons__Transcript_Line__c l : [SELECT Id FROM lmscons__Transcript_Line__c
                                             WHERE lmscons__Training_User_License__c = :tempLicense.Id
                                               AND lmscons__Transcript__c = :tempTranscript.Id
                                               AND lmscons__Training_Content__c = :Module.Id
                                               AND lmscons__Quiz__c = :quiz.Id
                                               AND lmscons__Trainee__c = :usrName]){
            //return error
            ApexPages.Message erMsg = new ApexPages.Message(ApexPages.Severity.WARNING, 'Quiz is already assigned');
            ApexPages.addMessage(erMsg);
            return null;
        }
        lmscons__Transcript_Line__c newAssign = new lmscons__Transcript_Line__c();
        newAssign.lmscons__Training_User_License__c = tempLicense.Id;
        newAssign.lmscons__Transcript__c = tempTranscript.Id;
        newAssign.lmscons__Training_Content__c = Module.Id;
        newAssign.lmscons__Quiz__c = quiz.Id;
        //newAssign.lmscons__Trainee__c = UserInfo.getUserId();
        insert newAssign;
        
        //return success
        ApexPages.Message scsMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Quiz assigned successfully');
        ApexPages.addMessage(scsMsg);
        return null;
    }
    
    public void AddPageBreak(){
        
        list<lmscons__Quiz_Question__c> lstQQ = [Select l.lmscons__Quiz__c, l.lmscons__Question__r.lmscons__Type__c, l.lmscons__Question__r.lmscons__Difficulty__c, 
                                                   l.lmscons__Question__r.CreatedById, l.lmscons__Question__r.Name, l.lmscons__Question__c, l.lmscons__Order__c 
                                                   From lmscons__Quiz_Question__c l where l.lmscons__Quiz__c=:quiz.id];
        
        //updated by JG (Appirio) on 3 March' 2015 for I-149972
        /*lmscons__Question__c objQues = [Select l.lmscons__Type__c, l.lmscons__Question__c, l.lmscons__Difficulty__c, l.Name, l.Id 
                        From lmscons__Question__c l WHERE l.Name = 'Page Break' limit 1];
        
        
        lmscons__Quiz_Question__c obj=new lmscons__Quiz_Question__c();
        obj.lmscons__Question__c=objQues.Id;*/
        
        list<lmscons__Question__c> lstObjQues = [Select l.lmscons__Type__c, l.lmscons__Question__c, l.lmscons__Difficulty__c, l.Name, l.Id 
                        From lmscons__Question__c l WHERE l.Name = 'Page Break' limit 1];
        lmscons__Quiz_Question__c obj=new lmscons__Quiz_Question__c();
        if(lstObjQues != null && lstObjQues.size()>0){
            obj.lmscons__Question__c=lstObjQues.get(0).Id;
        }else{
            lmscons__Question__c tempLQ = new lmscons__Question__c(Name = 'Page Break', lmscons__Type__c = 'Page Break');
            insert tempLQ;
            obj.lmscons__Question__c=tempLQ.Id;
        }
        obj.lmscons__Quiz__c=this.quiz.id;
        if(lstQQ != null && lstQQ.size()>0){
            obj.lmscons__Order__c=lstQQ.size()+1;
        }
        else{
            obj.lmscons__Order__c= 1;
        }
        
        insert obj;
    }

}