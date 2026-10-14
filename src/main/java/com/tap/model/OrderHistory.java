package com.tap.model;

public class OrderHistory {
    private int orderHistoryId;
    private int userId;
    private int orderId;
    private double totalAmount;
    private String status;

    public OrderHistory() {}

    public int getOrderHistoryId() { return orderHistoryId; }
    public void setOrderHistoryId(int orderHistoryId) { this.orderHistoryId = orderHistoryId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }

    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; } // <-- Essential
}