<%@ page import="java.util.List" %>
<%@ page import="model.UserSummary" %>

<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"admin".equals(role)) {
        response.sendRedirect("dashboard.jsp");
        return;
    }

    Integer totalUsers = (Integer) request.getAttribute("totalUsers");
    Integer totalAdmins = (Integer) request.getAttribute("totalAdmins");
    Integer totalNormalUsers = (Integer) request.getAttribute("totalNormalUsers");
    List<UserSummary> users = (List<UserSummary>) request.getAttribute("users");

    if (totalUsers == null) totalUsers = 0;
    if (totalAdmins == null) totalAdmins = 0;
    if (totalNormalUsers == null) totalNormalUsers = 0;
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Users Panel</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<%@ include file="navbar.jsp" %>

<div class="admin-users-page">
    <div class="admin-users-hero">
        <span class="admin-users-chip">ADMIN USER ANALYTICS</span>
        <h1>User Control & Insights</h1>
        <p>View registered users, their activity, profile details, and overall platform engagement.</p>
    </div>

    <div class="admin-users-stats">
        <div class="admin-user-stat-card blue-stat">
            <h3>Total Users</h3>
            <div class="admin-user-stat-number"><%= totalUsers %></div>
            <p>All registered accounts</p>
        </div>

        <div class="admin-user-stat-card purple-stat">
            <h3>Total Admins</h3>
            <div class="admin-user-stat-number"><%= totalAdmins %></div>
            <p>Privileged accounts</p>
        </div>

        <div class="admin-user-stat-card green-stat">
            <h3>Normal Users</h3>
            <div class="admin-user-stat-number"><%= totalNormalUsers %></div>
            <p>Standard platform users</p>
        </div>
    </div>

    <div class="admin-users-grid">
        <% if (users != null && !users.isEmpty()) { %>
            <% for (UserSummary u : users) { %>
                <div class="admin-user-card">
                    <div class="admin-user-top">
                        <div class="admin-user-avatar">
                            <%= (u.getName() != null && !u.getName().isEmpty()) ? u.getName().substring(0,1).toUpperCase() : "U" %>
                        </div>

                        <div class="admin-user-main">
                            <h3><%= u.getName() %></h3>
                            <p><%= u.getEmail() %></p>
                            <span class="admin-role-pill <%= "admin".equalsIgnoreCase(u.getRole()) ? "admin-role-admin" : "admin-role-user" %>">
                                <%= u.getRole() %>
                            </span>
                        </div>
                    </div>

                    <div class="admin-user-info-box">
                        <p><b>Phone:</b> <%= (u.getPhone() != null && !u.getPhone().trim().isEmpty()) ? u.getPhone() : "Not added" %></p>
                        <p><b>City:</b> <%= (u.getCity() != null && !u.getCity().trim().isEmpty()) ? u.getCity() : "Not added" %></p>
                        <p><b>Bio:</b> <%= (u.getBio() != null && !u.getBio().trim().isEmpty()) ? u.getBio() : "No bio available" %></p>
                    </div>

                    <div class="admin-user-mini-stats">
                        <div class="admin-mini-box">
                            <span>Saved</span>
                            <strong><%= u.getSavedCount() %></strong>
                        </div>
                        <div class="admin-mini-box">
                            <span>Compare</span>
                            <strong><%= u.getCompareCount() %></strong>
                        </div>
                        <div class="admin-mini-box">
                            <span>Support</span>
                            <strong><%= u.getSupportCount() %></strong>
                        </div>
                    </div>
                </div>
            <% } %>
        <% } else { %>
            <div class="search-empty-box">
                <h2>No users found</h2>
                <p>No registered users are available right now.</p>
            </div>
        <% } %>
    </div>
</div>

<%@ include file="footer.jsp" %>

</body>
</html>