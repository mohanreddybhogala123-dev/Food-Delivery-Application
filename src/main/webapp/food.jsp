<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.tap.model.Food" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Foodwala - Food Items</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f9f9f9; margin: 0; padding: 20px; }
        h1 { color: #333; text-align: center; }
        .back-link { display: inline-block; margin-bottom: 20px; color: #007bff; text-decoration: none; font-weight: bold; }
        .back-link:hover { text-decoration: underline; }
        .food-container { display: flex; flex-wrap: wrap; gap: 20px; justify-content: center; padding: 20px 0; }
        .food-card { background: #fff; border: 1px solid #ddd; border-radius: 8px; padding: 15px; width: 250px; box-shadow: 0 2px 5px rgba(0,0,0,0.05); transition: transform 0.2s; display: flex; flex-direction: column; justify-content: space-between; }
        .food-card:hover { transform: translateY(-3px); box-shadow: 4px 4px 15px rgba(0,0,0,0.1); }
        .food-card img { width: 100%; height: 140px; object-fit: cover; border-radius: 6px; }
        .food-card h3 { margin: 10px 0 5px 0; font-size: 18px; color: #111; }
        .food-card p { margin: 5px 0; color: #666; font-size: 14px; }
        .food-price { color: #e67e22; font-weight: bold; font-size: 16px; margin: 8px 0; }
        .add-btn { background-color: #28a745; color: white; border: none; padding: 10px; border-radius: 5px; cursor: pointer; font-weight: bold; width: 100%; margin-top: 10px; }
        .add-btn:hover { background-color: #218838; }
    </style>
</head>
<body>

    <a href="home" class="back-link">&larr; Back to Restaurants</a>
    <h1>Available Food Items</h1>

    <div class="food-container">
        <% 
            // Retrieve food list passed from your Servlet (e.g., MenuServlet or FoodServlet)
            List<Food> foodList = (List<Food>) request.getAttribute("menuList");
            if (foodList == null) {
                foodList = (List<Food>) request.getAttribute("foodList");
            }
            
            if (foodList != null && !foodList.isEmpty()) {
                for (Food food : foodList) {
        %>
                    <div class="food-card">
                        <div>
                            <!-- Food Image -->
                            <img src="<%= food.getImagePath() %>" alt="<%= food.getFoodName() %>">
                            <h3><%= food.getFoodName() %></h3>
                            <p><%= food.getDescription() != null ? food.getDescription() : "" %></p>
                            <p class="food-price">Rs. <%= food.getPrice() %></p>
                        </div>
                        
                        <!-- Add to Cart Form -->
                        <form action="CartServlet" method="post">
                            <input type="hidden" name="foodId" value="<%= food.getFoodId() %>">
                            <input type="hidden" name="quantity" value="1">
                            <button type="submit" class="add-btn">Add to Cart</button>
                        </form>
                    </div>
        <% 
                }
            } else { 
        %>
                <p style="text-align: center; color: #777;">No food items found in the database.</p>
        <% 
            } 
        %>
    </div>

</body>
</html>