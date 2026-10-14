package com.tap.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import com.tap.util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/AdminOrdersServlet")
public class AdminOrdersServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");

        // Handle order status update dynamically if requested from admin panel
        if ("updateStatus".equals(action)) {
            String orderIdStr = request.getParameter("orderId");
            String newStatus = request.getParameter("status");
            if (orderIdStr != null && newStatus != null) {
                try {
                    int orderId = Integer.parseInt(orderIdStr);
                    try (Connection conn = DBConnection.getConnection();
                         PreparedStatement pstmt = conn.prepareStatement("UPDATE orders SET status = ? WHERE orderId = ? OR order_id = ?")) {
                        pstmt.setString(1, newStatus);
                        pstmt.setInt(2, orderId);
                        pstmt.setInt(3, orderId);
                        pstmt.executeUpdate();
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            response.sendRedirect("AdminOrdersServlet");
            return;
        }

        List<HashMap<String, Object>> allOrders = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection()) {
            // Flexible query supporting different schema ordering conventions
            String sql = "SELECT * FROM orders ORDER BY orderId DESC";
            try (PreparedStatement pstmt = conn.prepareStatement(sql);
                 ResultSet rs = pstmt.executeQuery()) {

                while (rs.next()) {
                    HashMap<String, Object> order = new HashMap<>();
                    
                    // Safe column extraction mapping various naming conventions
                    try { order.put("orderId", rs.getInt("orderId")); } catch (Exception e) { 
                        try { order.put("orderId", rs.getInt("order_id")); } catch (Exception ignored) {} 
                    }
                    try { order.put("userId", rs.getInt("userId")); } catch (Exception e) { 
                        try { order.put("userId", rs.getInt("user_id")); } catch (Exception ignored) {} 
                    }
                    try { order.put("userEmail", rs.getString("userEmail")); } catch (Exception e) {
                        try { order.put("userEmail", rs.getString("email")); } catch (Exception ignored) {}
                    }
                    try { order.put("address", rs.getString("address")); } catch (Exception ignored) {}
                    try { order.put("phone", rs.getString("phone")); } catch (Exception e) {
                        try { order.put("phone", rs.getString("phonenumber")); } catch (Exception ignored) {}
                    }
                    try { order.put("paymentMethod", rs.getString("paymentMode")); } catch (Exception e) {
                        try { order.put("paymentMethod", rs.getString("payment_mode")); } catch (Exception ex) {
                            try { order.put("paymentMethod", rs.getString("paymentMethod")); } catch (Exception ignored) {}
                        }
                    }
                    try { order.put("totalAmount", rs.getDouble("totalAmount")); } catch (Exception e) {
                        try { order.put("totalAmount", rs.getDouble("total_amount")); } catch (Exception ignored) {}
                    }
                    try { order.put("status", rs.getString("status")); } catch (Exception ignored) {}
                    try { order.put("orderDate", rs.getTimestamp("orderDate")); } catch (Exception e) {
                        try { order.put("orderDate", rs.getTimestamp("order_date")); } catch (Exception ignored) {}
                    }

                    allOrders.add(order);
                }
            }

            HttpSession session = request.getSession();
            session.setAttribute("allOrders", allOrders);
            request.setAttribute("allOrders", allOrders);
            
            // Forward or redirect depending on how adminOrders.jsp is configured
            request.getRequestDispatcher("adminOrders.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("adminDashboard.jsp?error=orders_load_failed");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}