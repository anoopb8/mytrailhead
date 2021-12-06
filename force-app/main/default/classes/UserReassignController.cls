public with sharing class UserReassignController {

   private user userFromOwnerId = new user();
    private user userToOwnerId = new user();
  
    public user UserFrom { get
    {
        return userFromOwnerId;
    } 
    set
    {
        userFromOwnerId = value;
    } 
    }

    public user UserTo { get
    {
         return userToOwnerId;
    } 
    set
    {
        userToOwnerId = value;
    }
    }
}