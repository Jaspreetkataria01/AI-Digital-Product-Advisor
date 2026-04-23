<%@ page import="java.util.List" %>
<%@ page import="model.ApiProduct" %>

<%
    List<ApiProduct> searchResults = (List<ApiProduct>) request.getAttribute("searchResults");
    String searchKeyword = (String) request.getAttribute("searchKeyword");

    if (searchKeyword == null) {
        searchKeyword = "";
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Search Results</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<%@ include file="navbar.jsp" %>

<div class="search-results-page">

    <div class="search-results-hero-pro">
        <span class="search-results-chip">SMART DATASET SEARCH</span>
        <h1>Search Results</h1>
        <p>Showing matching products from your product dataset with smart actions and premium cards.</p>
    </div>

    <div class="search-bar-pro-box">
        <form action="search-product" method="get" class="search-bar-pro-form">
            <div class="search-bar-pro-wrap">
                <input type="text"
                       name="keyword"
                       value="<%= searchKeyword %>"
                       placeholder="Search by brand, product name, category, RAM, storage..."
                       required>
                <button type="submit" class="search-bar-pro-btn">Search Products</button>
            </div>
        </form>
    </div>

    <div id="action-toast" class="toast-message">Done</div>

    <div class="product-grid">
        <% if (searchResults != null && !searchResults.isEmpty()) { %>
            <% for (ApiProduct p : searchResults) { %>

                <div class="product-card search-premium-card">

                    <div class="auto-product-image <%= p.getCategory() %>">
                        <div class="auto-badge"><%= p.getBrand() %></div>
                        <div class="auto-title"><%= p.getTitle() %></div>
                        <div class="auto-sub"><%= p.getCategory().toUpperCase() %></div>
                    </div>

                    <div class="product-card-body">
                        <h3><%= p.getTitle() %></h3>
                        <p class="product-price">$<%= p.getPrice() %></p>

                        <span class="product-badge">
                            <%= (p.getBadge() != null && !p.getBadge().trim().isEmpty()) ? p.getBadge() : "Search Match" %>
                        </span>

                        <p class="product-score">
                            Rating: <%= p.getRating() %>
                        </p>
                        <p class="product-brand">Brand: <%= p.getBrand() %></p>
                        <p class="product-rating">RAM: <%= p.getRam() %></p>
                        <p class="product-rating">Storage: <%= p.getStorage() %></p>
                        <p class="product-rating">Processor: <%= p.getProcessor() %></p>
                        <p class="product-desc"><%= p.getDescription() %></p>

                        <div class="product-reason-box">
                            <b><%= (p.getReason() != null && !p.getReason().trim().isEmpty()) ? p.getReason() : "Matched from your dataset search." %></b>
                        </div>

                        <div class="product-actions">
                            <a href="product-detail?id=<%= p.getId() %>" class="product-btn">View Details</a>

                            <button type="button"
                                    class="save-btn save-product-btn"
                                    data-id="<%= p.getId() %>"
                                    onclick="handleSaveClick(this)">
                                <span class="save-text">Save Product</span>
                                <span class="saved-text" style="display:none;">Saved Product</span>
                            </button>

                            <button type="button"
                                    class="compare-btn"
                                    data-id="<%= p.getId() %>"
                                    onclick="handleCompareClick(this)">
                                <span class="compare-text">Add to Compare</span>
                                <span class="compared-text" style="display:none;">Added to Compare</span>
                            </button>
                        </div>
                    </div>

                </div>

            <% } %>
        <% } else { %>
            <div class="empty-recommendation-box">
                <div class="empty-recommendation-icon">!</div>
                <h2>No Products Found</h2>
                <p>
                    We could not find any matching product in your dataset.
                    Try searching by brand, category, RAM, storage, or a simpler keyword.
                </p>

                <div class="empty-recommendation-actions">
                    <a href="preferences.jsp" class="empty-rec-btn primary-rec-btn">Change Preferences</a>
                    <a href="recommendation.jsp" class="empty-rec-btn secondary-rec-btn">Back to Recommendations</a>
                    <a href="savedProducts.jsp" class="empty-rec-btn third-rec-btn">View Saved</a>
                </div>
            </div>
        <% } %>
    </div>

</div>

<%@ include file="footer.jsp" %>

<script>
function showToast(message, isError = false) {
    const toast = document.getElementById("action-toast");
    if (!toast) return;

    toast.textContent = message;
    toast.classList.add("show-toast");

    if (isError) {
        toast.style.background = "linear-gradient(90deg, #ef4444, #dc2626)";
    } else {
        toast.style.background = "linear-gradient(90deg, #10b981, #059669)";
    }

    setTimeout(() => {
        toast.classList.remove("show-toast");
    }, 2200);
}

function handleSaveClick(button) {
    const productId = button.getAttribute("data-id");

    if (button.classList.contains("saved")) {
        return;
    }

    button.classList.add("saving");

    fetch("save-product?id=" + productId, {
        method: "GET"
    })
    .then(response => {
        if (!response.ok) {
            throw new Error("Save failed");
        }
        return response.text();
    })
    .then(data => {
        button.classList.remove("saving");

        if (data === "saved" || data === "already_saved") {
            button.classList.add("saved");

            const saveText = button.querySelector(".save-text");
            const savedText = button.querySelector(".saved-text");

            if (saveText) saveText.style.display = "none";
            if (savedText) savedText.style.display = "inline";

            const card = button.closest(".product-card");
            if (card) {
                card.classList.add("saved-card-pop");
                setTimeout(() => {
                    card.classList.remove("saved-card-pop");
                }, 700);
            }

            if (data === "already_saved") {
                showToast("Product already saved");
            } else {
                showToast("Product saved successfully");
            }
        } else {
            showToast("Could not save product", true);
        }
    })
    .catch(error => {
        console.error(error);
        button.classList.remove("saving");
        showToast("Product could not be saved", true);
    });
}

function handleCompareClick(button) {
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

            const card = button.closest(".product-card");
            if (card) {
                card.classList.add("saved-card-pop");
                setTimeout(() => {
                    card.classList.remove("saved-card-pop");
                }, 700);
            }

            showToast("Product added to compare");
        } else {
            showToast("Maximum 3 products allowed or already added", true);
        }
    })
    .catch(error => {
        console.error(error);
        button.classList.remove("saving");
        showToast("Could not add to compare", true);
    });
}
</script>

</body>
</html>