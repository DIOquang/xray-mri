package com.mycompany.app.model;

import java.util.Date;

/**
 * Bản đổi tên của ImportReceipt -> ImportInvocie (giữ nguyên logic/fields)
 */
public class ImportInvocie {
    private String importReceiptID;
    private Date importDate;
    private double totalValue;
    private String status;
    private String supplierID;
    
    public ImportInvocie() {}

    public ImportInvocie(String importReceiptID, Date importDate, double totalValue, String status, String supplierID) {
        this.importReceiptID = importReceiptID;
        this.importDate = importDate;
        this.totalValue = totalValue;
        this.status = status;
        this.supplierID = supplierID;
    }

    public String getImportReceiptID() { return importReceiptID; }
    public void setImportReceiptID(String importReceiptID) { this.importReceiptID = importReceiptID; }
    public Date getImportDate() { return importDate; }
    public void setImportDate(Date importDate) { this.importDate = importDate; }
    public double getTotalValue() { return totalValue; }
    public void setTotalValue(double totalValue) { this.totalValue = totalValue; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getSupplierID() { return supplierID; }
    public void setSupplierID(String supplierID) { this.supplierID = supplierID; }
}
