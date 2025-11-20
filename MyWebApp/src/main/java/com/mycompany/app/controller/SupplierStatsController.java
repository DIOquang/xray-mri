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

import com.mycompany.app.dao.SupplierStatsDAO;
import com.mycompany.app.model.Manager;
import com.mycompany.app.model.Supplier;

@WebServlet("/supplierStats")
public class SupplierStatsController extends HttpServlet {
    
    private SupplierStatsDAO supplierStatsDAO;
    
    @Override
    public void init() {
        supplierStatsDAO = new SupplierStatsDAO();
    }    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String userType = (String) session.getAttribute("userType");
        Manager manager = (Manager) session.getAttribute("manager");
        
        // Check if user is manager
        if (!"manager".equals(userType) || manager == null) {
            response.sendRedirect("main");
            return;
        }
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("uiSupplierList.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String userType = (String) session.getAttribute("userType");
        Manager manager = (Manager) session.getAttribute("manager");
        
        // Check if user is manager
        if (!"manager".equals(userType) || manager == null) {
            response.sendRedirect("main");
            return;
        }
        
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String statisticType = request.getParameter("statisticType");
        
        // Default to revenue if not specified
        if (statisticType == null || statisticType.isEmpty()) {
            statisticType = "revenue";
        }
        
        if (startDate != null && endDate != null && !startDate.isEmpty() && !endDate.isEmpty()) {
            // Currently only revenue statistics is implemented
            if ("revenue".equals(statisticType)) {
                    List<Supplier> supplierList = supplierStatsDAO.getSupplierStats(startDate, endDate);
                request.setAttribute("supplierList", supplierList);
            } else {
                // For other types, show message that feature is not implemented yet
                request.setAttribute("message", "This statistic type is under development. Please select Revenue Statistics.");
            }
            
            request.setAttribute("startDate", startDate);
            request.setAttribute("endDate", endDate);
            request.setAttribute("statisticType", statisticType);
        }
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("uiSupplierList.jsp");
        dispatcher.forward(request, response);
    }
}
