<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>AI Digital Product Advisor</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/style.css">
</head>
<body>
<div class="main-wrapper">

    <div class="navbar">
        <div class="logo">AI <span>Digital Product Advisor</span></div>
        <div class="nav-links">
            <a href="index.jsp">Home</a>
            <a href="login.jsp">Login</a>
            <a href="register.jsp">Register</a>
        </div>
    </div>

    <section class="hero">
        <div class="hero-text">
            <h1>Choose Smart. Buy Better. <span>Find Your Perfect Gadget.</span></h1>
            <p>
                AI Digital Product Advisor helps users discover the most suitable phones,
                laptops, tablets, and accessories based on budget, purpose, and personal needs.
                It reduces confusion and gives smart recommendations in a simple way.
            </p>

            <div class="hero-buttons">
                <a href="register.jsp" class="btn btn-primary">Create Account</a>
                <a href="login.jsp" class="btn btn-outline">Login Now</a>
            </div>
        </div>

        <div class="hero-card">
            <img class="hero-image" src="https://images.unsplash.com/photo-1519389950473-47ba0277781c?auto=format&fit=crop&w=1200&q=80" alt="Digital Products">
            <div class="card-badges">
                <span class="badge">Smart Recommendations</span>
                <span class="badge">Modern Comparison</span>
                <span class="badge">User Friendly</span>
            </div>
            <h3>Your personal digital shopping assistant</h3>
            <p>
                Compare devices, check suitable options, and get product suggestions with better
                clarity. This system is designed to help users make easier and smarter decisions.
            </p>
        </div>
    </section>

    <section class="features">
        <div class="feature-card">
            <h3>Budget Based Suggestions</h3>
            <p>
                Users can enter their budget and get the best matching products without manually checking every device.
            </p>
        </div>

        <div class="feature-card">
            <h3>Purpose Driven Filtering</h3>
            <p>
                Whether the product is for gaming, study, office work, or daily use, the system suggests suitable options.
            </p>
        </div>

        <div class="feature-card">
            <h3>Simple Product Comparison</h3>
            <p>
                Users can compare multiple products side by side to understand the differences more clearly.
            </p>
        </div>
    </section>

</div>
<%@ include file="footer.jsp" %>
</body>
</html>