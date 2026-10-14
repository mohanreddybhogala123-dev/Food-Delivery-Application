<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map, com.tap.model.Cart, com.tap.model.CartItem, com.tap.model.User" %>
<%
    User user = (User) session.getAttribute("loggedInUser");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Cart cart = (Cart) session.getAttribute("cart");
    Map<Integer, CartItem> cartItems = (cart != null) ? cart.getItems() : null;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Your Food Cart - Foodwala</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #0c0c0c; color: #e0e0e0; font-family: 'Segoe UI', sans-serif; }
        header { background-color: #1a1a1a; padding: 15px 40px; display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #282828; }
        .logo { font-size: 1.8rem; font-weight: 800; color: #ff4e50; text-decoration: none; }
        .nav-links a { text-decoration: none; color: #e0e0e0; font-weight: 600; margin-left: 20px; }
        .nav-links a.active { color: #ff4e50; }
        .nav-links a:hover { color: #ff4e50; }
        .container { max-width: 900px; margin: 40px auto; padding: 0 20px; }
        .cart-card { background: #181818; border: 1px solid #262626; border-radius: 12px; padding: 35px; box-shadow: 0 10px 25px rgba(0,0,0,0.5); }
        h2 { color: #fff; font-weight: 800; margin-bottom: 25px; }
        .table { color: #fff; vertical-align: middle; }
        .table th { background-color: #1a1a1a; color: #ff4e50; border-bottom: 1px solid #333; font-weight: 600; padding: 14px; }
        .table td { background-color: #181818 !important; color: #fff; border-bottom: 1px solid #262626; padding: 14px; }
        .btn-qty { background-color: #262626; border: 1px solid #444; color: #fff; font-weight: bold; width: 32px; height: 32px; display: inline-flex; align-items: center; justify-content: center; border-radius: 6px; text-decoration: none; }
        .btn-qty:hover { background-color: #ff4e50; border-color: #ff4e50; color: #fff; }
        .btn-action { background-color: #ff4e50; border: none; color: #fff; font-weight: 600; padding: 10px 24px; border-radius: 6px; text-decoration: none; font-size: 1rem; }
        .btn-action:hover { background-color: #e64345; color: #fff; }
        .btn-danger-custom { background-color: transparent; border: 1px solid #dc3545; color: #dc3545; padding: 6px 14px; font-size: 0.9rem; border-radius: 6px; text-decoration: none; }
        .btn-danger-custom:hover { background-color: #dc3545; color: #fff; }
        .cart-summary { border-top: 1px solid #333; margin-top: 25px; padding-top: 20px; display: flex; justify-content: space-between; align-items: center; }
        .total-price { font-size: 1.6rem; font-weight: 700; color: #ff4e50; }
    </style>
</head>
<body>
    <header>
        <a href="home.jsp" class="logo">🍴 Foodwala</a>
        <div class="nav-links">
            <a href="home.jsp">Home</a>
            <a href="OrderHistoryServlet">My Orders</a>
            <a href="cart.jsp" class="active">Cart</a>
        </div>
    </header>

    <div class="container">
        <div class="cart-card">
            <h2>Your Food Cart</h2>

            <% if (cartItems == null || cartItems.isEmpty()) { %>
                <div class="text-center py-5">
                    <p style="font-size: 1.1rem; color: #888;">Your cart is empty.</p>
                    <a href="home.jsp" class="btn-action" style="margin-top: 15px; display: inline-block;">Browse Restaurants</a>
                </div>
            <% } else { %>
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Item Name</th>
                                <th class="text-center">Price (&#8377;)</th>
                                <th class="text-center">Quantity</th>
                                <th class="text-end">Total (&#8377;)</th>
                                <th class="text-center">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (CartItem item : cartItems.values()) { 
                                int currentId = item.getFoodId() > 0 ? item.getFoodId() : item.getItemId();
                                double itemTotal = item.getPrice() * item.getQuantity();
                            %>
                            <tr>
                                <td><strong><%= item.getName() %></strong></td>
                                <td class="text-center">&#8377;<%= item.getPrice() %></td>
                                <td class="text-center">
                                    <a href="CartServlet?action=update&foodId=<%= currentId %>&itemId=<%= currentId %>&quantity=<%= item.getQuantity() - 1 %>" class="btn-qty">-</a>
                                    <span class="mx-2 font-weight-bold"><%= item.getQuantity() %></span>
                                    <a href="CartServlet?action=update&foodId=<%= currentId %>&itemId=<%= currentId %>&quantity=<%= item.getQuantity() + 1 %>" class="btn-qty">+</a>
                                </td>
                                <td class="text-end" style="color: #ff4e50; font-weight: 600;">&#8377;<%= itemTotal %></td>
                                <td class="text-center">
                                    <a href="CartServlet?action=delete&foodId=<%= currentId %>&itemId=<%= currentId %>" class="btn-danger-custom">Remove</a>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>

                <div class="cart-summary">
                    <div>
                        <span style="font-size: 1.3rem; font-weight: 600;">Grand Total: </span>
                        <span class="total-price">&#8377;<%= cart.getTotalPrice() %></span>
                    </div>
                    <div>
                        <a href="home.jsp" class="btn btn-secondary me-2" style="padding: 10px 20px; font-weight: 600;">Add More Items</a>
                        <a href="checkout.jsp" class="btn-action">Proceed to Checkout</a>
                    </div>
                </div>
            <% } %>
        </div>
    </div>
</body>
</html>