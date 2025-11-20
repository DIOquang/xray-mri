package com.mycompany.app.model;

import java.util.Date;

public class Invoice {
    private String invoiceID;
    private Date creationDate;
    private Double totalValue;
    private String status;
    private String orderID;
    
    public Invoice() {}

    public String getInvoiceID() { return invoiceID; }
    public Date getCreationDate() { return creationDate; }
    public Double getTotalValue() { return totalValue; }
    public String getStatus() { return status; }
    public String getOrderID() { return orderID; }

    public void setInvoiceID(String invoiceID) { this.invoiceID = invoiceID; }
    public void setCreationDate(Date creationDate) { this.creationDate = creationDate; }
    public void setTotalValue(Double totalValue) { this.totalValue = totalValue; }
    public void setStatus(String status) { this.status = status; }
    public void setOrderID(String orderID) { this.orderID = orderID; }
}