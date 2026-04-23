package dao;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    public static Connection getConnection() {
        Connection conn = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            String url = System.getenv("DB_URL");
            String username = System.getenv("DB_USER");
            String password = System.getenv("DB_PASSWORD");

            conn = DriverManager.getConnection(url, username, password);

            System.out.println("Database connected successfully");

        } catch (Exception e) {
            e.printStackTrace();
        }

        return conn;
    }
}