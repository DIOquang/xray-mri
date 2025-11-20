package com.mycompany.app.model;

/**
 * Model cho ImportDetail (Chi tiết phiếu nhập hàng)
 */
public class ImportDetail {
    private String importDetailID;
    private int quantity;
    private double importPrice;
    private String importReceiptID;
    private String productID;
    
    // Thông tin sản phẩm (từ join)
    private String productName;
    private String productDescription;
    
    // Constructor
    public ImportDetail() {
    }
    
    // Getters and Setters
    public String getImportDetailID() {
        return importDetailID;
    }
    
    public void setImportDetailID(String importDetailID) {
        this.importDetailID = importDetailID;
    }
    
    public int getQuantity() {
        return quantity;
    }
    
    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
    
    public double getImportPrice() {
        return importPrice;
    }
    
    public void setImportPrice(double importPrice) {
        this.importPrice = importPrice;
    }
    
    public String getImportReceiptID() {
        return importReceiptID;
    }
    
    public void setImportReceiptID(String importReceiptID) {
        this.importReceiptID = importReceiptID;
    }
    
    public String getProductID() {
        return productID;
    }
    
    public void setProductID(String productID) {
        this.productID = productID;
    }
    
    public String getProductName() {
        return productName;
    }
    
    public void setProductName(String productName) {
        this.productName = productName;
    }
    
    public String getProductDescription() {
        return productDescription;
    }
    
    public void setProductDescription(String productDescription) {
        this.productDescription = productDescription;
    }
    
    // Tính tổng tiền cho dòng này
    public double getSubTotal() {
        return quantity * importPrice;
    }
}
