public class EmbededDocuSignController1{
    Id mySourceId='0011P000016Q7tR';   // The ID of the initiating Salesforce object.
    dfsle.Envelope myEnvelope;
    dfsle.UUID myEnvelopeId;
    
    
    public void DefTable(){
    //myTemplateId contains the DocuSign Id of the DocuSign Template
    dfsle.UUID myTemplateId = dfsle.UUID.parse('a5dc52d7-8c78-4616-ac63-b32144491e91');
    //create a new document for the Envelope using the template
    dfsle.Document myDocument = dfsle.Document.fromTemplate(
        myTemplateId, // templateId in dfsle.UUID format
        'template061101'); // name of the template
    String AccountStr = (String) mySourceId + '~Account';
    
    dfsle.CustomField myField = new dfsle.CustomField ('text', 'DSFSSourceObjectId', AccountStr, null, false, false);
    // Creating Envelope
    myEnvelope = dfsle.EnvelopeService.getEmptyEnvelope(
                    new dfsle.Entity(mySourceId)) // The initiating Salesforce entity.
            
                    .withDocuments(new List<dfsle.Document> { myDocument })
                    .withCustomFields(new List<dfsle.CustomField> {myField})
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
        system.debug('URl2:' + mySigningUrl.getPath());
        PageReference pg = new PageReference(mySigningUrl.toExternalForm());
        pg.setRedirect(true);
        return pg;
    }
}