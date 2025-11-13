package com.mycompany.webexe2.context;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DBContext {
    protected Connection connection;

    public DBContext() {
        try {
            // =================== PHẦN CẤU HÌNH ĐÃ SỬA ĐỔI ===================

            // Đọc thông tin kết nối từ Biến Môi Trường (dành cho Render)
            // Render sẽ tự động set biến DATABASE_URL
            String dbUrl = System.getenv("DATABASE_URL"); 
            String user = System.getenv("DB_USER");     // Tên biến này bạn tự đặt trên Render
            String pass = System.getenv("DB_PASS");     // Tên biến này bạn tự đặt trên Render
            String driver = "org.postgresql.Driver";    // Driver cho PostgreSQL

            // NẾU KHÔNG TÌM THẤY BIẾN MÔI TRƯỜNG (tức là đang chạy ở máy local)
            // THÌ SỬ DỤNG CẤU HÌNH POSTGRESQL LOCAL
            if (dbUrl == null || dbUrl.isEmpty()) {
                System.out.println("⚠️ Environment variables not found. Using local PostgreSQL config.");
                
                // === THAY ĐỔI THÔNG TIN CỦA BẠN VÀO ĐÂY ===
                String dbName = "web_exe_db"; // Tên database bạn tạo ở Bước 1
                user = "web_exe_db_user";               // Username mặc định của PostgreSQL
                pass = "your_local_password";    // Mật khẩu bạn đặt khi cài PostgreSQL
                // ===========================================

                dbUrl = "jdbc:postgresql://localhost:5432/" + dbName;
                
                // SSL không cần thiết cho kết nối local
            } else {
                // Thêm ?sslmode=require cho kết nối tới Render
                 dbUrl += "?sslmode=require";
            }
            
            // ======================= KẾT THÚC THAY ĐỔI ========================

            Class.forName(driver);
            connection = DriverManager.getConnection(dbUrl, user, pass);
            System.out.println("✅ Database connected successfully!");

        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, null, ex);
            System.out.println("❌ Failed to connect to database: " + ex.getMessage());
        }
    }

    public Connection getConnection() {
        return connection;
    }

    // Dùng hàm này để test nhanh kết nối
    public static void main(String[] args) {
        DBContext db = new DBContext();
        if (db.getConnection() != null) {
            System.out.println("✅ Connection test successful!");
            try {
                db.connection.close(); // Đóng kết nối sau khi test
            } catch (SQLException e) {
                e.printStackTrace();
            }
        } else {
            System.out.println("❌ Connection test failed!");
        }
    }
}