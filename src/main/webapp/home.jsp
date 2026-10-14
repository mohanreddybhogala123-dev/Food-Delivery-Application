<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ page import="com.tap.dao.RestaurantDAO" %>
<%@ page import="com.tap.daoimpl.RestaurantDAOImpl" %>
<%@ page import="com.tap.model.Restaurant" %>
<%@ page import="java.util.List" %>

<%
    RestaurantDAO restaurantDAO = new RestaurantDAOImpl();
    List<Restaurant> restaurantList = restaurantDAO.getAllRestaurants();
    request.setAttribute("restaurantList", restaurantList);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Foodwala - Order Food Online</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --bg-color: #0d0d0d;
            --card-bg: #161616;
            --border-color: #262626;
            --text-primary: #f8f9fa;
            --text-secondary: #9ca3af;
            --zomato-red: #ff5722;
            --zomato-red-dark: #e64a19;
        }

        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: 'Segoe UI', Inter, Helvetica, sans-serif; background-color: var(--bg-color); color: var(--text-primary); }

        /* Navbar */
        .navbar { background-color: #121212; padding: 16px 40px; display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid var(--border-color); position: sticky; top: 0; z-index: 1000; }
        .logo { font-size: 28px; font-weight: 800; color: var(--zomato-red); text-decoration: none; letter-spacing: -0.5px; }
        .nav-links { display: flex; gap: 24px; align-items: center; }
        .nav-links a { text-decoration: none; color: var(--text-secondary); font-weight: 500; font-size: 15px; transition: color 0.2s; }
        .nav-links a:hover { color: var(--zomato-red); }
        .user-greeting { color: var(--text-primary); font-weight: 600; font-size: 14px; background: #222; padding: 6px 12px; border-radius: 20px; border: 1px solid var(--border-color); }

        /* Hero / Banner Section */
        .hero { 
            background: linear-gradient(rgba(0,0,0,0.8), rgba(0,0,0,0.85)), url('https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=1600&q=80') no-repeat center center/cover; 
            color: white; text-align: center; padding: 90px 20px; border-bottom: 1px solid var(--border-color);
        }
        .hero h1 { font-size: 42px; font-weight: 800; margin-bottom: 12px; letter-spacing: -0.5px; }
        .hero p { font-size: 18px; color: var(--text-secondary); margin-bottom: 30px; }

        /* Search Bar Box */
        .search-container { max-width: 600px; margin: 0 auto; display: flex; background: #1f1f1f; border-radius: 30px; border: 1px solid #333; overflow: hidden; padding: 6px; box-shadow: 0 8px 20px rgba(0,0,0,0.4); }
        .search-container input { flex: 1; background: transparent; border: none; padding: 12px 20px; color: white; font-size: 16px; outline: none; }
        .search-container input::placeholder { color: #666; }
        .search-btn { background: var(--zomato-red); color: white; border: none; padding: 10px 24px; border-radius: 24px; font-weight: 600; cursor: pointer; transition: background 0.2s; }
        .search-btn:hover { background: var(--zomato-red-dark); }

        /* Container & Grid layout */
        .container { max-width: 1200px; margin: 50px auto; padding: 0 20px; }
        .section-title { font-size: 26px; font-weight: 700; margin-bottom: 30px; letter-spacing: -0.5px; display: flex; align-items: center; gap: 10px; }
        
        .restaurant-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(320px, 1fr)); gap: 30px; }
        
        /* Restaurant Card */
        .restaurant-card { 
            background: var(--card-bg); border-radius: 16px; overflow: hidden; 
            box-shadow: 0 4px 20px rgba(0,0,0,0.3); transition: transform 0.25s ease, box-shadow 0.25s ease, border-color 0.25s ease; 
            text-decoration: none; color: inherit; display: block; border: 1px solid var(--border-color); 
        }
        .restaurant-card:hover { transform: translateY(-6px); box-shadow: 0 12px 30px rgba(255, 87, 34, 0.18); border-color: rgba(255, 87, 34, 0.4); }
        
        .img-wrapper { position: relative; width: 100%; height: 210px; overflow: hidden; }
        .restaurant-img { width: 100%; height: 100%; object-fit: cover; transition: transform 0.4s ease; }
        .restaurant-card:hover .restaurant-img { transform: scale(1.04); }
        
        .delivery-badge { position: absolute; bottom: 12px; left: 12px; background: rgba(0, 0, 0, 0.75); backdrop-filter: blur(4px); color: #fff; font-size: 12px; font-weight: 600; padding: 4px 10px; border-radius: 6px; }

        .restaurant-info { padding: 18px 20px 22px 20px; }
        .restaurant-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 6px; }
        .restaurant-name { font-size: 19px; font-weight: 700; color: var(--text-primary); white-space: nowrap; overflow: hidden; text-overflow: ellipsis; max-width: 210px; }
        
        .rating-badge { background: #24963f; color: white; padding: 3px 8px; border-radius: 6px; font-size: 13px; font-weight: 700; display: flex; align-items: center; gap: 3px; }
        
        .restaurant-cuisine { color: var(--text-secondary); font-size: 14px; margin-bottom: 14px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        
        .restaurant-footer { display: flex; justify-content: space-between; align-items: center; font-size: 13px; color: var(--text-secondary); border-top: 1px solid var(--border-color); padding-top: 12px; }
        .price-for-two { color: #888; }
        
        .no-restaurants { text-align: center; color: var(--text-secondary); font-size: 16px; margin-top: 60px; padding: 40px; background: var(--card-bg); border-radius: 12px; border: 1px solid var(--border-color); }
    </style>
</head>
<body>

<!-- Navbar -->
<div class="navbar">
    <a href="home.jsp" class="logo"><i class="fa-solid fa-utensils"></i> Foodwala</a>
    <div class="nav-links">
        <a href="home.jsp">Home</a>
        <a href="OrderHistoryServlet"><i class="fa-solid fa-clock-rotate-left"></i> My Orders</a>
        <a href="cart.jsp"><i class="fa-solid fa-cart-shopping"></i> Cart</a>
        <c:choose>
            <c:when test="${not empty sessionScope.loggedInUser}">
                <span class="user-greeting"><i class="fa-solid fa-user"></i> ${sessionScope.loggedInUser.name}</span>
                <a href="LogoutServlet" style="color: #ff5722;"><i class="fa-solid fa-right-from-bracket"></i> Logout</a>
            </c:when>
            <c:otherwise>
                <a href="login.jsp" style="color: #ff5722;">Login</a>
                <a href="register.jsp" style="color: #ff5722;">Register</a>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<!-- Hero Section -->
<div class="hero">
    <h1>Discover the best food & drinks</h1>
    <p>Explore top-rated restaurants, cafés, and bakeries near you</p>
    
    <div class="search-container">
        <input type="text" placeholder="Search for restaurant, cuisine or a dish...">
        <button class="search-btn">Search</button>
    </div>
</div>

<!-- Main Restaurant Grid Section -->
<div class="container">
    <div class="section-title">
        <i class="fa-solid fa-store" style="color: var(--zomato-red);"></i> Restaurants to explore
    </div>

    <c:choose>
        <c:when test="${not empty restaurantList}">
            <div class="restaurant-grid">
                <c:forEach var="restaurant" items="${restaurantList}">
                    <a href="MenuServlet?restaurantId=${restaurant.restaurantId}" class="restaurant-card">
                        <div class="img-wrapper">
                            <img src="${restaurant.imagePath}" alt="${restaurant.restaurantName}" class="restaurant-img" onerror="this.src='https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=500&q=80'">
                            <div class="delivery-badge"><i class="fa-regular fa-clock"></i> ${restaurant.deliveryTime} mins</div>
                        </div>
                        <div class="restaurant-info">
                            <div class="restaurant-header">
                                <div class="restaurant-name" title="${restaurant.restaurantName}">${restaurant.restaurantName}</div>
                                <div class="rating-badge">
                                    ${restaurant.rating} <i class="fa-solid fa-star" style="font-size: 10px;"></i>
                                </div>
                            </div>
                            <div class="restaurant-cuisine">${restaurant.cuisineType}</div>
                            <div class="restaurant-footer">
                                <span class="price-for-two">Dining & Delivery Available</span>
                                <span style="color: var(--zomato-red); font-weight: 600;">Order Now &rarr;</span>
                            </div>
                        </div>
                    </a>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <div class="no-restaurants">
                <i class="fa-solid fa-triangle-exclamation" style="font-size: 32px; color: #ff5722; margin-bottom: 12px;"></i>
                <p>No restaurants found in the database.</p>
            </div>
        </c:otherwise>
    </c:choose>
</div>

</body>
</html>