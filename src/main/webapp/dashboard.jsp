<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.UserProductDAO" %>
<%@ page import="dao.SupportRequestDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.ApiProduct" %>

<%
    String userName = (String) session.getAttribute("userName");
    String userEmail = (String) session.getAttribute("userEmail");
    String role = (String) session.getAttribute("role");

    if (userName == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    UserProductDAO dao = new UserProductDAO();
    SupportRequestDAO supportDao = new SupportRequestDAO();

    int savedCount = dao.getSavedProductsCount(userName);
    int compareCount = dao.getCompareProductsCount(userName);
    int pendingSupportCount = supportDao.getRequestCountByStatus("Pending");

    Integer recommendationCountObj = (Integer) session.getAttribute("lastRecommendationCount");
    int recommendationCount = (recommendationCountObj != null) ? recommendationCountObj : 0;

    Integer totalSearchesObj = (Integer) session.getAttribute("totalSearches");
    int totalSearches = (totalSearchesObj != null) ? totalSearchesObj : 0;

    List<ApiProduct> recentViewed = (List<ApiProduct>) session.getAttribute("recentViewed");
    if (recentViewed == null) {
        recentViewed = new ArrayList<>();
    }

    String dashboardSuggestion = "Explore more products to improve your smart recommendations.";
    if (savedCount >= 2 && compareCount >= 1) {
        dashboardSuggestion = "You are close to a final decision. Compare saved products and submit support requests if needed.";
    } else if (savedCount >= 1) {
        dashboardSuggestion = "Good start. Save a few more products and use compare for better decisions.";
    }

    String roleLabel = "user";
    if ("admin".equals(role)) {
        roleLabel = "admin";
    }

    String initial = "U";
    if (userName != null && !userName.trim().isEmpty()) {
        initial = userName.substring(0,1).toUpperCase();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dashboard</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
<div class="dashboard-page">
    <%@ include file="navbar.jsp" %>

    <div class="dashboard-wrapper">

        <div class="dashboard-hero-pro">
            <div class="dashboard-hero-left">
                <span class="dashboard-chip">SMART COMMAND CENTER</span>
                <h1>Welcome back, <%= userName %></h1>
                <p class="dashboard-hero-text">
                    Manage your digital shopping journey from one place. Track products, compare options,
                    save favorites, and handle support requests with a smarter workflow.
                </p>

                <div class="dashboard-hero-actions">
                    <a href="preferences.jsp" class="btn btn-primary">Find Products</a>
                    <a href="comparison.jsp" class="btn btn-outline">Compare Devices</a>
                    <a href="mySupport.jsp" class="btn btn-dark-glow">Support Center</a>
                </div>

                <div class="dashboard-smart-tip">
                    <span class="tip-label">Smart Suggestion</span>
                    <p><%= dashboardSuggestion %></p>
                </div>
            </div>

            <div class="dashboard-hero-right">
                <div class="dashboard-profile-widget">
                    <div class="dashboard-big-avatar"><%= initial %></div>
                    <h3><%= userName %></h3>
                    <p><%= userEmail != null ? userEmail : "No email found" %></p>
                    <span class="role-pill <%= "admin".equals(role) ? "role-admin" : "role-user" %>">
                        <%= roleLabel.toUpperCase() %>
                    </span>

                    <div class="dashboard-profile-mini-grid">
                        <div class="mini-box">
                            <span>Saved</span>
                            <strong><%= savedCount %></strong>
                        </div>
                        <div class="mini-box">
                            <span>Compare</span>
                            <strong><%= compareCount %></strong>
                        </div>
                        <div class="mini-box">
                            <span>Support</span>
                            <strong><%= pendingSupportCount %></strong>
                        </div>
                        <div class="mini-box">
                            <span>Searches</span>
                            <strong><%= totalSearches %></strong>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="stats-grid premium-stats-grid">
            <div class="stat-card premium-stat-card blue-glow">
                <h3>Total Searches</h3>
                <div class="stat-number"><%= totalSearches %></div>
                <p>Searches made by you</p>
            </div>

            <div class="stat-card premium-stat-card purple-glow">
                <h3>Recommendations</h3>
                <div class="stat-number"><%= recommendationCount %></div>
                <p>Last result count</p>
            </div>

            <div class="stat-card premium-stat-card green-glow">
                <h3>Compared Products</h3>
                <div class="stat-number"><%= compareCount %></div>
                <p>Currently in compare list</p>
            </div>

            <div class="stat-card premium-stat-card orange-glow">
                <h3>Saved Items</h3>
                <div class="stat-number"><%= savedCount %></div>
                <p>Wishlist products</p>
            </div>

            <div class="stat-card premium-stat-card cyan-glow">
                <h3>Support Requests</h3>
                <div class="stat-number"><%= pendingSupportCount %></div>
                <p>Pending request count</p>
            </div>
        </div>

        <div class="dashboard-ai-box upgraded-ai-box">
            <div class="dashboard-ai-head">
                <span class="dashboard-ai-mini">AI INSIGHTS</span>
                <h2>Your Smart Activity Summary</h2>
                <p class="ai-head-sub">System-generated usage insights based on your current activity.</p>
            </div>

            <div class="dashboard-ai-grid">
                <div class="dashboard-ai-card gradient-card-one">
                    <h3>Shopping Pattern</h3>
                    <p>
                        <% if (savedCount > 3) { %>
                            You are actively shortlisting products. Your wishlist shows high buying intent and deeper comparison behavior.
                        <% } else { %>
                            You have started building your shortlist. Save more products to strengthen your product journey.
                        <% } %>
                    </p>
                </div>

                <div class="dashboard-ai-card gradient-card-two">
                    <h3>Comparison Insight</h3>
                    <p>
                        <% if (compareCount >= 2) { %>
                            You are comparing products effectively. Open compare page to identify the strongest final option.
                        <% } else { %>
                            Add at least 2 products to compare and make a smarter final decision.
                        <% } %>
                    </p>
                </div>

                <div class="dashboard-ai-card gradient-card-three">
                    <h3>Support Readiness</h3>
                    <p>
                        <% if (pendingSupportCount > 0) { %>
                            You currently have pending support activity. Monitor request status from your support dashboard.
                        <% } else { %>
                            No active support issues right now. Your account looks clean and under control.
                        <% } %>
                    </p>
                </div>
            </div>
        </div>

        <div class="recent-dashboard-section upgraded-recent-section">
            <div class="recent-dashboard-head">
                <h2>Recently Viewed Products</h2>
                <p>Products you checked most recently</p>
            </div>

            <% if (recentViewed != null && !recentViewed.isEmpty()) { %>
                <div class="recent-dashboard-grid">
                    <% for (ApiProduct p : recentViewed) { %>
                        <div class="recent-dashboard-card">
                            <div class="recent-dashboard-top <%= p.getCategory() %>">
                                <span class="recent-mini-brand"><%= p.getBrand() %></span>
                                <h3><%= p.getTitle() %></h3>
                                <p><%= p.getCategory().toUpperCase() %></p>
                            </div>

                            <div class="recent-dashboard-body">
                                <p class="recent-dashboard-price">$<%= p.getPrice() %></p>
                                <p class="recent-dashboard-rating">Rating: <%= p.getRating() %></p>
                                <a href="product-detail?id=<%= p.getId() %>" class="recent-dashboard-btn">View Again</a>
                            </div>
                        </div>
                    <% } %>
                </div>
            <% } else { %>
                <div class="recent-empty-box premium-empty-box">
                    <h3>No recently viewed products yet</h3>
                    <p>Open product details and they will appear here with quick relaunch access.</p>
                </div>
            <% } %>
        </div>

        <div class="dashboard-grid upgraded-dashboard-grid">
            <div class="panel">
                <h2>Quick Access</h2>
                <div class="quick-links">

                    <a href="preferences.jsp" class="quick-link-card">
                        <h3>Find a Product</h3>
                        <p>Enter your budget, purpose, and product type to get smart suggestions.</p>
                    </a>

                    <a href="recommendation.jsp" class="quick-link-card">
                        <h3>View Recommendations</h3>
                        <p>Check the list of suggested products based on your preferences.</p>
                    </a>

                    <a href="comparison.jsp" class="quick-link-card">
                        <h3>Compare Products</h3>
                        <p>See side-by-side comparison of multiple digital products.</p>
                    </a>

                    <a href="savedProducts.jsp" class="quick-link-card">
                        <h3>Saved Products</h3>
                        <p>Open your saved wishlist and manage selected items.</p>
                    </a>

                    <a href="mySupport.jsp" class="quick-link-card support-card">
                        <h3>Support Center</h3>
                        <p>Report issues, request help, and track your device support requests.</p>
                    </a>

                    <% if ("admin".equals(role)) { %>
                        <a href="admin-products" class="quick-link-card admin-card">
                            <h3>Admin Panel</h3>
                            <p>Manage products, add new items, and control the catalog.</p>
                        </a>
                        <a href="admin-users" class="quick-link-card admin-card">
    <h3>User Analytics Panel</h3>
    <p>View all users, profile data, support activity, and platform usage insights.</p>
</a>
<a href="admin-manage-users" class="quick-link-card admin-card">
    <h3>Manage Users</h3>
    <p>Add, edit, and delete users with full administrative control.</p>
</a>

                        <a href="supportAdmin.jsp" class="quick-link-card admin-card">
                            <h3>Support Admin Panel</h3>
                            <p>Manage user requests, approve/reject claims, and monitor support activity.</p>
                        </a>
                    <% } %>
                </div>
            </div>

            <div class="panel timeline-panel">
                <h2>Recent Activity</h2>
                <div class="activity-timeline">
                    <div class="timeline-item">
                        <span class="timeline-dot"></span>
                        <div>
                            <strong>Total searches made</strong>
                            <p><%= totalSearches %></p>
                        </div>
                    </div>

                    <div class="timeline-item">
                        <span class="timeline-dot"></span>
                        <div>
                            <strong>Products in compare list</strong>
                            <p><%= compareCount %></p>
                        </div>
                    </div>

                    <div class="timeline-item">
                        <span class="timeline-dot"></span>
                        <div>
                            <strong>Products saved in wishlist</strong>
                            <p><%= savedCount %></p>
                        </div>
                    </div>

                    <div class="timeline-item">
                        <span class="timeline-dot"></span>
                        <div>
                            <strong>Last recommendation result count</strong>
                            <p><%= recommendationCount %></p>
                        </div>
                    </div>

                    <div class="timeline-item">
                        <span class="timeline-dot"></span>
                        <div>
                            <strong>Pending support requests</strong>
                            <p><%= pendingSupportCount %></p>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </div>
    <%@ include file="footer.jsp" %>
</div>
</body>
</html>