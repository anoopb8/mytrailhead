public class Mergecontacts{

    // List of wrapper objects
    public List<cContact> contactList {get; set;}
    
    // Standard set controller
    ApexPages.StandardSetController setCon;
            public Mergecontacts(ApexPages.StandardSetController controller) {
            setCon = controller;
           if(SelectedContacts()) {
              ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Invalid Input.');
              ApexPages.addMessage(myMsg);
            }
            system.debug('setCon::' + setCon.getRecords());
    }
    
    // checking contacts are selected or not
    public boolean SelectedContacts() {
        if(setCon.getSelected().size() == 2  || setCon.getSelected().size() ==3 ){
         return false;
        }
        else return true;
    }
    // selected contactss  size
    public integer getMyRecordsSize() {
        return setCon.getRecords().size();
    }
    
    //retriving selected contacts details using dynamic query
    public list<contact> contacts(){

        list<id> cid = new list<id>();
        list<contact> contacts = setCon.getRecords();
        for( contact c:  contacts ){
          cid.add(c.id);
        }
        Map<String, Schema.SObjectField> contactFields             = Schema.SObjectType.Contact.fields.getMap();
        Map<String, Schema.DescribeFieldResult> standardFieldMap   = new Map<String, Schema.DescribeFieldResult>();
        Map<String, Schema.DescribeFieldResult> customFieldMap     = new Map<String, Schema.DescribeFieldResult>();    
        
        // Construct the query string
        String query = 'Select id, name, ';
        for (String fieldName : contactFields.keySet()) {
            
            Schema.SobjectField f = contactFields.get(fieldName);
            Schema.DescribeFieldResult fResult = f.getDescribe();
            
            // Only include the fields which are updateable and accessible
            if (fResult.isUpdateable() && fResult.isAccessible() ) {
            
                // If the field is type lookup, select the parent name  
                string relName = fResult.getRelationshipName();
                
                if (string.isBlank(relName)) {
                    query += (fieldName + ','); 
                } else {
                    //find the Name field for the related object
                    string nameField = getRelatedObjNameField(fResult);

                    if (nameField!=null) {
                        query += (relName + '.' + nameField + ',');
                    }
                }
                system.debug('query :: >>>' + query);
                // Collect the standard and custom fields separately for sorting
                if(fResult.isCustom()) {
                    customFieldMap.put(fieldName, fResult);
                } else {
                    standardFieldMap.put(fieldName, fResult);
                }
            }
        }
        
        
        // Adding some non-updateable system fields which we need to add to the record diff table.
        query +=  'createdby.name, createddate, LastModifiedBy.name, LastModifiedDate';
        // Finally completing the query by appending the table name and the filter clause
        query += ' from Contact where id IN :cid';        
         
       
        try {
                
                contacts = Database.query(query); // Query the records
                // Ensure we got back the same number of records as expected. In case any record got deleted/moved since last search.
                if (contacts == null || contacts.size() != cid.size()) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Some error'));
                    return contacts ;
            }
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,  'Some error2' + e));
            return contacts ;
        }        
        return contacts ;

    }
    
    private string getRelatedObjNameField(Schema.DescribeFieldResult fieldDesc) {
        string nameField = 'Name';
        Map<String, Schema.SObjectField> mapRelatedObjectFields = fieldDesc.getReferenceTo()[0].getDescribe().fields.getMap();

        //if Name isn't the correct name field, find it
        if (!mapRelatedObjectFields.containsKey(nameField)) {
            nameField = null;
            for (String relatedFieldName : mapRelatedObjectFields.keySet()) {
                if (mapRelatedObjectFields.get(relatedFieldName).getDescribe().isNameField())
                    return relatedFieldName;
            }
        }
        return nameField;
    }    
    
    
    // retriving contact fields
    public List<cContact> getContactsf() {

        list<contact> MergingContacts = contacts();
        Map<String, Schema.SObjectField> contactFields = Schema.SObjectType.Contact.fields.getMap();
        system.debug('contactFields:::' +contactFields);
        
        if(contactList == null) {

            contactList  = new List<cContact>();
            list<id> cid = new list<id>();
            list<contact> contacts = contacts();
            for(contact c:  contacts ){
                cid.add(c.id);
            }
            contactList.add(new cContact('Master Record',cid[0],cid[1],cid[2]));

            for (String fieldName : contactFields.keySet()) {

                Schema.SobjectField f               = contactFields.get(fieldName);
                Schema.DescribeFieldResult fResult  = f.getDescribe();
    
                if (fResult.isUpdateable() && fResult.isAccessible() ) {
                    
                    string relName = fResult.getRelationshipName();
                    
                    if (string.isBlank(relName)) {
                           String fieldlabel = contactFields.get(fieldName).getDescribe().getLabel().toupperCase();
                           contact c0=MergingContacts[0];
                           contact c1=MergingContacts[1];
                           contact c2=MergingContacts[2];                                                      
                          
                           Object Val1 = c0.get(fieldName);
                           Object Val2 = c1.get(fieldName);
                           Object Val3 = c2.get(fieldName);
                           contactList.add(new cContact(fieldlabel,Val1 , Val2, Val3));
                    }
                    else {
                         string nameField = getRelatedObjNameField(fResult);
                            if (nameField!=null) {
                                  String fName = (relName + '.' + nameField);
                                  
                                  String fieldlabel = contactFields.get(fieldName).getDescribe().getLabel().toupperCase();
                                  contact c0=MergingContacts[0];
                                  contact c1=MergingContacts[1];
                                  contact c2=MergingContacts[2];
                                  
                                  Sobject obj1 = c0.getSObject(contactFields.get(fieldName).getDescribe().getRelationshipName());
                                  Sobject obj2 = c1.getSObject(contactFields.get(fieldName).getDescribe().getRelationshipName());
                                  Sobject obj3 = c2.getSObject(contactFields.get(fieldName).getDescribe().getRelationshipName());
                                  
                                  Object Val1 = c0.get(fieldName);
                                  Object Val2 = c1.get(fieldName);
                                  Object Val3 = c2.get(fieldName);
                                  
                                  system.debug('Inside related field >>>>C0' + MergingContacts[0] );
                                  contactList.add(new cContact(fieldlabel,Val1 , Val2, Val3,true,obj1.id,obj2.id,obj3.id));
                                
                            }                  
                         
                         
                         
                         
                    }                    
                    
                }
               
            }
        }
        return contactList;
    }
    
    
       public PageReference mergeContacts() {
    
            List<object> selectedContacts = new List<object>();
            Map<String, Schema.SObjectField> contactFields = Schema.SObjectType.Contact.fields.getMap();
            Id MasterContactid ;
            list<Id> duplicatesid = new list<Id>();
            list<contact> contacts = contacts();
            SObject dsr  =[Select id from contact limit 1];

            //We will cycle through our list of cContacts and will check to see if the selected property is set to true, if it is we add the Contact to the selectedContacts list
            for(cContact cCon: getContactsf()) {
                
                if(cCon.Name == 'Master Record'){
                    
                    if(cCon.selected1 ) {
                        MasterContactid  = (id)cCon.Value1;
                        duplicatesid.add((id)cCon.Value2);
                        duplicatesid.add((id)cCon.Value3);                            
                        dsr.put('id',cCon.Value1);
                    }
                    if(cCon.selected2 ) {
                        MasterContactid  = (id)cCon.Value2;
                        duplicatesid.add((id)cCon.Value1);
                        duplicatesid.add((id)cCon.Value3);                            
                        dsr.put('id',cCon.Value2);
                    }
                    if(cCon.selected3) {
                        MasterContactid  = (id)cCon.Value3;
                        duplicatesid.add((id)cCon.Value1);
                        duplicatesid.add((id)cCon.Value2);                            
                        dsr.put('id',cCon.Value3);
                    }                  
                }
                for (String fieldName : contactFields.keySet()) {
                    
                    String fieldlabel = contactFields.get(fieldName).getDescribe().getLabel().toupperCase();
                    
                    system.debug('fieldlabel : cCon.Name >>' +fieldlabel + ':' +cCon.Name);
                    //system.debug('cCon.Name >>' +cCon.Name);
                    
                    if(fieldlabel ==cCon.Name && fieldlabel !='SSN'  ){
                       
                       system.debug('fieldName Updating>>' +  fieldName );
                       if(cCon.selected1 ) {
                            dsr.put(fieldName,cCon.Value1);
                            selectedContacts.add(cCon.Value1);
                       }
                       if(cCon.selected2 ) {
                            dsr.put(fieldName,cCon.Value2);
                       }
                       if(cCon.selected3 ) {
                            dsr.put(fieldName,cCon.Value3);
                       }
                    } 
                }
            }
            System.debug('updating Contact : >>>>'  +  dsr);
            
            
            
            // Identofying master and to be deteled contacted
            contact MasterCOntact = new contact();
            MasterContact.id =MasterContactid; 
            list<contact> duplicates = new list<contact>();
            for( id i: duplicatesid){
                contact c= new contact();
                c.id =i; 
                duplicates.add(c);
            }
            system.debug('MasterContact >>' + MasterContact);
            system.debug('duplicates    >>' + duplicates);
            
            Database.MergeResult[] results = Database.merge(MasterContact, duplicates, false);
            update dsr;
            System.debug('Select Values : >>>>'  +  selectedContacts);
            
            PageReference contactPage = new ApexPages.StandardController(dsr).view();
            contactPage.setRedirect(true);
            return contactPage ;

        }
    
        // This is our wrapper class  
        public class cContact {
            public String Name {get; set;}
            public boolean isrelated{get; set;}
            public Object Value1 {get; set;}            
            public Object Value2 {get; set;}            
            public Object Value3 {get; set;}
            
            public string relValue1 {get; set;}            
            public string relValue2 {get; set;}            
            public string relValue3 {get; set;}                                    
                                                
            
            public Boolean selected1 {get; set;}
            public Boolean selected2 {get; set;}
            public Boolean selected3 {get; set;}                        
    
            //This is the contructor method. When we create a new cContact object we pass a Contact that is set to the con property. We also set the selected value to false
            public cContact(String Name, Object Value1, Object Value2, Object Value3,boolean isrelated,string relValue1,string relValue2, string relValue3  ) {
                this.isrelated =isrelated;
                if(isrelated){
                    this.Name = Name;   
                    this.Value1 = Value1;
                    this.Value2 = Value2;
                    this.Value3 = Value3;
                    this.relValue1 =relValue1;
                    this.relValue2 =relValue2;
                    this.relValue3 =relValue3;
                    this.selected1 = true;
                    this.selected2 = false;
                    this.selected3 = false;
                }                
            }
            public cContact(String Name, Object Value1, Object Value2, Object Value3  ) {
                this.isrelated =false;
                this.Name = Name;
                this.Value1 = Value1;
                this.Value2 = Value2;
                this.Value3 = Value3;
                this.relValue1 =null;
                this.relValue2 =null;
                this.relValue3 =null;
                this.selected1 = true;
                this.selected2 = false;
                this.selected3 = false;
                
            }
            
        
    }
        

}