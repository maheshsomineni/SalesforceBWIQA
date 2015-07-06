global class cls_SalesfunnelScheduler implements Schedulable {
     global void execute(SchedulableContext ScMain)
     {
       
       string query='select Id,Name,Account.Territory__c,Risk_Adjusted_Opportunity_del__c ,Probability,(select Id,Product_Type__c,TotalPrice  from OpportunityLineItems where Product_Type__c!=null  ) from Opportunity  where (closedate = this_fiscal_year and isclosed=false ) or (isclosed = true and closedate >= last_n_days:30 and closedate = this_fiscal_year)';
       Id batchInstanceId = Database.executeBatch(new cls_SalesFunnelBatchable (query), 10); 
          
     }
}