package com.mycompany.app.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.mycompany.app.dao.InvoiceDetailDAO;
import com.mycompany.app.model.Invoice;
import com.mycompany.app.model.OrderDetail;

@WebServlet("/invoiceDetail")
public class InvoiceDetailController extends HttpServlet {
    
    private InvoiceDetailDAO invoiceDetailDAO;

    @Override
    public void init() {
        invoiceDetailDAO = new InvoiceDetailDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String orderID = request.getParameter("orderID");
        
        // Get invoice information
        Invoice invoice = invoiceDetailDAO.getInvoiceByOrderID(orderID);
        request.setAttribute("invoice", invoice);
        
        // Get order details
        List<OrderDetail> detailList = invoiceDetailDAO.getOrderDetail(orderID);
        request.setAttribute("invoiceDetail", detailList);
        
        request.setAttribute("orderID", orderID); 
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("uiInvoiceDetail.jsp");
        dispatcher.forward(request, response);
    }
}