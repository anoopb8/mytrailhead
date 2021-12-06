global class CaseWithVendorCLS3 {

public Case caseObj {get;set;}

public Attachment attachment {
  get {
      if (attachment == null)
        attachment = new Attachment();
      return attachment;
    }
  set;
}

public CaseWithVendorCLS3(){
 caseObj = new Case();
 

}

public PageReference save(){

system.debug('attachment>>' + attachment);

PageReference pgr=null;
/*
if((caseObj.Vendor_Number__c !=null && caseObj.Vendor_Number__c.length()>0) && caseObj.Has_Vendor_Number__c =='Yes'){
 List<Account> accList = [Select id from Account where accountNumber = :caseObj.Vendor_Number__c Limit 1];
 system.debug('accList is-->'+accList );

 if(accList !=null && accList.size()>0){
   caseObj.AccountID = accList.get(0).id;
   List<Contact> contctsLst = [select id, Email,Phone from Contact where accountId= :accList.get(0).id];
   if(contctsLst  !=null && contctsLst.size()>0){
    system.debug('accObj.contacts-->'+contctsLst);
     caseObj.ContactID =  contctsLst.get(0).id;
     caseObj.SuppliedEmail =  contctsLst.get(0).Email;
     caseObj.SuppliedPhone =  contctsLst.get(0).Phone;
   }
 }
 else{
  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Account details with vendor number is not available.'));
   return pgr;
 }
 }
 else if(caseObj.Vendor_Number__c ==null && caseObj.Has_Vendor_Number__c =='Yes'){
   ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please provide vendor number if you have vendor Number.'));
   return pgr;
 }
   system.debug('caseObj values is=='+caseObj);
   try{
   insert caseObj;
  if(attachment.name != null && attachment.name.length()>0){
    attachment.OwnerId = UserInfo.getUserId();
    attachment.ParentId = caseObj.id; // the record the file is attached to
    attachment.IsPrivate = false;
    insert attachment;
  }
   
  pgr = new PageReference('/apex/caseWithVendorThankyou');
  pgr.setRedirect(true);
   
  }catch(Exception e){
    system.debug('exception is-->'+e.getMessage());
 }
  */
return pgr;

}


}