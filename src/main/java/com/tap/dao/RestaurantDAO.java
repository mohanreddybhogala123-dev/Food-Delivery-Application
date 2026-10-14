package com.tap.dao;

import com.tap.model.Restaurant;
import java.util.List;

public interface RestaurantDAO {
    List<Restaurant> getAllRestaurants();
    Restaurant getRestaurantById(int restaurantId);
}