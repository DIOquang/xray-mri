package com.mycompany.app.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/main")
public class MainController extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String userType = (String) session.getAttribute("userType");
        
        // Kiểm tra xem user đã đăng nhập chưa
        if (userType == null) {
            response.sendRedirect("login");
            return;
        }
        
        // Forward đến trang chủ
        request.getRequestDispatcher("uiMain.jsp").forward(request, response);
    }
}
