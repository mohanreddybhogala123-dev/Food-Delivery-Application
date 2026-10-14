<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Orders - Foodwala Admin</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f6f8;
            margin: 0;
            padding: 20px;
        }
        .container {
            max-width: 1100px;
            margin: auto;
            background: #ffffff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }
        h2 {
            text-align: center;
            color: #333;
            margin-bottom: 25px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }
        table, th, td {
            border: 1px solid #dee2e6;
        }
        th, td {
            padding: 10px;
            text-align: left;
            font-size: 13px;
        }
        th {
            background-color: #333;
            color: white;
            text-align: center;
        }
        td {
            text-align: center;
        }
        tr:nth-child(even) {
            background-color: #f8f9fa;
        }
        select {
            padding: 5px;
            border-radius: 4px;
            border: 1px solid #ccc;
        }
        .update-btn {
            padding: 5px 10px;
            background: #28a745;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-weight: bold;
        }
        .update-btn:hover {
            background: #218838;
        }
        .back-btn {
            display: block;
            width: 200px;
            margin: 20px auto 0;
            padding: 10px;
            background: #ff5722;
            color: white;
            text-align: center;
            border-radius: 5px;
            text-decoration: none;
            font-weight: bold;
        }
        .back-btn:hover {
            background: #e64a19;
        }
    </style>
</head>
<body>

    <div class="container">
        <h2>Platform Order Management</h2>

        <table>
            <tr>
                <th>Order ID</th>
                <th>Customer Email</th>
                <th>Date</th>
                <th>Delivery Address</th>
                <th>Phone</th>
                <th>Payment</th>
                <th>Total (₹)</th>
                <th>Status</th>
                <th>Action</th>
            </tr>
            <% 
                List<HashMap<String, Object>> allOrders = (List<HashMap<String, Object>>) request.getAttribute("allOrders");
                if (allOrders == null) {
                    allOrders = (List<HashMap<String, Object>>) session.getAttribute("allOrders");
                }

                if (allOrders != null && !allOrders.isEmpty()) {
                    for (HashMap<String, Object> order : allOrders) {
                        String currentStatus = (String) order.get("status");
                        if (currentStatus == null || currentStatus.trim().isEmpty()) {
                            currentStatus = "Preparing";
                        }
            %>
            <tr>
                <td>#<%= order.get("orderId") %></td>
                <td><%= order.get("userEmail") != null ? order.get("userEmail") : "N/A" %></td>
                <td><%= order.get("orderDate") != null ? order.get("orderDate") : "N/A" %></td>
                <td><%= order.get("address") != null ? order.get("address") : "N/A" %></td>
                <td><%= order.get("phone") != null ? order.get("phone") : "N/A" %></td>
                <td><%= order.get("paymentMethod") != null ? order.get("paymentMethod") : "N/A" %></td>
                <td>₹<%= order.get("totalAmount") %></td>
                <td>
                    <form action="AdminOrdersServlet" method="get" style="margin: 0;">
                        <input type="hidden" name="action" value="updateStatus">
                        <input type="hidden" name="orderId" value="<%= order.get("orderId") %>">
                        <select name="status">
                            <option value="Preparing" <%= "Preparing".equalsIgnoreCase(currentStatus) ? "selected" : "" %>>Preparing</option>
                            <option value="Out for Delivery" <%= "Out for Delivery".equalsIgnoreCase(currentStatus) ? "selected" : "" %>>Out for Delivery</option>
                            <option value="Delivered" <%= "Delivered".equalsIgnoreCase(currentStatus) ? "selected" : "" %>>Delivered</option>
                            <option value="Cancelled" <%= "Cancelled".equalsIgnoreCase(currentStatus) ? "selected" : "" %>>Cancelled</option>
                        </select>
                </td>
                <td>
                        <button type="submit" class="update-btn">Update</button>
                    </form>
                </td>
            </tr>
            <% 
                    }
                } else {
            %>
            <tr>
                <td colspan="9" style="text-align: center; color: #777; padding: 20px;">No customer orders placed yet.</td>
            </tr>
            <% } %>
        </table>

        <a href="adminDashboard.jsp" class="back-btn">&larr; Back to Dashboard</a>
    </div>

</body>
</html>