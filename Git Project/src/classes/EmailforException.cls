public class EmailforException extends Exception{

public static void notifyDevelopersOf(Exception e, String locationName) {
    String orgId = UserInfo.getOrganizationId();
    String orgName = UserInfo.getOrganizationName();
    String user = UserInfo.getUserName();
    String message = e.getMessage();
    String stacktrace = e.getStackTraceString();
    String exType = '' + e.getTypeName();
    String line = '' + e.getLineNumber();
    String theTime = '' + System.now();

    String subject = String.format('Exception thrown at {0} by user {1} in org {2} (Id: {3})', new List<String>{ locationName, user, orgName, orgId });
    String body = String.format('Time: {0}\nMessage: {1}\nStacktrace: {2}\nLine: {3}', new List<String>{ theTime, message, stacktrace, line });

    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    String[] toAddresses = new String[] {'mahesh.somineni@cognizant.com','gaurang.daslania@cognizant.com','dgaurang32@gmail.com','naidumahesh5@gmail.com'};
    mail.setToAddresses(toAddresses);
    mail.setSubject(subject);
    mail.setUseSignature(false);
    mail.setPlainTextBody(body);

    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
}





}