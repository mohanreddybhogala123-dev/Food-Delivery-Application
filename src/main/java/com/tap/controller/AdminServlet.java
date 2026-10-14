package com.tap.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.tap.model.User;
import com.tap.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/AdminServlet")
public class AdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect("admin.jsp");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("loggedInUser");

        // Check if user is logged in
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        // Optional: If you want to restrict to specific admin emails or check a role if you added it later
        // For now, we allow logged-in management or check if user.getEmail().contains("admin")
        
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            String foodName = request.getParameter("foodName");
            double price = Double.parseDouble(request.getParameter("price"));
            String imagePath = request.getParameter("imagePath");
            int restaurantId = Integer.parseInt(request.getParameter("restaurantId"));

            String query = "INSERT INTO food (foodName, price, imagePath, restaurantId) VALUES (?, ?, ?, ?)";

            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement(query)) {
                
                ps.setString(1, foodName);
                ps.setDouble(2, price);
                ps.setString(3, imagePath);
                ps.setInt(4, restaurantId);
                
                ps.executeUpdate();
                response.sendRedirect("admin.jsp?success=foodAdded");
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("admin.jsp?error=failedToAdd");
            }
        } else {
            response.sendRedirect("admin.jsp");
        }
    }
}