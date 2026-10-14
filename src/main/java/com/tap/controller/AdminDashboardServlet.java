package com.tap.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.tap.util.DBConnection;

@WebServlet("/AdminDashboardServlet")
public class AdminDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int totalUsers = 0;
        int totalOrders = 0;
        double totalRevenue = 0.0;

        try (Connection con = DBConnection.getConnection()) {
            // Count total users
            try (PreparedStatement pstmt = con.prepareStatement("SELECT COUNT(*) FROM user");
                 ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) totalUsers = rs.getInt(1);
            } catch (Exception ignored) {}

            // Count total orders & sum revenue
            try (PreparedStatement pstmt = con.prepareStatement("SELECT COUNT(*), SUM(totalAmount) FROM orders");
                 ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    totalOrders = rs.getInt(1);
                    totalRevenue = rs.getDouble(2);
                }
            } catch (Exception ignored) {}
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("totalOrders", totalOrders);
        request.setAttribute("totalRevenue", totalRevenue);
        request.getRequestDispatcher("adminDashboard.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}