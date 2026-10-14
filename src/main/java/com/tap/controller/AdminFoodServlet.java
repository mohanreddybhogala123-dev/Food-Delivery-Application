package com.tap.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.tap.util.DBConnection;

@WebServlet("/AdminFoodServlet")
public class AdminFoodServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            String foodName = request.getParameter("foodName");
            String priceStr = request.getParameter("price");
            String restaurantIdStr = request.getParameter("restaurantId");

            try {
                double price = Double.parseDouble(priceStr);
                int restaurantId = restaurantIdStr != null ? Integer.parseInt(restaurantIdStr) : 1;

                try (Connection con = DBConnection.getConnection();
                     PreparedStatement pstmt = con.prepareStatement("INSERT INTO food (foodName, price, restaurantId, isAvailable) VALUES (?, ?, ?, 1)")) {
                    pstmt.setString(1, foodName);
                    pstmt.setDouble(2, price);
                    pstmt.setInt(3, restaurantId);
                    pstmt.executeUpdate();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else if ("delete".equals(action)) {
            String foodIdStr = request.getParameter("foodId");
            try {
                int foodId = Integer.parseInt(foodIdStr);
                try (Connection con = DBConnection.getConnection();
                     PreparedStatement pstmt = con.prepareStatement("DELETE FROM food WHERE foodId = ? OR id = ?")) {
                    pstmt.setInt(1, foodId);
                    pstmt.setInt(2, foodId);
                    pstmt.executeUpdate();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        response.sendRedirect("adminMenu.jsp");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect("adminMenu.jsp");
    }
}