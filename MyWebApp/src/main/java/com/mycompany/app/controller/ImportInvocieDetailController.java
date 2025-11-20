package com.mycompany.app.controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.mycompany.app.dao.ImportInvocieDetailDAO;
import com.mycompany.app.model.ImportDetail;
import com.mycompany.app.model.ImportInvocie;
import com.mycompany.app.model.Manager;
import com.mycompany.app.model.Supplier;

@WebServlet("/importReceiptDetail")
public class ImportInvocieDetailController extends HttpServlet {
    private ImportInvocieDetailDAO importReceiptDetailDAO;

    @Override
    public void init() {
        importReceiptDetailDAO = new ImportInvocieDetailDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String userType = (String) session.getAttribute("userType");
        Manager manager = (Manager) session.getAttribute("manager");

        if (!"manager".equals(userType) || manager == null) {
            request.setAttribute("error", "Access denied! Only Managers can view import receipt details.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        String importReceiptID = request.getParameter("importReceiptID");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");

        if (importReceiptID != null && !importReceiptID.isEmpty()) {
            ImportInvocie importReceipt = importReceiptDetailDAO.getImportReceiptByID(importReceiptID);
            if (importReceipt != null) {
                Supplier supplier = importReceiptDetailDAO.getSupplierInfo(importReceipt.getSupplierID());
                List<ImportDetail> importDetails = importReceiptDetailDAO.getImportDetails(importReceiptID);
                request.setAttribute("importReceipt", importReceipt);
                request.setAttribute("supplier", supplier);
                request.setAttribute("importDetails", importDetails);
            } else {
                request.setAttribute("error", "Import receipt not found with ID: " + importReceiptID);
            }
        } else {
            request.setAttribute("error", "Missing import receipt ID.");
        }

        if (startDate != null) request.setAttribute("startDate", startDate);
        if (endDate != null) request.setAttribute("endDate", endDate);

        request.getRequestDispatcher("uiImportInvocieDetail.jsp").forward(request, response);
    }
}
