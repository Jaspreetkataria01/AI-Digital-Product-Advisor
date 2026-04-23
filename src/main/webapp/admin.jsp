<%@ page import="java.util.List" %>
<%@ page import="model.Product" %>

<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"admin".equals(role)) {
        response.sendRedirect("dashboard.jsp");
        return;
    }
%>

<%
    List<Product> productList = (List<Product>) request.getAttribute("productList");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Panel</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<%@ include file="navbar.jsp" %>

<div class="admin-page">
    <div class="admin-header">
        <div>
            <span class="admin-mini">ADMIN CONTROL</span>
            <h1>Manage Products</h1>
            <p>Add, update, and remove products from your platform.</p>
        </div>
    </div>

    <div class="admin-form-box">
        <h2>Add New Product</h2>

        <form action="admin-products" method="post" class="admin-product-form">
            <input type="hidden" name="action" value="add">

            <div class="admin-form-grid">
                <input type="text" name="title" placeholder="Product Title" required>
                <input type="text" name="brand" placeholder="Brand" required>
                <input type="text" name="category" placeholder="Category" required>
                <input type="number" step="0.01" name="price" placeholder="Price" required>
                <input type="text" name="ram" placeholder="RAM">
                <input type="text" name="storage" placeholder="Storage">
                <input type="text" name="processor" placeholder="Processor">
                <input type="text" name="display" placeholder="Display">
                <input type="text" name="battery" placeholder="Battery">
                <input type="number" step="0.1" name="rating" placeholder="Rating" required>
                <input type="text" name="purpose" placeholder="Purpose">
                <input type="text" name="imageUrl" placeholder="Image URL">
            </div>

            <textarea name="description" placeholder="Product Description" rows="4"></textarea>

            <button type="submit" class="admin-main-btn">Add Product</button>
        </form>
    </div>

    <div class="admin-list-box">
        <h2>All Products</h2>

        <% if (productList != null && !productList.isEmpty()) { %>
            <div class="admin-table-wrap">
                <table class="admin-table">
                    <tr>
                        <th>ID</th>
                        <th>Title</th>
                        <th>Brand</th>
                        <th>Category</th>
                        <th>Price</th>
                        <th>Rating</th>
                        <th>Action</th>
                    </tr>

                    <% for (Product p : productList) { %>
                        <tr>
                            <td><%= p.getProductId() %></td>
                            <td><%= p.getTitle() %></td>
                            <td><%= p.getBrand() %></td>
                            <td><%= p.getCategory() %></td>
                            <td>$<%= p.getPrice() %></td>
                            <td><%= p.getRating() %></td>
                            <td>
                                <form action="admin-products" method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="productId" value="<%= p.getProductId() %>">
                                    <button type="submit" class="admin-delete-btn">Delete</button>
                                </form>
                            </td>
                        </tr>
                    <% } %>
                </table>
            </div>
        <% } else { %>
            <div class="admin-empty-box">
                <h3>No products found</h3>
                <p>Add products from the form above.</p>
            </div>
        <% } %>
    </div>
</div>
<%@ include file="footer.jsp" %>
</body>
</html>