<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String redirectUrl = request.getParameter("redirect");
    if (redirectUrl == null || redirectUrl.trim().isEmpty()) {
        redirectUrl = (String) session.getAttribute("redirectUrl");
    }
    if (redirectUrl == null || redirectUrl.trim().isEmpty()) {
        redirectUrl = "home.jsp"; // Default fallback if no previous destination
    }
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login - Foodwala</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-color: #0c0c0c;
            color: #e0e0e0;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 20px;
        }
        .card {
            background-color: #181818;
            border: 1px solid #262626;
            border-radius: 12px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.8);
        }
        .form-label {
            color: #cccccc;
            font-size: 0.9rem;
        }
        .form-control {
            background-color: #222222;
            border: 1px solid #333333;
            color: #ffffff;
            border-radius: 8px;
            padding: 10px 14px;
        }
        .form-control:focus {
            background-color: #222222;
            color: #ffffff;
            border-color: #ff4e50;
            box-shadow: 0 0 0 0.25rem rgba(255, 78, 80, 0.25);
        }
        .form-control::placeholder {
            color: #777777;
        }
        .btn-primary {
            background-color: #ff4e50;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            transition: background-color 0.2s ease;
        }
        .btn-primary:hover {
            background-color: #e64345;
        }
        .brand-title {
            color: #ff4e50;
            font-weight: 800;
            letter-spacing: 0.5px;
            text-decoration: none;
        }
        .brand-title:hover {
            color: #e64345;
        }
        .text-dark-custom {
            color: #ffffff !important;
        }
        .alert-danger {
            background-color: #2c1518;
            color: #ff6b6b;
            border: 1px solid #4a2024;
            border-radius: 8px;
        }
        .register-link {
            color: #ff4e50 !important;
            font-weight: 600;
            text-decoration: none;
        }
        .register-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-5">
                <div class="card p-2">
                    <div class="card-body p-4">
                        <div class="text-center mb-4">
                            <a href="home.jsp" class="brand-title h2 text-decoration-none">🍴 Foodwala</a>
                            <h4 class="text-dark-custom mt-2 fw-bold">Welcome Back</h4>
                            <p class="text-muted small">Login to access your orders and cart</p>
                        </div>

                        <% if (error != null && !error.trim().isEmpty()) { %>
                            <div class="alert alert-danger text-center py-2 mb-3" role="alert">
                                Invalid email or password. Please try again.
                            </div>
                        <% } %>

                        <form action="LoginServlet" method="post">
                            <!-- Hidden input passing the redirect destination to LoginServlet -->
                            <input type="hidden" name="redirect" value="<%= redirectUrl %>">

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Email Address</label>
                                <input type="email" name="email" class="form-control" value="aarav.sharma@gmail.com" placeholder="Enter your email" required>
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label fw-semibold">Password</label>
                                <input type="password" name="password" class="form-control" value="Password@123" placeholder="Enter your password" required>
                            </div>
                            
                            <div class="d-grid mt-4">
                                <button type="submit" class="btn btn-primary btn-lg">Login</button>
                            </div>
                        </form>

                        <div class="text-center mt-4">
                            <p class="mb-0 text-muted">Don't have an account? <a href="register.jsp" class="register-link">Register here</a></p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

</body>
</html>