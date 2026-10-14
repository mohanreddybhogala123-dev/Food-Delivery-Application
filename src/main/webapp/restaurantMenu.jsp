<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Foodwala - Restaurant Menu</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f8f9fa; margin: 0; padding: 20px; }
        h2 { text-align: center; color: #333; }
        .menu-container { max-width: 700px; margin: 0 auto; }
        .menu-item { display: flex; align-items: center; border: 1px solid #ddd; margin-bottom: 15px; padding: 15px; border-radius: 8px; background: #fff; box-shadow: 0 2px 4px rgba(0,0,0,0.05); }
        .menu-item img { width: 100px; height: 100px; object-fit: cover; border-radius: 6px; margin-right: 20px; }
        .menu-details { flex-grow: 1; }
        .menu-details h3 { margin: 0 0 8px 0; color: #222; }
        .menu-details p { margin: 0 0 12px 0; color: #666; font-weight: bold; }
        .add-btn { background-color: #28a745; color: white; border: none; padding: 8px 16px; border-radius: 4px; cursor: pointer; font-size: 14px; }
        .add-btn:hover { background-color: #218838; }
        .view-cart-btn { display: block; text-align: center; margin: 20px auto; padding: 10px 20px; background: #007bff; color: white; text-decoration: none; width: 150px; border-radius: 5px; }
        .view-cart-btn:hover { background: #0056b3; }
    </style>
</head>
<body>

    <div class="menu-container">
        <h2>Restaurant Menu</h2>
        
        <!-- Navigation to Cart -->
        <a href="cart.jsp" class="view-cart-btn">View Cart</a>
        
        <!-- Loop through food list sent from MenuServlet -->
        <c:choose>
            <c:when test="${not empty foodList}">
                <c:forEach var="food" items="${foodList}">
                    <div class="menu-item">
                        <!-- Food Image -->
                        <img src="${food.imagePath}" alt="${food.foodName}" />
                        
                        <div class="menu-details">
                            <h3>${food.foodName}</h3>
                            <p>Rs. ${food.price}</p>
                            
                            <!-- Add to Cart Form -->
                            <form action="CartServlet" method="post">
                                <input type="hidden" name="action" value="add">
                                <input type="hidden" name="foodId" value="${food.foodId}">
                                <input type="hidden" name="restaurantId" value="${food.restaurantId}">
                                <input type="hidden" name="foodName" value="${food.foodName}">
                                <input type="hidden" name="price" value="${food.price}">
                                <input type="hidden" name="imagePath" value="${food.imagePath}">
                                <button type="submit" class="add-btn">Add to Cart</button>
                            </form>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <p style="text-align: center; color: #888;">No menu items found for this restaurant.</p>
            </c:otherwise>
        </c:choose>
    </div>

</body>
</html>