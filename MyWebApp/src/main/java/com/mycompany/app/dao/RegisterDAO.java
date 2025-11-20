package com.mycompany.app.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import com.mycompany.app.util.DatabaseUtil;

public class RegisterDAO {
    
    /**
     * Kiểm tra xem username đã tồn tại trong hệ thống chưa
     */
    public boolean isUsernameExists(String username) {
        String sql = "SELECT COUNT(*) FROM User WHERE logginname = ?";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Tạo tài khoản khách hàng mới
     * @return true nếu đăng ký thành công, false nếu thất bại
     */
    public boolean registerCustomer(String username, String password, String address, String phone, String email) {
        Connection conn = null;
        PreparedStatement psUser = null;
        PreparedStatement psCustomer = null;
        
        try {
            conn = DatabaseUtil.getConnection();
            conn.setAutoCommit(false); // Bắt đầu transaction
            
            // 1. Tìm userID lớn nhất hiện tại
            String getMaxUserID = "SELECT COALESCE(MAX(userID), 0) FROM User";
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(getMaxUserID);
            int newUserID = 1;
            if (rs.next()) {
                newUserID = rs.getInt(1) + 1;
            }
            stmt.close();
            
            // 2. Insert vào bảng User
            String insertUser = "INSERT INTO User (userID, logginname, password) VALUES (?, ?, ?)";
            psUser = conn.prepareStatement(insertUser);
            psUser.setInt(1, newUserID);
            psUser.setString(2, username);
            psUser.setString(3, password);
            psUser.executeUpdate();
            
            // 3. Tìm userCustomerID lớn nhất
            String getMaxCustomerID = "SELECT COALESCE(MAX(userCustomerID), 0) FROM Customer";
            stmt = conn.createStatement();
            rs = stmt.executeQuery(getMaxCustomerID);
            int newCustomerID = 1;
            if (rs.next()) {
                newCustomerID = rs.getInt(1) + 1;
            }
            stmt.close();
            
            // 4. Insert vào bảng Customer
            String insertCustomer = "INSERT INTO Customer (userCustomerID, userID, address, phoneNumber, email) VALUES (?, ?, ?, ?, ?)";
            psCustomer = conn.prepareStatement(insertCustomer);
            psCustomer.setInt(1, newCustomerID);
            psCustomer.setInt(2, newUserID);
            psCustomer.setString(3, address);
            psCustomer.setString(4, phone);
            psCustomer.setString(5, email);
            psCustomer.executeUpdate();
            
            conn.commit(); // Commit transaction
            return true;
            
        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback(); // Rollback nếu có lỗi
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            return false;
        } finally {
            try {
                if (psUser != null) psUser.close();
                if (psCustomer != null) psCustomer.close();
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
