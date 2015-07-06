<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>CFSP_SendEmailAlert</fullName>
        <description>CFSP_SendEmailAlert</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CFS_Template/CFSP_EmailNotificationTemplate</template>
    </alerts>
    <fieldUpdates>
        <fullName>CFSP_SendEmailAlertComplete</fullName>
        <field>Status__c</field>
        <literalValue>Sent</literalValue>
        <name>CFSP_SendEmailAlertComplete</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>CFSP_EmailNotification</fullName>
        <actions>
            <name>CFSP_SendEmailAlert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>CFSP_SendEmailAlertComplete</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>CFSP_EmailNotification__c.Status__c</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>