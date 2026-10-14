<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map, java.util.HashMap, com.tap.model.CartItem, com.tap.model.User, java.net.URLEncoder" %>
<%
    User user = (User) session.getAttribute("loggedInUser");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Integer orderId = (Integer) session.getAttribute("lastOrderId");
    if (orderId == null || orderId <= 0) {
        String idParam = request.getParameter("orderId");
        try {
            if (idParam != null && !idParam.trim().isEmpty()) {
                orderId = Integer.parseInt(idParam.trim());
            }
        } catch (Exception e) {}
    }
    if (orderId == null || orderId <= 0) {
        orderId = 85;
    }

    Map<Integer, CartItem> cartItems = (Map<Integer, CartItem>) session.getAttribute("lastOrderCart");
    Double totalAmount = (Double) session.getAttribute("lastOrderTotal");
    String paymentMode = (String) session.getAttribute("lastOrderPayment");
    String address = (String) session.getAttribute("lastOrderAddress");

    if (cartItems == null) {
        cartItems = new HashMap<>();
    }
    if (totalAmount == null) {
        totalAmount = 0.0;
        for (CartItem ci : cartItems.values()) {
            totalAmount += (ci.getPrice() * ci.getQuantity());
        }
    }
    if (paymentMode == null) paymentMode = "COD";
    if (address == null || address.trim().isEmpty()) {
        address = user.getAddress() != null ? user.getAddress() : "MG Road, Bangalore";
    }
    
    String customerName = user.getName() != null ? user.getName() : "Foodwala Customer";

    // Dynamic map search query encoding based on user delivery address
    String encodedAddress = URLEncoder.encode(address, "UTF-8");
    String mapEmbedUrl = "https://maps.google.com/maps?q=" + encodedAddress + "&t=&z=13&ie=UTF8&iwloc=&output=embed";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Order Success & Live Tracking - Foodwala</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #0c0c0c; color: #e0e0e0; font-family: 'Segoe UI', sans-serif; }
        header { background-color: #1a1a1a; padding: 15px 40px; display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #282828; }
        .logo { font-size: 1.8rem; font-weight: 800; color: #ff4e50; text-decoration: none; }
        .nav-links a { text-decoration: none; color: #e0e0e0; font-weight: 600; margin-left: 20px; }
        .nav-links a:hover { color: #ff4e50; }
        .container { max-width: 750px; margin: 30px auto; padding: 0 20px; }
        .receipt-card { background: #181818; border: 1px solid #262626; border-radius: 12px; padding: 35px; box-shadow: 0 10px 25px rgba(0,0,0,0.5); }
        .success-icon { width: 60px; height: 60px; background-color: rgba(40, 167, 69, 0.15); color: #28a745; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 30px; margin: 0 auto 15px auto; }
        h2 { color: #fff; font-weight: 700; text-align: center; margin-bottom: 5px; }
        .subtitle { color: #888; text-align: center; font-size: 0.95rem; margin-bottom: 25px; }
        .info-box { background: #121212; border: 1px solid #282828; border-radius: 8px; padding: 20px; margin-bottom: 25px; }
        .info-row { display: flex; justify-content: space-between; margin-bottom: 8px; font-size: 0.95rem; }
        .info-row:last-child { margin-bottom: 0; }
        .table { color: #fff; vertical-align: middle; margin-bottom: 20px; }
        .table th { background-color: #1a1a1a; color: #ff4e50; border-bottom: 1px solid #333; font-weight: 600; }
        .table td { background-color: #181818 !important; color: #fff; border-bottom: 1px solid #262626; }
        .grand-total-box { display: flex; justify-content: space-between; align-items: center; border-top: 1px solid #333; padding-top: 15px; margin-top: 15px; }
        
        /* Zomato-style Tracker Legend */
        .tracking-status { background: #1a1a1a; border: 1px solid #333; border-radius: 8px; padding: 15px; margin-top: 25px; text-align: left; }
        .tracking-step { display: flex; align-items: center; margin-bottom: 8px; font-size: 0.95rem; color: #ccc; }
        .tracking-step span { width: 12px; height: 12px; background-color: #28a745; border-radius: 50%; display: inline-block; margin-right: 10px; flex-shrink: 0; }
        .map-container { margin: 15px 0 25px 0; border-radius: 8px; overflow: hidden; border: 1px solid #333; }

        /* Action Buttons */
        .btn-group-action { display: flex; gap: 15px; margin-top: 25px; flex-wrap: wrap; }
        .btn-action { background-color: #ff4e50; border: none; font-weight: bold; flex: 1; padding: 12px; color: #fff; border-radius: 8px; text-transform: uppercase; letter-spacing: 0.5px; text-decoration: none; display: inline-block; text-align: center; transition: background 0.2s; min-width: 150px; }
        .btn-action:hover { background-color: #e64345; color: #fff; }
        .btn-print { background-color: #262626; border: 1px solid #444; color: #fff; }
        .btn-print:hover { background-color: #333; color: #ff4e50; border-color: #ff4e50; }
        .btn-view-items { background-color: #28a745; }
        .btn-view-items:hover { background-color: #218838; }

        /* Print Styling */
        @media print {
            body { background-color: #fff !important; color: #000 !important; }
            header, .no-print { display: none !important; }
            .container { max-width: 100% !important; margin: 0 !important; padding: 0 !important; }
            .receipt-card { background: #fff !important; border: none !important; box-shadow: none !important; padding: 0 !important; }
            .info-box { background: #f9f9f9 !important; border: 1px solid #ddd !important; color: #000 !important; }
            .info-row { color: #000 !important; }
            h2 { color: #000 !important; }
            .subtitle { color: #555 !important; }
            .table th { background-color: #eee !important; color: #000 !important; border-bottom: 2px solid #000 !important; }
            .table td { background-color: #fff !important; color: #000 !important; border-bottom: 1px solid #ccc !important; }
            .grand-total-box { border-top: 2px solid #000 !important; color: #000 !important; }
            .grand-total-box h4 { color: #000 !important; }
        }
    </style>
</head>
<body>
    <!-- Order Success / Confirmation Sound Effect -->
    <audio id="successAudio" autoplay>
        <source src="https://assets.mixkit.co/active_storage/sfx/2869/2869-preview.mp3" type="audio/mpeg">
    </audio>

    <header class="no-print">
        <a href="home.jsp" class="logo">🍴 Foodwala</a>
        <div class="nav-links">
            <a href="home.jsp">Home</a>
            <a href="OrderHistoryServlet">My Orders</a>
            <a href="cart.jsp">Cart</a>
        </div>
    </header>

    <div class="container">
        <div class="receipt-card">
            <div class="success-icon">&#10003;</div>
            <h2>Order Placed Successfully!</h2>
            <div class="subtitle">Thank you for ordering with Foodwala. Your delicious meal is being prepared.</div>

            <div class="info-box">
                <div class="info-row">
                    <span><strong>Order ID:</strong></span>
                    <span style="color: #ff4e50; font-weight: 700;">#<%= orderId %></span>
                </div>
                <div class="info-row">
                    <span><strong>Customer:</strong></span>
                    <span><%= customerName %></span>
                </div>
                <div class="info-row">
                    <span><strong>Payment Mode:</strong></span>
                    <span><%= paymentMode != null ? paymentMode : "COD" %></span>
                </div>
                <div class="info-row">
                    <span><strong>Status:</strong></span>
                    <span style="color: #ffc107; font-weight: 600;">Preparing</span>
                </div>
                <hr style="border-color: #282828; margin: 12px 0;">
                <div class="info-row">
                    <span><strong>Delivery Address:</strong></span>
                    <span class="text-end" style="max-width: 65%;"><%= address %></span>
                </div>
            </div>

            <table class="table">
                <thead>
                    <tr>
                        <th>Item Name</th>
                        <th class="text-center">Qty</th>
                        <th class="text-end">Price</th>
                        <th class="text-end">Total</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                        if (cartItems != null && !cartItems.isEmpty()) {
                            for (CartItem item : cartItems.values()) {
                                double itemTotal = item.getPrice() * item.getQuantity();
                    %>
                    <tr>
                        <td><strong><%= item.getName() %></strong></td>
                        <td class="text-center"><%= item.getQuantity() %></td>
                        <td class="text-end">₹<%= item.getPrice() %></td>
                        <td class="text-end">₹<%= itemTotal %></td>
                    </tr>
                    <% 
                            }
                        } else {
                    %>
                    <tr>
                        <td colspan="4" class="text-center text-muted">Order items registered successfully. Click 'View Order Items' below.</td>
                    </tr>
                    <% } %>
                </tbody>
            </table>

            <div class="grand-total-box">
                <h4 class="mb-0">Grand Total:</h4>
                <h4 class="mb-0" style="color: #ff4e50;">₹<%= totalAmount %></h4>
            </div>

            <!-- Zomato Style Live Delivery Route Tracking -->
            <div class="tracking-status no-print">
                <div class="tracking-step"><span></span> <strong>Pickup Point:</strong> Foodwala Central Kitchen & Restaurant</div>
                <div class="tracking-step" style="margin-bottom: 0;"><span></span> <strong>Drop Location:</strong> <%= address %></div>
            </div>

            <div class="map-container no-print">
                <iframe 
                    width="100%" 
                    height="230" 
                    style="border:0;" 
                    loading="lazy" 
                    src="<%= mapEmbedUrl %>">
                </iframe>
            </div>

            <div class="btn-group-action no-print">
                <a href="OrderDetailsServlet?orderId=<%= orderId %>" class="btn-action btn-view-items">View Order Items</a>
                <button type="button" onclick="window.print()" class="btn-action btn-print">🖨️ Print Receipt</button>
                <a href="OrderHistoryServlet" class="btn-action">Order History</a>
            </div>
        </div>
    </div>
</body>
</html>