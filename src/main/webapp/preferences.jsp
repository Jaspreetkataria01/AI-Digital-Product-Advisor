<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String userName = (String) session.getAttribute("userName");
    if (userName == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Product Preferences</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style.css">
</head>
<body>
<div class="dashboard-page">

 <%@ include file="navbar.jsp" %>

    <div class="preferences-pro-wrapper">

    <div class="preferences-pro-grid">

        <div class="preferences-showcase-panel">
            <span class="preferences-mini-chip">SMART PRODUCT SEARCH</span>

            <h1>Tell us what you need, and we’ll suggest the best device for you.</h1>

            <p class="preferences-lead">
                Fill in your product preferences like category, budget, purpose, and brand.
                Based on your input, the system will generate smart recommendations to help
                you choose the most suitable digital product.
            </p>

            <div class="preferences-feature-stack">
                <div class="preferences-feature-card">
                    <div class="preferences-feature-icon">💸</div>
                    <div>
                        <h3>Budget Match</h3>
                        <p>Find products that fit within your selected budget range.</p>
                    </div>
                </div>

                <div class="preferences-feature-card">
                    <div class="preferences-feature-icon">🎯</div>
                    <div>
                        <h3>Purpose Based</h3>
                        <p>Choose products based on study, gaming, work, or daily use.</p>
                    </div>
                </div>

                <div class="preferences-feature-card">
                    <div class="preferences-feature-icon">⚡</div>
                    <div>
                        <h3>Better Decision</h3>
                        <p>Get recommendations with more clarity and less confusion.</p>
                    </div>
                </div>
            </div>

            <div class="preferences-info-strip">
                <div class="preferences-info-box">
                    <span>Smart Filters</span>
                    <strong>6+</strong>
                </div>
                <div class="preferences-info-box">
                    <span>Fast Search</span>
                    <strong>Live</strong>
                </div>
                <div class="preferences-info-box">
                    <span>User Friendly</span>
                    <strong>AI Ready</strong>
                </div>
            </div>
        </div>

        <div class="preferences-form-panel">
            <div class="preferences-form-top">
                <span class="preferences-form-chip">SEARCH FORM</span>
                <h2>Product Preference Form</h2>
                <p>Enter your details to get product recommendations</p>
            </div>

            <form action="recommendation" method="post" class="preferences-pro-form">

                <div class="preferences-field">
                    <label>Product Type</label>
                    <select name="productType" required>
                        <option value="">Select Product Type</option>
                        <option value="mobile">Mobile</option>
                        <option value="laptop">Laptop</option>
                        <option value="tablet">Tablet</option>
                        <option value="smartwatch">Smartwatch</option>
                        <option value="headphones">Headphones</option>
                    </select>
                </div>

                <div class="preferences-field">
                    <label>Budget</label>
                    <select name="budget" required>
                        <option value="">Select Budget Range</option>
                        <option value="0-300">$0 - $300</option>
                        <option value="301-600">$301 - $600</option>
                        <option value="601-1000">$601 - $1000</option>
                        <option value="1001-2000">$1001 - $2000</option>
                    </select>
                </div>

                <div class="preferences-field">
                    <label>Purpose</label>
                    <select name="purpose" required>
                        <option value="">Select Purpose</option>
                        <option value="study">Study</option>
                        <option value="gaming">Gaming</option>
                        <option value="office work">Office Work</option>
                        <option value="daily use">Daily Use</option>
                    </select>
                </div>

                <div class="preferences-field">
                    <label>Preferred Brand</label>
                    <input type="text" name="brand" placeholder="Example: Apple, Dell, Samsung">
                </div>

                <div class="preferences-field">
                    <label>Minimum RAM</label>
                    <select name="ram">
                        <option value="">Select RAM</option>
                        <option value="4GB">4GB</option>
                        <option value="8GB">8GB</option>
                        <option value="12GB">12GB</option>
                        <option value="16GB">16GB</option>
                    </select>
                </div>

                <div class="preferences-field">
                    <label>Storage Preference</label>
                    <select name="storage">
                        <option value="">Select Storage</option>
                        <option value="32GB">32GB</option>
                        <option value="64GB">64GB</option>
                        <option value="128GB">128GB</option>
                        <option value="256GB">256GB</option>
                        <option value="512GB">512GB</option>
                        <option value="1TB">1TB</option>
                    </select>
                </div>

                <div class="preferences-cta-row">
                    <button type="submit" class="preferences-submit-btn">
                        Get Recommendations
                    </button>
                </div>
            </form>
        </div>

    </div>
</div>

</div>

<%@ include file="footer.jsp" %>
</body>
</html>