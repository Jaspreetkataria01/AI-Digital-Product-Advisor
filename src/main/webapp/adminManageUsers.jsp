<%@ page import="java.util.List" %>
<%@ page import="model.UserSummary" %>
<%@ page import="model.User" %>

<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"admin".equals(role)) {
        response.sendRedirect("dashboard.jsp");
        return;
    }

    List<UserSummary> users = (List<UserSummary>) request.getAttribute("users");
    User editUser = (User) request.getAttribute("editUser");

    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Manage Users</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<%@ include file="navbar.jsp" %>

<div class="admin-manage-users-page">

    <% if (success != null) { %>
        <div class="info-banner"><%= success %></div>
    <% } %>

    <% if (error != null) { %>
        <div class="info-banner" style="background:linear-gradient(90deg,#ef4444,#dc2626);"><%= error %></div>
    <% } %>

    <div class="admin-manage-hero">
        <span class="admin-users-chip">ADMIN USER CONTROL</span>
        <h1>Manage Platform Users</h1>
        <p>Add, edit, delete, and control user accounts with full admin access.</p>
    </div>

    <div class="admin-manage-layout">

        <div class="admin-user-form-card">
            <h2><%= (editUser != null) ? "Update User" : "Add New User" %></h2>

            <form action="admin-manage-users" method="post" class="admin-user-form">
                <input type="hidden" name="action" value="<%= (editUser != null) ? "update" : "add" %>">

                <% if (editUser != null) { %>
                    <input type="hidden" name="userId" value="<%= editUser.getUserId() %>">
                <% } %>

                <input type="text" name="name" placeholder="Full Name"
                       value="<%= (editUser != null && editUser.getName() != null) ? editUser.getName() : "" %>" required>

                <input type="email" name="email" placeholder="Email Address"
                       value="<%= (editUser != null && editUser.getEmail() != null) ? editUser.getEmail() : "" %>" required>

                <% if (editUser == null) { %>
                    <input type="text" name="password" placeholder="Password" required>
                <% } %>

                <input type="text" name="phone" placeholder="Phone Number"
                       value="<%= (editUser != null && editUser.getPhone() != null) ? editUser.getPhone() : "" %>">

                <input type="text" name="city" placeholder="City"
                       value="<%= (editUser != null && editUser.getCity() != null) ? editUser.getCity() : "" %>">

                <textarea name="bio" placeholder="User Bio" rows="5"><%= (editUser != null && editUser.getBio() != null) ? editUser.getBio() : "" %></textarea>

                <select name="role" required>
                    <option value="user" <%= (editUser != null && "user".equalsIgnoreCase(editUser.getRole())) ? "selected" : "" %>>User</option>
                    <option value="admin" <%= (editUser != null && "admin".equalsIgnoreCase(editUser.getRole())) ? "selected" : "" %>>Admin</option>
                </select>

                <button type="submit" class="admin-user-submit-btn">
                    <%= (editUser != null) ? "Update User" : "Add User" %>
                </button>

                <% if (editUser != null) { %>
                    <a href="admin-manage-users" class="admin-user-cancel-btn">Cancel Edit</a>
                <% } %>
            </form>
        </div>

        <div class="admin-user-list-panel">
            <h2>Existing Users</h2>

            <% if (users != null && !users.isEmpty()) { %>
                <div class="admin-manage-user-grid">
                    <% for (UserSummary u : users) { %>
                        <div class="admin-manage-user-card">
                            <div class="admin-manage-user-top">
                                <div class="admin-user-avatar">
                                    <%= (u.getName() != null && !u.getName().isEmpty()) ? u.getName().substring(0,1).toUpperCase() : "U" %>
                                </div>
                                <div>
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

                            <div class="admin-manage-actions">
                                <a href="admin-manage-users?editId=<%= u.getUserId() %>" class="admin-edit-btn">Edit</a>

                                <form action="admin-manage-users" method="post" onsubmit="return confirm('Delete this user?');">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="userId" value="<%= u.getUserId() %>">
                                    <button type="submit" class="admin-delete-btn">Delete</button>
                                </form>
                            </div>
                        </div>
                    <% } %>
                </div>
            <% } else { %>
                <div class="search-empty-box">
                    <h2>No users found</h2>
                    <p>No registered users available.</p>
                </div>
            <% } %>
        </div>

    </div>
</div>

<%@ include file="footer.jsp" %>

</body>
</html>