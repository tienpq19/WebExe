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
            // =================== PHẦN THAY ĐỔI QUAN TRỌNG ===================

            // Đọc thông tin kết nối từ Biến Môi Trường do Render cung cấp
            String dbUrl = System.getenv("DB_URL");
            String user = System.getenv("DB_USER");
            String pass = System.getenv("DB_PASS");
            String driver = "org.postgresql.Driver"; // Driver cho PostgreSQL


            if (dbUrl == null || dbUrl.isEmpty()) {
                System.out.println("⚠️ Environment variables not found. Using local SQL Server config.");
                user = "sa";
                pass = "Aqswdefr19";
                dbUrl = "jdbc:sqlserver://localhost:1433;databaseName=exe2;encrypt=false;trustServerCertificate=true;";
                driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
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

    public static void main(String[] args) {
        DBContext db = new DBContext();
        if (db.getConnection() != null) {
            System.out.println("✅ Connection established successfully!");
        } else {
            System.out.println("❌ Failed to establish connection!");
        }
    }
}