package com.mycompany.app.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.mycompany.app.model.Invoice;
import com.mycompany.app.model.OrderDetail;
import com.mycompany.app.model.Product;
import com.mycompany.app.util.DatabaseUtil;

public class InvoiceDetailDAO {
    
    public Invoice getInvoiceByOrderID(String orderID) {
        Invoice invoice = null;
        String sql = "SELECT * FROM Invoice WHERE orderID = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, orderID);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    invoice = new Invoice();
                    invoice.setInvoiceID(rs.getString("invoiceID"));
                    invoice.setCreationDate(rs.getDate("creationDate"));
                    invoice.setTotalValue(rs.getDouble("totalValue"));
                    invoice.setStatus(rs.getString("status"));
                    invoice.setOrderID(rs.getString("orderID"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return invoice;
    }

    public List<OrderDetail> getOrderDetail(String orderID) {
        List<OrderDetail> list = new ArrayList<>();
        String sql = "SELECT od.*, p.name as productName, p.description, p.unitPrice as productPrice " +
                     "FROM OrderDetail od " +
                     "JOIN Product p ON od.productID = p.productID " +
                     "WHERE od.orderID = ?";

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, orderID);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product p = new Product();
                    p.setProductID(rs.getString("productID"));
                    p.setName(rs.getString("productName"));
                    p.setDescription(rs.getString("description"));
                    p.setUnitPrice(rs.getDouble("productPrice"));

                    OrderDetail od = new OrderDetail();
                    od.setOrderDetailID(rs.getString("orderDetailID"));
                    od.setOrderID(rs.getString("orderID"));
                    od.setQuantity(rs.getInt("quantity"));
                    od.setUnitPrice(rs.getDouble("unitPrice")); 
                    
                    od.setProduct(p);
                    
                    list.add(od);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}