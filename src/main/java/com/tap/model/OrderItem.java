package com.tap.model;

public class OrderItem {
    private int orderItemId;
    private int orderId;
    private int foodId;
    private int quantity;
    private double price;
    private double subtotal;
    private String itemName;
    private String imagePath;

    public OrderItem() {}

    public int getOrderItemId() { return orderItemId; }
    public void setOrderItemId(int orderItemId) { this.orderItemId = orderItemId; }

    public int getItemId() { return orderItemId; }
    public void setItemId(int orderItemId) { this.orderItemId = orderItemId; }

    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }

    public int getFoodId() { return foodId; }
    public void setFoodId(int foodId) { this.foodId = foodId; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { 
        this.quantity = quantity; 
        this.subtotal = this.quantity * this.price;
    }

    public double getPrice() { return price; }
    public void setPrice(double price) { 
        this.price = price; 
        this.subtotal = this.quantity * this.price;
    }

    public double getSubtotal() { return subtotal > 0 ? subtotal : (quantity * price); }
    public void setSubtotal(double subtotal) { this.subtotal = subtotal; }

    public String getItemName() { return itemName != null ? itemName : "Food Item"; }
    public void setItemName(String itemName) { this.itemName = itemName; }
    
    public String getName() { return getItemName(); }
    public void setName(String name) { this.itemName = name; }

    public String getImagePath() { return imagePath != null ? imagePath : ""; }
    public void setImagePath(String imagePath) { this.imagePath = imagePath; }
}