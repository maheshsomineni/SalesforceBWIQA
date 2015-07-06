public class retainValues
{
  public static string retainPicklistValues(String Cid)
  {
    String tech = '';
    List<Call__c> retainValuesinCall = [select Id,BWI_Ablation_Catheter__c,Other_BWI_Catheter__c,Competetive_Products__c,Technology_Type__c from Call__c where id =: Cid ];
    String techTypes = retainValuesinCall[0].Technology_Type__c;
    List<Product2> prodList = [Select id,name from Product2 where name like:techTypes and isactive=false];
    
    if(!prodList.isempty())
    {
      for(Product2 p : prodList)
    {
      tech = tech+p.Name;
    }
    }
    return tech;
  }
}