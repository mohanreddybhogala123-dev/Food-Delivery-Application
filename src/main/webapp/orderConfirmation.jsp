<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Order Confirmed - Foodwala</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f9f9f9; margin: 0; padding: 40px; text-align: center; }
        .container { max-width: 600px; margin: auto; background: white; padding: 40px; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
        h2 { color: #28a745; }
        p { color: #555; font-size: 16px; }
        .order-id { font-size: 20px; font-weight: bold; color: #333; margin: 20px 0; }
        .home-btn { display: inline-block; background-color: #e44d26; color: white; padding: 10px 20px; border-radius: 4px; text-decoration: none; font-weight: bold; margin-top: 20px; }
        .home-btn:hover { background-color: #c73c1b; }
    </style>
</head>
<body>

<div class="container">
    <h2>Order Placed Successfully!</h2>
    <p>Thank you for ordering with Foodwala. Your delicious food is on the way.</p>
    
    <div class="order-id">
        Order ID: #${sessionScope.orderId}
    </div>

    <a href="home.jsp" class="home-btn">Back to Home</a>
</div>

</body>
</html>