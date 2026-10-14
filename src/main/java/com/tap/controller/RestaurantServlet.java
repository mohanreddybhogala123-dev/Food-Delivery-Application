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

@WebServlet("/RestaurantServlet")
public class RestaurantServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<HashMap<String, Object>> restaurantList = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT * FROM restaurants";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                HashMap<String, Object> rest = new HashMap<>();
                rest.put("restaurantId", rs.getInt("restaurantId"));
                rest.put("restaurantName", rs.getString("restaurantName"));
                rest.put("cuisineType", rs.getString("cuisineType"));
                rest.put("deliveryTime", rs.getInt("deliveryTime"));
                rest.put("imagePath", rs.getString("imagePath"));
                restaurantList.add(rest);
            }

            HttpSession session = request.getSession();
            session.setAttribute("restaurantList", restaurantList);
            
            response.sendRedirect("restaurantList.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("home.jsp?error=db_error");
        }
    }
}