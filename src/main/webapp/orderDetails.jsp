<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.tap.model.OrderItem, com.tap.model.User" %>
<%
    User user = (User) session.getAttribute("loggedInUser");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Integer orderId = (Integer) request.getAttribute("orderId");
    if (orderId == null || orderId <= 0) {
        String idParam = request.getParameter("orderId");
        if (idParam == null || idParam.trim().isEmpty()) {
            idParam = request.getParameter("orderid");
        }
        try {
            if (idParam != null && !idParam.trim().isEmpty()) {
                orderId = Integer.parseInt(idParam.trim());
            }
        } catch (Exception e) {}
    }
    if (orderId == null || orderId <= 0) {
        orderId = (Integer) session.getAttribute("lastOrderId");
    }
    if (orderId == null || orderId <= 0) {
        orderId = 80;
    }

    List<OrderItem> orderItems = (List<OrderItem>) request.getAttribute("orderItems");
    if (orderItems == null || orderItems.isEmpty()) {
        orderItems = (List<OrderItem>) request.getAttribute("items");
    }

    double grandTotal = 0.0;
    if (orderItems != null) {
        for (OrderItem item : orderItems) {
            grandTotal += (item.getPrice() * item.getQuantity());
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Order Details - Foodwala</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #0c0c0c; color: #e0e0e0; font-family: 'Segoe UI', sans-serif; }
        header { background-color: #1a1a1a; padding: 15px 40px; display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #282828; }
        .logo { font-size: 1.8rem; font-weight: 800; color: #ff4e50; text-decoration: none; }
        .nav-links a { text-decoration: none; color: #e0e0e0; font-weight: 600; margin-left: 20px; }
        .nav-links a:hover { color: #ff4e50; }
        .container { max-width: 800px; margin: 40px auto; padding: 0 20px; }
        .back-link { color: #ff4e50; text-decoration: none; font-weight: 600; margin-bottom: 20px; display: inline-block; }
        .back-link:hover { text-decoration: underline; color: #e64345; }
        .details-card { background: #181818; border: 1px solid #262626; border-radius: 12px; padding: 35px; box-shadow: 0 10px 25px rgba(0,0,0,0.5); }
        h2 { color: #fff; font-weight: 800; font-size: 2rem; margin-bottom: 30px; }
        .table { color: #fff; vertical-align: middle; margin-bottom: 30px; }
        .table th { background-color: transparent; color: #ff4e50; border-bottom: 1px solid #333; font-weight: 600; padding: 14px 10px; }
        .table td { background-color: transparent !important; color: #fff; border-bottom: 1px solid #262626; padding: 16px 10px; font-weight: 600; }
        .total-section { border-top: 1px solid #333; padding-top: 20px; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 15px; }
        .total-label { font-size: 1.5rem; font-weight: 700; color: #fff; }
        .total-amount { font-size: 1.5rem; font-weight: 700; color: #ff4e50; }
        .btn-action { font-weight: 600; padding: 8px 16px; border-radius: 6px; text-decoration: none; font-size: 0.9rem; margin-right: 10px; }
        .btn-reorder-primary { background-color: #28a745; color: #fff; border: none; }
        .btn-reorder-primary:hover { background-color: #218838; color: #fff; }
        .btn-cancel-primary { background-color: transparent; border: 1px solid #dc3545; color: #dc3545; }
        .btn-cancel-primary:hover { background-color: #dc3545; color: #fff; }
    </style>
</head>
<body>
    <header>
        <a href="home.jsp" class="logo">🍴 Foodwala</a>
        <div class="nav-links">
            <a href="home.jsp">Home</a>
            <a href="OrderHistoryServlet" style="color: #ff4e50;">My Orders</a>
            <a href="cart.jsp">Cart</a>
        </div>
    </header>

    <div class="container">
        <a href="OrderHistoryServlet" class="back-link">&larr; Back to Order History</a>

        <div class="details-card">
            <h2>Items for Order #<%= orderId %></h2>

            <% if (orderItems == null || orderItems.isEmpty()) { %>
                <div class="text-center py-4">
                    <p style="color: #888;">No items found for this order.</p>
                </div>
            <% } else { %>
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Item Name</th>
                                <th class="text-center">Quantity</th>
                                <th class="text-center">Price (&#8377;)</th>
                                <th class="text-end">Total (&#8377;)</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (OrderItem item : orderItems) { 
                                double itemTotal = item.getPrice() * item.getQuantity();
                            %>
                            <tr>
                                <td><%= item.getItemName() %></td>
                                <td class="text-center"><%= item.getQuantity() %></td>
                                <td class="text-center">&#8377;<%= item.getPrice() %></td>
                                <td class="text-end" style="color: #ff4e50;">&#8377;<%= itemTotal %></td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>

                <div class="total-section">
                    <div>
                        <span class="total-label">Order Total: </span>
                        <span class="total-amount">&#8377;<%= grandTotal %></span>
                    </div>
                    <div>
                        <a href="OrderAgainServlet?orderId=<%= orderId %>" class="btn btn-action btn-reorder-primary">Order Again</a>
                        <a href="CancelOrderServlet?orderId=<%= orderId %>" class="btn btn-action btn-cancel-primary">Cancel Order</a>
                    </div>
                </div>
            <% } %>
        </div>
    </div>
</body>
</html>