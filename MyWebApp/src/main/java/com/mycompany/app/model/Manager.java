package com.mycompany.app.model;

public class Manager {
    private String userManagerID;
    private String employeeID;
    private String userID;
    private String logginname;
    
    public Manager() {}

    public String getUserManagerID() { return userManagerID; }
    public void setUserManagerID(String userManagerID) { this.userManagerID = userManagerID; }
    
    public String getEmployeeID() { return employeeID; }
    public void setEmployeeID(String employeeID) { this.employeeID = employeeID; }
    
    public String getUserID() { return userID; }
    public void setUserID(String userID) { this.userID = userID; }
    
    public String getLogginname() { return logginname; }
    public void setLogginname(String logginname) { this.logginname = logginname; }
}
