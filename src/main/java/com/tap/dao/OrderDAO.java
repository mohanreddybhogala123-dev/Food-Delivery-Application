package com.tap.dao;

import java.util.List;
import com.tap.model.Order;
import com.tap.model.OrderItem;
import com.tap.model.Cart;

public interface OrderDAO {
    int insertOrderAndGetId(Order order, Cart cart);
    List<Order> getOrdersByUserId(int userId);
    List<OrderItem> getOrderItemsByOrderId(int orderId);
}