trigger trg_DefaultProiceZeroWhileClone on Opportunity (before insert) {

  for(Opportunity objOpp : Trigger.New) 
  {    
      if(objOpp.OpportunityLineItems.size() <= 0)
      {    
          objOpp.Amount=0;
      }
  }


}