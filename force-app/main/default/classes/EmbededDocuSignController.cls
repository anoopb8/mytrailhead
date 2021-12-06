public class EmbededDocuSignController{
    Id mySourceId='a1I1P000007ugd7UAA';   // The ID of the initiating Salesforce object.
    Id myDocumentId='0151P000005lKSA'; // ID of a Salesforce Document library record.
    dfsle.Envelope myEnvelope;
    dfsle.UUID myEnvelopeId;
    
    public EmbededDocuSignController(){
            myEnvelope = dfsle.EnvelopeService.getEmptyEnvelope(
        
            new dfsle.Entity(mySourceId)) // The initiating Salesforce entity.
            
            .withDocuments(dfsle.DocumentService.getDocuments(
            
                    Document.getSObjectType(), // The SObject type to retrieve.
                    
                    new Set<Id> { // The Salesforce document IDs.
                        myDocumentId 
                    }))
                    
            .withRecipients(new List<dfsle.Recipient> {
                
                dfsle.Recipient.newEmbeddedSigner() // An embedded signer
                
            });
        
       
    }
   
   
    public PageReference SendEnvelope() {
        myEnvelope = dfsle.EnvelopeService.sendEnvelope(
        myEnvelope, // The envelope to send
            true); // Send now?

        // Save the DocuSign envelope ID for later.
        myEnvelopeId = myEnvelope.docuSignId;
         return null;
    }
    
    public PageReference createEmbededUrl() {
        
        Url mySigningUrl = dfsle.SigningService.getEmbeddedSigningUrl(
        myEnvelopeId, // DocuSign envelope ID
        new Url('https://ctsanoop-dev-ed.my.salesforce.com/home/home.jsp')); 
        
         //return null;
         //pageReference pg = new pageReference('https://google.com');
         //return pg;
         
         //system.debug('URl1:' + mySigningUrl.geturl());
         
         
         //string url = String.valueOf(mySigningUrl);
         system.debug('URl2:' + mySigningUrl.getPath());
         
         
         
          PageReference pg = new PageReference(mySigningUrl.toExternalForm());
          pg.setRedirect(true);
          return pg;

    }
}