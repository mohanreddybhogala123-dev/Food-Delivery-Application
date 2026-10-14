package com.tap.daoimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.tap.dao.RestaurantDAO;
import com.tap.model.Restaurant;
import com.tap.util.DBConnection;

public class RestaurantDAOImpl implements RestaurantDAO {

    private static final String SELECT_ALL_QUERY = "SELECT * FROM restaurant";
    private static final String SELECT_BY_ID_QUERY = "SELECT * FROM restaurant WHERE restaurantId = ?";

    @Override
    public List<Restaurant> getAllRestaurants() {
        List<Restaurant> restaurantList = new ArrayList<>();
        
        try (Connection con = DBConnection.getConnection();
             Statement stmt = con.createStatement();
             ResultSet rs = stmt.executeQuery(SELECT_ALL_QUERY)) {
            
            while (rs.next()) {
                Restaurant restaurant = new Restaurant();
                restaurant.setRestaurantId(rs.getInt("restaurantId"));
                restaurant.setRestaurantName(rs.getString("restaurantName"));
                restaurant.setDeliveryTime(rs.getString("deliveryTime"));
                restaurant.setCuisineType(rs.getString("cuisineType"));
                restaurant.setRating(rs.getDouble("rating"));
                restaurant.setImagePath(rs.getString("imagePath"));
                restaurant.setAddress(rs.getString("address"));
                
                restaurantList.add(restaurant);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return restaurantList;
    }

    @Override
    public Restaurant getRestaurantById(int restaurantId) {
        Restaurant restaurant = null;
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(SELECT_BY_ID_QUERY)) {
            
            pstmt.setInt(1, restaurantId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    restaurant = new Restaurant();
                    restaurant.setRestaurantId(rs.getInt("restaurantId"));
                    restaurant.setRestaurantName(rs.getString("restaurantName"));
                    restaurant.setDeliveryTime(rs.getString("deliveryTime"));
                    restaurant.setCuisineType(rs.getString("cuisineType"));
                    restaurant.setRating(rs.getDouble("rating"));
                    restaurant.setImagePath(rs.getString("imagePath"));
                    restaurant.setAddress(rs.getString("address"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return restaurant;
    }
}