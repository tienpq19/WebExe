package com.mycompany.webexe2.model;

public class OrderDetail {
    private int id;
    private int orderId;
    private Product product; // ✅ thêm dòng này
    private int quantity;
    private double price;

    public OrderDetail() {}

    // Getters & Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }

    public Product getProduct() { return product; }     // ✅ thêm getter
    public void setProduct(Product product) { this.product = product; } // ✅ thêm setter

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
}
