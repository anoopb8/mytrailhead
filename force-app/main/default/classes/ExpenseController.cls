//TODO: ALWAYS be sure to substitute your org's namespace where you see ctsanoop
public class ExpenseController {
   
    //Action method to return the expense list called from client side JavaScript controller
    @AuraEnabled
    public static List<ctsanoop__Expense__c> getExpenses() {

        return [SELECT id
                    ,name
                    ,ctsanoop__amount__c
                    ,ctsanoop__client__c
                    ,ctsanoop__date__c
                    ,ctsanoop__reimbursed__c
                    ,ctsanoop__approved__c
                    ,ctsanoop__Name__c
                FROM 
                    ctsanoop__Expense__c 
                ORDER BY 
                    createdDate ASC
               ];
    }    

    //Save method called from client side JavaScript controller
    @AuraEnabled
    public static ctsanoop__Expense__c saveExpense(ctsanoop__Expense__c expense) {
        upsert expense;
        return expense;
    }
   
}