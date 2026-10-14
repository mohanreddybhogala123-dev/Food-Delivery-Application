package com.tap.controller;

import java.io.IOException;
import java.net.URLEncoder;
import java.util.HashMap;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.tap.dao.OrderDAO;
import com.tap.daoimpl.OrderDAOImpl;
import com.tap.model.Cart;
import com.tap.model.Order;
import com.tap.model.User;

@WebServlet("/OrderServlet")
public class OrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("loggedInUser");
        Cart cart = (Cart) session.getAttribute("cart");

        if (cart == null || cart.getItems().isEmpty()) {
            response.sendRedirect("cart.jsp");
            return;
        }

        String address = request.getParameter("address");
        String paymentMode = request.getParameter("paymentMode");

        Order order = new Order();
        int userId = (user != null && user.getUserId() > 0) ? user.getUserId() : 1;
        order.setUserId(userId);
        
        order.setPaymentMode((paymentMode != null && !paymentMode.trim().isEmpty()) ? paymentMode.trim() : "Cash on Delivery (COD)");
        
        if (address != null && !address.trim().isEmpty()) {
            order.setAddress(address.trim());
        } else {
            order.setAddress("MG Road, Bangalore");
        }
        
        order.setStatus("Preparing");

        try {
            OrderDAO orderDAO = new OrderDAOImpl();
            int orderId = orderDAO.insertOrderAndGetId(order, cart);

            if (orderId != -1) {
                session.setAttribute("lastOrderId", orderId);
                session.setAttribute("lastOrderCart", new HashMap<>(cart.getItems()));
                session.setAttribute("lastOrderTotal", cart.getTotalPrice());
                session.setAttribute("lastOrderPayment", order.getPaymentMode());
                session.setAttribute("lastOrderAddress", order.getAddress());

                cart.getItems().clear();
                session.removeAttribute("cart");

                response.sendRedirect("orderSuccess.jsp");
            } else {
                response.sendRedirect("checkout.jsp?error=orderFailed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("checkout.jsp?error=exception");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}