/*
* Modified By: 
* Modified On: 08/06/2009
* Purpose: Whenever Donor contact is selected in contact then it should be reflected in the contact object itself
*/

trigger trgDonContactUpdate on Account (before Update) {

    Set<Id> contIdsSet = new Set<Id>();
    Set<Id> contactIdSet = new Set<Id>();
    
    //Code Section to uncheck the donor contact if 
    //the donor contact on the account is blanked out
    
    Set<Id> ContactsToUncheck = new Set<Id>();
    Set<Id> ContactsToCheck = new Set<Id>();
    
    For( Integer i=0 ; i<Trigger.New.size() ; i++ )
    {
        If(Trigger.New[i].Update_Donor_Contact__c != 'Path2')
        {
            If(Trigger.Old[i].Donor_Contact__c != Null && Trigger.New[i].Donor_Contact__c == Null)
                ContactsToUncheck.add(Trigger.Old[i].Donor_Contact__c);
                
            If(Trigger.New[i].Donor_Contact__c != Null && Trigger.Old[i].Donor_Contact__c == Null)
                ContactsToCheck.add(Trigger.New[i].Donor_Contact__c);
                
            If(Trigger.Old[i].Donor_Contact__c != Null && Trigger.New[i].Donor_Contact__c != Null)
            {
                If(Trigger.Old[i].Donor_Contact__c != Trigger.New[i].Donor_Contact__c)
                {
                    ContactsToUncheck.add(Trigger.Old[i].Donor_Contact__c);
                    ContactsToCheck.add(Trigger.New[i].Donor_Contact__c);
                }
            }
        }
        Else
        {
            Trigger.New[i].Update_Donor_Contact__c = '';
        }
    }
    
    If(ContactsToUncheck.Size() > 0)
    {
        List<Contact> ContactListToUncheck = New List<Contact>();
        
        For(Contact Cont: [Select Id, Donor_Contact__c from Contact where Id in :ContactsToUncheck])
        {
            Cont.Donor_Contact__c = False;
            Cont.Update_Donor_Contact__c = 'Path1';
            ContactListToUncheck.add(Cont);
        }
        
        If(ContactListToUncheck.size() > 0)
            Update ContactListToUncheck;
    }
    
    If(ContactsToCheck.Size() > 0)
    {
        List<Contact> ContactListToCheck = New List<Contact>();
        
        For(Contact Cont: [Select Id, Donor_Contact__c from Contact where Id in :ContactsToCheck])
        {
            Cont.Donor_Contact__c = True;
            Cont.Update_Donor_Contact__c = 'Path1';
            ContactListToCheck.add(Cont);
        }
        
        If(ContactListToCheck.size() > 0)
            Update ContactListToCheck;
    }

}