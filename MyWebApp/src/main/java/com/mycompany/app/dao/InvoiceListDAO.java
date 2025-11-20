package com.mycompany.app.dao;

import com.mycompany.app.model.Invoice;
import com.mycompany.app.util.DatabaseUtil;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class InvoiceListDAO {
    
    public List<Invoice> getInvoiceList(String userCustomerID) {
        List<Invoice> list = new ArrayList<>();
        
        String sql = "SELECT i.* FROM Invoice i " +
                     "JOIN `Order` o ON i.orderID = o.orderID " +
                     "WHERE o.userCustomerID = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, userCustomerID);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Invoice inv = new Invoice();
                    inv.setInvoiceID(rs.getString("invoiceID"));
                    inv.setCreationDate(rs.getDate("creationDate"));
                    inv.setTotalValue(rs.getDouble("totalValue"));
                    inv.setStatus(rs.getString("status"));
                    inv.setOrderID(rs.getString("orderID"));
                    list.add(inv);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    

    public double getTotalPurchaseAmount(String userCustomerID) {
        double totalAmount = 0.0;
        
        String sql = "SELECT SUM(i.totalValue) AS totalSum FROM Invoice i " +
                     "JOIN `Order` o ON i.orderID = o.orderID " +
                     "WHERE o.userCustomerID = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, userCustomerID);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    totalAmount = rs.getDouble("totalSum");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return totalAmount;
    }
}