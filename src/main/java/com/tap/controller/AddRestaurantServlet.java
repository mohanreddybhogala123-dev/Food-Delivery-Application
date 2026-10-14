package com.tap.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import com.tap.util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/AddRestaurantServlet")
public class AddRestaurantServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String restaurantName = request.getParameter("restaurantName");
        String cuisineType = request.getParameter("cuisineType");
        String deliveryTime = request.getParameter("deliveryTime");
        String imagePath = request.getParameter("imagePath");

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO restaurants (restaurantName, cuisineType, deliveryTime, imagePath) VALUES (?, ?, ?, ?)";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, restaurantName);
            pstmt.setString(2, cuisineType);
            pstmt.setString(3, deliveryTime);
            pstmt.setString(4, imagePath);
            
            pstmt.executeUpdate();
            
            response.sendRedirect("adminDashboard.jsp?success=restaurant_added");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("addRestaurant.jsp?error=server_error");
        }
    }
}