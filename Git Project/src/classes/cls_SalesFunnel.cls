public class cls_SalesFunnel 
{
    public List<Sale__c> lstSale {get;set;} 
    public static boolean inFutureContext = false;
    
     cls_SalesFunnel(List<Sale__c> lstSaleTemp)
     {
         lstSale =lstSaleTemp; 
         //CalculateSalesFunnel(lstSale);
         
     }
     @future(CallOut=false)
     public static void CalculateSalesFunnel(List<Id> lstSaleToComputeIds)
     {
           Map<Id,Sale__c> saleFiscalMap = new Map<Id,Sale__c>();
            Set<String> saleProductTypeSet = new Set<String>();
            Map<Id,Sale__c> mapSaleToUpdate = new map<Id,Sale__c>();
            
            List<Sale__c> lstSaleToCompute= [select Id,Name,Product_Type__c,Fiscal_Period__c,Territory__c from Sale__c where ID IN :lstSaleToComputeIds ];
            set<string> stTerritories = new set<string>();  
            system.debug('Gaurang :  got size of lstSaleTocompute' + lstSaleToCompute.size());
            for(Sale__c objSale : lstSaleToCompute)
            {
                saleFiscalMap.put(objSale.Id,objSale);
                if(objSale.Product_Type__c.contains('/')){
                    saleProductTypeSet.add(objSale.Product_Type__c);
                }
                if(stTerritories.contains(objSale.Territory__c+'%'))
                {
                    stTerritories.add(objSale.Territory__c+'%');
                }
            }
            
            /*Set<String> prodValue = new Set<String>();
            List<String> salesProductTypeList = new List<String>();
            salesProductTypeList.addAll(saleProductTypeSet) ;
            for(String str : saleProductTypeSet){
                for(String s : str.split('/')){
                    prodValue.add(s);
                }
            }*/
            
            Map<Id,Opportunity> opportunityMap;
            string strYear = string.valueof( Date.Today().Year());
            opportunityMap = new Map<Id,Opportunity>( [select Id,Name,AccountId,Probability,
                                                   Account.Territory__c,CloseDate,
                                                (select Id,Product_type__c,TotalPrice from OpportunityLineItems)
                                                 from Opportunity 
                                                 where IsClosed=false  ] );
            /*if(prodValue.size()>0){
                opportunityMap = new Map<Id,Opportunity>( [select Id,Name,AccountId,Probability,
                                                   Account.Territory__c,CloseDate,
                                                (select Id,Product_type__c,TotalPrice from OpportunityLineItems where Product_type__c in:prodValue)
                                                 from Opportunity 
                                                 where IsClosed=false] );
            }*/
           
            
            
            
            //Map<Id,String> strsaleFiscalMap = new Map<Id,String>();
            set<string> strFicslYear = new set<string>(); 
            for(Sale__c objSale : lstSaleToCompute)
            {
            
                string year = objSale.Fiscal_Period__c.substring(0,objSale.Fiscal_period__c.length()-2);
                
                if(! strFicslYear.contains(year))
                strFicslYear.add(year +'%' );
            }
            system.debug('strsaleFiscalMap :'+strFicslYear);
            
            /*
            
              Map<Id,Fiscal_Calendar__c> fiscalMap = new  Map<Id,Period>([SELECT Id,Name,Period_Start__c,Period_End__c  
                                                                FROM Fiscal_Calendar__c WHERE Id in:strsaleFiscalMap .values()]);
                                                                
            */
            
            //as per change request in Requirement dated 8th March 2014, 
            //we are going to consider only fiscal year not fiscal period 
            
            Map<Id,Period> fiscalMap = new  Map<Id,Period>([SELECT Id,StartDate,EndDate,PeriodLabel
                                                                FROM Period
                                                                 WHERE PeriodLabel LIKE :strFicslYear  ]);
            
            Map<Id,Period> salFiscalMap = new Map<Id,Period>();
            for(Sale__c sal : saleFiscalMap.values()){
                for(Period fiscal : fiscalMap.values()){
                    system.debug('Gaurang :  sal.Fiscal_Period__r.Name:'+sal.Fiscal_Period__c);
                    if(sal.Fiscal_Period__c == fiscal.PeriodLabel){
                        salFiscalMap.put(sal.Id,fiscal);
                    }
                }
            }
                
            
            List<Opportunity> finalOpportunityList = new List<Opportunity>();
            for(Sale__c objSale :lstSaleToCompute)
            {
            //       
             Decimal Risk_adjusted_value=0;      
             
                 for(Opportunity Opp: opportunityMap.values())
                 {
                     Period fc = salFiscalMap.get(objSale.Id);
                    system.debug('Fiscal :'+fc+ ' objSale:' +objSale + ' Opp:'+Opp );
                    if(fc != null && fc.Id!= null){
                        if(objSale.Fiscal_Period__c.substring(0,objSale.Fiscal_Period__c.length()-2) == fc.PeriodLabel.substring(0,fc.PeriodLabel.length()-2) && (  string.valueof( Opp.CloseDate.Year()) == objSale.Fiscal_Period__c.substring(0,objSale.Fiscal_Period__c.length()-2)   ) ){
                            for(OpportunityLineItem OppLineItem : Opp.OpportunityLineItems)
                            {
                                system.debug('we got territory'+ Opp.Account.Territory__c);                       
                                    system.debug('got list of saleProductTypeSet'+saleProductTypeSet);
                                    system.debug('Territory of Account'+Opp.Account.Territory__c + 'Territory of Sale'+ objSale.Territory__c);
                                        string[] arrProductType= objSale.Product_Type__c.split('/');
                                        if((OppLineItem.Product_Type__c == ObjSale.Product_Type__c )&& ( IsParentTerritory(objSale.Territory__c,Opp.Account.Territory__c )))
                                        {                        
                                            
                                            Risk_adjusted_value = Risk_adjusted_value +( OppLineItem.TotalPrice * Opp.Probability);
                                            finalOpportunityList.add(Opp);
                                            system.debug('we are in simple equalto condition'+ objSale.Product_type__c);
                                            system.debug('Opportun:'+Opp);
                                                                 
                                        }
                                        /*system.debug('got Product Type is'+ objSale.Product_Type__c );*/
                                        
                                      //  system.debug('got arraysize'+ arrProductType.size() + ' Product Type  after split'+ objSale.Product_Type__c);
                                        
                                        else if( arrProductType.size() > 1 )
                                        {
                                            system.debug('we are inside contains');
                                            
                                            for(string str : arrProductType)
                                            {
                                                  if((OppLineItem.Product_Type__c == str)  && (IsParentTerritory(objSale.Territory__c,Opp.Account.Territory__c )))
                                                 {
                                               // system.debug('Gaurang: we are in combine'+ ObjSale.Product_Type__c ); 
                                                Risk_adjusted_value = Risk_adjusted_value +( OppLineItem.TotalPrice * Opp.Probability);
                                                finalOpportunityList.add(Opp);
                                                system.debug('Opp sale with /:'+Opp);
                                                }
                                            
                                            }
                                        }
                                        else if( objSale.Product_type__c=='TOTAL'  && (IsParentTerritory(objSale.Territory__c,Opp.Account.Territory__c )) )
                                        {
                                            Risk_adjusted_value = Risk_adjusted_value +( OppLineItem.TotalPrice * Opp.Probability);
                                        }
                                        else if( objSale.Product_type__c=='DISPOSABLES'  && (IsParentTerritory(objSale.Territory__c,Opp.Account.Territory__c )) )
                                        {
                                            if(OppLineItem.Product_type__c != 'HSS')
                                            Risk_adjusted_value = Risk_adjusted_value +( OppLineItem.TotalPrice * Opp.Probability);
                                        }
                                       /*  else if((saleProductTypeSet != null) && saleProductTypeSet.contains(ObjSale.Product_Type__c) && (Opp.Account.Territory__c == objSale.Territory__c)){
                                            system.debug('Gaurang: we are in combine'+ ObjSale.Product_Type__c ); 
                                            Risk_adjusted_value = Risk_adjusted_value +( OppLineItem.TotalPrice * Opp.Probability);
                                            finalOpportunityList.add(Opp);
                                            system.debug('Opp sale with /:'+Opp);
                                        }*/ 
                                        
                                      /* else if(ObjSale.Product_Type__c =='TOTAL' && (Opp.Account.Territory__c == objSale.Territory__c)){
                                            Risk_adjusted_value = Risk_adjusted_value +( OppLineItem.TotalPrice * Opp.Probability);
                                            finalOpportunityList.add(Opp);
                                            system.debug('Opportun:'+Opp);
                                            system.debug('we are inside total block'+ObjSale.Product_Type__c);
                                        }*/ 
                                        //objSale.adderror('Opportunity Line Item ProductType ,Sales Product type and Account Territory and Sales Territory should be same');
                            }
                        }
                        //objSale.addError('Opportunity Close Date should be between Start Date and End Date of Fiscal 
                        //
                        //
                        //
                        //
                        //
                        //
                        //');
                          System.debug('Salesfunnel:'+Risk_adjusted_value);
                 objSale.SalesFunnel__c= Risk_adjusted_value/100;
                 mapSaleToUpdate .put(objSale.Id,objSale);
                    }
                 
               
                 }
                 
     
     }
     inFutureContext =true;
     update mapSaleToUpdate.values();
     UpdateBWIAdmin();
     }
     public static void UpdateBWIAdmin()
     {
        List<Sale__c> lstBWISale= [select Id,Name,Territory__c,Product_type__c from Sale__c where Territory__c='BWI Admin']; 
        List<Sale__c> lstAreaSale = [select Id,Name,Product_Type__c,SalesFunnel__c,Territory__c from Sale__c where IsArea__c=true and Territory__c!='BWI Admin' ];
        
        List<Sale__C> lstSaleToUpdate= new List<Sale__c>(); 
        
        for(Sale__c objBWISale : lstBWISale) 
        {
            Decimal Salesfunnel = 0; 
            system.debug('Gaurang: we are inside BWISAle'); 
            for(Sale__c objAreaSale : lstAreaSale) 
            {
                if(( objBWISale.Product_type__c == objAreaSale.Product_type__c)) 
                {
                     if(objAreaSale.Salesfunnel__c != null) 
                   Salesfunnel = Salesfunnel + objAreaSale.Salesfunnel__c;  
                    system.debug('Gaurang: we are inside AreaSale'+objAreaSale.Salesfunnel__c); 
                }
            }
            objBWISale.Salesfunnel__c= Salesfunnel; 
              system.debug('Gaurang: before updating salesfunel.'+ objBWISale.Salesfunnel__c); 
            lstSaleToUpdate.add(objBWISale); 
            
            
        }
        update lstBWISale; 
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