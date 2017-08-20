/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
//@isTest
public class TestManagement {

    static testMethod void IndMembershipTest(){

        Account acct = new Account();
        acct.Name = 'Organization Test';
        insert acct;
        
        Contact Cont = new Contact();
        Cont.LastName = 'test';
        Cont.AccountId = acct.id;
        Cont.email='test@gmail.com';
        insert Cont;        
        Id ContId= Cont.Id;
        
        RecordType Rec;
        Rec = [select Id from RecordType where Name = 'Individual Membership'];
        
        Opportunity Opp = new Opportunity();
        Opp.CloseDate = Date.today();
        Opp.RecordTypeId = Rec.Id;
        Opp.Membership_End_Date__c=Date.today();
        Opp.Payment_Type__c='Cash/Check';
        Opp.Accounting_Code__c='123';
        opp.StageName = 'Closed Won';
        Opp.name = 'test';
        Opp.Amount = 100;
        Opp.Contact__c=ContId;
        insert Opp; 
        Id OppId = Opp.Id;
        
        
        Opportunity Opp1 = new Opportunity();
        Opp1.CloseDate = Date.today();
        Opp1.RecordTypeId = Rec.Id;
        Opp1.Membership_End_Date__c=Date.today();
        Opp1.Payment_Type__c='Cash/Check';
        Opp1.Accounting_Code__c='123';
        opp1.StageName = 'Closed Won';
        Opp1.name = 'test';
        Opp1.Amount = 100;
        Opp1.Contact__c=ContId;
        insert Opp1;
        
            
        Opportunity Opp2 = new Opportunity();
        Opp2.CloseDate = Date.today();
        Opp2.RecordTypeId = Rec.Id;
        Opp2.Membership_End_Date__c=Date.today();
        Opp2.Payment_Type__c='Cash/Check';
        Opp2.Accounting_Code__c='123';
        opp2.StageName = 'Closed Won';
        Opp2.name = 'test';
        Opp2.Amount = 100;
        Opp2.Contact__c=ContId;
        insert Opp2;    
        
        Contact[] mycontacts = [SELECT Id, Ind_Member_End_Date__c FROM Contact Where Id=:ContId];
        System.assertEquals(1, mycontacts.size() );
        System.assertEquals(Date.today(), mycontacts[0].Ind_Member_End_Date__c );
        
        Opp.Amount = 0;
        update Opp;

        mycontacts = [SELECT Id, Ind_Member_End_Date__c FROM Contact Where Id=:ContId];
        System.assertEquals(1, mycontacts.size() );
        System.assertEquals(Date.today(), mycontacts[0].Ind_Member_End_Date__c );
        
        Opp.Amount = 10000;
        update Opp;
        
        mycontacts = [SELECT Id, Ind_Member_End_Date__c FROM Contact Where Id=:ContId];
        System.assertEquals(1, mycontacts.size() );
        System.assertEquals(Date.today(), mycontacts[0].Ind_Member_End_Date__c );
                
        mycontacts = [SELECT Id, Ind_Member_End_Date__c FROM Contact Where Id=:ContId];
        System.assertEquals(1, mycontacts.size() );
        System.assertEquals(Date.today(), mycontacts[0].Ind_Member_End_Date__c );
        
        Opp2.Membership_End_Date__c = Date.Today()+1;
        update Opp2;
        
        mycontacts = [SELECT Id, Ind_Member_End_Date__c FROM Contact Where Id=:ContId];
        System.assertEquals(1, mycontacts.size() );
        System.assertEquals(Date.today()+1, mycontacts[0].Ind_Member_End_Date__c );
            
        delete Opp2;
        mycontacts = [SELECT Id, Ind_Member_End_Date__c FROM Contact Where Id=:ContId];
        System.assertEquals(1, mycontacts.size() );
        System.assertEquals(Date.today(), mycontacts[0].Ind_Member_End_Date__c );
        
        delete Opp1;
        mycontacts = [SELECT Id, Ind_Member_End_Date__c FROM Contact Where Id=:ContId];
        System.assertEquals(1, mycontacts.size() );
        System.assertEquals(Date.today(), mycontacts[0].Ind_Member_End_Date__c );
        
        delete Opp;
        mycontacts = [SELECT Id, Ind_Member_End_Date__c FROM Contact Where Id=:ContId];
        System.assertEquals(1, mycontacts.size() );
        System.assertEquals(NULL, mycontacts[0].Ind_Member_End_Date__c );
    }

static testMethod void ExecMembershipTest(){

        Account acct = new Account();
        acct.Name = 'Organization Test';
        insert acct;
        
        Contact Cont = new Contact();
        Cont.LastName = 'test';
        Cont.AccountId = acct.id;
        Cont.email='test@gmail.com';
        insert Cont;        
        Id ContId= Cont.Id;
        
        RecordType Rec;
        Rec = [select Id from RecordType where Name = 'EAB Membership'];
        
        Opportunity Opp = new Opportunity();
        Opp.CloseDate = Date.today();
        Opp.RecordTypeId = Rec.Id;
        Opp.Membership_End_Date__c=Date.today()+1;
        Opp.Payment_Type__c='Cash/Check';
        Opp.Accounting_Code__c='123';
        Opp.StageName = 'Closed Won';
        Opp.name = 'test';
        Opp.Type = 'Executive';
        Opp.Amount = 100;
        Opp.Contact__c=ContId;
        insert Opp; 
        Id OppId = Opp.Id;
        
        
        Opportunity Opp1 = new Opportunity();
        Opp1.CloseDate = Date.today();
        Opp1.RecordTypeId = Rec.Id;
        Opp1.Membership_End_Date__c=Date.today()+1;
        Opp1.Payment_Type__c='Cash/Check';
        Opp1.Accounting_Code__c='123';
        Opp1.StageName = 'Closed Won';
        Opp1.name = 'test';
        Opp1.Type = 'Executive';
        Opp1.Amount = 100;
        Opp1.Contact__c=ContId;
        insert Opp1;
        
            
        Opportunity Opp2 = new Opportunity();
        Opp2.CloseDate = Date.today();
        Opp2.RecordTypeId = Rec.Id;
        Opp2.Membership_End_Date__c=Date.today()+1;
        Opp2.Payment_Type__c='Cash/Check';
        Opp2.Accounting_Code__c='123';
        Opp2.StageName = 'Closed Won';
        Opp2.name = 'test';
        Opp2.Type = 'Executive';
        Opp2.Amount = 100;
        Opp2.Contact__c=ContId;
        insert Opp2;    
        
        Contact[] mycontacts = [SELECT Id, Exec_Member_End_Date__c FROM Contact Where Id=:ContId];
        System.assertEquals(1, mycontacts.size() );
        System.assertEquals(Date.today()+1, mycontacts[0].Exec_Member_End_Date__c );
        
        Opp.Amount = 0;
        update Opp;

        mycontacts = [SELECT Id, Exec_Member_End_Date__c FROM Contact Where Id=:ContId];
        System.assertEquals(1, mycontacts.size() );
        System.assertEquals(Date.today()+1, mycontacts[0].Exec_Member_End_Date__c );
        
        Opp.Amount = 10000;
        update Opp;
        
        mycontacts = [SELECT Id, Exec_Member_End_Date__c FROM Contact Where Id=:ContId];
        System.assertEquals(1, mycontacts.size() );
        System.assertEquals(Date.today()+1, mycontacts[0].Exec_Member_End_Date__c );
                    
        Opp2.Membership_End_Date__c = Date.Today()+2;
        update Opp2;
        
        mycontacts = [SELECT Id, Exec_Member_End_Date__c FROM Contact Where Id=:ContId];
        System.assertEquals(1, mycontacts.size() );
        System.assertEquals(Date.today()+2, mycontacts[0].Exec_Member_End_Date__c );
            
        delete Opp2;
        mycontacts = [SELECT Id, Exec_Member_End_Date__c FROM Contact Where Id=:ContId];
        System.assertEquals(1, mycontacts.size() );
        System.assertEquals(Date.today()+1, mycontacts[0].Exec_Member_End_Date__c );
        
        delete Opp1;
        mycontacts = [SELECT Id, Exec_Member_End_Date__c FROM Contact Where Id=:ContId];
        System.assertEquals(1, mycontacts.size() );
        System.assertEquals(Date.today()+1, mycontacts[0].Exec_Member_End_Date__c );
        
        delete Opp;
        mycontacts = [SELECT Id, Exec_Member_End_Date__c FROM Contact Where Id=:ContId];
        System.assertEquals(1, mycontacts.size() );
        System.assertEquals(NULL, mycontacts[0].Exec_Member_End_Date__c );
    }

static testMethod void LastRegistrationDateTest(){

        Account acct = new Account();
        acct.Name = 'Organization Test';
        insert acct;
        
        Contact Cont = new Contact();
        Cont.LastName = 'test';
        Cont.AccountId = acct.id;
        Cont.email='test@gmail.com';
        insert Cont;        
        Id ContId= Cont.Id;
        
        RecordType Rec;
        Rec = [select Id from RecordType where Name = 'Program Registration'];
        
        Opportunity Opp = new Opportunity();
        Opp.CloseDate = Date.today();
        Opp.RecordTypeId = Rec.Id;
        Opp.CloseDate=Date.today()-2;
        Opp.Payment_Type__c='Cash/Check';
        Opp.Accounting_Code__c='123';
        opp.StageName = 'Closed Won';
        Opp.name = 'test';
        Opp.Amount = 100;
        Opp.Contact__c=ContId;
        insert Opp; 
        Id OppId = Opp.Id;
        
        
        Opportunity Opp1 = new Opportunity();
        Opp1.CloseDate = Date.today();
        Opp1.RecordTypeId = Rec.Id;
        Opp1.CloseDate=Date.today()-1;
        Opp1.Payment_Type__c='Cash/Check';
        Opp1.Accounting_Code__c='123';
        opp1.StageName = 'Closed Won';
        Opp1.name = 'test';
        Opp1.Amount = 100;
        Opp1.Contact__c=ContId;
        insert Opp1;
        
            
        Opportunity Opp2 = new Opportunity();
        Opp2.CloseDate = Date.today();
        Opp2.RecordTypeId = Rec.Id;
        Opp2.CloseDate=Date.today();
        Opp2.Payment_Type__c='Cash/Check';
        Opp2.Accounting_Code__c='123';
        opp2.StageName = 'Closed Won';
        Opp2.name = 'test';
        Opp2.Amount = 100;
        Opp2.Contact__c=ContId;
        insert Opp2;    
        
        Contact[] mycontacts = [SELECT Id, Last_Registration_Date__c FROM Contact Where Id=:ContId];
        System.assertEquals(1, mycontacts.size() );
        System.assertEquals(Date.today(), mycontacts[0].Last_Registration_Date__c );
        
        Opp2.CloseDate = Date.Today()+1;
        update Opp2;
        
        mycontacts = [SELECT Id, Last_Registration_Date__c FROM Contact Where Id=:ContId];
        System.assertEquals(1, mycontacts.size() );
        System.assertEquals(Date.today()+1, mycontacts[0].Last_Registration_Date__c );
            
        delete Opp2;
        mycontacts = [SELECT Id, Last_Registration_Date__c FROM Contact Where Id=:ContId];
        System.assertEquals(1, mycontacts.size() );
        System.assertEquals(Date.today()-1, mycontacts[0].Last_Registration_Date__c );
        
        delete Opp1;
        mycontacts = [SELECT Id, Last_Registration_Date__c FROM Contact Where Id=:ContId];
        System.assertEquals(1, mycontacts.size() );
        System.assertEquals(Date.today()-2, mycontacts[0].Last_Registration_Date__c );
        
        delete Opp;
        mycontacts = [SELECT Id, Last_Registration_Date__c FROM Contact Where Id=:ContId];
        System.assertEquals(1, mycontacts.size() );
        System.assertEquals(NULL, mycontacts[0].Last_Registration_Date__c );
    }
    
