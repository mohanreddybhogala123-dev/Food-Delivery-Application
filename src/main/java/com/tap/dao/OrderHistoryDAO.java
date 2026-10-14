package com.tap.dao;

import java.util.List;
import com.tap.model.Order;
import com.tap.model.OrderHistory;

public interface OrderHistoryDAO {
    List<Order> getOrdersByUserId(int userId);
    void insertOrderHistory(OrderHistory orderHistory);
    List<OrderHistory> getAllOrderHistories();
}