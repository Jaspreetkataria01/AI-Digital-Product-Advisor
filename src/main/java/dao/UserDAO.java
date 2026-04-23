package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import model.User;
import org.mindrot.jbcrypt.BCrypt;

public class UserDAO {

    public boolean registerUser(User user) {
        boolean status = false;

        try {
            Connection conn = DBConnection.getConnection();
            String sql = "INSERT INTO users(name, email, password, phone, city, bio, role) VALUES (?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);

            String hashedPassword = BCrypt.hashpw(user.getPassword(), BCrypt.gensalt(12));

            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            ps.setString(3, hashedPassword);
            ps.setString(4, user.getPhone());
            ps.setString(5, user.getCity());
            ps.setString(6, user.getBio());
            ps.setString(7, "user");

            int rows = ps.executeUpdate();
            status = rows > 0;

            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return status;
    }

    public User loginUser(String email, String password) {
        User user = null;

        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT * FROM users WHERE email = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, email);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String storedHash = rs.getString("password");

                if (storedHash != null && BCrypt.checkpw(password, storedHash)) {
                    user = new User();
                    user.setUserId(rs.getInt("user_id"));
                    user.setName(rs.getString("name"));
                    user.setEmail(rs.getString("email"));
                    user.setPassword(storedHash);
                    user.setPhone(rs.getString("phone"));
                    user.setCity(rs.getString("city"));
                    user.setBio(rs.getString("bio"));
                    user.setRole(rs.getString("role"));
                }
            }

            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return user;
    }

    public boolean emailExists(String email) {
        boolean exists = false;

        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT 1 FROM users WHERE email = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, email);

            ResultSet rs = ps.executeQuery();
            exists = rs.next();

            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return exists;
    }

    public User getUserByEmail(String email) {
        User user = null;

        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT * FROM users WHERE email = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, email);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setName(rs.getString("name"));
                user.setEmail(rs.getString("email"));
                user.setPassword(rs.getString("password"));
                user.setPhone(rs.getString("phone"));
                user.setCity(rs.getString("city"));
                user.setBio(rs.getString("bio"));
                user.setRole(rs.getString("role"));
            }

            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return user;
    }

    public boolean updateUserProfile(User user) {
        boolean status = false;

        try {
            Connection conn = DBConnection.getConnection();
            String sql = "UPDATE users SET name = ?, phone = ?, city = ?, bio = ? WHERE email = ?";
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, user.getName());
            ps.setString(2, user.getPhone());
            ps.setString(3, user.getCity());
            ps.setString(4, user.getBio());
            ps.setString(5, user.getEmail());

            status = ps.executeUpdate() > 0;

            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return status;
    }
    public int getTotalUsersCount() {
        int count = 0;

        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT COUNT(*) AS total FROM users";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                count = rs.getInt("total");
            }

            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return count;
    }

    public int getTotalAdminsCount() {
        int count = 0;

        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT COUNT(*) AS total FROM users WHERE role='admin'";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                count = rs.getInt("total");
            }

            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return count;
    }

    public int getTotalNormalUsersCount() {
        int count = 0;

        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT COUNT(*) AS total FROM users WHERE role='user'";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                count = rs.getInt("total");
            }

            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return count;
    }
    public java.util.List<model.UserSummary> getAllUserSummaries() {
        java.util.List<model.UserSummary> list = new java.util.ArrayList<>();

        try {
            Connection conn = DBConnection.getConnection();

            String sql = "SELECT u.user_id, u.name, u.email, u.role, u.phone, u.city, u.bio, " +
                    "(SELECT COUNT(*) FROM saved_products sp WHERE sp.username = u.name) AS saved_count, " +
                    "(SELECT COUNT(*) FROM compare_products cp WHERE cp.username = u.name) AS compare_count, " +
                    "(SELECT COUNT(*) FROM support_requests sr WHERE sr.username = u.name) AS support_count " +
                    "FROM users u ORDER BY u.user_id DESC";

            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                model.UserSummary user = new model.UserSummary();
                user.setUserId(rs.getInt("user_id"));
                user.setName(rs.getString("name"));
                user.setEmail(rs.getString("email"));
                user.setRole(rs.getString("role"));
                user.setPhone(rs.getString("phone"));
                user.setCity(rs.getString("city"));
                user.setBio(rs.getString("bio"));
                user.setSavedCount(rs.getInt("saved_count"));
                user.setCompareCount(rs.getInt("compare_count"));
                user.setSupportCount(rs.getInt("support_count"));

                list.add(user);
            }

            rs.close();
            ps.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    
    public boolean addUserByAdmin(model.User user) {
        boolean status = false;

        try {
            Connection conn = DBConnection.getConnection();
            String sql = "INSERT INTO users(name, email, password, phone, city, bio, role) VALUES (?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword());
            ps.setString(4, user.getPhone());
            ps.setString(5, user.getCity());
            ps.setString(6, user.getBio());
            ps.setString(7, user.getRole());

            status = ps.executeUpdate() > 0;

            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return status;
    }
    
    public boolean updateUserByAdmin(model.User user) {
        boolean status = false;

        try {
            Connection conn = DBConnection.getConnection();
            String sql = "UPDATE users SET name=?, email=?, phone=?, city=?, bio=?, role=? WHERE user_id=?";
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhone());
            ps.setString(4, user.getCity());
            ps.setString(5, user.getBio());
            ps.setString(6, user.getRole());
            ps.setInt(7, user.getUserId());

            status = ps.executeUpdate() > 0;

            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return status;
    }
    public boolean deleteUserByAdmin(int userId) {
        boolean status = false;

        try {
            Connection conn = DBConnection.getConnection();
            String sql = "DELETE FROM users WHERE user_id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);

            status = ps.executeUpdate() > 0;

            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return status;
    }
    public model.User getUserById(int userId) {
        model.User user = null;

        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT * FROM users WHERE user_id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                user = new model.User();
                user.setUserId(rs.getInt("user_id"));
                user.setName(rs.getString("name"));
                user.setEmail(rs.getString("email"));
                user.setPassword(rs.getString("password"));
                user.setPhone(rs.getString("phone"));
                user.setCity(rs.getString("city"));
                user.setBio(rs.getString("bio"));
                user.setRole(rs.getString("role"));
            }

            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return user;
    }
    
    public boolean deleteUserByAdmin(int userId, String userName) {
        boolean status = false;

        try {
            Connection conn = DBConnection.getConnection();

            PreparedStatement ps1 = conn.prepareStatement("DELETE FROM saved_products WHERE username=?");
            ps1.setString(1, userName);
            ps1.executeUpdate();

            PreparedStatement ps2 = conn.prepareStatement("DELETE FROM compare_products WHERE username=?");
            ps2.setString(1, userName);
            ps2.executeUpdate();

            PreparedStatement ps3 = conn.prepareStatement("DELETE FROM support_requests WHERE username=?");
            ps3.setString(1, userName);
            ps3.executeUpdate();

            PreparedStatement ps4 = conn.prepareStatement("DELETE FROM users WHERE user_id=?");
            ps4.setInt(1, userId);

            status = ps4.executeUpdate() > 0;

            ps1.close();
            ps2.close();
            ps3.close();
            ps4.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return status;
    }
}