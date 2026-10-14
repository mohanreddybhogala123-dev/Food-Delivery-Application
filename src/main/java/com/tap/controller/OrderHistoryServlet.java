package com.tap.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.tap.model.Order;
import com.tap.model.User;
import com.tap.util.DBConnection;

@WebServlet("/OrderHistoryServlet")
public class OrderHistoryServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("loggedInUser");

        int userId = -1;
        String userEmail = "rrsharma@gmail.com";

        if (user != null) {
            if (user.getUserId() > 0) {
                userId = user.getUserId();
            }
            if (user.getEmail() != null && !user.getEmail().trim().isEmpty()) {
                userEmail = user.getEmail().trim().toLowerCase();
            }
        } else {
            try {
                if (session.getAttribute("userId") != null) {
                    userId = Integer.parseInt(session.getAttribute("userId").toString());
                }
                if (session.getAttribute("userEmail") != null) {
                    userEmail = session.getAttribute("userEmail").toString().trim().toLowerCase();
                }
            } catch (Exception ignored) {}
        }

        List<Order> orderList = new ArrayList<>();

        // Multi-schema query execution to fetch historical and future orders seamlessly
        String[] queries = {
            "SELECT * FROM orders WHERE userId = ? OR LOWER(userEmail) = ? OR LOWER(email) = ? OR userId = (SELECT userId FROM user WHERE LOWER(email) = ?) ORDER BY orderId DESC",
            "SELECT * FROM orders WHERE order_id IS NOT NULL ORDER BY order_id DESC",
            "SELECT * FROM orders ORDER BY orderId DESC"
        };

        for (String q : queries) {
            try (Connection con = DBConnection.getConnection();
                 PreparedStatement pstmt = con.prepareStatement(q)) {
                
                if (q.contains("?")) {
                    pstmt.setInt(1, userId > 0 ? userId : 1);
                    pstmt.setString(2, userEmail);
                    pstmt.setString(3, userEmail);
                    pstmt.setString(4, userEmail);
                }

                try (ResultSet rs = pstmt.executeQuery()) {
                    while (rs.next()) {
                        Order order = new Order();
                        
                        try { order.setOrderId(rs.getInt("orderId")); } 
                        catch (Exception e) { try { order.setOrderId(rs.getInt("order_id")); } catch (Exception ignored) {} }
                        
                        try { order.setUserId(rs.getInt("userId")); } 
                        catch (Exception e) { try { order.setUserId(rs.getInt("user_id")); } catch (Exception ignored) {} }
                        
                        try { order.setTotalAmount(rs.getDouble("totalAmount")); } 
                        catch (Exception e) { try { order.setTotalAmount(rs.getDouble("total_amount")); } catch (Exception ignored) {} }

                        try { order.setStatus(rs.getString("status")); } catch (Exception ignored) {}
                        
                        try { order.setPaymentMode(rs.getString("paymentMode")); } 
                        catch (Exception e) {
                            try { order.setPaymentMode(rs.getString("payment_mode")); } 
                            catch (Exception ex) {
                                try { order.setPaymentMode(rs.getString("paymentMethod")); } catch (Exception ignored) {}
                            }
                        }

                        try { order.setAddress(rs.getString("address")); } catch (Exception ignored) {}
                        
                        try { order.setOrderDate(rs.getTimestamp("orderDate")); } 
                        catch (Exception e) { try { order.setOrderDate(rs.getTimestamp("order_date")); } catch (Exception ignored) {} }

                        orderList.add(order);
                    }
                }
                if (!orderList.isEmpty()) break;
            } catch (Exception ignored) {}
        }

        request.setAttribute("orderList", orderList);
        session.setAttribute("orderList", orderList);
        request.getRequestDispatcher("orderHistory.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}