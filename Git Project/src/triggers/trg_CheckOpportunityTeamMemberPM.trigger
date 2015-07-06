trigger trg_CheckOpportunityTeamMemberPM on OpportunityTeamMember (before update,before insert) {

    
    
    User objUser= [select Id,Name,Department from User where Id=:UserInfo.GetUserID()];
    string CurrentUserDepartment = ''; 
    if(objUser.Department != null)
    {
        CurrentUserDepartment = objUser.Department; 
        system.debug('got department' + CurrentUserDepartment );
    }
       
           for(OpportunityTeamMember oppTeamMember : Trigger.New )
           {
               
               //If current user's department is null, then we will allow TM to add that team member
               User TeamMember  = [select Id,Name,Department from user where Id=:oppTeamMember.UserID ];
               
               if(TeamMember.Department != null)
               {
                   
                    if(! IsParentTerritory(CurrentUserDepartment ,TeamMember.Department )  )
                  {
                      oppTeamMember.adderror('You can select team members from your primary territory only.');
                  }
               
               
                   /*if( CurrentUserDepartment  !=TeamMember.Department  )
                  {
                      oppTeamMember.adderror('You can select team members from your primary territory only.');
                  }*/
               }
               
              
           }
       
       
   
public static boolean IsParentTerritory(string SaleTerritory,string OppTerritory)
            {
                boolean result= false;
                string[] arrSale = SaleTerritory.split('_'); 
                string[] arrOpp = OppTerritory.split('_');
                if (SaleTerritory == OppTerritory) 
                {
                    result = true;
                }
                else if(arrSale.size()>1 && arrOpp.size()>2) 
                {
                   if((arrSale[0]== arrOpp[0]) &&( arrSale[1] == arrOpp[1])     )
                   {
                       if(arrSale.size()== 2)
                       result=true;
                       
                   }
                   
                }
                else if(arrSale.size()==1 && arrOpp.size()>2)
                {
                    if(arrSale[0]== arrOpp[0])
                    {
                        result = true;
                    }
                }
                return result;
            }
    


}