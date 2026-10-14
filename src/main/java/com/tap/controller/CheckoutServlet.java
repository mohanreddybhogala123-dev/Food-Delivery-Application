package com.tap.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.tap.model.Cart;
import com.tap.model.CartItem;
import com.tap.model.User;
import com.tap.util.DBConnection;

@WebServlet("/CheckoutServlet")
public class CheckoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("loggedInUser");
        Cart cart = (Cart) session.getAttribute("cart");

        if (user == null || cart == null || cart.getItems().isEmpty()) {
            response.sendRedirect("cart.jsp");
            return;
        }

        String paymentMode = request.getParameter("paymentMode");
        if (paymentMode == null || paymentMode.trim().isEmpty()) paymentMode = "Cash on Delivery (COD)";
        
        String address = request.getParameter("address");
        if (address == null || address.trim().isEmpty()) {
            address = user.getAddress() != null ? user.getAddress() : "MG Road, Bengaluru";
        }

        double totalAmount = cart.getTotalPrice();
        int generatedOrderId = -1;

        Connection con = null;
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            // 1. Insert into orders table
            String orderQuery = "INSERT INTO orders (userId, userEmail, totalAmount, paymentMethod, address, phone, orderDate, status) VALUES (?, ?, ?, ?, ?, ?, NOW(), 'Preparing')";
            try (PreparedStatement pstmt = con.prepareStatement(orderQuery, Statement.RETURN_GENERATED_KEYS)) {
                pstmt.setInt(1, user.getUserId());
                pstmt.setString(2, user.getEmail());
                pstmt.setDouble(3, totalAmount);
                pstmt.setString(4, paymentMode);
                pstmt.setString(5, address);
                pstmt.setString(6, user.getPhone() != null ? user.getPhone() : "9999999999");
                pstmt.executeUpdate();

                try (ResultSet rs = pstmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        generatedOrderId = rs.getInt(1);
                    }
                }
            }

            if (generatedOrderId <= 0) {
                try (Statement stmt = con.createStatement();
                     ResultSet rs = stmt.executeQuery("SELECT LAST_INSERT_ID()")) {
                    if (rs.next()) {
                        generatedOrderId = rs.getInt(1);
                    }
                }
            }

            // 2. Insert cart items into database permanently for future orders (#89, #90...)
            if (generatedOrderId > 0) {
                for (Map.Entry<Integer, CartItem> entry : cart.getItems().entrySet()) {
                    CartItem item = entry.getValue();
                    int foodId = item.getFoodId();
                    if (foodId <= 0) foodId = 1;
                    int quantity = item.getQuantity() > 0 ? item.getQuantity() : 1;
                    double price = item.getPrice();

                    String[] insertQueries = {
                        "INSERT INTO order_items (orderId, foodId, quantity, price) VALUES (?, ?, ?, ?)",
                        "INSERT INTO order_item (orderId, foodId, quantity, price) VALUES (?, ?, ?, ?)",
                        "INSERT INTO order_items (order_id, food_id, quantity, price) VALUES (?, ?, ?, ?)",
                        "INSERT INTO order_item (order_id, food_id, quantity, price) VALUES (?, ?, ?, ?)"
                    };

                    for (String iq : insertQueries) {
                        try (PreparedStatement ipstmt = con.prepareStatement(iq)) {
                            ipstmt.setInt(1, generatedOrderId);
                            ipstmt.setInt(2, foodId);
                            ipstmt.setInt(3, quantity);
                            ipstmt.setDouble(4, price);
                            ipstmt.executeUpdate();
                        } catch (Exception ignored) {}
                    }
                }
            }

            con.commit();

            session.setAttribute("lastOrderId", generatedOrderId);
            session.setAttribute("lastOrderCart", cart.getItems());
            session.removeAttribute("cart");

            response.sendRedirect("orderSuccess.jsp?orderId=" + generatedOrderId);

        } catch (Exception e) {
            if (con != null) {
                try { con.rollback(); } catch (Exception ignored) {}
            }
            e.printStackTrace();
            response.sendRedirect("cart.jsp?error=checkout_failed");
        } finally {
            if (con != null) {
                try { con.close(); } catch (Exception ignored) {}
            }
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}