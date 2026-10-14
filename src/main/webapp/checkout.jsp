<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tap.model.Cart, com.tap.model.User" %>
<%
    User user = (User) session.getAttribute("loggedInUser");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Cart cart = (Cart) session.getAttribute("cart");
    if (cart == null || cart.getItems().isEmpty()) {
        response.sendRedirect("cart.jsp");
        return;
    }

    // Preserve typed address if redirected back due to error, otherwise use profile or default
    String defaultAddress = request.getParameter("address");
    if (defaultAddress == null || defaultAddress.trim().isEmpty()) {
        defaultAddress = (user.getAddress() != null && !user.getAddress().trim().isEmpty()) 
                         ? user.getAddress() 
                         : "MG Road, Bangalore";
    }

    String errorParam = request.getParameter("error");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Secure Checkout - Foodwala</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #0c0c0c; color: #e0e0e0; font-family: 'Segoe UI', sans-serif; }
        header { background-color: #1a1a1a; padding: 15px 40px; display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #282828; }
        .logo { font-size: 1.8rem; font-weight: 800; color: #ff4e50; text-decoration: none; }
        .nav-links a { text-decoration: none; color: #e0e0e0; font-weight: 600; margin-left: 20px; }
        .checkout-container { max-width: 650px; margin: 40px auto; background: #181818; border: 1px solid #262626; border-radius: 12px; padding: 40px; box-shadow: 0 10px 25px rgba(0,0,0,0.5); }
        h2 { color: #ff4e50; font-weight: 800; text-align: center; margin-bottom: 30px; }
        .summary-box { background: #111; padding: 15px 20px; border-radius: 8px; border: 1px solid #222; margin-bottom: 25px; display: flex; justify-content: space-between; align-items: center; }
        label { font-weight: 600; color: #ccc; margin-bottom: 8px; display: block; }
        .form-control, .form-select { background-color: #111; border: 1px solid #ff4e50; color: #fff; border-radius: 6px; padding: 12px; }
        .form-control:focus, .form-select:focus { background-color: #111; color: #fff; border-color: #ff4e50; box-shadow: 0 0 0 0.2rem rgba(255, 78, 80, 0.25); }
        .btn-place-order { background-color: #ff4e50; border: none; color: #fff; font-weight: 700; font-size: 1.1rem; width: 100%; padding: 14px; border-radius: 8px; margin-top: 25px; transition: 0.3s ease; }
        .btn-place-order:hover { background-color: #e64345; }
        .btn-profile-addr { background: transparent; border: 1px solid #333; color: #888; font-size: 0.8rem; padding: 2px 8px; border-radius: 4px; float: right; cursor: pointer; }
        .btn-profile-addr:hover { color: #ff4e50; border-color: #ff4e50; }
    </style>
</head>
<body>
    <header>
        <a href="home.jsp" class="logo">🍴 Foodwala</a>
        <div class="nav-links">
            <a href="home.jsp" style="color:#e0e0e0;">Home</a>
            <a href="cart.jsp" style="color:#e0e0e0;">Cart</a>
        </div>
    </header>

    <div class="checkout-container">
        <h2>Secure Checkout</h2>

        <% if (errorParam != null) { %>
            <div class="alert alert-danger text-center mb-4" role="alert">
                Order processing failed. Please verify your details and try again.
            </div>
        <% } %>

        <div class="summary-box">
            <div><strong>Total Items:</strong> <%= cart.getItems().size() %></div>
            <div><strong>Grand Total:</strong> <span style="color: #ff4e50; font-size: 1.2rem; font-weight: 700;">&#8377;<%= cart.getTotalPrice() %></span></div>
        </div>

        <form action="OrderServlet" method="post">
            <div class="mb-4">
                <label for="address">
                    Delivery Address
                    <button type="button" class="btn-profile-addr" onclick="document.getElementById('address').value='<%= user.getAddress() != null ? user.getAddress() : "MG Road, Bangalore" %>'">Use Profile Address</button>
                </label>
                <!-- Fully editable textarea for any custom address -->
                <textarea class="form-control" id="address" name="address" rows="3" required placeholder="Type any delivery address here..."><%= defaultAddress %></textarea>
                <small style="color: #666; font-size: 0.8rem;">Type any new address here; it will be saved directly for this order and shown in your order history.</small>
            </div>

            <div class="mb-4">
                <label for="paymentMode">Payment Mode</label>
                <select class="form-select" id="paymentMode" name="paymentMode">
                    <option value="Cash on Delivery (COD)" selected>Cash on Delivery (COD)</option>
                    <option value="UPI">UPI / Online Payment</option>
                    <option value="Credit/Debit Card">Credit / Debit Card</option>
                </select>
            </div>

            <button type="submit" class="btn-place-order">PLACE ORDER</button>
        </form>
    </div>
</body>
</html>