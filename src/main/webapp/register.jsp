<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Register</title>
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
            <h1>Join the Smart Digital Shopping Experience</h1>
            <p>
                Create your account to access product recommendations, comparison features,
                and personalized digital product suggestions according to your budget and needs.
            </p>

            <ul class="auth-points">
                <li>✔ Find the right gadget faster</li>
                <li>✔ Save time with smart filtering</li>
                <li>✔ Compare products with clarity</li>
                <li>✔ Get better recommendations based on your needs</li>
            </ul>
        </div>

        <div class="auth-right">
            <h2 class="auth-form-title">Create Account</h2>
            <p class="auth-form-subtitle">Register to start exploring smart recommendations</p>

            <%
                String error = (String) request.getAttribute("error");
                if (error != null) {
            %>
                <div class="form-message-error"><%= error %></div>
            <%
                }
            %>

            <form action="register" method="post">
                <div class="form-group">
                    <label>Full Name</label>
                    <input type="text" name="name" placeholder="Enter your full name" required>
                </div>

                <div class="form-group">
                    <label>Email Address</label>
                    <input type="email" name="email" placeholder="Enter your email address" required>
                </div>

                <div class="form-group">
                    <label>Password</label>
                    <input type="password" name="password" placeholder="Create a password" required>
                </div>

                <button type="submit" class="auth-btn">Register Now</button>
            </form>

            <p class="auth-bottom-text">
                Already have an account? <a href="login.jsp">Login here</a>
            </p>
        </div>

    </div>
</div>
<%@ include file="footer.jsp" %>
</body>
</html>