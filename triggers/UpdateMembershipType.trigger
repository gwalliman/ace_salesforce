trigger UpdateMembershipType on Opportunity (after delete, after insert, after update, after undelete) {
set<ID> orgIDs = new Set<ID>();
	
	if(Trigger.isInsert || Trigger.isUnDelete) {
		for(Opportunity o : System.Trigger.new){
				if(o.RecordTypeId == '01280000000FPOJ') { orgIDs.add(o.AccountId); }	
			}
	
		Account[] orgs = new List<Account>();
		orgs = [select Id, (select Type, RecordType.Name from Opportunities where RecordType.Name = 'Organizational Membership'  AND IsWon = TRUE order by Membership_End_Date__c Desc limit 1 ) from Account where ID in :orgIDs ];
		
		
		Opportunity[] os = new List<Opportunity>(); 
		Map<Id, Opportunity[]> orgopp = new Map<Id, Opportunity[]>();
		for (Account eachOrg: orgs){
			orgopp.put(eachOrg.Id, eachOrg.Opportunities);
			 }
		Account[] updatedOrganizations = new List<Account>();
		Opportunity[] opps = new List<Opportunity>();
		for (Account a : orgs ){
				opps=orgopp.get(a.Id);
				for(Opportunity opty : opps) {
					a.Latest_Membership_Type__c=opty.Type; 	
				}
				updatedOrganizations.add(a);
		
		}	
		if(updatedOrganizations.size()>0) {update updatedOrganizations;}
	
	}	
	if(Trigger.isDelete || Trigger.isUpdate) {
		for(Opportunity o : System.Trigger.old){
				if(o.RecordTypeId == '01280000000FPOJ') {orgIDs.add(o.AccountId);}	
			}
	
		Account[] orgs = new List<Account>();
		orgs = [select Id, (select Membership_End_Date__c, Type from Opportunities where RecordType.Name = 'Organizational Membership'  AND IsWon = TRUE order by Membership_End_Date__c Desc limit 1 ) from Account where ID in :orgIDs ];
	
		Opportunity[] os = new List<Opportunity>(); 
		Map<Id, Opportunity[]> orgopp = new Map<Id, Opportunity[]>();
		for (Account eachOrg: orgs){
			orgopp.put(eachOrg.Id, eachOrg.Opportunities);
			 }
		Account[] updatedOrganizations = new List<Account>();
		Opportunity[] opps = new List<Opportunity>();
		for (Account a : orgs ){
				opps=orgopp.get(a.Id);
				if(opps.size()==0){
					a.Latest_Membership_Type__c=NULL;
				}
				for(Opportunity opty : opps) {
					a.Latest_Membership_Type__c=opty.Type;}
				updatedOrganizations.add(a);
		
		}	
		if(updatedOrganizations.size()>0) {update updatedOrganizations;}
	}	


}