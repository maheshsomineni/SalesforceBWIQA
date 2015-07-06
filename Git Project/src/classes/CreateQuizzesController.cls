public class CreateQuizzesController {

public String u {get; set;}
    public CreateQuizzesController(ApexPages.StandardSetController controller) {
        
 
        u = Userinfo.getUserEmail();
    }
    
    
    
    public PageReference executeBatchforQuizzes()
    {
        // Apex code for handling record from a Detail page goes here
        
        System.debug('Email is '+u);
        CFSBatchProcessQuizData b = New CFSBatchProcessQuizData(u);
    b.isFullLog = true; 
    Database.executeBatch(b);
      PageReference ReturnPage = new PageReference('/a0t?fcf=00BE0000004gwvN');
      ReturnPage.setRedirect(true);
      return ReturnPage;
    }

}