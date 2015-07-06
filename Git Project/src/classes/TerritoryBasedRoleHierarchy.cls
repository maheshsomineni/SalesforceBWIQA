// Territory Based Role Hierarchy
public class TerritoryBasedRoleHierarchy
{
    @Future
    public static void insertRolesBasedOnTerritory()
    {
         List<Territory> territoryList = [SELECT Id,Name,DeveloperName,External_Territory_Id__c FROM TERRITORY];
         List<UserRole> insertAreaRoles = new List<UserRole>();
         List<UserRole> userParentRoleforAD = [SELECT Id,ParentRoleId,DeveloperName FROM USERROLE];
         Map<String,UserRole> mapUserRolesBWIAdmin = new Map<String,UserRole>();
         for(UserRole urforAD : userParentRoleforAD)
         {
               mapUserRolesBWIAdmin.put(urforAD.DeveloperName,urforAD);
         }
         
         for(Territory terr : territoryList)
         {
             string[] splitTerritory = terr.External_Territory_Id__c.split('_');
             if(splitTerritory.size()==1 && terr.External_Territory_Id__c!='BWI Admin')
             {
                 UserRole assignRole = new UserRole();
                 UserRole parentRole = mapUserRolesBWIAdmin.get('BWI_Administrator');
                 assignRole.Name = 'Area Director of '+terr.Name;
                 if(parentRole!=null)
                 {
                    assignRole.ParentRoleId = parentRole.Id; 
                 }                
                 assignRole.DeveloperName = terr.External_Territory_Id__c;
                 insertAreaRoles.add(assignRole);
             }
         }
         
         insert insertAreaRoles;
         
         List<UserRole> userRolesforRegion = [SELECT Id,ParentRoleId,DeveloperName FROM USERROLE];
         Map<String,UserRole> mapUserRoles = new Map<String,UserRole>();
         for(UserRole ur : userRolesforRegion)
         {
               mapUserRoles.put(ur.DeveloperName,ur);
         }
         
         List<UserRole> insertRegionRoles = new List<UserRole>();
         
         for(Territory terr : territoryList)
         {
             string[] splitTerritory = terr.External_Territory_Id__c.split('_');
             if(splitTerritory.size()==2)
             {
                 UserRole assignRole = new UserRole();
                 UserRole parentRole = mapUserRoles.get(splitTerritory[0]);
                 assignRole.Name = 'Regional Business Director of '+terr.Name;
                 assignRole.DeveloperName = terr.External_Territory_Id__c;
                 assignRole.ParentRoleId = parentRole.Id;
                 
                 insertRegionRoles.add(assignRole);
             }
         }
         
         insert insertRegionRoles;
         
          List<UserRole> userRolesforTerritory = [SELECT Id,ParentRoleId,DeveloperName FROM USERROLE];
         Map<String,UserRole> mapUserRolesforTerritory = new Map<String,UserRole>();
         for(UserRole urt : userRolesforTerritory)
         {
               mapUserRolesforTerritory.put(urt.DeveloperName,urt);
         }
        
        List<UserRole> insertTerritoryRoles = new List<UserRole>();
         
         for(Territory terr : territoryList)
         {
             string[] splitTerritory = terr.External_Territory_Id__c.split('_');
             if(splitTerritory.size()==3)
             {
                 UserRole assignRole = new UserRole();
                 System.debug('split territory '+splitTerritory[0]+'_'+splitTerritory[1]);
                 UserRole parentRole = mapUserRolesforTerritory.get(splitTerritory[0]+'_'+splitTerritory[1]);
                 System.debug('Parent Role for TM '+parentRole);
                 assignRole.Name = 'Territory Manager of '+terr.name;
                // if(parentRole!=null)
                // {
                     assignRole.ParentRoleId = parentRole.Id;
                // }                 
                 assignRole.DeveloperName = 'TM_'+terr.External_Territory_Id__c;
                 insertTerritoryRoles.add(assignRole);
             }
         }
        
        insert insertTerritoryRoles;
        
/*        List<UserRole> userRolesforCAS = [SELECT Id,ParentRoleId,DeveloperName FROM USERROLE];
         Map<String,UserRole> mapUserRolesforCAS = new Map<String,UserRole>();
         for(UserRole urt : userRolesforCAS)
         {
               mapUserRolesforCAS.put(urt.DeveloperName,urt);
       }
*/        
        Map<Id,Profile> mapProfile = new Map<Id,Profile>( [select Id,Name from Profile ]);
        List<user> usersList = [SELECT Id,Name,UserRoleID,ProfileID,Department from USER];
        List<UserRole> listRoles = [SELECT Id,ParentRoleId,DeveloperName FROM USERROLE];
        Map<String,UserRole> mapRoleList = new Map<String,UserRole>();
        for(UserRole ur : listRoles)
        {
            mapRoleList.put(ur.DeveloperName, ur);            
        }
        
        List<User> updateUsers = new List<User>();
        for(User u:usersList)
        {
            Profile p = mapProfile.get(u.ProfileId);
            if(p!=null)
            {
              if(p.Name == 'BWI Administrator'|| p.Name == 'Sales Operations'|| p.Name == 'BWI Marketing User')
            	{
                	if(u.Department!=null && u.Department!='')
                    {
                        UserRole ur = mapRoleList.get('BWI_Administrator');
                        if(ur!=null)
                        {
                        	u.UserRoleId = ur.Id;
                            updateUsers.add(u);
                        }
                        
                    }
            	}  
                else if(p.Name == 'Area Director')
                {
                    if(u.Department!=null && u.Department!='')
                    {
                        UserRole ur = mapRoleList.get(u.Department);
                        if(ur!=null)
                        {
                            u.UserRoleId = ur.Id;
                            updateUsers.add(u);
                        }
                    }
                }
                else if(p.Name == 'Regional Business Director')
                {
                    if(u.Department!=null && u.Department!='')
                    {
                        UserRole ur = mapRoleList.get(u.Department);
                        if(ur!=null)
                        {
                            u.UserRoleId = ur.Id;
                            updateUsers.add(u);
                        }
                    }
                }
                else if(p.Name == 'Territory Manager')
                {
                    if(u.Department!=null && u.Department!='')
                    {
                        UserRole ur = mapRoleList.get('TM_'+u.Department);
                        if(ur!=null)
                        {
                            u.UserRoleId = ur.Id;
                            updateUsers.add(u);
                        }
                    }
                }
                
            }
            
        }
        
        update updateUsers;
    }
}