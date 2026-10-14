<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Restaurant - Foodwala Admin</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f6f8;
            margin: 0;
            padding: 20px;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }
        .form-container {
            background: #ffffff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            width: 400px;
        }
        h2 {
            text-align: center;
            color: #333;
            margin-bottom: 20px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            color: #555;
            font-weight: bold;
        }
        .form-group input {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-sizing: border-box;
        }
        .btn-submit {
            width: 100%;
            padding: 12px;
            background: #ff5722;
            border: none;
            color: white;
            font-size: 16px;
            border-radius: 5px;
            cursor: pointer;
            font-weight: bold;
            margin-top: 10px;
        }
        .btn-submit:hover {
            background: #e64a19;
        }
        .back-link {
            display: block;
            text-align: center;
            margin-top: 15px;
            color: #666;
            text-decoration: none;
            font-size: 14px;
        }
        .back-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

    <div class="form-container">
        <h2>Add New Restaurant</h2>

        <!-- Form targets your AddRestaurantServlet -->
        <form action="AddRestaurantServlet" method="post">
            <div class="form-group">
                <label>Restaurant Name:</label>
                <input type="text" name="restaurantName" placeholder="e.g. Royal Mughal" required />
            </div>

            <div class="form-group">
                <label>Cuisine Type:</label>
                <input type="text" name="cuisineType" placeholder="e.g. Mughlai, North Indian" required />
            </div>

            <div class="form-group">
                <label>Delivery Time:</label>
                <input type="text" name="deliveryTime" placeholder="e.g. 30-40 mins" required />
            </div>

            <div class="form-group">
                <label>Image URL:</label>
                <input type="text" name="imagePath" placeholder="https://images.unsplash.com/..." required />
            </div>

            <button type="submit" class="btn-submit">Add Restaurant</button>
        </form>

        <a href="index.jsp" class="back-link">&larr; Back to Home</a>
    </div>

</body>
</html>