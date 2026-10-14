package com.tap.controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.tap.model.Cart;
import com.tap.model.User;

@WebServlet("/CheckoutPageServlet")
public class CheckoutPageServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("loggedInUser") : null;
        Cart cart = (session != null) ? (Cart) session.getAttribute("cart") : null;

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        if (cart == null || cart.getItems() == null || cart.getItems().isEmpty()) {
            response.sendRedirect("cart.jsp?error=empty");
            return;
        }

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head>");
        out.println("<meta charset='UTF-8'>");
        out.println("<title>Checkout - Foodwala</title>");
        out.println("<style>");
        out.println("body { font-family: Arial, sans-serif; background-color: #121212; color: #ffffff; margin: 0; padding: 0; }");
        out.println(".navbar { background-color: #1f1f1f; padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; }");
        out.println(".navbar a { color: #ffffff; text-decoration: none; margin-left: 20px; }");
        out.println(".logo { font-size: 24px; font-weight: bold; color: #ff4757; }");
        out.println(".container { max-width: 600px; margin: 40px auto; background: #1e1e1e; padding: 30px; border-radius: 8px; box-shadow: 0px 4px 10px rgba(0,0,0,0.5); }");
        out.println("h2 { color: #ff4757; text-align: center; }");
        out.println(".form-group { margin-bottom: 20px; }");
        out.println("label { display: block; margin-bottom: 8px; color: #ccc; }");
        out.println("textarea, select { width: 100%; padding: 10px; background: #2a2a2a; border: 1px solid #444; color: #fff; border-radius: 4px; box-sizing: border-box; }");
        out.println(".summary { background: #252525; padding: 15px; border-radius: 5px; margin-bottom: 20px; }");
        out.println(".summary p { margin: 5px 0; color: #bbb; }");
        out.println(".btn { width: 100%; padding: 12px; background-color: #ff4757; color: white; border: none; border-radius: 5px; font-weight: bold; font-size: 16px; cursor: pointer; }");
        out.println(".btn:hover { background-color: #ff6b81; }");
        out.println("</style>");
        out.println("</head>");
        out.println("<body>");

        out.println("<div class='navbar'>");
        out.println("<div class='logo'>🍴 Foodwala</div>");
        out.println("<div><a href='home.jsp'>Home</a><a href='cart.jsp'>Cart</a></div>");
        out.println("</div>");

        out.println("<div class='container'>");
        out.println("<h2>Secure Checkout</h2>");

        out.println("<div class='summary'>");
        out.println("<h3>Order Summary</h3>");
        out.println("<p><strong>Total Items:</strong> " + cart.getItems().size() + "</p>");
        out.println("<p><strong>Total Amount:</strong> $" + cart.getTotalPrice() + "</p>");
        out.println("</div>");

        out.println("<form action='CheckoutServlet' method='post'>");
        out.println("<div class='form-group'>");
        out.println("<label for='address'>Delivery Address:</label>");
        out.println("<textarea id='address' name='address' rows='4' required placeholder='Enter your full delivery address...'></textarea>");
        out.println("</div>");

        out.println("<div class='form-group'>");
        out.println("<label for='paymentMode'>Payment Mode:</label>");
        out.println("<select id='paymentMode' name='paymentMode' required>");
        out.println("<option value='COD'>Cash on Delivery (COD)</option>");
        out.println("<option value='Online'>Online Payment</option>");
        out.println("</select>");
        out.println("</div>");

        out.println("<button type='submit' class='btn'>Place Order</button>");
        out.println("</form>");
        out.println("</div>");

        out.println("</body>");
        out.println("</html>");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}