<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.tap.model.Food" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Restaurant Menu - Foodwala</title>
    <style>
        * { box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #0c0c0c; color: #e0e0e0; margin: 0; padding: 0; }
        
        /* Zomato-style Navbar */
        header { background-color: #1a1a1a; padding: 15px 40px; display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #282828; position: sticky; top: 0; z-index: 1000; box-shadow: 0 4px 12px rgba(0,0,0,0.5); }
        .logo { font-size: 1.8rem; font-weight: 800; color: #ff4e50; text-decoration: none; letter-spacing: 0.5px; }
        .nav-links { display: flex; gap: 25px; align-items: center; }
        .nav-links a { text-decoration: none; color: #e0e0e0; font-weight: 600; font-size: 0.95rem; transition: color 0.2s; }
        .nav-links a:hover { color: #ff4e50; }

        .container { max-width: 1200px; margin: 40px auto; padding: 0 20px; }
        
        /* Restaurant Header Info */
        .restaurant-header { text-align: left; margin-bottom: 30px; border-left: 4px solid #ff4e50; padding-left: 15px; }
        h2 { margin: 0; color: #ffffff; font-size: 2.2rem; font-weight: 700; }
        .subtitle { color: #ff4e50; font-weight: 700; margin-top: 5px; text-transform: uppercase; font-size: 0.9rem; letter-spacing: 1px; }
        
        /* Modern Grid Layout */
        .menu-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 25px; }
        
        /* Zomato-style Food Card */
        .menu-card { background-color: #181818; border-radius: 12px; overflow: hidden; border: 1px solid #262626; box-shadow: 0 8px 20px rgba(0,0,0,0.4); display: flex; flex-direction: column; justify-content: space-between; transition: transform 0.2s ease, box-shadow 0.2s ease, border-color 0.2s ease; }
        .menu-card:hover { transform: translateY(-4px); box-shadow: 0 12px 25px rgba(255, 78, 80, 0.15); border-color: #383838; }

        /* Image Wrapper */
        .card-img-container { position: relative; width: 100%; height: 180px; background-color: #222; overflow: hidden; }
        .item-img { width: 100%; height: 100%; object-fit: cover; transition: transform 0.3s; }
        .menu-card:hover .item-img { transform: scale(1.05); }

        /* Card Content Area */
        .card-content { padding: 16px; flex-grow: 1; display: flex; flex-direction: column; justify-content: space-between; }
        .item-details h4 { margin: 0 0 8px 0; color: #ffffff; font-size: 1.15rem; font-weight: 600; }
        .item-details p { margin: 0 0 12px 0; color: #999; font-size: 0.85rem; line-height: 1.4; }
        
        .price-row { display: flex; justify-content: space-between; align-items: center; margin-bottom: 14px; }
        .item-price { font-size: 1.1rem; font-weight: 700; color: #ff4e50; }
        
        /* Form and Action Controls */
        .card-footer { padding: 0 16px 16px 16px; }
        .add-form { display: flex; flex-direction: column; gap: 10px; }
        
        .quantity-box { display: flex; align-items: center; justify-content: space-between; background: #222; padding: 6px 10px; border-radius: 6px; border: 1px solid #333; }
        .quantity-box label { font-size: 0.85rem; color: #aaa; font-weight: 500; }
        .qty-input { width: 50px; padding: 4px; background: #121212; border: 1px solid #444; color: white; border-radius: 4px; text-align: center; font-weight: bold; }
        
        .add-btn { background: linear-gradient(135deg, #ff4e50, #f9d423); color: #fff; border: none; padding: 10px; border-radius: 6px; cursor: pointer; font-weight: 700; font-size: 0.9rem; text-transform: uppercase; letter-spacing: 0.5px; transition: opacity 0.2s; width: 100%; }
        .add-btn:hover { opacity: 0.9; }
        
        .no-data { text-align: center; color: #888; padding: 60px; font-size: 1rem; grid-column: 1 / -1; background: #181818; border-radius: 12px; border: 1px solid #262626; }
        
        /* Footer Navigation links */
        .nav-links-footer { display: flex; justify-content: space-between; margin-top: 50px; border-top: 1px solid #282828; padding-top: 25px; }
        .nav-links-footer a { color: #ff4e50; text-decoration: none; font-weight: 600; font-size: 0.95rem; }
        .nav-links-footer a:hover { text-decoration: underline; }
    </style>
</head>
<body>

    <header>
        <a href="home.jsp" class="logo">Foodwala</a>
        <div class="nav-links">
            <a href="home.jsp">Home</a>
            <a href="OrderHistoryServlet">My Orders</a>
            <a href="cart.jsp">Cart</a>
        </div>
    </header>

    <div class="container">
        <div class="restaurant-header">
            <h2>Restaurant Menu</h2>
            <% 
                String restName = (String) session.getAttribute("currentRestaurantName");
                if (restName != null) { 
            %>
                <div class="subtitle"><%= restName %></div>
            <% } %>
        </div>

        <div class="menu-grid">
            <% 
                // Check both request attribute and session attribute to prevent empty list rendering bugs
                List<Food> menuList = (List<Food>) request.getAttribute("menuList");
                if (menuList == null) {
                    menuList = (List<Food>) session.getAttribute("menuList");
                }
                
                if (menuList != null && !menuList.isEmpty()) {
                    for (Food food : menuList) {
                        String imgPath = food.getImagePath();
                        if (imgPath == null || imgPath.trim().isEmpty()) {
                            imgPath = "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=500&auto=format&fit=crop&q=60";
                        }
            %>
            <div class="menu-card">
                <div>
                    <div class="card-img-container">
                        <img src="<%= imgPath %>" alt="Food Image" class="item-img" onerror="this.src='https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=500&auto=format&fit=crop&q=60'">
                    </div>
                    
                    <div class="card-content">
                        <div class="item-details">
                            <h4><%= food.getFoodName() %></h4>
                            <p><%= food.getDescription() != null ? food.getDescription() : "Freshly prepared with quality ingredients, served hot and delicious." %></p>
                        </div>
                        
                        <div class="price-row">
                            <span class="item-price">₹<%= food.getPrice() %></span>
                        </div>
                    </div>
                </div>
                
                <div class="card-footer">
                    <form action="CartServlet" method="POST" class="add-form">
                        <input type="hidden" name="action" value="add">
                        <input type="hidden" name="itemId" value="<%= food.getFoodId() %>">
                        <input type="hidden" name="menuId" value="<%= food.getFoodId() %>">
                        <input type="hidden" name="restaurantId" value="<%= food.getRestaurantId() %>">
                        <input type="hidden" name="itemName" value="<%= food.getFoodName() %>">
                        <input type="hidden" name="price" value="<%= food.getPrice() %>">
                        <input type="hidden" name="imagePath" value="<%= imgPath %>">
                        
                        <div class="quantity-box">
                            <label for="qty-<%= food.getFoodId() %>">Quantity:</label>
                            <input type="number" id="qty-<%= food.getFoodId() %>" name="quantity" value="1" min="1" max="10" class="qty-input">
                        </div>
                        
                        <button type="submit" class="add-btn">Add to Cart</button>
                    </form>
                </div>
            </div>
            <% 
                    }
                } else {
            %>
            <div class="no-data">
                No food items found for this restaurant in the database. Please verify your restaurant selection and table records.
            </div>
            <% } %>
        </div>

        <div class="nav-links-footer">
            <a href="home.jsp">&larr; Back to Home</a>
            <a href="cart.jsp">Go to Cart &rarr;</a>
        </div>
    </div>

</body>
</html>