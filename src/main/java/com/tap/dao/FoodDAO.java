package com.tap.dao;

import java.util.List;
import com.tap.model.Food;

public interface FoodDAO {
    List<Food> getAllFoodItems();
    List<Food> getFoodItemsByRestaurant(int restaurantId);
    List<Food> getFoodItemsByRestaurantId(int restaurantId);
    Food getFoodById(int foodId);
    boolean addFood(Food food);
    boolean updateFood(Food food);
    boolean deleteFood(int foodId);
}