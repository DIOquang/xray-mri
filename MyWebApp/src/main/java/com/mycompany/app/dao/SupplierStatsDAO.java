package com.mycompany.app.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.mycompany.app.model.Supplier;
import com.mycompany.app.util.DatabaseUtil;

/**
 * DAO phục vụ thống kê nhà cung cấp (SupplierStatsController)
 * Chức năng: Tổng hợp dữ liệu supplier với phiếu nhập hàng theo khoảng thời gian
 */
public class SupplierStatsDAO {
    
    /**
     * Lấy thống kê các supplier dựa trên ImportReceipt (phiếu nhập hàng)
     * KHÔNG dùng Invoice (hóa đơn của khách hàng)
     * 
     * @param startDate Ngày bắt đầu (format: yyyy-MM-dd)
     * @param endDate Ngày kết thúc (format: yyyy-MM-dd)
     * @return Danh sách Supplier với aggregate data (totalOrders, totalRevenue)
     */
    public List<Supplier> getSupplierStats(String startDate, String endDate) {
        List<Supplier> list = new ArrayList<>();
        
        String sql = "SELECT s.supplierID, s.name, s.address, " +
                     "COUNT(ir.importReceiptID) AS totalImports, " +
                     "COALESCE(SUM(ir.totalValue), 0) AS totalRevenue " +
                     "FROM Supplier s " +
                     "LEFT JOIN ImportReceipt ir ON s.supplierID = ir.supplierID " +
                     "WHERE ir.importDate BETWEEN ? AND ? " +
                     "GROUP BY s.supplierID, s.name, s.address " +
                     "ORDER BY totalRevenue DESC";
        
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, startDate);
            ps.setString(2, endDate);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Supplier supplier = new Supplier();
                    supplier.setSupplierID(rs.getString("supplierID"));
                    supplier.setName(rs.getString("name"));
                    supplier.setAddress(rs.getString("address"));
                    supplier.setTotalOrders(rs.getInt("totalImports")); // Số lượng phiếu nhập
                    supplier.setTotalRevenue(rs.getDouble("totalRevenue")); // Tổng giá trị nhập
                    list.add(supplier);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
