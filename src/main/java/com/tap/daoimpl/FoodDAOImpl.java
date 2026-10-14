package com.tap.daoimpl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.tap.dao.FoodDAO;
import com.tap.model.Food;
import com.tap.util.DBConnection;

public class FoodDAOImpl implements FoodDAO {

    @Override
    public List<Food> getAllFoodItems() {
        List<Food> foodList = new ArrayList<>();
        String sql = "SELECT * FROM food";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                Food food = new Food();
                food.setFoodId(rs.getInt("foodId"));
                food.setRestaurantId(rs.getInt("restaurantId"));
                food.setFoodName(rs.getString("foodName"));
                food.setDescription(rs.getString("description"));
                food.setPrice(rs.getDouble("price"));
                food.setImagePath(rs.getString("imagePath"));
                foodList.add(food);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return foodList;
    }

    @Override
    public List<Food> getFoodItemsByRestaurant(int restaurantId) {
        List<Food> foodList = new ArrayList<>();
        String sql = "SELECT * FROM food WHERE restaurantId = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, restaurantId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Food food = new Food();
                    food.setFoodId(rs.getInt("foodId"));
                    food.setRestaurantId(rs.getInt("restaurantId"));
                    food.setFoodName(rs.getString("foodName"));
                    food.setDescription(rs.getString("description"));
                    food.setPrice(rs.getDouble("price"));
                    food.setImagePath(rs.getString("imagePath"));
                    foodList.add(food);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return foodList;
    }

    @Override
    public List<Food> getFoodItemsByRestaurantId(int restaurantId) {
        return getFoodItemsByRestaurant(restaurantId);
    }

    @Override
    public Food getFoodById(int foodId) {
        Food food = null;
        String sql = "SELECT * FROM food WHERE foodId = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, foodId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    food = new Food();
                    food.setFoodId(rs.getInt("foodId"));
                    food.setRestaurantId(rs.getInt("restaurantId"));
                    food.setFoodName(rs.getString("foodName"));
                    food.setDescription(rs.getString("description"));
                    food.setPrice(rs.getDouble("price"));
                    food.setImagePath(rs.getString("imagePath"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return food;
    }

    @Override
    public boolean addFood(Food food) {
        return false;
    }

    @Override
    public boolean updateFood(Food food) {
        return false;
    }

    @Override
    public boolean deleteFood(int foodId) {
        return false;
    }
}