<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/style.css"></head>
<body>
<div class="top-nav">
    <div class="logo">
        AI <span>Digital Product Advisor</span>
    </div>

    <div class="nav-links">
        <a href="index.jsp">Home</a>
        <a href="login.jsp">Login</a>
        <a href="register.jsp">Register</a>
    </div>
</div>
<div class="auth-page">

    <div class="auth-container">

        <div class="auth-left">
            <h1>Welcome Back</h1>
            <p>
                Login to continue your digital product journey. Access your dashboard,
                recommendations, comparison tools, and saved preferences.
            </p>

            <ul class="auth-points">
                <li>✔ Access your account securely</li>
                <li>✔ Continue from your saved activity</li>
                <li>✔ View recommendations anytime</li>
                <li>✔ Explore digital products with ease</li>
            </ul>
        </div>

        <div class="auth-right">
            <h2 class="auth-form-title">Login</h2>
            <p class="auth-form-subtitle">Enter your credentials to continue</p>

            <%
                String error = (String) request.getAttribute("error");
                String success = (String) request.getAttribute("success");
                if (error != null) {
            %>
                <div class="form-message-error"><%= error %></div>
            <%
                }
                if (success != null) {
            %>
                <div class="form-message-success"><%= success %></div>
            <%
                }
            %>

            <form action="login" method="post">
                <div class="form-group">
                    <label>Email Address</label>
                    <input type="email" name="email" placeholder="Enter your email address" required>
                </div>

                <div class="form-group">
                    <label>Password</label>
                    <input type="password" name="password" placeholder="Enter your password" required>
                </div>

                <button type="submit" class="auth-btn">Login Now</button>
            </form>

            <p class="auth-bottom-text">
                New user? <a href="register.jsp">Create account</a>
            </p>
        </div>

    </div>
</div>
<%@ include file="footer.jsp" %>
</body>
</html>