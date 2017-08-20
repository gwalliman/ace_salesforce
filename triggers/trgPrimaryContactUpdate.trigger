trigger trgPrimaryContactUpdate on Contact (after Insert, before Update) {

    Set<Id> acctIdSet = new Set<Id>();
    Set<Id> AccountIdsToFill = new Set<Id>();
    
    //Code Section to blank out the primary contact on the account
    //if the contact that was marked primary is no longer marked primary
                
    If(Trigger.IsUpdate)
    {
        Set<Id> AccountIdsToNull = new Set<Id>();

        
        For( Integer i=0 ; i<Trigger.New.size() ; i++ )
        {
            If(Trigger.Old[i].Primary_Contact__c == True && Trigger.New[i].Primary_Contact__c == False && Trigger.New[i].TempText__c != 'Path1')
                If(Trigger.New[i].AccountId != Null)
                    AccountIdsToNull.add(Trigger.New[i].AccountId);
            If(Trigger.New[i].Primary_Contact__c == True && Trigger.Old[i].Primary_Contact__c == False && Trigger.New[i].TempText__c != 'Path1')
                If(Trigger.New[i].AccountId != Null)
                    AccountIdsToFill.add(Trigger.New[i].AccountId);
        }
        
        If(AccountIdsToNull.Size() > 0)
        {
            List<Account> AccountListToNull = New List<Account>();
            
            For(Account Acc: [Select Id, Primary_Contact__c from Account where Id in :AccountIdsToNull])
            {
                Acc.Primary_Contact__c = Null;
                Acc.TempText__c = 'Path2';
                AccountListToNull.add(Acc);
            }
            
            If(AccountListToNull.size() > 0)
                Update AccountListToNull;
        }

    }
    
    If(Trigger.IsUpdate)
    For( Integer i=0 ; i<Trigger.New.size() ; i++ )
    {
        If(Trigger.New[i].Primary_Contact__c == True && Trigger.Old[i].Primary_Contact__c == False && Trigger.New[i].TempText__c != 'Path1')
            If(Trigger.New[i].AccountId != Null)
                AccountIdsToFill.add(Trigger.New[i].AccountId);
    }
    
    If(Trigger.IsInsert)
    For( Integer i=0 ; i<Trigger.New.size() ; i++ )
    {
        If(Trigger.New[i].Primary_Contact__c == True && Trigger.New[i].TempText__c != 'Path1')
            If(Trigger.New[i].AccountId != Null)
                AccountIdsToFill.add(Trigger.New[i].AccountId);
    }
    
    If(Trigger.IsUpdate)
        For(Contact Cont: Trigger.New)
        {
            Cont.TempText__c = '';    
        }
    
    //Code to query all the Primary contacts of the Accounts
    Set<Id> tempAcctIdSet = new Set<Id>();
    Set<Id> ErrorAcctIdSet = new Set<Id>();
    
    If(AccountIdsToFill.Size() > 0)
    {
        For(Contact Cont : [Select Id, AccountId, Primary_Contact__c from Contact where AccountId in :AccountIdsToFill and Primary_Contact__c = True and Id not in :Trigger.New])
        {
            If(AccountIdsToFill.contains(Cont.AccountId))
            {
                ErrorAcctIdSet.add(Cont.AccountId);
                AccountIdsToFill.remove(Cont.AccountId);
            }
        }
    
    
        //Showing error when 2 contacts are marked as primary
        Map<Id, Id> AcctContactMap = new Map<Id, Id>();
        
        For(Contact Cont: Trigger.New)
        {
            If(ErrorAcctIdSet.contains(Cont.AccountId))
            {
                Cont.Primary_Contact__c.addError('This Contact cannot be marked as primary because there already is another primary contact for this organization. Uncheck the other primary contact first.');
            }
            Else If(AccountIdsToFill.contains(Cont.AccountId))
            {
                AcctContactMap.put(Cont.AccountId, Cont.Id);
            }
        }
        
        //Updating all the valid values to the Primary contact field on the account
        
        List<Account> AccountList = New List<Account>();
        
        For(Account Acc: [Select Id, Primary_Contact__c, TempText__c from Account where Id in :AcctContactMap.keyset()])
        {
            Acc.Primary_Contact__c = AcctContactMap.get(Acc.Id);
            Acc.TempText__c = 'Path2';
            AccountList.add(Acc);
        }
        
        If(AccountList.size() > 0)
            {Update AccountList;}
    }   
   
    

}