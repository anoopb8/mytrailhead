public class CON_ContactMerge {
    
    /*******************************************************************************************************
    * @description Min number of contacts that can be merged.
    */
    public final Integer MERGE_MINIMUM = 2;
    
    /*******************************************************************************************************
    * @description Max number of contacts that can be merged.
    */
    public final Integer MERGE_LIMIT = 3;
    
    /*******************************************************************************************************
    * @description Contact for the winning record.
    */
    public Contact winner {get; set;}
    
    /*******************************************************************************************************
    * @description List for the losing records.
    */
    public List<Contact> losers {get; set;}
    
    /*******************************************************************************************************
    * @description Exception raised by the contact merge process.
    */
    public class ConMergeException extends Exception {} 
        
    /*******************************************************************************************************
    * @description Merges the winner and losers.
    * @param winner The winner record.
    * @param losers The loser records.
    * @return Boolean Whether the merge was successful.
    */
    public static Boolean mergeContacts(Contact winner, List<Contact> losers) {
        boolean successfulMerge = false;
        
        List<Account> winnerAccount = new List<Account>();
        Set<Id> loserAccountIds = new Set<Id>();
        List<Account> loserAccounts = new List<Account>();
        List<Account> loserAccountsToBeMerged = new List<Account>();
        List<Account> loserAccountsToBeDeleted = new List<Account>();
    
        Id winningAccountId = null;
        Boolean winnerAccountIsOneToOne = false;
        winner = [Select Account.Id from Contact where Id=:winner.Id];

        // detect PersonAccounts
        boolean isPAEnabled = UTIL_Describe.isValidField('Account', 'isPersonAccount');
        
        //get winner contact Account
        if (winner.AccountId!=null){
            ID winnerAccId = winner.AccountId;
            string strSoql = 'Select Id,npe01__SYSTEM_AccountType__c,Name';
            if (isPAEnabled)
                strSoql += ', PersonContactId ';  // note: we originally used isPersonAccount, but having the field in the sobject caused merge to fail.
            strSoql += ' from Account where Id=:winnerAccId';
            winnerAccount = database.query(strSoql);
        }
            
        if (winnerAccount.size()>0) {
            
            winningAccountId = winnerAccount[0].Id;
            
            /*if(winnerAccount[0].npe01__SYSTEM_AccountType__c==CAO_Constants.ONE_TO_ONE_ORGANIZATION_TYPE){
                winnerAccountIsOneToOne = true;
            }*/
            
            if (isPAEnabled && (ID)winnerAccount[0].get('PersonContactId') != null)
                throw new ConMergeException('TEST');
        }
           
        string strSoql = 'Select Account.Id,Account.npe01__SYSTEM_AccountType__c ';
        if (isPAEnabled)
            strSoql += ', isPersonAccount ';
        strSoql += ' from Contact where Id IN :losers ORDER BY Id ASC';
        losers = database.query(strSoql);
        
        for (Contact thisloserContact : losers) {
            if (isPAEnabled && (boolean)thisloserContact.get('isPersonAccount'))
                throw new ConMergeException('Test');
                
            //don't try to merge null Accounts or Accounts that are the same as the winner's Account
            if (thisloserContact.id!=null && thisloserContact.AccountId!=winner.AccountId) {
                loserAccountIds.add(thisloserContact.AccountId);
            }
        }
        //UTIL_Debug.debug('losers: ' + loserAccountIds);
        //UTIL_Debug.debug('winneraccountid: ' + winner.AccountId);
        
        //get loser contact Accounts that should be merged out.  This includes
        // One2One accounts and Solo Household Accounts
        loserAccountsToBeMerged = [Select Id,Name from Account a
            where Id IN :loserAccountIds 
            //and Name<>:CAO_Constants.BUCKET_ACCOUNT_NAME
            ];        
        
        //one-to-one contacts each have an Account, so when merging Contacts we have to merge Accounts as well
        //we merge the Accounts first, if there are any one-to-one Accounts or Solo Household Accounts in the mix
        if(loserAccountsToBeMerged.size()>0){                      
            merge winnerAccount[0] loserAccountsToBeMerged;
        }
        
        //merge the contacts
        
        //there is a Contact delete trigger that deletes the one-to-one Account of a Contact after it is deleted
        //merge deletes the losing Contacts, so their Accounts get deleted, which causes errors
        //to get around this, we detach the Contacts for their Accounts before we merge
        
        //create new contacts for updating as the SOSL returned contacts have read-only fields on them
        Contact winnerMakePrivate = new Contact();
        if(winnerAccountIsOneToOne){            
           // winnerMakePrivate = new Contact(Id = winner.id,AccountId = null,npe01__Private__c=true);
        } else {
            winnerMakePrivate = new Contact(Id = winner.id);
        }
        List<Contact> losersMakePrivate = new List<Contact>();
        
        for(Contact contactForUpdate : losers){
            // only do this for One2One losers
            //if (contactForUpdate.Account.npe01__SYSTEM_AccountType__c == CAO_Constants.ONE_TO_ONE_ORGANIZATION_TYPE) {       
                //Contact loserMakePrivate = new Contact(id=contactForUpdate.id,accountId=null,npe01__Private__c=true);
                //losersMakePrivate.add(loserMakePrivate);
            //}
        }
            
        //set the account to null and mark private so that trigger won't reset the Account
        if (winningAccountId!=null && winnerAccountIsOneToOne){         
            update winnerMakePrivate;           
        }
        
        if(losersMakePrivate.size()>0){
            update losersMakePrivate;
        }

        merge winnerMakePrivate losers;
        
        //set the contact Account Id back to the winning Account Id
        if (winnerAccountIsOneToOne){
            winnerMakePrivate.AccountId = winningAccountId;
            //winnerMakePrivate.npe01__Private__c = false;
            update winnerMakePrivate;
        }       
        
        //UTIL_Debug.debug('loserAccountsToBeDeleted: ' + loserAccountsToBeDeleted);
        if (loserAccountsToBeDeleted.size() > 0) {
            delete loserAccountsToBeDeleted;
        }
        successfulMerge = true;
        return successfulMerge;
    }   
}