<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata"><alerts>
        <fullName>Send_Notification_of_a_new_website_users</fullName>
        <description>Send Notification of a new website users</description>
        <protected>false</protected>
        <recipients>
            <recipient>ace.asu@asu.edu</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>bryana.merrell@asu.edu</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>jacki.houchens@asu.edu</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>kpiland@asu.edu</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ACE_Email_Templates/Website_New_Users_Default_Notification</template>
    </alerts><rules>
        <fullName>New Website User task</fullName>
        <actions>
            <name>Send_Notification_of_a_new_website_users</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Campaign.Name</field>
            <operation>equals</operation>
            <value>Website New Users Default</value>
        </criteriaItems>
        <description>Assign a task when a new campaign member is added in the campaign "Website New Users Default"</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules></Workflow>