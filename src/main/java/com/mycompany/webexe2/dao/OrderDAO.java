package com.mycompany.webexe2.dao;



import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.mycompany.webexe2.context.DBContext;
import com.mycompany.webexe2.model.Order;
import com.mycompany.webexe2.model.OrderDetail;
import com.mycompany.webexe2.model.Product;

public class OrderDAO extends DBContext {

    // 🔹 Lấy tổng số đơn hàng
    public int getTotalOrders() {
        String sql = "SELECT COUNT(*) FROM Orders";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // 🔹 Lấy danh sách đơn hàng theo trang (10 đơn/trang)
    public List<Order> getOrdersByPage(int page, int pageSize) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM ("
                  + " SELECT ROW_NUMBER() OVER (ORDER BY OrderDate DESC) AS RowNum, *"
                  + " FROM Orders"
                  + ") AS t"
                  + " WHERE t.RowNum BETWEEN (? - 1) * ? + 1 AND ? * ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, page);
            ps.setInt(2, pageSize);
            ps.setInt(3, page);
            ps.setInt(4, pageSize);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order o = new Order();
                    o.setId(rs.getInt("OrderID"));
                    o.setCustomerName(rs.getString("CustomerName"));
                    o.setPhone(rs.getString("Phone"));
                    o.setAddress(rs.getString("Address"));
                    o.setOrderDate(rs.getTimestamp("OrderDate"));
                    o.setTotal(rs.getDouble("Total"));
                    o.setStatus(rs.getString("Status"));
                    o.setOrderCode(rs.getString("OrderCode"));
                    list.add(o);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 🔹 Lấy tất cả chi tiết đơn hàng
    public List<OrderDetail> getOrderDetails(int orderId) {
        List<OrderDetail> list = new ArrayList<>();
        String sql = "SELECT d.OrderDetailID, d.OrderID, d.Quantity, d.Price,"
                + " p.ProductID, p.ProductName, p.ImageURL"
                + " FROM OrderDetails d"
                + " JOIN Products p ON d.ProductID = p.ProductID"
                + " WHERE d.OrderID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product p = new Product();
                    p.setId(rs.getInt("ProductID"));
                    p.setName(rs.getString("ProductName"));
                    p.setImageURL(rs.getString("ImageURL"));

                    OrderDetail d = new OrderDetail();
                    d.setId(rs.getInt("OrderDetailID"));
                    d.setOrderId(rs.getInt("OrderID"));
                    d.setProduct(p);
                    d.setQuantity(rs.getInt("Quantity"));
                    d.setPrice(rs.getDouble("Price"));
                    list.add(d);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 🔹 Lấy đơn hàng theo ID
    public Order getOrderById(int id) {
        String sql = "SELECT * FROM Orders WHERE OrderID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Order o = new Order();
                    o.setId(rs.getInt("OrderID"));
                    o.setCustomerName(rs.getString("CustomerName"));
                    o.setPhone(rs.getString("Phone"));
                    o.setAddress(rs.getString("Address"));
                    o.setOrderDate(rs.getTimestamp("OrderDate"));
                    o.setTotal(rs.getDouble("Total"));
                    o.setStatus(rs.getString("Status"));
                    o.setOrderCode(rs.getString("OrderCode"));
                    o.setDetails(getOrderDetails(id));
                    return o;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // 🔹 Cập nhật trạng thái đơn hàng
    public void updateStatus(int orderId, String newStatus) {
        String sql = "UPDATE Orders SET Status = ? WHERE OrderID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, orderId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    // ✅ Thêm đơn hàng
public int insertOrder(String name, String phone, String address, double total, String orderCode) {
    String sql = "INSERT INTO Orders (CustomerName, Phone, Address, Total, OrderCode, Status) VALUES (?, ?, ?, ?, ?, ?)";
    try (PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
        ps.setString(1, name);
        ps.setString(2, phone);
        ps.setString(3, address);
        ps.setDouble(4, total);
        ps.setString(5, orderCode);
        ps.setString(6, "Chờ thanh toán"); // Mặc định trạng thái khi tạo đơn
        ps.executeUpdate();

        ResultSet rs = ps.getGeneratedKeys();
        if (rs.next()) {
            return rs.getInt(1);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return -1;
}

// ✅ Thêm chi tiết đơn hàng
public void insertOrderDetail(int orderId, int productId, int quantity, double price) {
    String sql = "INSERT INTO OrderDetails (OrderID, ProductID, Quantity, Price) VALUES (?, ?, ?, ?)";
    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setInt(1, orderId);
        ps.setInt(2, productId);
        ps.setInt(3, quantity);
        ps.setDouble(4, price);
        ps.executeUpdate();
    } catch (SQLException e) {
        e.printStackTrace();
    }
}

}
