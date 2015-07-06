@isTest
public class Test_Attachment_Privacy_Check
{
   static testMethod void testAttachments()
    {
         Contact conone = new Contact();
           RecordType[] rectype1 =[Select Id,  Name, SobjectType from RecordType where  SobjectType ='Contact' and Name ='EP Fellow'];       
       Conone.RecordTypeId = rectype1[0].Id;
       Conone.LastName = 'Test Contactone';
       Conone.External_Id__c = '12345';
       Conone.Privacy_Consent__c=True;
        insert conone ;
        
          Contact contwo = new Contact();
       RecordType[] rectype2 =[Select Id,  Name, SobjectType from RecordType where  SobjectType ='Contact' and Name ='EP'];
       contwo.RecordTypeId = rectype2[0].Id;
       contwo.LastName = 'Test Contact2';
       contwo.External_Id__c = '56789';
       contwo.Privacy_Consent__c=True;
       insert contwo;
       
       Contact conthree = new Contact();
       RecordType[] rectype3 =[Select Id,  Name, SobjectType from RecordType where  SobjectType ='Contact' and Name ='Cardiologist'];
       conthree.RecordTypeId = rectype3[0].Id;
       conthree.LastName = 'Test Contact3';
       conthree.External_Id__c = '13579';
       conthree.Privacy_Consent__c=True;
       insert conthree;
       
       Contact confour = new Contact();
       RecordType[] rectype4 =[Select Id,  Name, SobjectType from RecordType where  SobjectType ='Contact' and Name ='Other'];
       confour.RecordTypeId = rectype4[0].Id;
       confour.LastName = 'Test Contact4';
       confour.External_Id__c = '24680';
       confour.Privacy_Consent__c=True;
       insert confour;
 
        Attachment attach=new Attachment();     
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=conone .id;
        insert attach;
        
        List<Attachment> attachments=[select id, name from Attachment where parent.id=:conone.id];
        System.assertEquals(1, attachments.size());
           
  }
  }