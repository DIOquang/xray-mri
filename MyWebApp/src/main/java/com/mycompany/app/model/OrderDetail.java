package com.mycompany.app.model;

public class OrderDetail {
    private String orderDetailID;
    private Integer quantity;
    private Double unitPrice;
    private String productID;
    private String orderID;

    private Product product;

    public Integer getQuantity() { return quantity; }
    public void setQuantity(Integer quantity) { this.quantity = quantity; }
    public Double getUnitPrice() { return unitPrice; }
    public void setUnitPrice(Double unitPrice) { this.unitPrice = unitPrice; }
    public String getProductID() { return productID; }
    public void setProductID(String productID) { this.productID = productID; }
    public String getOrderID() { return orderID; }
    public void setOrderID(String orderID) { this.orderID = orderID; }
    public Product getProduct() { return product; }
    public void setProduct(Product product) { this.product = product; }
    public String getOrderDetailID() { return orderDetailID; }
    public void setOrderDetailID(String orderDetailID) { this.orderDetailID = orderDetailID; }
}