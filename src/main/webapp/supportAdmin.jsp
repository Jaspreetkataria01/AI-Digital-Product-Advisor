<%@ page import="java.util.List" %>
<%@ page import="dao.SupportRequestDAO" %>
<%@ page import="model.SupportRequest" %>

<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"admin".equals(role)) {
        response.sendRedirect("dashboard.jsp");
        return;
    }
%>
<%
    String supportSuccess = (String) session.getAttribute("supportSuccess");
    String supportError = (String) session.getAttribute("supportError");

    if (supportSuccess != null) {
        session.removeAttribute("supportSuccess");
    }
    if (supportError != null) {
        session.removeAttribute("supportError");
    }
%>

<% if (supportSuccess != null) { %>
    <div class="info-banner"><%= supportSuccess %></div>
<% } %>

<% if (supportError != null) { %>
    <div class="info-banner" style="background:linear-gradient(90deg,#ef4444,#dc2626);">
        <%= supportError %>
    </div>
<% } %>
<%
    SupportRequestDAO dao = new SupportRequestDAO();
    List<SupportRequest> list = dao.getAllRequests();

    int pendingCount = dao.getRequestCountByStatus("Pending");
    int approvedCount = dao.getRequestCountByStatus("Approved");
    int rejectedCount = dao.getRequestCountByStatus("Rejected");
    int resolvedCount = dao.getRequestCountByStatus("Resolved");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Support Admin</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<%@ include file="navbar.jsp" %>

<div class="support-page-wrapper">
    <div class="support-hero-box">
        <span class="support-mini-tag">ADMIN SUPPORT DASHBOARD</span>
        <h1>Manage Protection Requests</h1>
        <p>Review support requests, update decisions, and manage customer issue flow.</p>
    </div>

    <div class="support-stats-grid">
        <div class="support-stat-box"><h3>Pending</h3><div><%= pendingCount %></div></div>
        <div class="support-stat-box"><h3>Approved</h3><div><%= approvedCount %></div></div>
        <div class="support-stat-box"><h3>Rejected</h3><div><%= rejectedCount %></div></div>
        <div class="support-stat-box"><h3>Resolved</h3><div><%= resolvedCount %></div></div>
    </div>

    <div class="support-list-card">
        <h2>All Requests</h2>

        <% if (list != null && !list.isEmpty()) { %>
            <% for (SupportRequest r : list) { %>
                <div class="support-request-item">
                    <div class="support-request-top">
                        <h3><%= r.getIssueTitle() %></h3>
                        <span class="support-status-badge <%= r.getStatus().toLowerCase() %>"><%= r.getStatus() %></span>
                    </div>

                    <p><b>User:</b> <%= r.getUsername() %></p>
                    <p><b>Product ID:</b> <%= r.getProductName() %></p>
                    <p><b>Priority:</b> <%= r.getPriority() %></p>
                    <p><b>Description:</b> <%= r.getIssueDescription() %></p>

                    <form action="update-support-status" method="post" class="support-admin-form">
                        <input type="hidden" name="requestId" value="<%= r.getRequestId() %>">

                        <select name="status" required>
                            <option value="Pending">Pending</option>
                            <option value="Approved">Approved</option>
                            <option value="Rejected">Rejected</option>
                            <option value="Resolved">Resolved</option>
                        </select>

                        <input type="text" name="adminNote" placeholder="Admin note">
                        <button type="submit" class="support-submit-btn">Update</button>
                    </form>
                </div>
            <% } %>
        <% } else { %>
            <div class="recent-empty-box">
                <h3>No support requests found</h3>
            </div>
        <% } %>
    </div>
</div>

<%@ include file="footer.jsp" %>

</body>
</html>