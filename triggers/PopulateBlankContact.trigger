trigger PopulateBlankContact on Opportunity (before insert, before update) {
	  List<Opportunity> accList = new List<Opportunity>();
      List<Contact> conList = new List<Contact>();
	  RecordType rt = [Select Id, Name from RecordType where Name = 'Organizational Membership' limit 1];
      Id OrgMemRTid = rt.Id;
	  for (Opportunity o : Trigger.new) {
         if (o.Contact__c == null && o.RecordTypeId == OrgMemRTid && (o.Membership_Contact_ID__c <> NULL || o.Primary_Contact_ID__c <> NULL)) {
         	if (o.Membership_Contact_ID__c <> NULL){o.Contact__c = o.Membership_Contact_ID__c;}
         	else {
         		if (o.Primary_Contact_ID__c <> NULL){o.Contact__c = o.Primary_Contact_ID__c;}
         	}  
         }
	  }
}