<%@ page import="java.util.List" %>
<%@ page import="dao.SupportRequestDAO" %>
<%@ page import="dao.ProductDAO" %>
<%@ page import="model.SupportRequest" %>
<%@ page import="model.Product" %>

<%
    String username = (String) session.getAttribute("userName");
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    SupportRequestDAO supportDao = new SupportRequestDAO();
    List<SupportRequest> list = supportDao.getRequestsByUsername(username);

    ProductDAO productDao = new ProductDAO();
    List<Product> products = productDao.getAllProducts();

    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Support Requests</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<%@ include file="navbar.jsp" %>

<div class="support-page-wrapper">

    <% if (success != null) { %>
        <div class="info-banner"><%= success %></div>
    <% } %>

    <% if (error != null) { %>
        <div class="info-banner" style="background:linear-gradient(90deg,#ef4444,#dc2626);">
            <%= error %>
        </div>
    <% } %>

    <div class="support-hero-box">
        <span class="support-mini-tag">SMART SUPPORT CENTER</span>
        <h1>Protection & Support Requests</h1>
        <p>Submit issues for your devices and track request progress with smart status updates.</p>
    </div>

   <div class="support-layout">

    <div class="support-form-card">
        <h2>Report a New Issue</h2>

        <form action="submit-support" method="post" class="support-form">
            <input type="text" name="productName" placeholder="Enter Product Name" required>
            <input type="text" name="issueTitle" placeholder="Issue Title" required>
            <textarea name="issueDescription"
                      placeholder="Describe your issue in detail..."
                      rows="6"
                      required></textarea>

            <button type="submit" class="support-submit-btn">Submit Request</button>
        </form>
    </div>

    <div class="support-list-card">
        <h2>My Requests</h2>

        <% if (list != null && !list.isEmpty()) { %>
            <% for (SupportRequest r : list) { %>
                <div class="support-request-item">
                    <div class="support-request-top">
                        <h3><%= r.getIssueTitle() %></h3>
                        <span class="support-status-badge <%= r.getStatus().toLowerCase() %>">
                            <%= r.getStatus() %>
                        </span>
                    </div>

                    <p><b>Product Name:</b> <%= r.getProductName() %></p>
                    <p><b>Priority:</b> <%= r.getPriority() %></p>
                    <p><b>Description:</b> <%= r.getIssueDescription() %></p>
                    <p><b>Created:</b> <%= r.getCreatedAt() %></p>

                    <% if (r.getAdminNote() != null && !r.getAdminNote().trim().isEmpty()) { %>
                        <div class="support-admin-note">
                            <b>Admin Note:</b> <%= r.getAdminNote() %>
                        </div>
                    <% } %>

                    <div class="support-request-actions">
                        <form action="delete-support-request" method="post" onsubmit="return confirm('Delete this support request?');">
                            <input type="hidden" name="requestId" value="<%= r.getRequestId() %>">
                            <button type="submit" class="support-delete-btn">Delete Request</button>
                        </form>
                    </div>
                </div>
            <% } %>
        <% } else { %>
            <div class="recent-empty-box">
                <h3>No support requests yet</h3>
                <p>Submit your first issue from the form.</p>
            </div>
        <% } %>
    </div>

</div>
</div>

<%@ include file="footer.jsp" %>

</body>
</html>