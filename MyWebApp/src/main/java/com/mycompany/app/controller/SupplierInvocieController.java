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

import com.mycompany.app.dao.SupplierInvocieDAO;
import com.mycompany.app.model.ImportInvocie;
import com.mycompany.app.model.Manager;
import com.mycompany.app.model.Supplier;

@WebServlet("/supplierImportReceipts")
public class SupplierInvocieController extends HttpServlet {
    private SupplierInvocieDAO supplierReceiptsDAO;

    @Override
    public void init() {
        supplierReceiptsDAO = new SupplierInvocieDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String userType = (String) session.getAttribute("userType");
        Manager manager = (Manager) session.getAttribute("manager");

        if (!"manager".equals(userType) || manager == null) {
            response.sendRedirect("main");
            return;
        }

        String supplierID = request.getParameter("supplierID");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");

        if (supplierID != null && startDate != null && endDate != null) {
            Supplier supplier = supplierReceiptsDAO.getSupplierInfo(supplierID);
            request.setAttribute("supplier", supplier);

            List<ImportInvocie> importReceiptList = supplierReceiptsDAO.getSupplierImportReceipts(supplierID, startDate, endDate);
            request.setAttribute("importReceiptList", importReceiptList);

            request.setAttribute("startDate", startDate);
            request.setAttribute("endDate", endDate);
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("uiImportInvocieList.jsp");
        dispatcher.forward(request, response);
    }
}