    /*static testMethod void PrimaryContactTest(){
        Account acct = new Account();
        acct.Name = 'Organization Test';
        insert acct;
        Id AcctId = Acct.Id;
        
        Contact Cont = new Contact();
        Cont.LastName = 'test';
        Cont.AccountId = acct.id;
        Cont.email='test@gmail.com';
        Cont.Primary_Contact__c=TRUE;
        insert Cont;        
        Id ContId= Cont.Id;
        
        Account[] myaccounts = [SELECT Id, Primary_Contact__c FROM Account Where Id=:AcctId];
        System.assertEquals(1, myaccounts.size() );
        System.assertEquals(ContId, myaccounts[0].Primary_Contact__c );
        
        Contact Cont1 = new Contact();
        Cont1.LastName = 'test';
        Cont1.AccountId = acct.id;
        Cont1.email='test@gmail.com';
        Cont1.Primary_Contact__c=TRUE;
        insert Cont1;       
        Id Cont1Id= Cont1.Id;
        
        myaccounts = [SELECT Id, Primary_Contact__c FROM Account Where Id=:AcctId];
        System.assertEquals(1, myaccounts.size() );
        System.assertEquals(ContId, myaccounts[0].Primary_Contact__c );
        
        delete cont;
        
        myaccounts = [SELECT Id, Primary_Contact__c FROM Account Where Id=:AcctId];
        System.assertEquals(1, myaccounts.size() );
        System.assertEquals(NULL, myaccounts[0].Primary_Contact__c );
        
        
    }*/
    static testMethod void PrimaryContactTestMethod()
    {
        Account acct = new Account();
        acct.Name = 'Organization Test';
        insert acct;
        Id AcctId = Acct.Id;
        
        Contact Cont = new Contact();
        Cont.LastName = 'test';
        Cont.AccountId = acct.id;
        Cont.email='test@gmail.com';
        Cont.Primary_Contact__c=False;
        insert Cont;        
        
        Contact Cont1 = new Contact();
        Cont1.LastName = 'test';
        Cont1.AccountId = acct.id;
        Cont1.email='test@gmail.com';
        Cont1.Primary_Contact__c=TRUE;
        insert Cont1; 
        
        Cont1.Primary_Contact__c=FALSE;
        Update Cont1;
        
        Cont.Primary_Contact__c=TRUE;
        Update Cont;
        
        try{
            Cont1.Primary_Contact__c=TRUE;
            Update Cont1;
        }catch(Exception e){}
        
        acct.Primary_contact__c = cont1.Id;
        update acct;
        
        acct.Primary_Contact__c = null;          
        update acct;
        
        acct.Primary_Contact__c = cont1.Id;          
        update acct;
        
        acct = new Account();
        acct.Name = 'Organization Test';
        acct.Primary_Contact__c = Cont1.id;
        insert acct; 
    }
    static testMethod void MembershipContactTestMethod()
    {
        Account acct = new Account();
        acct.Name = 'Organization Test';
        insert acct;
        Id AcctId = Acct.Id;
        
        Contact Cont = new Contact();
        Cont.LastName = 'test';
        Cont.AccountId = acct.id;
        Cont.email='test@gmail.com';
        Cont.Membership_Contact__c=False;
        insert Cont;        
        
        Contact Cont1 = new Contact();
        Cont1.LastName = 'test';
        Cont1.AccountId = acct.id;
        Cont1.email='test@gmail.com';
        Cont1.Membership_Contact__c=TRUE;
        insert Cont1; 
        
        Cont1.Membership_Contact__c=FALSE;
        Update Cont1;
        
        Cont.Membership_Contact__c=TRUE;
        Update Cont;     
        
        try{
            Cont1.Membership_Contact__c=TRUE;
            Update Cont1;
        }catch(Exception e){}
        
        acct.Membership_Contact__c = Cont.id;
        update acct;
        
        acct.Membership_Contact__c = Cont1.id;
        update acct;
        
        acct.Membership_Contact__c = null;          
        update acct;
        
        acct.Membership_Contact__c = Cont1.id;          
        update acct;
        
        acct = new Account();
        acct.Name = 'Organization Test';
        acct.Membership_Contact__c = Cont1.id;
        insert acct;
       
    }
    static testMethod void DonorContactTestMethod()
    {
        Account acct = new Account();
        acct.Name = 'Organization Test';
        insert acct;
        Id AcctId = Acct.Id;
        
        Contact Cont = new Contact();
        Cont.LastName = 'test';
        Cont.AccountId = acct.id;
        Cont.email='test@gmail.com';
        Cont.Donor_Contact__c=False;
        insert Cont;        
        
        Contact Cont1 = new Contact();
        Cont1.LastName = 'test';
        Cont1.AccountId = acct.id;
        Cont1.email='test@gmail.com';
        Cont1.Donor_Contact__c=TRUE;
        insert Cont1; 
        
        Cont1.Donor_Contact__c=FALSE;
        Update Cont1;
        
        Cont.Donor_Contact__c=TRUE;
        Update Cont;     
        
        try{
            Cont1.Donor_Contact__c=TRUE;
            Update Cont1;
        }catch(Exception e){}
        
        acct.Donor_Contact__c = Cont.id;
        update acct;
        
        acct.Donor_Contact__c = Cont1.id;
        update acct;
        
        acct.Donor_Contact__c = null;
        update acct;
        
        acct.Donor_Contact__c = Cont1.id;
        update acct;
        
        acct = new Account();
        acct.Name = 'Organization Test';
        acct.Donor_Contact__c = Cont1.id;
        insert acct;         
    }
    static testMethod void FundraisingTest(){

        Account acct = new Account();
        acct.Name = 'Organization Test';
        insert acct;
        
        Contact Cont = new Contact();
        Cont.LastName = 'test';
        Cont.AccountId = acct.id;
        Cont.email='test@gmail.com';
        insert Cont;        
        Id ContId= Cont.Id;
        
        RecordType Rec;
        Rec = [select Id from RecordType where Name = 'Individual Donation'];
        
        Opportunity Opp = new Opportunity();
        Opp.CloseDate = Date.today();
        Opp.RecordTypeId = Rec.Id;
        Opp.CloseDate=Date.today()-2;
        Opp.Payment_Type__c='Cash/Check';
        Opp.Accounting_Code__c='123';
        opp.StageName = 'Closed Won';
        Opp.name = 'test';
        Opp.Amount = 100;
        Opp.Contact__c=ContId;
        insert Opp; 
        Id OppId = Opp.Id;
        
        
        Opportunity Opp1 = new Opportunity();
        Opp1.CloseDate = Date.today();
        Opp1.RecordTypeId = Rec.Id;
        Opp1.CloseDate=Date.today()-1;
        Opp1.Payment_Type__c='Cash/Check';
        Opp1.Accounting_Code__c='123';
        opp1.StageName = 'Closed Won';
        Opp1.name = 'test';
        Opp1.Amount = 100;
        Opp1.Contact__c=ContId;
        insert Opp1;
        
            
        Opportunity Opp2 = new Opportunity();
        Opp2.CloseDate = Date.today();
        Opp2.RecordTypeId = Rec.Id;
        Opp2.CloseDate=Date.today();
        Opp2.Payment_Type__c='Cash/Check';
        Opp2.Accounting_Code__c='123';
        opp2.StageName = 'Closed Won';
        Opp2.name = 'test';
        Opp2.Amount = 100;
        Opp2.Contact__c=ContId;
        insert Opp2;    
        
        Contact[] mycontacts = [SELECT Id, Last_Donation_Date__c, First_Donation_Date__c, Total_Donated__c FROM Contact Where Id=:ContId];
        System.assertEquals(1, mycontacts.size() );
        System.assertEquals(Date.today(), mycontacts[0].Last_Donation_Date__c );
        System.assertEquals(Date.today()-2, mycontacts[0].First_Donation_Date__c );
        System.assertEquals(300, mycontacts[0].Total_Donated__c );
        
        Opp2.CloseDate = Date.Today()+1;
        update Opp2;
        
        mycontacts = [SELECT Id, Last_Donation_Date__c, First_Donation_Date__c, Total_Donated__c FROM Contact Where Id=:ContId];
        System.assertEquals(1, mycontacts.size() );
        System.assertEquals(Date.today()+1, mycontacts[0].Last_Donation_Date__c );
        System.assertEquals(Date.today()-2, mycontacts[0].First_Donation_Date__c );
        System.assertEquals(300, mycontacts[0].Total_Donated__c );
            
        delete Opp2;
        mycontacts = [SELECT Id, Last_Donation_Date__c, First_Donation_Date__c, Total_Donated__c FROM Contact Where Id=:ContId];
        System.assertEquals(1, mycontacts.size() );
        System.assertEquals(Date.today()-1, mycontacts[0].Last_Donation_Date__c );
        System.assertEquals(Date.today()-2, mycontacts[0].First_Donation_Date__c );
        System.assertEquals(200, mycontacts[0].Total_Donated__c );
        
        delete Opp1;
        mycontacts = [SELECT Id, Last_Donation_Date__c, First_Donation_Date__c, Total_Donated__c FROM Contact Where Id=:ContId];
        System.assertEquals(1, mycontacts.size() );
        System.assertEquals(Date.today()-2, mycontacts[0].Last_Donation_Date__c );
        System.assertEquals(Date.today()-2, mycontacts[0].First_Donation_Date__c );
        System.assertEquals(100, mycontacts[0].Total_Donated__c );
        
        delete Opp;
        mycontacts = [SELECT Id, Last_Donation_Date__c, First_Donation_Date__c, Total_Donated__c FROM Contact Where Id=:ContId];
        System.assertEquals(1, mycontacts.size() );
        System.assertEquals(NULL, mycontacts[0].Last_Donation_Date__c );
        System.assertEquals(NULL, mycontacts[0].First_Donation_Date__c );
        System.assertEquals(0, mycontacts[0].Total_Donated__c );
    }
    
static testMethod void MembershipTypeTest(){

        Account acct = new Account();
        acct.Name = 'Organization Test';
        insert acct;
        Id AcctId = acct.id;
                
        RecordType Rec;
        Rec = [select Id from RecordType where Name = 'Organizational Membership'];
        
        Opportunity Opp = new Opportunity();
        Opp.RecordTypeId = Rec.Id;
        Opp.Membership_End_Date__c=Date.today()+2;
        Opp.CloseDate=Date.today()+2;
        Opp.Payment_Type__c='Cash/Check';
        Opp.Accounting_Code__c='123';
        opp.StageName = 'Closed Won';
        Opp.name = 'test';
        Opp.Amount = 100;
        Opp.Type='Corporate';
        Opp.AccountId = AcctId;
        insert Opp; 
        Id OppId = Opp.Id;
            
        Account[] myaccounts = [SELECT Id, Latest_Membership_Type__c FROM Account Where Id=:AcctId];
        System.assertEquals(1, myaccounts.size() );
        System.assertEquals('Corporate', myaccounts[0].Latest_Membership_Type__c );
        
        Opp.Type = 'Sustaining';
        update Opp;
        
        myaccounts = [SELECT Id, Latest_Membership_Type__c FROM Account Where Id=:AcctId];
        System.assertEquals(1, myaccounts.size() );
        System.assertEquals('Sustaining', myaccounts[0].Latest_Membership_Type__c );
        
        delete Opp;
        myaccounts = [SELECT Id, Latest_Membership_Type__c FROM Account Where Id=:AcctId];
        System.assertEquals(1, myaccounts.size() );
        System.assertEquals(NULL, myaccounts[0].Latest_Membership_Type__c );
                        
    }
     static testMethod void CampaignMemberStatusTest(){
    	   	
    		Campaign camp1 = new Campaign();
    		camp1.Name = 'test';
    		camp1.IsActive = True;
    		insert camp1;
    		
    		CampaignMemberStatus[] cms = [Select Id, Label, CampaignID  FROM CampaignMemberStatus WHERE CampaignId = :camp1.Id and Label = 'Buyer'];
    		System.assertEquals(1, cms.size());
    		
    		cms = [Select Id, Label, CampaignID  FROM CampaignMemberStatus WHERE CampaignId = :camp1.Id and Label = 'Attendee'];
    		System.assertEquals(1, cms.size());
    }
    
