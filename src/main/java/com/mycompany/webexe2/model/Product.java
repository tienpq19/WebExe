package com.mycompany.webexe2.model;

public class Product {

    private int id;
    private String name;
    private String description;
    private double price;
    private String imageURL;
    private boolean isDrink;

    public Product() {
    }

    public Product(int id, String name, String description, double price, String imageURL) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.price = price;
        this.imageURL = imageURL;
    }

    // Getters & Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public String getImageURL() {
        return imageURL;
    }

    public void setImageURL(String imageURL) {
        this.imageURL = imageURL;
    }

    public boolean isDrink() {
        return isDrink;
    }

    public void setDrink(boolean isDrink) {
        this.isDrink = isDrink;
    }

    @Override
    public String toString() {
        return "Product{"
                + "id=" + id
                + ", name='" + name + '\''
                + ", description='" + description + '\''
                + ", price=" + price
                + ", imageURL='" + imageURL + '\'' +
                ", isDrink=" + isDrink +
                '}';
    }
}
