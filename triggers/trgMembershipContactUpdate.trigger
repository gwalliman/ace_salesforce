/*
* Modified By: 
* Modified On: 08/06/2009
* Purpose: Whenever Membership contact is selected in contact then it should be reflected in the account object itself
*/

trigger trgMembershipContactUpdate on Contact (after Insert, before Update) {

    Set<Id> acctIdSet = new Set<Id>();
    Set<Id> AccountIdsToFill = new Set<Id>();
    
    //Code Section to blank out the membership contact on the account
    //if the contact that was marked membership is no longer marked membership
                
    If(Trigger.IsUpdate)
    {
        Set<Id> AccountIdsToNull = new Set<Id>();

        
        For( Integer i=0 ; i<Trigger.New.size() ; i++ )
        {
            If(Trigger.Old[i].Membership_Contact__c == True && Trigger.New[i].Membership_Contact__c == False && Trigger.New[i].Update_Membership_Contact__c != 'Path1')
                If(Trigger.New[i].AccountId != Null)
                    AccountIdsToNull.add(Trigger.New[i].AccountId);
            If(Trigger.New[i].Membership_Contact__c == True && Trigger.Old[i].Membership_Contact__c == False && Trigger.New[i].Update_Membership_Contact__c != 'Path1')
                If(Trigger.New[i].AccountId != Null)
                    AccountIdsToFill.add(Trigger.New[i].AccountId);
        }
        
        If(AccountIdsToNull.Size() > 0)
        {
            List<Account> AccountListToNull = New List<Account>();
            
            For(Account Acc: [Select Id, Membership_Contact__c from Account where Id in :AccountIdsToNull])
            {
                Acc.Membership_Contact__c = Null;
                Acc.Update_Membership_Contact__c = 'Path2';
                AccountListToNull.add(Acc);
            }
            
            If(AccountListToNull.size() > 0)
                Update AccountListToNull;
        }

    }
    
    If(Trigger.IsUpdate)
    For( Integer i=0 ; i<Trigger.New.size() ; i++ )
    {
        If(Trigger.New[i].Membership_Contact__c == True && Trigger.Old[i].Membership_Contact__c == False && Trigger.New[i].Update_Membership_Contact__c != 'Path1')
            If(Trigger.New[i].AccountId != Null)
                AccountIdsToFill.add(Trigger.New[i].AccountId);
    }
    
    If(Trigger.IsInsert)
    For( Integer i=0 ; i<Trigger.New.size() ; i++ )
    {
        If(Trigger.New[i].Membership_Contact__c == True && Trigger.New[i].Update_Membership_Contact__c != 'Path1')
            If(Trigger.New[i].AccountId != Null)
                AccountIdsToFill.add(Trigger.New[i].AccountId);
    }
    
    If(Trigger.IsUpdate)
        For(Contact Cont: Trigger.New)
        {
            Cont.Update_Membership_Contact__c = '';    
        }
    
    //Code to query all the Membership contacts of the Accounts
    Set<Id> tempAcctIdSet = new Set<Id>();
    Set<Id> ErrorAcctIdSet = new Set<Id>();
    
    If(AccountIdsToFill.Size() > 0)
    {
        For(Contact Cont : [Select Id, AccountId, Membership_Contact__c from Contact where AccountId in :AccountIdsToFill and Membership_Contact__c = True and Id not in :Trigger.New])
        {
            If(AccountIdsToFill.contains(Cont.AccountId))
            {
                ErrorAcctIdSet.add(Cont.AccountId);
                AccountIdsToFill.remove(Cont.AccountId);
            }
        }
    
    
        //Showing error when 2 contacts are marked as membership
        Map<Id, Id> AcctContactMap = new Map<Id, Id>();
        
        For(Contact Cont: Trigger.New)
        {
            If(ErrorAcctIdSet.contains(Cont.AccountId))
            {
                Cont.Membership_Contact__c.addError('This Contact cannot be marked as membership because there already is another membership contact for this organization. Uncheck the other membership contact first.');
            }
            Else If(AccountIdsToFill.contains(Cont.AccountId))
            {
                AcctContactMap.put(Cont.AccountId, Cont.Id);
            }
        }
        
        //Updating all the valid values to the Membership contact field on the account
        
        List<Account> AccountList = New List<Account>();
        
        For(Account Acc: [Select Id, Membership_Contact__c, Update_Membership_Contact__c from Account where Id in :AcctContactMap.keyset()])
        {
            Acc.Membership_Contact__c = AcctContactMap.get(Acc.Id);
            Acc.Update_Membership_Contact__c = 'Path2';
            AccountList.add(Acc);
        }
        
        If(AccountList.size() > 0)
            {Update AccountList;}
    }   
   
    

}