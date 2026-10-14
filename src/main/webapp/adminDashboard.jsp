<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard - Foodwala</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f6f8;
            margin: 0;
            padding: 0;
        }
        header {
            background-color: #333;
            color: white;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .logo {
            font-size: 22px;
            font-weight: bold;
            color: white;
            text-decoration: none;
        }
        .container {
            max-width: 900px;
            margin: 40px auto;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        h2 {
            color: #333;
            margin-bottom: 10px;
            text-align: center;
        }
        .admin-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
            gap: 20px;
            margin-top: 25px;
        }
        .admin-card {
            background: #f8f9fa;
            border: 1px solid #dee2e6;
            padding: 25px;
            border-radius: 8px;
            text-align: center;
            transition: transform 0.2s;
        }
        .admin-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
        }
        .admin-card h3 {
            margin-top: 0;
            color: #ff5722;
        }
        .admin-card p {
            color: #666;
            font-size: 14px;
            margin-bottom: 20px;
        }
        .admin-btn {
            display: inline-block;
            padding: 10px 20px;
            background: #ff5722;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            font-weight: bold;
        }
        .admin-btn:hover {
            background: #e64a19;
        }
        .back-home {
            display: block;
            text-align: center;
            margin-top: 30px;
            color: #666;
            text-decoration: none;
            font-weight: bold;
        }
        .back-home:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

    <header>
        <a href="adminDashboard.jsp" class="logo">🛠️ Foodwala Admin Portal</a>
        <a href="index.jsp" style="color: white; text-decoration: none; font-weight: bold;">Exit to App</a>
    </header>

    <div class="container">
        <h2>Administrator Control Panel</h2>
        <p style="text-align: center; color: #666;">Manage your restaurant platform listings, menus, and customer orders below.</p>

        <div class="admin-grid">
            <!-- Add Restaurant Card -->
            <div class="admin-card">
                <h3>Restaurants</h3>
                <p>Add new partner restaurants to the Foodwala network.</p>
                <a href="addRestaurant.jsp" class="admin-btn">Add Restaurant</a>
            </div>

            <!-- Add Food Item Card -->
            <div class="admin-card">
                <h3>Food Items</h3>
                <p>Add delicious dishes and menus to registered restaurants.</p>
                <a href="addFood.jsp" class="admin-btn">Add Food Item</a>
            </div>

            <!-- View Orders Card -->
            <div class="admin-card">
                <h3>Customer Orders</h3>
                <p>View and manage all customer orders across the platform.</p>
                <a href="AdminOrdersServlet" class="admin-btn">View All Orders</a>
            </div>
        </div>

        <a href="index.jsp" class="back-home">&larr; Return to Main Website</a>
    </div>

</body>
</html>