    static testMethod void LastCampaignDateRollupUnitTest() {
    	   	
    	Contact Cont = new Contact();
		Cont.FirstName = 'test';
		Cont.LastName = 'test';
		Cont.email='test@gmail.com';
		insert Cont; 		
		Id ContId= Cont.Id;
		
		Campaign ca = new Campaign();
		ca.Name = 'Test Campaign';
		ca.StartDate = Date.Today();
		ca.IsActive = TRUE;
		insert ca;
		Id CaId = ca.Id;
		
		CampaignMember c1 = new CampaignMember();
		c1.CampaignId = caId;
		c1.ContactId = ContId;
		c1.Status = 'Sent';
		
		test.starttest();
		insert c1;
		//test.stoptest();
		
		Contact[] mycontacts = [SELECT Id, AccountId, Last_Participation_Date__c  FROM Contact Where Id=:ContId];
    	System.assertEquals(1, mycontacts.size() );
    	System.assertEquals(NULL, mycontacts[0].Last_Participation_Date__c );
    	
    	c1.Status = 'Responded';
    	//test.starttest();
    	update c1;
    	//test.stoptest();
    	
    	mycontacts = [SELECT Id, AccountId, Last_Participation_Date__c  FROM Contact Where Id=:ContId];
    	System.assertEquals(1, mycontacts.size() );
    	System.assertEquals(Date.Today(), mycontacts[0].Last_Participation_Date__c );
    	
    	//test.starttest();
    	Delete c1;
    	test.stoptest();
    	
    	mycontacts = [SELECT Id, AccountId, Last_Participation_Date__c  FROM Contact Where Id=:ContId];
    	System.assertEquals(1, mycontacts.size() );
    	System.assertEquals(NULL, mycontacts[0].Last_Participation_Date__c );
    }
    static testMethod void TestPopulateBlankContact() {
        Account a1 = new Account();
        a1.Name = 'Test Org';
        insert a1;
        
        Contact c1 = new Contact();
    	c1.FirstName = 'Test1';
    	c1.LastName = 'Test1';
    	insert c1;
    	
    	Contact c2 = new Contact();
    	c2.FirstName = 'Test2';
    	c2.LastName = 'Test2';
    	insert c2;
    	
    	a1.Membership_Contact__c = c1.Id;
    	a1.Primary_Contact__c = c2.Id;
    	update a1;

		RecordType rt = [Select Id, Name from RecordType where Name = 'Organizational Membership' limit 1];
		
		Opportunity o1 = new Opportunity();
		o1.Name = 'Test';
		o1.StageName = 'Closed Won';
		o1.CloseDate = System.Today();
		o1.Amount = 0;
		o1.AccountId = a1.Id;
		o1.RecordTypeId = rt.id;
		o1.Accounting_Code__c = '0';
		o1.Payment_Type__c = 'Cash';
		insert o1;
		
    	Opportunity[] opps= [Select Id,Contact__c  FROM Opportunity WHERE Id = :o1.Id and Contact__c <> NULL];
    	System.assertEquals(1, opps.size());
    	
    	a1.Membership_Contact__c = NULL;
    	update a1;
    	o1.Contact__c = NULL;
    	update o1;
    	
    	opps= [Select Id,Contact__c  FROM Opportunity WHERE Id = :o1.Id and Contact__c <> NULL];
    	System.assertEquals(1, opps.size());
    	
    }

}