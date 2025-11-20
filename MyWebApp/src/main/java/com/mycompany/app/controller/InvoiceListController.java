package com.mycompany.app.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.mycompany.app.dao.InvoiceListDAO;
import com.mycompany.app.model.Customer;
import com.mycompany.app.model.Invoice;


@WebServlet("/invoiceList")
public class InvoiceListController extends HttpServlet {
    
    private InvoiceListDAO invoiceListDAO;

    @Override
    public void init() {
        invoiceListDAO = new InvoiceListDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String userType = (String) session.getAttribute("userType");
        Customer customer = (Customer) session.getAttribute("cus");
        
        // Check if user is customer
        if (!"customer".equals(userType) || customer == null) {
            response.sendRedirect("main");
            return;
        }
        
        // Lấy danh sách hóa đơn
        List<Invoice> list = invoiceListDAO.getInvoiceList(customer.getUserCustomerID());
        
        // Lấy tổng số tiền đã mua
        double totalAmount = invoiceListDAO.getTotalPurchaseAmount(customer.getUserCustomerID());
        
        // Đặt cả hai vào request
        request.setAttribute("listInvoice", list); 
        request.setAttribute("totalAmount", totalAmount);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("uiInvoiceList.jsp");
        dispatcher.forward(request, response);
    }
}