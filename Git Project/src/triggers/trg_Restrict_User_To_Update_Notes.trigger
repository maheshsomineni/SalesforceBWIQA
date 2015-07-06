trigger trg_Restrict_User_To_Update_Notes on Note (before update) {

        
List<note> lstNote=[select parentId from Note limit 1];
string parentId='';
if( lstNote != null && lstNote.size() > 0 )
{
 parentId=lstNote[0].parentid;
 system.debug('parentId: @@@@@@@@@@@@@@@'+parentId);
}
string strObjectType= Utility.whichObject(parentId);
            system.debug('details from trigger: got object name'+ strObjectType);
            //string ProfileName = [select Name from profile where id = :userinfo.getProfileId()];
                Profile ProfileName = [select Name from profile where id = :userinfo.getProfileId()];
                system.debug('ProfileName: @@@@@@@@@@@@@@@'+ProfileName);
                if((strObjectType=='Opportunity') && (ProfileName.Name!='System Administrator' || ProfileName.Name != 'BWI Administrator'))
                {
                    
                    
                            for(Note objNote : Trigger.new)
                            {
                                objNote.adderror('You cannot edit notes.');
                                
                             } 
                            
                        
                    
                                    
                }
    
}