<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Instantly redirects traffic from root/home straight to the Restaurant Servlet
    response.sendRedirect("RestaurantServlet");
%>