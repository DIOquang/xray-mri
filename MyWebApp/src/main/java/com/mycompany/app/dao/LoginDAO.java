package com.mycompany.app.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.mycompany.app.model.Customer;
import com.mycompany.app.model.Manager;
import com.mycompany.app.util.DatabaseUtil;

public class LoginDAO {

    public Customer checkLoginCustomer(String username, String password) {
        Customer customer = null;
        
        String sql = "SELECT c.*, u.logginname FROM Customer c " +
                     "JOIN `User` u ON c.userID = u.userID " +
                     "WHERE u.logginname = ? AND u.password = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, username);
            ps.setString(2, password);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    customer = new Customer();
                    customer.setUserCustomerID(rs.getString("userCustomerID"));
                    customer.setUserID(rs.getString("userID"));
                    customer.setLogginname(rs.getString("logginname"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return customer;
    }
    
    public Manager checkLoginManager(String username, String password) {
        Manager manager = null;
        
        String sql = "SELECT m.*, u.logginname FROM Manager m " +
                     "JOIN Employee e ON m.employeeID = e.employeeID " +
                     "JOIN `User` u ON e.userID = u.userID " +
                     "WHERE u.logginname = ? AND u.password = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, username);
            ps.setString(2, password);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    manager = new Manager();
                    manager.setUserManagerID(rs.getString("userManagerID"));
                    manager.setEmployeeID(rs.getString("employeeID"));
                    manager.setLogginname(rs.getString("logginname"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return manager;
    }
    
    public String checkUserType(String username, String password) {
        // Check if customer
        Customer customer = checkLoginCustomer(username, password);
        if (customer != null) {
            return "customer";
        }
        
        // Check if manager
        Manager manager = checkLoginManager(username, password);
        if (manager != null) {
            return "manager";
        }
        
        return null;
    }
}