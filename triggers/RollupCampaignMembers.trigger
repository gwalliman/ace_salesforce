trigger RollupCampaignMembers on CampaignMember (after delete, after insert, after undelete, 
after update) {
	set<ID> contIDs = new Set<ID>();		
	
	if(Trigger.isInsert || Trigger.isUnDelete) {
		for(CampaignMember c : System.Trigger.new){
					if(c.HasResponded == TRUE) {contIDs.add(c.ContactId);}
		}
		if(ContIDs.isEmpty() == FALSE) {LastCampaignParticipationCalculation.Rollup(contIDs);}
	}	
	
	if(Trigger.isUpdate) {
		
		for (integer i = 0; i<Trigger.new.size(); i++) {
					if((Trigger.old[i].HasResponded == TRUE && Trigger.new[i].HasResponded == FALSE) ||
					(Trigger.old[i].HasResponded == FALSE && Trigger.new[i].HasResponded == TRUE)) 
						{contIDs.add(Trigger.new[i].ContactId);}
		}
		if(ContIDs.isEmpty() == FALSE) {LastCampaignParticipationCalculation.Rollup(contIDs);}
	}
	
	if(Trigger.isDelete) {
		for(CampaignMember c : System.Trigger.old){
					if(c.HasResponded == TRUE) {contIDs.add(c.ContactId);}
		}
		if(ContIDs.isEmpty() == FALSE) {LastCampaignParticipationCalculation.Rollup(contIDs);}
	}
}