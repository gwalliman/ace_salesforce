trigger UpdateLastRegistrationDate on Opportunity (after delete, after insert, after update, after undelete) {
	set<ID> contIDs = new Set<ID>();
	
	if(Trigger.isInsert || Trigger.isUnDelete) {
		for(Opportunity o : System.Trigger.new){
				if(o.RecordTypeId == '01280000000FPjx' || o.RecordTypeId =='01280000000UBV6') {contIDs.add(o.Contact__c);}
				contIDs.add(o.Contact__c);
					
			}
	
		Contact[] conts = new List<Contact>();
		conts = [select Id, (select CloseDate from Opportunities2__r where (RecordType.Name = 'Program Registration' OR RecordType.Name = 'Task Force Registration Individual')  AND IsWon = TRUE order by CloseDate Desc limit 1 ) from Contact where ID in :contIDs ];
	
		Opportunity[] os = new List<Opportunity>(); 
		Map<Id, Opportunity[]> contopp = new Map<Id, Opportunity[]>();
		for (Contact eachCont: conts){
			contopp.put(eachCont.Id, eachCont.Opportunities2__r);
			 }
		Contact[] updatedContacts = new List<Contact>();
		Opportunity[] opps = new List<Opportunity>();
		for (Contact c : conts ){
				opps=contopp.get(c.Id);
				for(Opportunity opty : opps) {
					c.Last_Registration_Date__c=opty.CloseDate; }
				updatedContacts.add(c);
		
		}	
		if (updatedContacts.size()>0) {update updatedContacts;}
	
	}	
	if(Trigger.isDelete || Trigger.isUpdate) {
		for(Opportunity o : System.Trigger.old){
				if(o.RecordTypeId == '01280000000FPjx' || o.RecordTypeId =='01280000000UBV6') {contIDs.add(o.Contact__c);}	
				contIDs.add(o.Contact__c);
			}
	
		Contact[] conts = new List<Contact>();
		conts = [select Id, (select CloseDate from Opportunities2__r where (RecordType.Name = 'Program Registration' OR RecordType.Name = 'Task Force Registration Individual')  AND IsWon = TRUE order by CloseDate Desc limit 1 ) from Contact where ID in :contIDs ];
	
		Opportunity[] os = new List<Opportunity>(); 
		Map<Id, Opportunity[]> contopp = new Map<Id, Opportunity[]>();
		for (Contact eachCont: conts){
			contopp.put(eachCont.Id, eachCont.Opportunities2__r);
			 }
		Contact[] updatedContacts = new List<Contact>();
		Opportunity[] opps = new List<Opportunity>();
		for (Contact c : conts ){
				opps=contopp.get(c.Id);
				if(opps.size()==0){
					c.Last_Registration_Date__c=NULL;
				}
				for(Opportunity opty : opps) {
					c.Last_Registration_Date__c=opty.CloseDate;}
				updatedContacts.add(c);
		
		}	
		if (updatedContacts.size()>0) {update updatedContacts;}	
	}
	
}