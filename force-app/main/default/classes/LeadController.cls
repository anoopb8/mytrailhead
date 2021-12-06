//TODO: ALWAYS be sure to substitute your org's namespace where you see ctsanoop
public class LeadController {
   
    //Action method to return the expense list called from client side JavaScript controller
    @AuraEnabled
    public static List<lead> getleads() {

        return [SELECT ID,name
                FROM   Lead
 

               
               ];
    }    

   
}