package com.tap.controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.tap.dao.UserDAO;
import com.tap.daoimpl.UserDAOImpl;
import com.tap.model.User;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        if (username == null || username.trim().isEmpty()) {
            username = request.getParameter("name");
        }
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            response.sendRedirect("register.jsp?error=missingFields");
            return;
        }

        username = username != null && !username.trim().isEmpty() ? username.trim() : "Aarav Sharma";
        email = email.trim().toLowerCase();
        password = password.trim();
        phone = phone != null && !phone.trim().isEmpty() ? phone.trim() : "9876543210";
        address = address != null && !address.trim().isEmpty() ? address.trim() : "MG Road, Bangalore";

        UserDAO userDAO = new UserDAOImpl();

        // Check if email already exists to prevent duplicate key errors
        boolean emailExists = false;
        try {
            emailExists = userDAO.isEmailExists(email);
        } catch (Exception ignored) {}

        if (emailExists) {
            response.sendRedirect("login.jsp?msg=alreadyExists");
            return;
        }

        User newUser = new User();
        newUser.setName(username);
        newUser.setEmail(email);
        newUser.setPassword(password);
        newUser.setPhone(phone);
        newUser.setAddress(address);

        boolean registered = false;
        try {
            registered = userDAO.registerUser(newUser);
        } catch (Exception ignored) {}

        if (registered) {
            response.sendRedirect("login.jsp?msg=registeredSuccessfully");
        } else {
            response.sendRedirect("register.jsp?error=registrationFailed");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}