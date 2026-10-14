package com.tap.daoimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.tap.dao.OrderHistoryDAO;
import com.tap.model.Order;
import com.tap.model.OrderHistory;
import com.tap.util.DBConnection;

public class OrderHistoryDAOImpl implements OrderHistoryDAO {

    private static final String GET_ORDERS_BY_USER_DESC = 
        "SELECT * FROM orders WHERE userId = ? ORDER BY orderId DESC";

    @Override
    public List<Order> getOrdersByUserId(int userId) {
        List<Order> orderList = new ArrayList<>();
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(GET_ORDERS_BY_USER_DESC)) {

            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Order order = new Order();
                    try { order.setOrderId(rs.getInt("orderId")); } catch (Exception e) { order.setOrderId(rs.getInt("order_id")); }
                    try { order.setUserId(rs.getInt("userId")); } catch (Exception e) { order.setUserId(rs.getInt("user_id")); }
                    try { order.setTotalAmount(rs.getDouble("totalAmount")); } catch (Exception e) { order.setTotalAmount(rs.getDouble("total_amount")); }
                    try { order.setStatus(rs.getString("status")); } catch (Exception ignored) {}
                    try { order.setPaymentMode(rs.getString("paymentMode")); } catch (Exception e) { order.setPaymentMode(rs.getString("payment_mode")); }
                    try { order.setAddress(rs.getString("address")); } catch (Exception ignored) {}
                    orderList.add(order);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return orderList;
    }

    @Override
    public void insertOrderHistory(OrderHistory orderHistory) {
        // Stub to satisfy interface
    }

    @Override
    public List<OrderHistory> getAllOrderHistories() {
        return new ArrayList<>();
    }
}