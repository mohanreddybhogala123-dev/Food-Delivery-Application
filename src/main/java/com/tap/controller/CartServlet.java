package com.tap.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.tap.dao.FoodDAO;
import com.tap.daoimpl.FoodDAOImpl;
import com.tap.model.Cart;
import com.tap.model.CartItem;
import com.tap.model.Food;
import com.tap.model.User;

@WebServlet("/CartServlet")
public class CartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("loggedInUser");

        String action = request.getParameter("action");
        if (action == null) {
            action = "view";
        }

        Cart cart = (Cart) session.getAttribute("cart");
        if (cart == null) {
            cart = new Cart();
            session.setAttribute("cart", cart);
        }

        System.out.println("=== [CartServlet] Action: " + action + " ===");

        try {
            if ("add".equals(action)) {
                String idStr = request.getParameter("foodId");
                if (idStr == null || idStr.trim().isEmpty()) idStr = request.getParameter("itemId");
                if (idStr == null || idStr.trim().isEmpty()) idStr = request.getParameter("id");

                int foodId = 1;
                try {
                    if (idStr != null) foodId = Integer.parseInt(idStr.trim());
                } catch (Exception ignored) {}

                int quantity = 1;
                try {
                    String qtyStr = request.getParameter("quantity");
                    if (qtyStr != null) quantity = Integer.parseInt(qtyStr.trim());
                } catch (Exception ignored) {}

                FoodDAO foodDAO = new FoodDAOImpl();
                Food food = foodDAO.getFoodById(foodId);

                CartItem item = null;
                if (food != null) {
                    item = new CartItem(
                        food.getFoodId(),
                        food.getRestaurantId(),
                        food.getFoodName(),
                        quantity,
                        food.getPrice(),
                        food.getImagePath()
                    );
                } else {
                    String name = request.getParameter("foodName");
                    if (name == null) name = request.getParameter("name");
                    if (name == null) name = "Food Item #" + foodId;

                    double price = 100.0;
                    try {
                        String priceStr = request.getParameter("price");
                        if (priceStr != null) price = Double.parseDouble(priceStr.trim());
                    } catch (Exception ignored) {}

                    int restId = 1;
                    try {
                        String restStr = request.getParameter("restaurantId");
                        if (restStr != null) restId = Integer.parseInt(restStr.trim());
                    } catch (Exception ignored) {}

                    String imagePath = request.getParameter("imagePath");
                    if (imagePath == null) imagePath = "";

                    item = new CartItem(foodId, restId, name, quantity, price, imagePath);
                }

                if (item != null) {
                    cart.addItem(item);
                }
                
                session.setAttribute("cart", cart);

                if (user == null) {
                    session.setAttribute("redirectUrl", "cart.jsp");
                    response.sendRedirect("login.jsp?redirect=cart.jsp");
                    return;
                }

                response.sendRedirect("cart.jsp");
                return;
            } 
            else if ("update".equals(action)) {
                String idStr = request.getParameter("foodId");
                if (idStr == null || idStr.trim().isEmpty()) idStr = request.getParameter("itemId");
                if (idStr == null || idStr.trim().isEmpty()) idStr = request.getParameter("id");
                
                int foodId = 0;
                if (idStr != null && !idStr.trim().isEmpty()) {
                    foodId = Integer.parseInt(idStr.trim());
                }

                int quantity = 1;
                try {
                    String qtyStr = request.getParameter("quantity");
                    if (qtyStr != null) quantity = Integer.parseInt(qtyStr.trim());
                } catch (Exception ignored) {}

                if (foodId > 0) {
                    if (quantity <= 0) {
                        cart.removeItem(foodId);
                        System.out.println("Quantity <= 0, removed item with ID: " + foodId);
                    } else {
                        if (cart.getItems() != null && cart.getItems().containsKey(foodId)) {
                            CartItem ci = cart.getItems().get(foodId);
                            ci.setQuantity(quantity);
                            System.out.println("Updated quantity for ID " + foodId + " to " + quantity);
                        }
                    }
                }
                session.setAttribute("cart", cart);
                response.sendRedirect("cart.jsp");
                return;
            }
            else if ("remove".equals(action) || "delete".equals(action)) {
                String idStr = request.getParameter("itemId");
                if (idStr == null || idStr.trim().isEmpty()) idStr = request.getParameter("foodId");
                if (idStr == null || idStr.trim().isEmpty()) idStr = request.getParameter("id");
                
                if (idStr != null && !idStr.trim().isEmpty()) {
                    int id = Integer.parseInt(idStr.trim());
                    cart.removeItem(id);
                    System.out.println("Successfully removed item with ID: " + id);
                }
                session.setAttribute("cart", cart);
                response.sendRedirect("cart.jsp");
                return;
            } 
            else {
                if (user == null) {
                    session.setAttribute("redirectUrl", "cart.jsp");
                    response.sendRedirect("login.jsp?redirect=cart.jsp");
                    return;
                }
                response.sendRedirect("cart.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("cart.jsp");
        }
    }
}