package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import model.SupportRequest;

public class SupportRequestDAO {
	public boolean addRequest(SupportRequest request) {
	    boolean status = false;

	    try {
	        Connection conn = DBConnection.getConnection();

	        String sql = "INSERT INTO support_requests(username, product_name, issue_title, issue_description, priority, status) VALUES (?, ?, ?, ?, ?, ?)";
	        PreparedStatement ps = conn.prepareStatement(sql);

	        ps.setString(1, request.getUsername());
	        ps.setString(2, request.getProductName());
	        ps.setString(3, request.getIssueTitle());
	        ps.setString(4, request.getIssueDescription());
	        ps.setString(5, request.getPriority());
	        ps.setString(6, "Pending");

	        status = ps.executeUpdate() > 0;

	        ps.close();
	        conn.close();
	    } catch (Exception e) {
	        e.printStackTrace();
	    }

	    return status;
	}

    public List<SupportRequest> getRequestsByUsername(String username) {
        List<SupportRequest> list = new ArrayList<>();

        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT * FROM support_requests WHERE username = ? ORDER BY created_at DESC";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, username);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                SupportRequest r = new SupportRequest();
                r.setRequestId(rs.getInt("request_id"));
                r.setUsername(rs.getString("username"));
                r.setProductName(rs.getString("product_name"));
                r.setIssueTitle(rs.getString("issue_title"));
                r.setIssueDescription(rs.getString("issue_description"));
                r.setPriority(rs.getString("priority"));
                r.setStatus(rs.getString("status"));
                r.setAdminNote(rs.getString("admin_note"));
                r.setCreatedAt(rs.getString("created_at"));
                list.add(r);
            }

            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<SupportRequest> getAllRequests() {
        List<SupportRequest> list = new ArrayList<>();

        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT * FROM support_requests ORDER BY created_at DESC";
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                SupportRequest r = new SupportRequest();
                r.setRequestId(rs.getInt("request_id"));
                r.setUsername(rs.getString("username"));
                r.setProductName(rs.getString("product_name"));
                r.setIssueTitle(rs.getString("issue_title"));
                r.setIssueDescription(rs.getString("issue_description"));
                r.setPriority(rs.getString("priority"));
                r.setStatus(rs.getString("status"));
                r.setAdminNote(rs.getString("admin_note"));
                r.setCreatedAt(rs.getString("created_at"));
                list.add(r);
            }

            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public boolean updateRequestStatus(int requestId, String statusValue, String adminNote) {
        boolean status = false;

        try {
            Connection conn = DBConnection.getConnection();
            String sql = "UPDATE support_requests SET status = ?, admin_note = ? WHERE request_id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, statusValue);
            ps.setString(2, adminNote);
            ps.setInt(3, requestId);

            status = ps.executeUpdate() > 0;

            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return status;
    }
    public boolean deleteRequestByUser(int requestId, String username) {
        boolean status = false;

        try {
            Connection conn = DBConnection.getConnection();
            String sql = "DELETE FROM support_requests WHERE request_id = ? AND username = ?";
            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setInt(1, requestId);
            ps.setString(2, username);

            status = ps.executeUpdate() > 0;

            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return status;
    }
    public int getRequestCountByStatus(String statusText) {
        int count = 0;

        try {
            Connection conn = DBConnection.getConnection();
            String sql = "SELECT COUNT(*) AS total FROM support_requests WHERE status = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, statusText);

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
}