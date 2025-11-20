package com.mycompany.app.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseUtil {
    
    private static final String DB_URL = "jdbc:mysql://localhost:3306/pttk";
    private static final String USER = "root";
    private static final String PASS = "Quang1210=";

    public static Connection getConnection() {
        Connection conn = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(DB_URL, USER, PASS);
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            System.out.println("Database connection error!");
        }
        return conn;
    }

    public static void main(String[] args) {
        if(getConnection() != null){
            System.out.println("Database connection successful!");
        }
    }
}