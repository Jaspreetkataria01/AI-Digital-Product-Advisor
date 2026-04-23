<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="dao.UserDAO" %>
<%@ page import="model.User" %>

<%
    String userEmail = (String) session.getAttribute("userEmail");
    String userName = (String) session.getAttribute("userName");

    if (userEmail == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    UserDAO userDao = new UserDAO();
    User user = userDao.getUserByEmail(userEmail);

    String profileUpdated = request.getParameter("profileUpdated");
    String userInitial = "U";

    if (userName != null && !userName.trim().isEmpty()) {
        userInitial = userName.substring(0, 1).toUpperCase();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Profile</title>
    <link rel="stylesheet" href="style.css">
</head>
<body class="profile-page-body">

<jsp:include page="navbar.jsp" />

<div class="profile-page-wrapper">

    <% if ("true".equals(profileUpdated)) { %>
        <div class="info-banner">Profile updated successfully.</div>
    <% } else if ("false".equals(profileUpdated)) { %>
        <div class="info-banner" style="background: linear-gradient(90deg,#ef4444,#dc2626);">
            Profile could not be updated.
        </div>
    <% } %>

    <div class="profile-page-hero">
        <div class="profile-page-left">
            <div class="profile-big-avatar"><%= userInitial %></div>

            <h1><%= (user != null && user.getName() != null) ? user.getName() : userName %></h1>
            <p class="profile-page-email"><%= (user != null && user.getEmail() != null) ? user.getEmail() : "" %></p>

            <div class="profile-info-box">
                <div class="profile-info-row">
                    <span>Phone</span>
                    <strong>
                        <%= (user != null && user.getPhone() != null && !user.getPhone().trim().isEmpty() && !"null".equalsIgnoreCase(user.getPhone()))
                            ? user.getPhone() : "Not added" %>
                    </strong>
                </div>

                <div class="profile-info-row">
                    <span>City</span>
                    <strong>
                        <%= (user != null && user.getCity() != null && !user.getCity().trim().isEmpty() && !"null".equalsIgnoreCase(user.getCity()))
                            ? user.getCity() : "Not added" %>
                    </strong>
                </div>

                <div class="profile-info-row profile-bio-row">
                    <span>About</span>
                    <strong>
                        <%= (user != null && user.getBio() != null && !user.getBio().trim().isEmpty() && !"null".equalsIgnoreCase(user.getBio()))
                            ? user.getBio() : "No profile description added yet." %>
                    </strong>
                </div>
            </div>
        </div>

        <div class="profile-page-right">
            <div class="profile-form-card">
                <span class="profile-mini-tag">ACCOUNT SETTINGS</span>
                <h2>Edit Profile</h2>
                <p>Update your personal information and keep your account details current.</p>

                <form action="update-profile" method="post" class="profile-modern-form">
                    <div class="profile-form-grid">
                        <input type="text" name="name" placeholder="Full Name"
                               value="<%= (user != null && user.getName() != null) ? user.getName() : "" %>" required>

                        <input type="text" name="phone" placeholder="Phone Number"
                               value="<%= (user != null && user.getPhone() != null && !"null".equalsIgnoreCase(user.getPhone())) ? user.getPhone() : "" %>">

                        <input type="text" name="city" placeholder="City"
                               value="<%= (user != null && user.getCity() != null && !"null".equalsIgnoreCase(user.getCity())) ? user.getCity() : "" %>">

                        <input type="email"
                               value="<%= (user != null && user.getEmail() != null) ? user.getEmail() : "" %>" disabled>
                    </div>

                    <textarea name="bio" placeholder="Write something about yourself..." rows="6"><%= (user != null && user.getBio() != null && !"null".equalsIgnoreCase(user.getBio())) ? user.getBio() : "" %></textarea>

                    <button type="submit" class="profile-main-save-btn">Save Profile</button>
                </form>
            </div>
        </div>
    </div>
</div>
<%@ include file="footer.jsp" %>
</body>
</html>