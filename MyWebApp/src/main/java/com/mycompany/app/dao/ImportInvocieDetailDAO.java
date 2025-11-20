package com.mycompany.app.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.mycompany.app.model.ImportDetail;
import com.mycompany.app.model.ImportInvocie;
import com.mycompany.app.model.Supplier;
import com.mycompany.app.util.DatabaseUtil;

/**
 * Bản đổi tên của ImportReceiptDetailDAO -> ImportInvocieDetailDAO
 * Giữ nguyên truy vấn và logic.
 */
public class ImportInvocieDetailDAO {
    public ImportInvocie getImportReceiptByID(String importReceiptID) {
        ImportInvocie receipt = null;
        String sql = "SELECT * FROM ImportReceipt WHERE importReceiptID = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, importReceiptID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    receipt = new ImportInvocie();
                    receipt.setImportReceiptID(rs.getString("importReceiptID"));
                    receipt.setImportDate(rs.getDate("importDate"));
                    receipt.setTotalValue(rs.getDouble("totalValue"));
                    receipt.setStatus(rs.getString("status"));
                    receipt.setSupplierID(rs.getString("supplierID"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return receipt;
    }

    public List<ImportDetail> getImportDetails(String importReceiptID) {
        List<ImportDetail> list = new ArrayList<>();
        String sql = "SELECT id.*, p.name AS productName, p.description AS productDescription " +
                     "FROM ImportDetail id " +
                     "JOIN Product p ON id.productID = p.productID " +
                     "WHERE id.importReceiptID = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, importReceiptID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ImportDetail detail = new ImportDetail();
                    detail.setImportDetailID(rs.getString("importDetailID"));
                    detail.setQuantity(rs.getInt("quantity"));
                    detail.setImportPrice(rs.getDouble("importPrice"));
                    detail.setImportReceiptID(rs.getString("importReceiptID"));
                    detail.setProductID(rs.getString("productID"));
                    detail.setProductName(rs.getString("productName"));
                    detail.setProductDescription(rs.getString("productDescription"));
                    list.add(detail);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Supplier getSupplierInfo(String supplierID) {
        Supplier supplier = null;
        String sql = "SELECT * FROM Supplier WHERE supplierID = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, supplierID);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    supplier = new Supplier();
                    supplier.setSupplierID(rs.getString("supplierID"));
                    supplier.setName(rs.getString("name"));
                    supplier.setAddress(rs.getString("address"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return supplier;
    }
}
