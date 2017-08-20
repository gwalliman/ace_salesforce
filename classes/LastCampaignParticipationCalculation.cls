public with sharing class LastCampaignParticipationCalculation {
	
	//@Future(callout=true)
	public static void Rollup (Set<ID> contIDs){
	
		Contact[] conts = new List<Contact>();
		conts = [select Id, Last_Participation_Date__c ,(select Campaign.StartDate from CampaignMembers where HasResponded = TRUE order by Campaign.StartDate Desc) from Contact where ID in :contIDs ];
		
		CampaignMember[] cm = new List<CampaignMember>(); 
		Map<Id, CampaignMember[]> contcampaignmember = new Map<Id, CampaignMember[]>();
		for (Contact eachCont: conts){
			contcampaignmember.put(eachCont.Id, eachCont.CampaignMembers);
			 }
		Contact[] updatedContacts = new List<Contact>();
		CampaignMember[] cms = new List<CampaignMember>();
		
		for (Contact co : conts ){
				cms=contcampaignmember.get(co.Id);
				co.Last_Participation_Date__c = NULL;
				if(cms.size()>0){
					co.Last_Participation_Date__c = cms[0].Campaign.StartDate;
					}			
				updatedContacts.add(co);
			}		
		if (updatedContacts.size()>0) {update updatedContacts;}
		
	}

}