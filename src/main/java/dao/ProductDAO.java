package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import model.Product;

public class ProductDAO {

    public boolean addProduct(Product p) {
        boolean status = false;

        try {
            Connection conn = DBConnection.getConnection();
            String sql = "INSERT INTO products(title, brand, category, price, ram, storage, processor, display, battery, rating, description, purpose, image_url) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?)";
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, p.getTitle());
            ps.setString(2, p.getBrand());
            ps.setString(3, p.getCategory());
            ps.setDouble(4, p.getPrice());
            ps.setString(5, p.getRam());
            ps.setString(6, p.getStorage());
            ps.setString(7, p.getProcessor());
            ps.setString(8, p.getDisplay());
            ps.setString(9, p.getBattery());
            ps.setDouble(10, p.getRating());
            ps.setString(11, p.getDescription());
            ps.setString(12, p.getPurpose());
            ps.setString(13, p.getImageUrl());

            status = ps.executeUpdate() > 0;

            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return status;
    }

    public List<Product> getAllProducts() {
        List<Product> list = new ArrayList<>();

        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT * FROM products ORDER BY product_id DESC";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Product p = new Product();
                p.setProductId(rs.getInt("product_id"));
                p.setTitle(rs.getString("title"));
                p.setBrand(rs.getString("brand"));
                p.setCategory(rs.getString("category"));
                p.setPrice(rs.getDouble("price"));
                p.setRam(rs.getString("ram"));
                p.setStorage(rs.getString("storage"));
                p.setProcessor(rs.getString("processor"));
                p.setDisplay(rs.getString("display"));
                p.setBattery(rs.getString("battery"));
                p.setRating(rs.getDouble("rating"));
                p.setDescription(rs.getString("description"));
                p.setPurpose(rs.getString("purpose"));
                p.setImageUrl(rs.getString("image_url"));
                list.add(p);
            }

            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public Product getProductById(int id) {
        Product p = null;

        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT * FROM products WHERE product_id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                p = new Product();
                p.setProductId(rs.getInt("product_id"));
                p.setTitle(rs.getString("title"));
                p.setBrand(rs.getString("brand"));
                p.setCategory(rs.getString("category"));
                p.setPrice(rs.getDouble("price"));
                p.setRam(rs.getString("ram"));
                p.setStorage(rs.getString("storage"));
                p.setProcessor(rs.getString("processor"));
                p.setDisplay(rs.getString("display"));
                p.setBattery(rs.getString("battery"));
                p.setRating(rs.getDouble("rating"));
                p.setDescription(rs.getString("description"));
                p.setPurpose(rs.getString("purpose"));
                p.setImageUrl(rs.getString("image_url"));
            }

            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return p;
    }

    public boolean updateProduct(Product p) {
        boolean status = false;

        try {
            Connection conn = DBConnection.getConnection();
            String sql = "UPDATE products SET title=?, brand=?, category=?, price=?, ram=?, storage=?, processor=?, display=?, battery=?, rating=?, description=?, purpose=?, image_url=? WHERE product_id=?";
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, p.getTitle());
            ps.setString(2, p.getBrand());
            ps.setString(3, p.getCategory());
            ps.setDouble(4, p.getPrice());
            ps.setString(5, p.getRam());
            ps.setString(6, p.getStorage());
            ps.setString(7, p.getProcessor());
            ps.setString(8, p.getDisplay());
            ps.setString(9, p.getBattery());
            ps.setDouble(10, p.getRating());
            ps.setString(11, p.getDescription());
            ps.setString(12, p.getPurpose());
            ps.setString(13, p.getImageUrl());
            ps.setInt(14, p.getProductId());

            status = ps.executeUpdate() > 0;

            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return status;
    }

    public List<Product> searchProductsByKeyword(String keyword) {
        List<Product> list = new java.util.ArrayList<>();

        try {
            Connection conn = DBConnection.getConnection();

            String sql = "SELECT * FROM products WHERE " +
                         "LOWER(product_name) LIKE ? OR " +
                         "LOWER(brand) LIKE ? OR " +
                         "LOWER(category) LIKE ? OR " +
                         "LOWER(purpose) LIKE ? " +
                         "ORDER BY product_name ASC";

            PreparedStatement ps = conn.prepareStatement(sql);
            String searchValue = "%" + keyword.toLowerCase() + "%";

            ps.setString(1, searchValue);
            ps.setString(2, searchValue);
            ps.setString(3, searchValue);
            ps.setString(4, searchValue);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Product p = new Product();
                p.setProductId(rs.getInt("product_id"));
                p.setTitle(rs.getString("product_name"));
                p.setBrand(rs.getString("brand"));
                p.setPrice(rs.getDouble("price"));
                p.setRam(rs.getString("ram"));
                p.setStorage(rs.getString("storage"));
                p.setProcessor(rs.getString("processor"));
                p.setPurpose(rs.getString("purpose"));
                p.setCategory(rs.getString("category"));
                list.add(p);
            }

            rs.close();
            ps.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    public boolean deleteProduct(int id) {
        boolean status = false;

        try {
            Connection conn = DBConnection.getConnection();
            String sql = "DELETE FROM products WHERE product_id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);

            status = ps.executeUpdate() > 0;

            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return status;
    }
}