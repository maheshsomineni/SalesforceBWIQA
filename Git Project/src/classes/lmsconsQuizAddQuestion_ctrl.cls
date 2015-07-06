public with sharing class lmsconsQuizAddQuestion_ctrl {
    
    public String SearchParameter{get;set;}
    public boolean noerrors{get;set;}
    public boolean showTable{get;set;}
    public list<WrapperClass> qList{get;set;}
    Public Integer numberOfRecords{get; set;}
    Public Integer pageSize{get; set;}
   // Public Integer size{get;set;}
    public ApexPages.StandardSetController setCon {get;set;}
    String Quizid {get;set;}
    set<String> prevQuestions = new set<String>();
    set<String> qQIds = new set<String>();
    public lmsconsQuizAddQuestion_ctrl(){
        Quizid = ApexPages.currentPage().getParameters().get('id');
        qList = new list<WrapperClass>();
        list<lmscons__Quiz_Question__c> tmpQList = new list<lmscons__Quiz_Question__c>();
        list<lmscons__Question__c> tmpQuesList = new list<lmscons__Question__c>();
        tmpQList = [Select l.lmscons__Quiz__c, l.lmscons__Question__r.lmscons__Type__c, l.lmscons__Question__r.lmscons__Difficulty__c, 
                l.lmscons__Question__r.CreatedById, l.lmscons__Question__r.Name, l.lmscons__Question__c, l.lmscons__Order__c 
                From lmscons__Quiz_Question__c l where l.lmscons__Quiz__c=:Quizid];
                
        
        for(lmscons__Quiz_Question__c qQ : tmpQList){
            //if(qQ.lmscons__Question__r.Name.equalsignorecase('test quest 444444')){
                prevQuestions.add(qQ.lmscons__Question__r.Name);
                qQIds.add(qQ.lmscons__Question__c);
            //}
        }       
        system.debug('==prevQuestions=='+prevQuestions);
        system.debug('==Quizid=='+qQIds);
    //  tmpQList = [Select l.lmscons__Quiz__c, l.lmscons__Question__r.lmscons__Type__c, l.lmscons__Question__r.lmscons__Difficulty__c, 
        //      l.lmscons__Question__r.CreatedById, l.lmscons__Question__r.Name, l.lmscons__Question__c, l.lmscons__Order__c 
        //      From lmscons__Quiz_Question__c l where l.lmscons__Quiz__c!=:Quizid AND l.lmscons__Question__r.Name NOT IN :prevQuestions];//AND l.lmscons__Question__r.Name NOT IN :prevQuestions
                
        tmpQuesList = [Select l.lmscons__Type__c, l.lmscons__Question__c, l.lmscons__Difficulty__c, l.Name, l.Id 
                        From lmscons__Question__c l WHERE l.Id NOT IN :qQIds];
                
        pageSize = 10;
        
    //  if(tmpQList.size()>0){
        //  showTable = true;
        //  setCon = new ApexPages.StandardSetController(tmpQList);
    //      for(lmscons__Quiz_Question__c qQ : (List<lmscons__Quiz_Question__c>)setCon.getRecords()){
    //          qList.add(new WrapperClass(false,qQ));
    //      }
    //  }   
        
        fillStandardSetController(tmpQuesList); 
        
    }
    
    public void fillStandardSetController(list<lmscons__Question__c> tmpQuesList){
        if(tmpQuesList.size()>0){
            showTable = true;
            setCon = new ApexPages.StandardSetController(tmpQuesList);
            lmscons__Quiz_Question__c qQc;
            for(lmscons__Question__c qQ : (List<lmscons__Question__c>)setCon.getRecords()){
                qQc = new lmscons__Quiz_Question__c();
                qQc.lmscons__Question__c = qQ.Id;
                qList.add(new WrapperClass(false,qQ,qQc));
            }
        }
        else{
            showTable = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'There are no questions to add.'));
            //updated by JG (Appirio) on 3 March' 2015 for I-149972
            return;
        }   
        system.debug('==tmpQuesList=='+tmpQuesList);
        setCon.setPageSize(pageSize);
        numberOfRecords = setCon.getResultSize();
    }
    
    public Boolean hasNext {
        get {
            return setCon.getHasNext();
        }
        set;
    }
    public Boolean hasPrevious {
        get {
            return setCon.getHasPrevious();
        }
        set;
    }
  
    public Integer pageNumber {
        get {
            return setCon.getPageNumber();
        }
        set;
    }
  
    public void first() {
        setCon.first();
    }
  
    public void last() {
        setCon.last();
    }
  
    public void previous() {
        setCon.previous();
        qList.clear();
        
        lmscons__Quiz_Question__c qQc;
        for(lmscons__Question__c qQ : (List<lmscons__Question__c>)setCon.getRecords()){
            qQc = new lmscons__Quiz_Question__c();
            qQc.lmscons__Question__c = qQ.Id;
            qList.add(new WrapperClass(false,qQ,qQc));
        }
    }
  
    public void next() {
        setCon.next();
        qList.clear();
        lmscons__Quiz_Question__c qQc;
        for(lmscons__Question__c qQ : (List<lmscons__Question__c>)setCon.getRecords()){
            qQc = new lmscons__Quiz_Question__c();
            qQc.lmscons__Question__c = qQ.Id;
            qList.add(new WrapperClass(false,qQ,qQc));
        }
    }

    public void searchByString(){
         qList.clear();
        list<lmscons__Question__c> tmpQuesList = new list<lmscons__Question__c>();
        String searchString='%'+SearchParameter+'%';
        
        tmpQuesList = [Select l.lmscons__Type__c, l.lmscons__Question__c, l.lmscons__Difficulty__c, l.Name, l.Id 
                        From lmscons__Question__c l WHERE l.Id NOT IN :qQIds AND l.Name like: searchString];
        
        //tmpQList = [Select l.lmscons__Quiz__c, l.lmscons__Question__r.lmscons__Type__c, l.lmscons__Question__r.lmscons__Difficulty__c, 
        //         l.lmscons__Question__r.CreatedById, l.lmscons__Question__r.Name, l.lmscons__Question__c, l.lmscons__Order__c 
        //         From lmscons__Quiz_Question__c l where l.lmscons__Question__r.Name like: searchString AND l.lmscons__Quiz__c!=:Quizid ];//AND l.lmscons__Question__c NOT IN :prevQuestions
        system.debug('==searchString=='+searchString);
        system.debug('==Quizid=='+Quizid);
        fillStandardSetController(tmpQuesList); 
    }
    
    public void AddQuestions(){
        list<lmscons__Quiz_Question__c> lstQQ=new list<lmscons__Quiz_Question__c>();
         for(WrapperClass wc : qList){
            if(wc.checked){
                wc.qqc.lmscons__Quiz__c = Quizid;
                lstQQ.add(wc.qqc);
            }
        }
        try{
            if(lstQQ.size()>0){
                insert lstQQ;
                noerrors = true;
            }
        }
        catch(Exception e){
            noerrors = false;
        }
    }
    
    public class WrapperClass{
        public boolean checked{get;set;}
        public lmscons__Quiz_Question__c qqc{get;set;}
        public lmscons__Question__c qc{get;set;}
        
        public WrapperClass(boolean checked,lmscons__Question__c qc,lmscons__Quiz_Question__c qqc){
            this.checked = checked;
            this.qc = qc;
            this.qqc = qqc;
        }
    }
}