public class EmbededDocuSignController2 {
    
    @AuraEnabled
    public Static void SendEnvelope(String quoteId) {
        Id mySourceId = quoteId;
        dfsle.Envelope myEnvelope;
        dfsle.UUID myEnvelopeId;
        
        System.debug('Inside SendEnvelope Method');
        
        //myTemplateId contains the DocuSign Id of the DocuSign Template
        //c5c17fda-c3c6-453a-a4c5-baf152d09b17
        dfsle.UUID myTemplateId = dfsle.UUID.parse('a5dc52d7-8c78-4616-ac63-b32144491e91');
        
        //create a new document for the Envelope
        dfsle.Document myDocument = dfsle.Document.fromTemplate(
            myTemplateId, // templateId in dfsle.UUID format
            'myTemplate'); // name of the template
        
        //add document to the Envelope
        //myEnvelope = myEnvelope.withDocuments(new List<dfsle.Document> { myDocument });
        
        myEnvelope = dfsle.EnvelopeService.getEmptyEnvelope(
            
            new dfsle.Entity(mySourceId)) // The initiating Salesforce entity.
            
            .withDocuments(new List<dfsle.Document> { myDocument })
            
            .withRecipients(new List<dfsle.Recipient> {
                
                dfsle.Recipient.newEmbeddedSigner() // An embedded signer
                    
                    });
        
        
		/*myEnvelope = dfsle.EnvelopeService.sendEnvelope(
            myEnvelope, // The envelope to send
            true); // Send now?
        
        // Save the DocuSign envelope ID for later.
        myEnvelopeId = myEnvelope.docuSignId;
        System.debug('myEnvelopeId '+myEnvelopeId);
        System.debug('myEnvelope '+myEnvelope);
        Url mySigningUrl = dfsle.SigningService.getEmbeddedSigningUrl(
            myEnvelopeId, // DocuSign envelope ID
            new Url('https://docusign58-dev-ed.my.salesforce.com/home/home.jsp'));
        system.debug('mySigningUrl:' + mySigningUrl.getPath());
        
        /*If(myEnvelopeId != null && myEnvelope != null){
            createEmbededUrl(myEnvelopeId,myEnvelope);
        }*/
    }
    
    
    @AuraEnabled
    public static void createEmbededUrl(dfsle.UUID myEnvId, dfsle.Envelope myEnv) {
        System.debug('myEnvId '+myEnvId);
        System.debug('myEnv '+myEnv);
        dfsle.Envelope myEnvelope = myEnv;
        dfsle.UUID myEnvelopeId = myEnvId;
        System.debug('myEnvelopeId@ '+myEnvelopeId);
        System.debug('myEnvelope@ '+myEnvelope);
        // https://ctsanoop-dev-ed.my.salesforce.com/home/home.jsp'
        
        Url mySigningUrl = dfsle.SigningService.getEmbeddedSigningUrl(
            myEnvelopeId, // DocuSign envelope ID
            new Url('https://docusign58-dev-ed.my.salesforce.com/home/home.jsp')); 
        
        //return null;
        //pageReference pg = new pageReference('https://google.com');
        //return pg;
        
        //system.debug('URl1:' + mySigningUrl.geturl());
        
        
        //string url = String.valueOf(mySigningUrl);
        system.debug('URl2:' + mySigningUrl.getPath());
        
        
        
        /*PageReference pg = new PageReference(mySigningUrl.toExternalForm());
        pg.setRedirect(true);
        return pg;*/
        
    }

}