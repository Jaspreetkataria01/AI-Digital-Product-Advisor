package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class UserProductDAO {

    public boolean saveProduct(String username, int productId) {
        try (Connection conn = DBConnection.getConnection()) {

            String checkSql = "SELECT * FROM saved_products WHERE username=? AND product_id=?";
            PreparedStatement checkPs = conn.prepareStatement(checkSql);
            checkPs.setString(1, username);
            checkPs.setInt(2, productId);

            ResultSet rs = checkPs.executeQuery();
            if (rs.next()) {
                return false;
            }

            String sql = "INSERT INTO saved_products(username, product_id) VALUES(?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            ps.setInt(2, productId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public int getSavedProductsCount(String username) {
        int count = 0;

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT COUNT(*) AS total FROM saved_products WHERE username=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, username);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt("total");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return count;
    }

    public int getCompareProductsCount(String username) {
        int count = 0;

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT COUNT(*) AS total FROM compare_products WHERE username=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, username);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt("total");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return count;
    }

    public boolean removeSavedProduct(String username, int productId) {
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "DELETE FROM saved_products WHERE username=? AND product_id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            ps.setInt(2, productId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Integer> getSavedProductIds(String username) {
        List<Integer> ids = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT product_id FROM saved_products WHERE username=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                ids.add(rs.getInt("product_id"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return ids;
    }

    public boolean addCompareProduct(String username, int productId) {
        try (Connection conn = DBConnection.getConnection()) {

            String countSql = "SELECT COUNT(*) AS total FROM compare_products WHERE username=?";
            PreparedStatement countPs = conn.prepareStatement(countSql);
            countPs.setString(1, username);
            ResultSet countRs = countPs.executeQuery();

            if (countRs.next() && countRs.getInt("total") >= 3) {
                return false;
            }

            String checkSql = "SELECT * FROM compare_products WHERE username=? AND product_id=?";
            PreparedStatement checkPs = conn.prepareStatement(checkSql);
            checkPs.setString(1, username);
            checkPs.setInt(2, productId);
            ResultSet rs = checkPs.executeQuery();

            if (rs.next()) {
                return false;
            }

            String sql = "INSERT INTO compare_products(username, product_id) VALUES(?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            ps.setInt(2, productId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean removeCompareProduct(String username, int productId) {
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "DELETE FROM compare_products WHERE username=? AND product_id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            ps.setInt(2, productId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Integer> getCompareProductIds(String username) {
        List<Integer> ids = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT product_id FROM compare_products WHERE username=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                ids.add(rs.getInt("product_id"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return ids;
    }
}