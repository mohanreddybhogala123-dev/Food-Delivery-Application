<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Available Restaurants - Foodwala</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f8f9fa; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .container { max-width: 1100px; margin-top: 40px; }
        .card { border: none; border-radius: 12px; transition: transform 0.2s; box-shadow: 0 4px 10px rgba(0,0,0,0.05); }
        .card:hover { transform: translateY(-5px); box-shadow: 0 6px 15px rgba(0,0,0,0.1); }
        .card-img-top { height: 180px; object-fit: cover; border-top-left-radius: 12px; border-top-right-radius: 12px; }
        .btn-orange { background-color: #ff5722; color: white; font-weight: 600; }
        .btn-orange:hover { background-color: #e64a19; color: white; }
    </style>
</head>
<body>

    <div class="container">
        <h2 class="text-center fw-bold mb-4">Available Restaurants</h2>

        <!-- If restaurantList is missing in session, provide a direct button to load via HomeServlet -->
        <c:choose>
            <c:when test="${not empty sessionScope.restaurantList}">
                <div class="row row-cols-1 row-cols-md-3 g-4">
                    <c:forEach var="r" items="${sessionScope.restaurantList}">
                        <div class="col">
                            <div class="card h-100">
                                <img src="${r.imagePath}" class="card-img-top" alt="Restaurant Image" onerror="this.src='images/default-restaurant.jpg'">
                                <div class="card-body d-flex flex-column">
                                    <h5 class="card-title fw-bold">${r.restaurantName}</h5>
                                    <p class="text-muted small mb-1">Cuisine: ${r.cuisineType}</p>
                                    <p class="text-muted small mb-3">Delivery Time: ${r.deliveryTime} mins</p>
                                    <!-- Link to menu servlet passing restaurant id -->
                                    <a href="MenuServlet?restaurantId=${r.restaurantId}" class="btn btn-orange mt-auto">View Menu</a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="text-center py-5">
                    <p class="text-muted fs-5">No restaurants found in session.</p>
                    <a href="HomeServlet" class="btn btn-orange btn-lg">Click here to load restaurants</a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

</body>
</html>