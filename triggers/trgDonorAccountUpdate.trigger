trigger trgDonorAccountUpdate on Account (after insert, after update) {
    set<ID> contIDs = new Set<ID>();
    Id PrimaccId;
    Id PrimconId;
    Contact[] updatedContacts = new List<Contact>();
    if(Trigger.isInsert || Trigger.isUnDelete) {
        for(Account a : System.Trigger.new){
                PrimaccId = a.Id;
                PrimconId = a.Donor_Contact__c;
                if(a.Donor_Contact__c <> NULL && a.Id == PrimaccId) {
                    Contact c = new Contact(id = a.Donor_Contact__c,Donor_Contact__c = TRUE );
                    updatedContacts.add(c);
            }   
        }
        if (updatedContacts.size()>0) {update updatedContacts;}
    }
}