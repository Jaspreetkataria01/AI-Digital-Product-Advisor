<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.ApiProduct" %>
<%@ page import="dao.UserProductDAO" %>
<%@ page import="dao.LocalProductService" %>

<%
    String username = (String) session.getAttribute("userName");
    List<ApiProduct> savedProducts = new ArrayList<>();

    if (username != null) {
        UserProductDAO dao = new UserProductDAO();
        LocalProductService service = new LocalProductService();
        List<Integer> ids = dao.getSavedProductIds(username);

        for (Integer id : ids) {
            ApiProduct p = service.getProductById(id, application);
            if (p != null) {
                savedProducts.add(p);
            }
        }
    }

    String removed = request.getParameter("removed");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Saved Products</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<%@ include file="navbar.jsp" %>

<div id="toast-message" class="toast-message <%= "true".equals(removed) ? "show-toast" : "" %>">
    <%= "true".equals(removed) ? "Product removed successfully" : "" %>
</div>

<div class="saved-header premium-saved-header">
    <div>
        <h1>Saved Products</h1>
        <p>Your wishlist and bookmarked devices</p>
    </div>
    <div class="saved-count-box">
        <span><%= savedProducts.size() %></span>
        <small>Saved Items</small>
    </div>
</div>

<div class="saved-grid">
<% if (savedProducts != null && !savedProducts.isEmpty()) {
    for (ApiProduct p : savedProducts) { %>

    <div class="saved-card">
        <div class="saved-card-top <%= p.getCategory() %>">
            <div class="saved-chip"><%= p.getBrand() %></div>
            <h2><%= p.getTitle() %></h2>
            <p><%= p.getCategory().toUpperCase() %></p>
        </div>

        <div class="saved-card-body">
            <p class="saved-price">$<%= p.getPrice() %></p>
            <p class="saved-brand">Brand: <%= p.getBrand() %></p>
            <p class="saved-rating">Rating: <%= p.getRating() %></p>
            <p class="saved-desc"><%= p.getDescription() %></p>

            <div class="saved-actions">

                <a href="product-detail?id=<%= p.getId() %>" 
                   class="saved-action-btn view-btn-saved">
                    <span class="saved-btn-label">View Details</span>
                </a>

                <button type="button"
                        class="saved-action-btn compare-btn-saved"
                        data-id="<%= p.getId() %>"
                        onclick="handleSavedCompareClick(this)">
                    <span class="compare-text saved-btn-label">Add to Compare</span>
                    <span class="compared-text saved-btn-label" style="display:none;">Added to Compare</span>
                </button>

                <button type="button"
                        class="saved-action-btn remove-btn-saved"
                        data-id="<%= p.getId() %>"
                        onclick="confirmRemove(<%= p.getId() %>, this)">
                    <span class="remove-text saved-btn-label">Remove</span>
                    <span class="removing-text saved-btn-label" style="display:none;">Removing...</span>
                </button>

            </div>
        </div>
    </div>

<%  }
} else { %>
    <div class="empty-saved-box">
        <h2>No saved products yet</h2>
        <p>Save some products from the recommendation page and they will appear here.</p>
        <a href="preferences.jsp" class="go-find-btn">Find Products</a>
    </div>
<% } %>
</div>

<script>
function handleSavedCompareClick(button) {
    const productId = button.getAttribute("data-id");

    if (button.classList.contains("compared")) {
        return;
    }

    button.classList.add("saving");

    fetch("add-to-compare?id=" + productId, {
        method: "GET"
    })
    .then(response => {
        if (!response.ok) {
            throw new Error("Compare failed");
        }
        return response.text();
    })
    .then(data => {
        button.classList.remove("saving");

        if (data === "added") {
            button.classList.add("compared");

            const compareText = button.querySelector(".compare-text");
            const comparedText = button.querySelector(".compared-text");

            if (compareText) compareText.style.display = "none";
            if (comparedText) comparedText.style.display = "inline";

            showSavedToast("Product added to compare");
        } else {
            showSavedToast("Already added or compare limit reached", true);
        }
    })
    .catch(() => {
        button.classList.remove("saving");
        showSavedToast("Could not add to compare", true);
    });
}

function confirmRemove(productId, button) {
    const ok = confirm("Are you sure you want to remove this product?");
    if (!ok) return;

    button.classList.add("removing");

    const removeText = button.querySelector(".remove-text");
    const removingText = button.querySelector(".removing-text");

    if (removeText) removeText.style.display = "none";
    if (removingText) removingText.style.display = "inline";

    setTimeout(() => {
        window.location.href = "remove-saved-product?id=" + productId;
    }, 450);
}

function showSavedToast(message, isError = false) {
    const toast = document.getElementById("toast-message");
    if (!toast) return;

    toast.textContent = message;
    toast.classList.add("show-toast");
    toast.style.background = isError
        ? "linear-gradient(90deg, #ef4444, #dc2626)"
        : "linear-gradient(90deg, #10b981, #059669)";

    setTimeout(() => {
        toast.classList.remove("show-toast");
    }, 2200);
}

window.addEventListener("load", function() {
    const toast = document.getElementById("toast-message");
    if (toast && toast.textContent.trim() !== "") {
        setTimeout(() => {
            toast.classList.remove("show-toast");
        }, 2200);
    }
});
</script>
<%@ include file="footer.jsp" %>
</body>
</html>