<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Register - Foodwala</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #0c0c0c; color: #e0e0e0; font-family: 'Segoe UI', sans-serif; }
        .register-container { max-width: 480px; margin: 50px auto; }
        .register-card { background: #181818; border: 1px solid #262626; border-radius: 12px; padding: 35px; box-shadow: 0 10px 25px rgba(0,0,0,0.5); }
        .logo { font-size: 2.2rem; font-weight: 800; color: #ff4e50; text-align: center; margin-bottom: 5px; text-decoration: none; display: block; }
        h3 { color: #fff; font-weight: 700; text-align: center; margin-bottom: 25px; }
        .form-label { font-weight: 600; color: #ccc; margin-top: 12px; }
        .form-control { background-color: #121212; border: 1px solid #333; color: #fff; border-radius: 8px; padding: 12px; }
        .form-control:focus { background-color: #121212; border-color: #ff4e50; color: #fff; box-shadow: none; }
        .btn-register { background-color: #ff4e50; border: none; font-weight: bold; width: 100%; padding: 14px; color: #fff; border-radius: 8px; margin-top: 25px; text-transform: uppercase; letter-spacing: 0.5px; }
        .btn-register:hover { background-color: #e64345; color: #fff; }
        .alert-custom { background-color: rgba(220, 53, 69, 0.15); border: 1px solid #dc3545; color: #ff6b6b; border-radius: 8px; padding: 10px 15px; font-size: 0.9rem; margin-bottom: 15px; }
        .login-link { text-align: center; margin-top: 20px; font-size: 0.95rem; color: #aaa; }
        .login-link a { color: #ff4e50; text-decoration: none; font-weight: 600; }
        .login-link a:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <div class="container register-container">
        <div class="register-card">
            <a href="home.jsp" class="logo">🍴 Foodwala</a>
            <h3>Create Account</h3>

            <% 
                String error = request.getParameter("error");
                if ("emailExists".equals(error)) {
            %>
                <div class="alert-custom">An account with this email address already exists. Please login.</div>
            <%  } else if ("registrationFailed".equals(error)) { %>
                <div class="alert-custom">Unable to create account. Please try again.</div>
            <%  } else if ("invalidInput".equals(error)) { %>
                <div class="alert-custom">Please fill out all required fields.</div>
            <%  } %>

            <form action="RegisterServlet" method="POST">
                <div class="mb-2">
                    <label class="form-label">Full Name</label>
                    <input type="text" name="name" class="form-control" placeholder="Enter your full name" required>
                </div>

                <div class="mb-2">
                    <label class="form-label">Email Address</label>
                    <input type="email" name="email" class="form-control" placeholder="Enter your email address" required>
                </div>

                <div class="mb-2">
                    <label class="form-label">Password</label>
                    <input type="password" name="password" class="form-control" placeholder="Create a password" required>
                </div>

                <div class="mb-2">
                    <label class="form-label">Phone Number</label>
                    <input type="tel" name="phone" class="form-control" placeholder="Enter your phone number">
                </div>

                <div class="mb-2">
                    <label class="form-label">Address</label>
                    <textarea name="address" class="form-control" rows="2" placeholder="Enter your delivery address"></textarea>
                </div>

                <button type="submit" class="btn-register">Create Account</button>

                <div class="login-link">
                    Already have an account? <a href="login.jsp">Login here</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>