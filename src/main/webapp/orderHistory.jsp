<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.tap.model.Order, com.tap.model.User" %>
<%
    User user = (User) session.getAttribute("loggedInUser");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<Order> orderList = (List<Order>) request.getAttribute("orderList");
    if (orderList == null) {
        orderList = (List<Order>) request.getAttribute("orders");
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Order History - Foodwala</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #0c0c0c; color: #e0e0e0; font-family: 'Segoe UI', sans-serif; }
        header { background-color: #1a1a1a; padding: 15px 40px; display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #282828; }
        .logo { font-size: 1.8rem; font-weight: 800; color: #ff4e50; text-decoration: none; }
        .nav-links a { text-decoration: none; color: #e0e0e0; font-weight: 600; margin-left: 20px; }
        .nav-links a:hover, .nav-links a.active { color: #ff4e50; }
        .container { max-width: 1100px; margin: 40px auto; padding: 0 20px; }
        .back-link { color: #ff4e50; text-decoration: none; font-weight: 600; margin-bottom: 20px; display: inline-block; }
        .back-link:hover { text-decoration: underline; color: #e64345; }
        .history-card { background: #181818; border: 1px solid #262626; border-radius: 12px; padding: 35px; box-shadow: 0 10px 25px rgba(0,0,0,0.5); }
        h2 { color: #fff; font-weight: 700; margin-bottom: 25px; }
        .table { color: #fff; vertical-align: middle; }
        .table th { background-color: #1a1a1a; color: #ff4e50; border-bottom: 1px solid #333; font-weight: 600; padding: 14px 10px; }
        .table td { background-color: #181818 !important; color: #fff; border-bottom: 1px solid #262626; padding: 16px 10px; font-weight: 600; }
        .badge-status { padding: 6px 12px; border-radius: 6px; font-weight: 600; font-size: 0.85rem; display: inline-block; }
        .status-preparing { background-color: rgba(255, 193, 7, 0.15); color: #ffc107; border: 1px solid #ffc107; }
        .status-delivered { background-color: rgba(40, 167, 69, 0.15); color: #28a745; border: 1px solid #28a745; }
        .status-pending { background-color: rgba(23, 162, 184, 0.15); color: #17a2b8; border: 1px solid #17a2b8; }
        .status-cancelled { background-color: rgba(220, 53, 69, 0.15); color: #dc3545; border: 1px solid #dc3545; }
        .btn-view { background-color: #ff4e50; border: none; color: #fff; font-weight: 600; padding: 6px 14px; border-radius: 6px; text-decoration: none; font-size: 0.85rem; }
        .btn-view:hover { background-color: #e64345; color: #fff; }
    </style>
</head>
<body>
    <header>
        <a href="home.jsp" class="logo">🍴 Foodwala</a>
        <div class="nav-links">
            <a href="home.jsp">Home</a>
            <a href="OrderHistoryServlet" class="active">My Orders</a>
            <a href="cart.jsp">Cart</a>
        </div>
    </header>

    <div class="container">
        <a href="home.jsp" class="back-link">&larr; Back to Home</a>
        
        <div class="history-card">
            <h2>Your Order History</h2>

            <% if (orderList == null || orderList.isEmpty()) { %>
                <div class="text-center py-5">
                    <p style="font-size: 1.1rem; color: #bbb;">You have not placed any orders yet.</p>
                    <a href="home.jsp" class="btn-view" style="padding: 10px 24px;">Browse Menu</a>
                </div>
            <% } else { %>
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Order ID</th>
                                <th>Total (&#8377;)</th>
                                <th>Payment Mode</th>
                                <th>Status</th>
                                <th>Delivery Address</th>
                                <th class="text-end">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Order o : orderList) { 
                                String status = o.getStatus() != null ? o.getStatus() : "Preparing";
                                String statusClass = "status-preparing";
                                if ("Delivered".equalsIgnoreCase(status)) {
                                    statusClass = "status-delivered";
                                } else if ("Pending".equalsIgnoreCase(status)) {
                                    statusClass = "status-pending";
                                } else if ("Cancelled".equalsIgnoreCase(status)) {
                                    statusClass = "status-cancelled";
                                }
                            %>
                            <tr>
                                <td><strong>#<%= o.getOrderId() %></strong></td>
                                <td style="color: #ff4e50; font-weight: 600;">&#8377;<%= o.getTotalAmount() %></td>
                                <td><%= o.getPaymentMode() != null ? o.getPaymentMode() : "COD" %></td>
                                <td>
                                    <span class="badge-status <%= statusClass %>">
                                        <%= status %>
                                    </span>
                                </td>
                                <td><%= o.getAddress() != null ? o.getAddress() : "MG Road, Bangalore" %></td>
                                <td class="text-end">
                                    <a href="OrderDetailsServlet?orderId=<%= o.getOrderId() %>" class="btn-view">View Items</a>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            <% } %>
        </div>
    </div>
</body>
</html>