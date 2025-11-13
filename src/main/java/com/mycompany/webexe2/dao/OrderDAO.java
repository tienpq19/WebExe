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

/**
 * DAO dùng cho chức năng quản lý Đơn hàng
 * ĐÃ ĐƯỢC CẬP NHẬT ĐỂ TƯƠNG THÍCH VỚI POSTGRESQL
 */
public class OrderDAO extends DBContext {

    // 🔹 Lấy tổng số đơn hàng
    public int getTotalOrders() {
        // THAY ĐỔI: Tên bảng viết thường
        String sql = "SELECT COUNT(*) FROM orders";
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

    // 🔹 Lấy danh sách đơn hàng theo trang (sử dụng cú pháp LIMIT OFFSET của PostgreSQL)
    public List<Order> getOrdersByPage(int page, int pageSize) {
        List<Order> list = new ArrayList<>();
        // THAY ĐỔI LỚN: Cú pháp phân trang của PostgreSQL hiệu quả hơn nhiều
        String sql = "SELECT * FROM orders ORDER BY orderdate DESC LIMIT ? OFFSET ?";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, pageSize); // LIMIT: Số lượng bản ghi mỗi trang
            ps.setInt(2, (page - 1) * pageSize); // OFFSET: Vị trí bắt đầu lấy
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order o = new Order();
                    // THAY ĐỔI: Tên cột trong ResultSet viết thường
                    o.setId(rs.getInt("orderid"));
                    o.setCustomerName(rs.getString("customername"));
                    o.setPhone(rs.getString("phone"));
                    o.setAddress(rs.getString("address"));
                    o.setOrderDate(rs.getTimestamp("orderdate"));
                    o.setTotal(rs.getDouble("total"));
                    o.setStatus(rs.getString("status"));
                    o.setOrderCode(rs.getString("ordercode"));
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
        // THAY ĐỔI: Tên bảng và cột viết thường
        String sql = "SELECT d.orderdetailid, d.orderid, d.quantity, d.price,"
                + " p.productid, p.productname, p.imageurl"
                + " FROM orderdetails d"
                + " JOIN products p ON d.productid = p.productid"
                + " WHERE d.orderid = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product p = new Product();
                    // THAY ĐỔI: Tên cột viết thường
                    p.setId(rs.getInt("productid"));
                    p.setName(rs.getString("productname"));
                    p.setImageURL(rs.getString("imageurl"));

                    OrderDetail d = new OrderDetail();
                    d.setId(rs.getInt("orderdetailid"));
                    d.setOrderId(rs.getInt("orderid"));
                    d.setProduct(p);
                    d.setQuantity(rs.getInt("quantity"));
                    d.setPrice(rs.getDouble("price"));
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
        // THAY ĐỔI: Tên bảng và cột viết thường
        String sql = "SELECT * FROM orders WHERE orderid = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Order o = new Order();
                    // THAY ĐỔI: Tên cột viết thường
                    o.setId(rs.getInt("orderid"));
                    o.setCustomerName(rs.getString("customername"));
                    o.setPhone(rs.getString("phone"));
                    o.setAddress(rs.getString("address"));
                    o.setOrderDate(rs.getTimestamp("orderdate"));
                    o.setTotal(rs.getDouble("total"));
                    o.setStatus(rs.getString("status"));
                    o.setOrderCode(rs.getString("ordercode"));
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
        // THAY ĐỔI: Tên bảng và cột viết thường
        String sql = "UPDATE orders SET status = ? WHERE orderid = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, orderId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    // ✅ Thêm đơn hàng (sử dụng RETURNING để lấy ID)
    public int insertOrder(String name, String phone, String address, double total, String orderCode) {
        // THAY ĐỔI LỚN: Dùng "RETURNING orderid" để lấy ID vừa tạo, hiệu quả hơn
        String sql = "INSERT INTO orders (customername, phone, address, total, ordercode, status) VALUES (?, ?, ?, ?, ?, ?) RETURNING orderid";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, phone);
            ps.setString(3, address);
            ps.setDouble(4, total);
            ps.setString(5, orderCode);
            ps.setString(6, "Chờ thanh toán"); 

            // Dùng executeQuery vì RETURNING trả về một ResultSet
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1); // Lấy ID từ cột đầu tiên của ResultSet
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    // ✅ Thêm chi tiết đơn hàng
    public void insertOrderDetail(int orderId, int productId, int quantity, double price) {
        // THAY ĐỔI: Tên bảng và cột viết thường
        String sql = "INSERT INTO orderdetails (orderid, productid, quantity, price) VALUES (?, ?, ?, ?)";
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