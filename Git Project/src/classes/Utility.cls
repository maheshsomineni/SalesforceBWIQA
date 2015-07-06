public with sharing class Utility {
	public static string whichObject(string parentId) {
        string keyPrefix = parentId.substring(0, 3);
		string result= '';
        if(keyPrefix == '006')          
           result= 'Opportunity';
           
           return result;
           
           
        
        
    }
	

}