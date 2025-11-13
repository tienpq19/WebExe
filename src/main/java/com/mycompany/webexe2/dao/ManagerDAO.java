package com.mycompany.webexe2.dao;

import com.mycompany.webexe2.context.DBContext;
import com.mycompany.webexe2.model.Manager;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * DAO dùng cho chức năng đăng nhập và quản lý Manager (Admin)
 * ĐÃ ĐƯỢC CẬP NHẬT ĐỂ TƯƠNG THÍCH VỚI POSTGRESQL
 */
public class ManagerDAO extends DBContext {

    /**
     * Đăng nhập quản lý
     *
     * @param username tên đăng nhập
     * @param password mật khẩu
     * @return đối tượng Manager nếu đúng, null nếu sai
     */
    public Manager login(String username, String password) {
        // THAY ĐỔI: Tên bảng và cột viết thường để khớp với PostgreSQL
        String sql = "SELECT * FROM managers WHERE username = ? AND password = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Manager m = new Manager();
                // THAY ĐỔI: Tên cột trong ResultSet cũng phải viết thường
                m.setId(rs.getInt("managerid"));
                m.setUsername(rs.getString("username"));
                m.setPassword(rs.getString("password"));
                m.setFullName(rs.getString("fullname"));
                return m;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Kiểm tra username có tồn tại hay không
     */
    public boolean checkUsernameExist(String username) {
        // THAY ĐỔI: Tên bảng và cột viết thường
        String sql = "SELECT * FROM managers WHERE username = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Thêm tài khoản quản lý mới
     */
    public void addManager(Manager m) {
        // THAY ĐỔI: Tên bảng và cột viết thường
        String sql = "INSERT INTO managers (username, password, fullname) VALUES (?, ?, ?)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, m.getUsername());
            ps.setString(2, m.getPassword());
            ps.setString(3, m.getFullName());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * Xoá tài khoản quản lý (tùy chọn thêm cho admin)
     */
    public void deleteManager(int id) {
        // THAY ĐỔI: Tên bảng và cột viết thường
        String sql = "DELETE FROM managers WHERE managerid = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * Đóng kết nối khi không còn dùng DAO (khuyến nghị)
     */
    public void close() {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
                System.out.println("🔒 Connection closed successfully.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}