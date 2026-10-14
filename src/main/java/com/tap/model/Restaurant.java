package com.tap.model;

public class Restaurant {
    private int restaurantId;
    private String restaurantName;
    private String deliveryTime;
    private String cuisineType;
    private double rating;
    private String imagePath;
    private String address;

    // Default Constructor
    public Restaurant() {}

    // Parameterized Constructor
    public Restaurant(int restaurantId, String restaurantName, String deliveryTime, String cuisineType, double rating, String imagePath, String address) {
        this.restaurantId = restaurantId;
        this.restaurantName = restaurantName;
        this.deliveryTime = deliveryTime;
        this.cuisineType = cuisineType;
        this.rating = rating;
        this.imagePath = imagePath;
        this.address = address;
    }

    // Getters and Setters
    public int getRestaurantId() { return restaurantId; }
    public void setRestaurantId(int restaurantId) { this.restaurantId = restaurantId; }

    public String getRestaurantName() { return restaurantName; }
    public void setRestaurantName(String restaurantName) { this.restaurantName = restaurantName; }

    public String getDeliveryTime() { return deliveryTime; }
    public void setDeliveryTime(String deliveryTime) { this.deliveryTime = deliveryTime; }

    public String getCuisineType() { return cuisineType; }
    public void setCuisineType(String cuisineType) { this.cuisineType = cuisineType; }

    public double getRating() { return rating; }
    public void setRating(double rating) { this.rating = rating; }

    public String getImagePath() { return imagePath; }
    public void setImagePath(String imagePath) { this.imagePath = imagePath; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
}