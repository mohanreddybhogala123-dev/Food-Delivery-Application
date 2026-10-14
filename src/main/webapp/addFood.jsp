<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Food Item - Foodwala Admin</title>
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
        .form-group input, 
        .form-group textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-sizing: border-box;
        }
        .form-group textarea {
            resize: vertical;
            height: 70px;
        }
        .btn-submit {
            width: 100%;
            padding: 12px;
            background: #28a745;
            border: none;
            color: white;
            font-size: 16px;
            border-radius: 5px;
            cursor: pointer;
            font-weight: bold;
            margin-top: 10px;
        }
        .btn-submit:hover {
            background: #218838;
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
        <h2>Add Food Item</h2>

        <!-- Form targets your AddFoodServlet -->
        <form action="AddFoodServlet" method="post">
            <div class="form-group">
                <label>Restaurant ID:</label>
                <input type="number" name="restaurantId" placeholder="e.g. 20" required />
            </div>

            <div class="form-group">
                <label>Food Name:</label>
                <input type="text" name="foodName" placeholder="e.g. Mughlai Biryani" required />
            </div>

            <div class="form-group">
                <label>Description:</label>
                <textarea name="description" placeholder="Brief description of the dish..." required></textarea>
            </div>

            <div class="form-group">
                <label>Price (₹):</label>
                <input type="number" step="0.01" name="price" placeholder="e.g. 380.00" required />
            </div>

            <div class="form-group">
                <label>Image URL:</label>
                <input type="text" name="imagePath" placeholder="https://images.unsplash.com/..." required />
            </div>

            <button type="submit" class="btn-submit">Add Food Item</button>
        </form>

        <a href="index.jsp" class="back-link">&larr; Back to Home</a>
    </div>

</body>
</html>