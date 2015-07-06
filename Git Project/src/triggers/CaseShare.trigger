trigger CaseShare on case(after update,after insert) {
// if(trigger.isInsert){
List<caseShare> CreatorAccessList = new List<CaseShare>();
Map<Id,User> mapUser = new Map<Id,User>([Select id,name from User]);
for(case AR: trigger.new){
if((Trigger.isUpdate && Ar.OwnerId<>trigger.oldMap.get(AR.Id).OwnerId) || Trigger.IsInsert){
User u = mapUser.get(AR.Assigned_To__c);
System.debug('User is '+u);
caseShare creatorShare = new caseShare();
creatorshare.CaseId= AR.id;
creatorshare.userOrGroupID = AR.createdbyID;
creatorShare.CaseAccessLevel = 'Edit';


CreatorAccessList.add(CreatorShare);

if(Ar.id!=u.id)
{
  caseShare EndUserShare = new caseShare();
  EndUserShare.CaseId= AR.id;
  EndUserShare.userOrGroupID =  u.id;
  EndUserShare.CaseAccessLevel = 'Edit';
  
  CreatorAccessList.add(EndUserShare);
}
}
}

Database.SaveResult[] AssistRequestShareInsertResult = Database.insert(CreatorAccessList,False);


// }

}