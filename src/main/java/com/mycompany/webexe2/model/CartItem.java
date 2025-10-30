package com.mycompany.webexe2.model;

public class CartItem {
    private Product product;
    private int quantity;
    private String drinkOption; // "Nóng" hoặc "Lạnh" hoặc null

    public CartItem() {
    }

    public CartItem(Product product, int quantity, String drinkOption) {
        this.product = product;
        this.quantity = quantity;
        this.drinkOption = drinkOption;
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public String getDrinkOption() {
        return drinkOption;
    }

    public void setDrinkOption(String drinkOption) {
        this.drinkOption = drinkOption;
    }
    
    public double getTotalPrice() {
        return product.getPrice() * quantity;
    }
}
