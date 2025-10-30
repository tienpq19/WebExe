package com.mycompany.webexe2.model;

import java.util.HashMap;
import java.util.Map;

public class Cart {
    // Sử dụng String làm key để phân biệt sản phẩm có lựa chọn (ví dụ: "12-Nong")
    private Map<String, CartItem> items;

    public Cart() {
        this.items = new HashMap<>();
    }

    public Map<String, CartItem> getItems() {
        return items;
    }

    // Thêm sản phẩm vào giỏ, có xử lý lựa chọn đồ uống
    public void addItem(Product product, int quantity, String drinkOption) {
        // Tạo key duy nhất cho sản phẩm
        String itemKey = String.valueOf(product.getId());
        if (product.isDrink() && drinkOption != null && !drinkOption.isEmpty()) {
            itemKey += "-" + drinkOption; // Ví dụ: "12-Nong"
        }

        if (items.containsKey(itemKey)) {
            CartItem existingItem = items.get(itemKey);
            existingItem.setQuantity(existingItem.getQuantity() + quantity);
        } else {
            items.put(itemKey, new CartItem(product, quantity, drinkOption));
        }
    }

    // Cập nhật số lượng sản phẩm bằng key
    public void updateItem(String itemKey, int quantity) {
        if (items.containsKey(itemKey)) {
            if (quantity > 0) {
                items.get(itemKey).setQuantity(quantity);
            } else {
                removeItem(itemKey);
            }
        }
    }

    // Xóa sản phẩm khỏi giỏ bằng key
    public void removeItem(String itemKey) {
        items.remove(itemKey);
    }

    // Tính tổng tiền
    public double getTotalAmount() {
        double total = 0;
        for (CartItem item : items.values()) {
            total += item.getTotalPrice();
        }
        return total;
    }

    // Lấy tổng số loại sản phẩm trong giỏ
    public int getTotalItems() {
        return items.values().stream().mapToInt(CartItem::getQuantity).sum();
    }
    
    // Xóa sạch giỏ hàng
    public void clear() {
        items.clear();
    }
}
