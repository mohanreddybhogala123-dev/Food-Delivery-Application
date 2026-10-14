package com.tap.model;

public class CartItem {
    private int foodId;
    private int itemId;
    private int restaurantId;
    private String name;
    private int quantity;
    private double price;
    private String imagePath;

    public CartItem() {
    }

    public CartItem(int foodId, int restaurantId, String name, int quantity, double price, String imagePath) {
        this.foodId = foodId;
        this.itemId = foodId; // Synchronize itemId with foodId
        this.restaurantId = restaurantId;
        this.name = name;
        this.quantity = quantity;
        this.price = price;
        this.imagePath = imagePath != null ? imagePath : "";
    }

    public int getFoodId() {
        return foodId > 0 ? foodId : itemId;
    }

    public void setFoodId(int foodId) {
        this.foodId = foodId;
        this.itemId = foodId;
    }

    public int getItemId() {
        return itemId > 0 ? itemId : foodId;
    }

    public void setItemId(int itemId) {
        this.itemId = itemId;
        this.foodId = itemId;
    }

    public int getRestaurantId() {
        return restaurantId;
    }

    public void setRestaurantId(int restaurantId) {
        this.restaurantId = restaurantId;
    }

    // Support both getName() and getItemName() to prevent any NoSuchMethodError across JSPs
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getItemName() {
        return name;
    }

    public void setItemName(String name) {
        this.name = name;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public String getImagePath() {
        return imagePath != null ? imagePath : "";
    }

    public void setImagePath(String imagePath) {
        this.imagePath = imagePath != null ? imagePath : "";
    }

    @Override
    public int hashCode() {
        return getFoodId();
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) return true;
        if (obj == null || getClass() != obj.getClass()) return false;
        CartItem cartItem = (CartItem) obj;
        return getFoodId() == cartItem.getFoodId();
    }
}