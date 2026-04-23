<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.ApiProduct" %>

<%
    ApiProduct p = (ApiProduct) request.getAttribute("product");

    List<ApiProduct> recentViewed = (List<ApiProduct>) session.getAttribute("recentViewed");
    if (recentViewed == null) {
        recentViewed = new ArrayList<>();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Product Details</title>
    <link rel="stylesheet" href="style.css">
</head>
<body class="detail-page-body">

<%@ include file="navbar.jsp" %>

<% if (p != null) { %>
    <div class="detail-container">
        <div class="detail-left">
            <div class="detail-auto-image <%= p.getCategory() %>">
                <div class="detail-badge"><%= p.getBrand() %></div>
                <div class="detail-title"><%= p.getTitle() %></div>
                <div class="detail-sub"><%= p.getCategory().toUpperCase() %></div>
                <div class="detail-price-tag">$<%= p.getPrice() %></div>
            </div>
        </div>

        <div class="detail-right">
            <h1><%= p.getTitle() %></h1>
            <p class="detail-brand">Brand: <%= p.getBrand() %></p>
            <p class="detail-price">$<%= p.getPrice() %></p>
            <p class="detail-rating">Rating: <%= p.getRating() %></p>

            <div class="detail-box">
                <p><b>RAM:</b> <%= p.getRam() %></p>
                <p><b>Storage:</b> <%= p.getStorage() %></p>
                <p><b>Processor:</b> <%= p.getProcessor() %></p>
                <p><b>Display:</b> <%= p.getDisplay() %></p>
                <p><b>Battery:</b> <%= p.getBattery() %></p>
                <p><b>Category:</b> <%= p.getCategory() %></p>
            </div>

            <div class="detail-description">
                <h3>About this item</h3>
                <p><%= p.getDescription() %></p>
            </div>

            <div class="detail-description">
                <h3>Why recommended</h3>
                <p><%= p.getReason() %></p>
            </div>

            <div class="detail-actions">
                <a href="javascript:history.back()" class="back-btn">Back to Recommendations</a>
                <a href="<%= p.getAmazonLink() %>" target="_blank" class="amazon-btn">View on Amazon</a>
            </div>
        </div>
    </div>

    <div class="detail-recent-section">
        <div class="detail-recent-head">
            <h2>Recently Viewed</h2>
            <p>Quickly reopen products you checked recently</p>
        </div>

        <% 
            boolean hasOtherRecent = false;
            for (ApiProduct item : recentViewed) {
                if (item.getId() != p.getId()) {
                    hasOtherRecent = true;
                    break;
                }
            }
        %>

        <% if (recentViewed != null && !recentViewed.isEmpty() && hasOtherRecent) { %>
            <div class="detail-recent-grid">
                <% for (ApiProduct item : recentViewed) {
                    if (item.getId() == p.getId()) {
                        continue;
                    }
                %>
                    <a href="product-detail?id=<%= item.getId() %>" class="detail-recent-card">
                        <div class="detail-recent-top <%= item.getCategory() %>">
                            <span class="detail-recent-brand"><%= item.getBrand() %></span>
                            <h3><%= item.getTitle() %></h3>
                            <p><%= item.getCategory().toUpperCase() %></p>
                        </div>

                        <div class="detail-recent-body">
                            <p class="detail-recent-price">$<%= item.getPrice() %></p>
                            <p class="detail-recent-rating">Rating: <%= item.getRating() %></p>
                        </div>
                    </a>
                <% } %>
            </div>
        <% } else { %>
            <div class="recent-empty-box">
                <h3>No other recently viewed products yet</h3>
                <p>Open more product details and they will appear here.</p>
            </div>
        <% } %>
    </div>

<% } else { %>
    <h2 style="color:white; text-align:center; margin-top:50px;">Product not found</h2>
<% } %>
<%@ include file="footer.jsp" %>
</body>
</html>