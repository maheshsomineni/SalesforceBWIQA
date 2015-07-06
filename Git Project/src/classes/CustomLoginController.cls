/**
*   An apex page controller that exposes the site login functionality
*/
global with sharing class CustomLoginController {
    global String username{get;set;}
    global String password{get;set;}

    global CustomLoginController () {}
    global PageReference forwardToCustomAuthPage() {
        return new PageReference( '/CustomLogin');
    }
    global PageReference login() {
        return Site.login(username, password, null);
    }
    
    public Boolean pageHasMessages {
        get {return ApexPages.hasMessages();}
    }
    
    public String severity {
        get {
            String type = '';

            for (ApexPages.Message msg : ApexPages.getMessages()) {
                type = String.valueOf(msg.getSeverity()).toLowerCase();
                break;
            }
            return type;
        }
        set;
     }
    
}