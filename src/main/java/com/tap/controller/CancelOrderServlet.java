package com.tap.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.tap.model.User;
import com.tap.util.DBConnection;

@WebServlet("/CancelOrderServlet")
public class CancelOrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("loggedInUser");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String orderIdParam = request.getParameter("orderId");
        if (orderIdParam != null && !orderIdParam.trim().isEmpty()) {
            try {
                int orderId = Integer.parseInt(orderIdParam.trim());

                // Multi-query fallback strategy to update order status across table/column name variations
                String[] updateQueries = {
                    "UPDATE orders SET status = 'Cancelled' WHERE orderId = ?",
                    "UPDATE orders SET status = 'Cancelled' WHERE order_id = ?",
                    "UPDATE `order` SET status = 'Cancelled' WHERE orderId = ?",
                    "UPDATE `order` SET status = 'Cancelled' WHERE order_id = ?"
                };

                for (String query : updateQueries) {
                    try (Connection con = DBConnection.getConnection();
                         PreparedStatement pstmt = con.prepareStatement(query)) {
                        pstmt.setInt(1, orderId);
                        int rows = pstmt.executeUpdate();
                        if (rows > 0) {
                            break; // Successfully updated status
                        }
                    } catch (Exception ex) {
                        // Continue to next fallback query
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        response.sendRedirect("OrderHistoryServlet");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}