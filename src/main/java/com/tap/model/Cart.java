package com.tap.model;

import java.util.HashMap;
import java.util.Map;

public class Cart {
    private Map<Integer, CartItem> items;

    public Cart() {
        this.items = new HashMap<>();
    }

    public Map<Integer, CartItem> getItems() {
        return items;
    }

    public void addItem(CartItem item) {
        if (item == null) return;
        
        // Ensure we get a valid key, using a stable hash fallback instead of object hashCode()
        int key = item.getFoodId() > 0 ? item.getFoodId() : item.getItemId();
        if (key <= 0 && item.getName() != null) {
            key = Math.abs(item.getName().hashCode());
        }
        if (key <= 0) {
            key = 1;
        }

        if (items.containsKey(key)) {
            CartItem existingItem = items.get(key);
            existingItem.setQuantity(existingItem.getQuantity() + item.getQuantity());
        } else {
            items.put(key, item);
        }
    }

    public void removeItem(int id) {
        items.remove(id);
    }

    public double getTotalPrice() {
        double total = 0.0;
        for (CartItem item : items.values()) {
            if (item != null) {
                total += item.getPrice() * item.getQuantity();
            }
        }
        return total;
    }
}