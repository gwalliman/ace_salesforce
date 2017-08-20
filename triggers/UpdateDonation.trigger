trigger UpdateDonation on Opportunity (after delete, after insert, after update, after undelete) {

	set<ID> contIDs = new Set<ID>();
	
	if(Trigger.isInsert || Trigger.isUnDelete) {
		for(Opportunity o : System.Trigger.new ){
				if(o.RecordTypeId == '01280000000B3T8') {contIDs.add(o.Contact__c);}
		}
	
		Contact[] conts = new List<Contact>();
		conts = [select Id, First_Donation_Date__c, Last_Donation_Date__c, (select Amount, CloseDate from Opportunities2__r where RecordType.Name = 'Individual Donation' AND IsWon = TRUE order by CloseDate Desc) from Contact where ID in :contIDs ];
	
		
		Opportunity[] os = new List<Opportunity>(); 
		Map<Id, Opportunity[]> contopp = new Map<Id, Opportunity[]>();
		for (Contact eachCont: conts){
			contopp.put(eachCont.Id, eachCont.Opportunities2__r);
			 }
		Contact[] updatedContacts = new List<Contact>();
		Opportunity[] opps = new List<Opportunity>();
		for (Contact c : conts ){
				opps=contopp.get(c.Id);
				c.Last_Donation_Date__c = opps[0].CloseDate;
				c.First_Donation_Date__c = opps[opps.size()-1].CloseDate;
				Double SumOfAmount = 0;
				for(Opportunity opty : opps) {
					SumOfAmount += opty.Amount; }
				c.Total_Donated__c = SumOfAmount;
				updatedContacts.add(c);
			}	
			if (updatedContacts.size()>0) {update updatedContacts;}
	
	}	
	if(Trigger.isDelete || Trigger.isUpdate) {
		for(Opportunity o : System.Trigger.old){
				if(o.RecordTypeId == '01280000000B3T8') { contIDs.add(o.Contact__c); }	
			}
		
		Contact[] conts = new List<Contact>();
		conts = [select Id, (select CloseDate, Amount, RecordType.Name from Opportunities2__r where RecordType.Name = 'Individual Donation'  AND IsWon = TRUE order by CloseDate Desc) from Contact where ID in :contIDs ];
	
		Opportunity[] os = new List<Opportunity>(); 
		Map<Id, Opportunity[]> contopp = new Map<Id, Opportunity[]>();
		for (Contact eachCont: conts){
			contopp.put(eachCont.Id, eachCont.Opportunities2__r);
			 }
		Contact[] updatedContacts = new List<Contact>();
		Opportunity[] opps = new List<Opportunity>();
				
		Double SumOfAmount;
		for (Contact c : conts ){
				opps=contopp.get(c.Id);
				SumOfAmount = 0;
				c.Last_Donation_Date__c = NULL;
				c.First_Donation_Date__c = NULL;
				if (opps.size()>0) {
					c.Last_Donation_Date__c = opps[0].CloseDate;
					c.First_Donation_Date__c = opps[opps.size()-1].CloseDate;
				}
				if(opps.size()==0){ c.Last_Donation_Date__c=NULL;}
				for(Opportunity opty : opps) { SumOfAmount += opty.Amount; }	
				c.Total_Donated__c = SumOfAmount;
				updatedContacts.add(c);
		}	
		if (updatedContacts.size()>0) {update updatedContacts;}	
	}
}