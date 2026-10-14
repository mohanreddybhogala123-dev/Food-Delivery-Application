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

@WebServlet("/AddFoodServlet")
public class AddFoodServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        int restaurantId = Integer.parseInt(request.getParameter("restaurantId"));
        String foodName = request.getParameter("foodName");
        String description = request.getParameter("description");
        double price = Double.parseDouble(request.getParameter("price"));
        String imagePath = request.getParameter("imagePath");

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO food_items (restaurantId, foodName, description, price, imagePath) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, restaurantId);
            pstmt.setString(2, foodName);
            pstmt.setString(3, description);
            pstmt.setDouble(4, price);
            pstmt.setString(5, imagePath);
            
            pstmt.executeUpdate();
            
            response.sendRedirect("adminDashboard.jsp?success=food_added");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("addFood.jsp?error=server_error");
        }
    }
}