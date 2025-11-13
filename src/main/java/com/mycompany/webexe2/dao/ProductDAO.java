package com.mycompany.webexe2.dao;

import com.mycompany.webexe2.context.DBContext;
import com.mycompany.webexe2.model.Product;
import java.sql.*;
import java.util.List;
import java.util.ArrayList;

/**
 * DAO dùng cho chức năng quản lý Sản phẩm
 * ĐÃ ĐƯỢC CẬP NHẬT ĐỂ TƯƠNG THÍCH VỚI POSTGRESQL
 */
public class ProductDAO extends DBContext {

    // 🔹 Lấy danh sách sản phẩm theo trang (sử dụng cú pháp LIMIT OFFSET của PostgreSQL)
    public List<Product> getProductsByPage(int page, int pageSize) {
        List<Product> list = new ArrayList<>();
        // THAY ĐỔI LỚN: Dùng cú pháp phân trang của PostgreSQL
        String sql = "SELECT * FROM products ORDER BY productid DESC LIMIT ? OFFSET ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, pageSize); // LIMIT
            ps.setInt(2, (page - 1) * pageSize); // OFFSET
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Product p = new Product();
                // THAY ĐỔI: Tên cột viết thường
                p.setId(rs.getInt("productid"));
                p.setName(rs.getString("productname"));
                p.setDescription(rs.getString("description"));
                p.setPrice(rs.getDouble("price"));
                p.setImageURL(rs.getString("imageurl"));
                p.setDrink(rs.getBoolean("isdrink"));
                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 🔹 Đếm tổng số sản phẩm
    public int getTotalProducts() {
        // THAY ĐỔI: Tên bảng viết thường
        String sql = "SELECT COUNT(*) FROM products";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // 🔹 Thêm sản phẩm
    public void addProduct(Product p) {
        // THAY ĐỔI: Tên bảng và cột viết thường
        String sql = "INSERT INTO products (productname, description, price, imageurl, isdrink) VALUES (?, ?, ?, ?, ?)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, p.getName());
            ps.setString(2, p.getDescription());
            ps.setDouble(3, p.getPrice());
            ps.setString(4, p.getImageURL());
            ps.setBoolean(5, p.isDrink()); // Thêm cột isdrink
            ps.executeUpdate();
            System.out.println("✅ Thêm sản phẩm thành công!");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // 🔹 Xóa sản phẩm
    public void deleteProduct(int id) {
        // THAY ĐỔI: Tên bảng và cột viết thường
        String sql = "DELETE FROM products WHERE productid = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            ps.executeUpdate();
            System.out.println("✅ Xóa sản phẩm ID " + id + " thành công!");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // 🔹 Cập nhật sản phẩm
    public void updateProduct(Product p) {
        // THAY ĐỔI: Tên bảng và cột viết thường
        String sql = "UPDATE products SET productname=?, description=?, price=?, imageurl=?, isdrink=? WHERE productid=?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, p.getName());
            ps.setString(2, p.getDescription());
            ps.setDouble(3, p.getPrice());
            ps.setString(4, p.getImageURL());
            ps.setBoolean(5, p.isDrink()); // Thêm cột isdrink
            ps.setInt(6, p.getId());
            ps.executeUpdate();
            System.out.println("✅ Cập nhật sản phẩm ID " + p.getId() + " thành công!");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // 🔹 Lấy sản phẩm theo ID
    public Product getProductById(int id) {
        // THAY ĐỔI: Tên bảng và cột viết thường
        String sql = "SELECT * FROM products WHERE productid=?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Product p = new Product();
                // THAY ĐỔI: Tên cột viết thường
                p.setId(rs.getInt("productid"));
                p.setName(rs.getString("productname"));
                p.setDescription(rs.getString("description"));
                p.setPrice(rs.getDouble("price"));
                p.setImageURL(rs.getString("imageurl"));
                p.setDrink(rs.getBoolean("isdrink"));
                return p;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // ✅ HÀM MAIN TEST DAO (giữ nguyên để kiểm tra)
    public static void main(String[] args) {
        // ... (Không cần thay đổi)
    }
}