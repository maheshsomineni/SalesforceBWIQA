trigger SendEmailonTaskCompletion on Task (before update)
 {
    SendEmailonTaskStatusChange.sendEmailOnChangeOfStatus(Trigger.new,Trigger.oldMap);
 }