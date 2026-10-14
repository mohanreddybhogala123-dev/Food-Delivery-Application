package com.tap.controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;

import com.tap.dao.FoodDAO;
import com.tap.daoimpl.FoodDAOImpl;
import com.tap.model.Food;
import com.tap.util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/MenuServlet")
public class MenuServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String restIdParam = request.getParameter("restaurantId");
        
        if (restIdParam == null || restIdParam.trim().isEmpty()) {
            response.sendRedirect("home.jsp");
            return;
        }

        int restaurantId = Integer.parseInt(restIdParam);
        String restaurantName = "Restaurant Menu";

        // Fetch Restaurant Name safely
        try (Connection conn = DBConnection.getConnection()) {
            PreparedStatement restStmt = conn.prepareStatement("SELECT * FROM restaurants WHERE restaurantId = ?");
            restStmt.setInt(1, restaurantId);
            ResultSet restRs = restStmt.executeQuery();
            
            if (restRs.next()) {
                try {
                    restaurantName = restRs.getString("restaurantName");
                } catch (Exception e) {
                    try {
                        restaurantName = restRs.getString("name");
                    } catch (Exception ex) {
                        restaurantName = "Restaurant #" + restaurantId;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Fetch Food items from the 'food' table via FoodDAO
        FoodDAO foodDAO = new FoodDAOImpl();
        List<Food> menuList = foodDAO.getFoodItemsByRestaurant(restaurantId);

        HttpSession session = request.getSession();
        session.setAttribute("menuList", menuList);
        session.setAttribute("currentRestaurantName", restaurantName);
        
        response.sendRedirect("menu.jsp");
    }
}