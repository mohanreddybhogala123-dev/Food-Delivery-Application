package com.tap.daoimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import com.tap.dao.OrderItemDAO;
import com.tap.model.OrderItem;
import com.tap.util.DBConnection;

public class OrderItemDAOImpl implements OrderItemDAO {

    private static final String INSERT_ORDER_ITEM = 
        "INSERT INTO orderItem (orderId, foodId, quantity, price) VALUES (?, ?, ?, ?)";

    private static final String SELECT_ITEMS_BY_ORDER_ID = 
        "SELECT oi.*, f.foodName, f.imagePath FROM orderItem oi JOIN food f ON oi.foodId = f.foodId WHERE oi.orderId = ?";

    @Override
    public void addOrderItem(OrderItem orderItem) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(INSERT_ORDER_ITEM)) {
            
            pstmt.setInt(1, orderItem.getOrderId());
            pstmt.setInt(2, orderItem.getFoodId());
            pstmt.setInt(3, orderItem.getQuantity());
            pstmt.setDouble(4, orderItem.getPrice());
            
            pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public List<OrderItem> getOrderItemsByOrderId(int orderId) {
        List<OrderItem> items = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(SELECT_ITEMS_BY_ORDER_ID)) {
            
            pstmt.setInt(1, orderId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    OrderItem item = new OrderItem();
                    
                    try { item.setOrderItemId(rs.getInt("orderItemId")); } 
                    catch (Exception e) { try { item.setOrderItemId(rs.getInt("itemId")); } catch (Exception ignored) {} }

                    try { item.setOrderId(rs.getInt("orderId")); } catch (Exception ignored) {}
                    try { item.setFoodId(rs.getInt("foodId")); } catch (Exception ignored) {}
                    try { item.setQuantity(rs.getInt("quantity")); } catch (Exception ignored) {}

                    try { item.setPrice(rs.getDouble("price")); } 
                    catch (Exception e) { item.setPrice(0.0); }

                    try { item.setSubtotal(rs.getDouble("subtotal")); } 
                    catch (Exception e) { item.setSubtotal(item.getQuantity() * item.getPrice()); }

                    try { item.setItemName(rs.getString("foodName")); } 
                    catch (Exception e) { item.setItemName("Food Item"); }

                    try { item.setImagePath(rs.getString("imagePath")); } 
                    catch (Exception e) { item.setImagePath(""); }

                    items.add(item);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return items;
    }
}