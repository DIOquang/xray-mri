package com.mycompany.app.model;

public class Product {
    private String productID;
    private String name;
    private String description;
    private Double unitPrice;
    
    public String getProductID() { return productID; }
    public void setProductID(String productID) { this.productID = productID; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public Double getUnitPrice() { return unitPrice; }
    public void setUnitPrice(Double unitPrice) { this.unitPrice = unitPrice; }
}