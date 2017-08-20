trigger trgPrimaryAccountUpdate on Account (after insert, after update) {
	set<ID> contIDs = new Set<ID>();
	Id PrimaccId;
	Id PrimconId;
	Contact[] updatedContacts = new List<Contact>();
	if(Trigger.isInsert || Trigger.isUnDelete) {
		for(Account a : System.Trigger.new){
				PrimaccId = a.Id;
				PrimconId = a.Primary_Contact__c;
				if(a.Primary_Contact__c <> NULL && a.Id == PrimaccId) {
					Contact c = new Contact(id = a.Primary_Contact__c,Membership_Contact__c = TRUE );
					updatedContacts.add(c);
			}	
		}
		if (updatedContacts.size()>0) {update updatedContacts;}
	}
}