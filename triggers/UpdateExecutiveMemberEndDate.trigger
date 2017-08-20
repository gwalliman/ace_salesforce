trigger UpdateExecutiveMemberEndDate on Opportunity (after delete, after insert, after update, after undelete) {
	set<ID> contIDs = new Set<ID>();
	RecordType rt = [Select Id, Name from RecordType where Name = 'EAB Membership' limit 1];
	Id RTid = rt.Id;
	if(Trigger.isInsert || Trigger.isUnDelete) {
		for(Opportunity o : System.Trigger.new){
				if(o.RecordTypeId == RTid) {contIDs.add(o.Contact__c);}	
			}
	
		Contact[] conts = new List<Contact>();
		conts = [select Id, (select Membership_End_Date__c, RecordType.Name from Opportunities2__r where RecordType.Name = 'EAB Membership'  AND IsWon = TRUE order by Membership_End_Date__c Desc limit 1 ) from Contact where ID in :contIDs ];
		
		
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
					c.Exec_Member_End_Date__c=opty.Membership_End_Date__c; 
					}
				updatedContacts.add(c);
		
		}	
		if(updatedContacts.size()>0) { update updatedContacts;}
	
	}	
	if(Trigger.isDelete || Trigger.isUpdate) {
		
		for(Opportunity o : System.Trigger.old){
				if(o.RecordTypeId == rt.Id) {contIDs.add(o.Contact__c);}	
			}
	
		Contact[] conts = new List<Contact>();
		conts = [select Id, (select Membership_End_Date__c from Opportunities2__r where RecordType.Name = 'EAB Membership'  AND IsWon = TRUE order by Membership_End_Date__c Desc limit 1 ) from Contact where ID in :contIDs ];
	
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
					c.Exec_Member_End_Date__c=NULL;
				}
				for(Opportunity opty : opps) {
					c.Exec_Member_End_Date__c=opty.Membership_End_Date__c;}
				updatedContacts.add(c);
		
		}	
		if (updatedContacts.size()>0) {update updatedContacts;}
	}	


}