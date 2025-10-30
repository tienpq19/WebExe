package com.mycompany.webexe2.dao;

import com.mycompany.webexe2.context.DBContext;
import com.mycompany.webexe2.model.Product;
import java.sql.*;
import java.util.List;
import java.util.ArrayList;

public class ProductDAO extends DBContext {

    // 🔹 Lấy danh sách sản phẩm theo trang (10 sản phẩm mỗi trang)
    public List<Product> getProductsByPage(int page, int pageSize) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM Products ORDER BY ProductID DESC " +
                     "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, (page - 1) * pageSize);
            ps.setInt(2, pageSize);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Product p = new Product();
                p.setId(rs.getInt("ProductID"));
                p.setName(rs.getString("ProductName"));
                p.setDescription(rs.getString("Description"));
                p.setPrice(rs.getDouble("Price"));
                p.setImageURL(rs.getString("ImageURL"));
                p.setDrink(rs.getBoolean("isDrink"));
                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 🔹 Đếm tổng số sản phẩm
    public int getTotalProducts() {
        String sql = "SELECT COUNT(*) FROM Products";
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
        String sql = "INSERT INTO Products (ProductName, Description, Price, ImageURL) VALUES (?, ?, ?, ?)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, p.getName());
            ps.setString(2, p.getDescription());
            ps.setDouble(3, p.getPrice());
            ps.setString(4, p.getImageURL());
            ps.executeUpdate();
            System.out.println("✅ Thêm sản phẩm thành công!");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // 🔹 Xóa sản phẩm
    public void deleteProduct(int id) {
        String sql = "DELETE FROM Products WHERE ProductID = ?";
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
        String sql = "UPDATE Products SET ProductName=?, Description=?, Price=?, ImageURL=? WHERE ProductID=?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, p.getName());
            ps.setString(2, p.getDescription());
            ps.setDouble(3, p.getPrice());
            ps.setString(4, p.getImageURL());
            ps.setInt(5, p.getId());
            ps.executeUpdate();
            System.out.println("✅ Cập nhật sản phẩm ID " + p.getId() + " thành công!");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // 🔹 Lấy sản phẩm theo ID
    public Product getProductById(int id) {
        String sql = "SELECT * FROM Products WHERE ProductID=?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Product p = new Product();
                p.setId(rs.getInt("ProductID"));
                p.setName(rs.getString("ProductName"));
                p.setDescription(rs.getString("Description"));
                p.setPrice(rs.getDouble("Price"));
                p.setImageURL(rs.getString("ImageURL"));
                p.setDrink(rs.getBoolean("isDrink"));
                return p;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // ✅ HÀM MAIN TEST DAO
    public static void main(String[] args) {
        ProductDAO dao = new ProductDAO();

        System.out.println("====== TEST ProductDAO ======\n");

        // 1️⃣ Test thêm sản phẩm
        Product newProduct = new Product();
        newProduct.setName("Tai nghe Bluetooth");
        newProduct.setDescription("Tai nghe không dây chống ồn");
        newProduct.setPrice(350000);
        newProduct.setImageURL("img/earphone.jpg");
        dao.addProduct(newProduct);

        // 2️⃣ Test lấy sản phẩm theo ID
        Product p = dao.getProductById(1);
        if (p != null) {
            System.out.println("Sản phẩm ID=1: " + p.getName() + " - " + p.getPrice());
        } else {
            System.out.println("Không tìm thấy sản phẩm ID=1");
        }

        // 3️⃣ Test cập nhật sản phẩm
        if (p != null) {
            p.setPrice(p.getPrice() + 50000);
            p.setDescription(p.getDescription() + " (updated)");
            dao.updateProduct(p);
        }

        // 4️⃣ Test lấy tất cả sản phẩm theo trang
        int page = 1;
        int pageSize = 10;
        List<Product> list = dao.getProductsByPage(page, pageSize);
        System.out.println("\nDanh sách sản phẩm (trang " + page + "):");
        for (Product item : list) {
            System.out.println(item.getId() + " - " + item.getName() + " - " + item.getPrice());
        }

        // 5️⃣ Test đếm tổng số sản phẩm
        int total = dao.getTotalProducts();
        System.out.println("\nTổng số sản phẩm: " + total);

        // 6️⃣ Test xóa sản phẩm (thay ID phù hợp để tránh mất dữ liệu thật)
        // dao.deleteProduct(5);

        System.out.println("\n====== Kết thúc test ======");
    }
}
