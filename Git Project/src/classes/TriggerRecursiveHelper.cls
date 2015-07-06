public with sharing class TriggerRecursiveHelper {

    private static boolean alreadyAffiliationTrigger = false;
    private static boolean alreadyAccountTrigger = false;

    public static boolean hasAlreadyExecutedTrigger(string TriggerName) {
               if (TriggerName=='Affiliation') 
            {
            return alreadyAffiliationTrigger ;
            }
        else
            {
                  return alreadyAccountTrigger;
            }
                }

    // By setting the variable to true, it maintains this  
    
    // new value throughout the duration of the request  
    
    // (or testMethod)  
    
    public static void setAlreadyExecuted(string TriggerName) {
        if (TriggerName=='Affiliation') 
            {
            alreadyAffiliationTrigger = True;
            alreadyAccountTrigger = True;
            }
        else
            {
            alreadyAffiliationTrigger = False;
            alreadyAccountTrigger = True;
            }                
    }


 }