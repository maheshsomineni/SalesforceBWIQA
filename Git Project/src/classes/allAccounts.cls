public with sharing class allAccounts {

    List<Account> allAccount = new List<Account>();

public allAccounts()
{
  allAccount = [SELECT Id FROM Account];
}

public List<Account> acc()
{
  return allAccount;
}
}