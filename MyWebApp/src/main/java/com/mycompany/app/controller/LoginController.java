package com.mycompany.app.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.mycompany.app.dao.LoginDAO;
import com.mycompany.app.model.Customer;
import com.mycompany.app.model.Manager;

@WebServlet("/login")
public class LoginController extends HttpServlet {
    
    private LoginDAO loginDAO;

    @Override
    public void init() {
        loginDAO = new LoginDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String user = request.getParameter("username");
        String pass = request.getParameter("password");
        
        // Check user type
        String userType = loginDAO.checkUserType(user, pass);
        
        if (userType != null) {
            HttpSession session = request.getSession();
            
            if ("customer".equals(userType)) {
                Customer customer = loginDAO.checkLoginCustomer(user, pass);
                session.setAttribute("cus", customer);
                session.setAttribute("userType", "customer");
                response.sendRedirect("main");
            } else if ("manager".equals(userType)) {
                Manager manager = loginDAO.checkLoginManager(user, pass);
                session.setAttribute("manager", manager);
                session.setAttribute("userType", "manager");
                response.sendRedirect("main");
            }
        } else {
            request.setAttribute("error", "Sai tên đăng nhập hoặc mật khẩu!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }
}