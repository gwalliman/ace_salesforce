trigger CampaignMemberStatus on Campaign (after insert) {

	//change default member statuses (Sent and Responded) for select campaigns
	Set <Id> cmpns1 = new Set <Id>();
	Set <Id> cmpns2 = new Set <Id>();
	
	//RecordType rt1 = [Select Id, Name from RecordType where Name = 'Chowchilla Family Express Bus' limit 1];  
	  
	
	for (Campaign c: trigger.new){ 
		//if (c.RecordTypeId == rt1.Id)
			cmpns1.add(c.Id);
	}
	
	List<CampaignMemberStatus> cms2Delete = new List<CampaignMemberStatus>();
	List<CampaignMemberStatus> cms2Insert = new List<CampaignMemberStatus>();
	
	for (CampaignMemberStatus cm: [Select Id, Label, CampaignID  FROM CampaignMemberStatus WHERE CampaignID IN :cmpns1]){
	  if(cm.Label == 'Responded' ){
			CampaignMemberStatus cms1 = new CampaignMemberStatus(CampaignId=cm.CampaignID, Label='Buyer', HasResponded=true, IsDefault = True, SortOrder=3);	        
			CampaignMemberStatus cms2 = new CampaignMemberStatus(CampaignId=cm.CampaignID, Label='Attendee', HasResponded=true, IsDefault = False, SortOrder=4);
	  		System.debug(cms1);
	  		cms2Insert.add(cms1);
	  		cms2Insert.add(cms2);
	  }
	}
			
	//perform insert before delete because system requires at least one CMS for a Campaign
	insert cms2Insert;
	//delete cms2Delete; 

}