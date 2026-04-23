<%@ page import="java.util.List" %>
<%@ page import="model.ApiProduct" %>

<%
    List<ApiProduct> list = (List<ApiProduct>) request.getAttribute("productList");
    List<ApiProduct> aiPicks = (List<ApiProduct>) request.getAttribute("aiPicks");
    String infoMessage = (String) request.getAttribute("infoMessage");

    String productType = request.getParameter("productType") == null ? "" : request.getParameter("productType");
    String budget = request.getParameter("budget") == null ? "" : request.getParameter("budget");
    String purpose = request.getParameter("purpose") == null ? "" : request.getParameter("purpose");
    String brand = request.getParameter("brand") == null ? "" : request.getParameter("brand");
    String ram = request.getParameter("ram") == null ? "" : request.getParameter("ram");
    String storage = request.getParameter("storage") == null ? "" : request.getParameter("storage");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Recommendations</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<%@ include file="navbar.jsp" %>

<% if (infoMessage != null) { %>
    <div class="info-banner"><%= infoMessage %></div>
<% } %>

<div class="sort-bar">
    <form method="post" action="recommendation">
        <input type="hidden" name="productType" value="<%= productType %>">
        <input type="hidden" name="budget" value="<%= budget %>">
        <input type="hidden" name="purpose" value="<%= purpose %>">
        <input type="hidden" name="brand" value="<%= brand %>">
        <input type="hidden" name="ram" value="<%= ram %>">
        <input type="hidden" name="storage" value="<%= storage %>">

        <select name="sortBy" onchange="this.form.submit()">
            <option value="">Sort Products</option>
            <option value="priceLow">Price: Low to High</option>
            <option value="priceHigh">Price: High to Low</option>
            <option value="rating">Rating: High to Low</option>
            <option value="score">Match Score: High to Low</option>
        </select>
    </form>
</div>

<% if (aiPicks != null && !aiPicks.isEmpty()) { %>
    <div class="ai-summary-section">
        <div class="ai-summary-head">
            <span class="ai-summary-mini">SMART RECOMMENDATION</span>
            <h2>AI Best Match Summary</h2>

            <% if (list == null || list.isEmpty()) { %>
                <p>We could not find an exact match, so here are smart alternative recommendations based on overall quality, price, and performance.</p>
            <% } else { %>
                <p>These are the strongest picks based on rating, price, specs, and your selected preferences.</p>
            <% } %>
        </div>

        <div class="ai-summary-grid">
            <% for (ApiProduct ai : aiPicks) { %>
                <div class="ai-summary-card">
                    <div class="ai-summary-top">
                        <span class="ai-summary-tag"><%= ai.getAiTag() %></span>
                        <span class="ai-summary-brand"><%= ai.getBrand() %></span>
                    </div>

                    <h3><%= ai.getTitle() %></h3>
                    <p class="ai-summary-price">$<%= ai.getPrice() %></p>
                    <p class="ai-summary-rating">Rating: <%= ai.getRating() %> | Score: <%= ai.getScore() %></p>
                    <p class="ai-summary-text"><%= ai.getAiSummary() %></p>

                    <div class="ai-summary-actions">
                        <a href="product-detail?id=<%= ai.getId() %>" class="ai-summary-btn">View Product</a>
                    </div>
                </div>
            <% } %>
        </div>
    </div>
<% } %>

<div id="action-toast" class="toast-message">Done</div>

<div class="product-grid">
<% if (list != null && !list.isEmpty()) {
    for (ApiProduct p : list) { %>

    <div class="product-card">
        <div class="auto-product-image <%= p.getCategory() %>">
            <div class="auto-badge"><%= p.getBrand() %></div>
            <div class="auto-title"><%= p.getTitle() %></div>
            <div class="auto-sub"><%= p.getCategory().toUpperCase() %></div>
        </div>

        <div class="product-card-body">
            <h3><%= p.getTitle() %></h3>
            <p class="product-price">$<%= p.getPrice() %></p>

            <span class="product-badge"><%= p.getBadge() %></span>

            <p class="product-score">Match Score: <%= p.getScore() %></p>
            <p class="product-brand">Brand: <%= p.getBrand() %></p>
            <p class="product-rating">Rating: <%= p.getRating() %></p>
            <p class="product-desc"><%= p.getDescription() %></p>

            <div class="product-reason-box">
                <b><%= p.getReason() %></b>
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

<%  }
} else { %>

    <div class="empty-recommendation-box">
        <div class="empty-recommendation-icon">!</div>
        <h2>No Products Found</h2>
        <p>
            We could not find any product matching your selected filters.
            Try changing budget, brand, RAM, storage, or purpose to get better results.
        </p>
        
        <div class="smart-search-box">
    <div class="smart-search-top">
        <span class="smart-search-chip">DATASET SEARCH</span>
        <h2>Search Directly from Product Catalog</h2>
        <p>If filters did not match, search manually by product name, brand, category, or purpose.</p>
    </div>

    <form action="search-product" method="get" class="smart-search-form">
        <div class="smart-search-input-wrap">
            <input type="text"
                   name="keyword"
                   placeholder="Try: iPhone, Samsung, laptop, gaming, smartwatch..."
                   required>
            <button type="submit" class="smart-search-btn">Search Products</button>
        </div>
    </form>
</div>

        <div class="empty-recommendation-actions">
            <a href="preferences.jsp" class="empty-rec-btn primary-rec-btn">Change Preferences</a>

            <button type="button" class="empty-rec-btn secondary-rec-btn" onclick="openResetModal()">
                Reset Filters
            </button>

            <a href="savedProducts.jsp" class="empty-rec-btn third-rec-btn">View Saved</a>
        </div>
    </div>

<% } %>
</div>

<div id="resetFilterModal" class="reset-filter-modal">
    <div class="reset-filter-overlay" onclick="closeResetModal()"></div>

    <div class="reset-filter-modal-box">
        <button type="button" class="reset-close-btn" onclick="closeResetModal()">x</button>

        <div class="reset-modal-top">
            <div class="reset-modal-icon">#</div>
            <h2>Choose Product Category</h2>
            <p>Select one category and we will show products only from that section.</p>
        </div>

        <form id="quickTypeForm" method="post" action="recommendation">
            <input type="hidden" name="productType" id="quickProductType">
            <input type="hidden" name="budget" value="">
            <input type="hidden" name="purpose" value="">
            <input type="hidden" name="brand" value="">
            <input type="hidden" name="ram" value="">
            <input type="hidden" name="storage" value="">
            <input type="hidden" name="sortBy" value="">

            <div class="reset-type-grid">
                <button type="button" class="reset-type-card mobile-card" onclick="submitQuickType('mobile')">
                    <span class="reset-type-title">Mobile</span>
                    <span class="reset-type-sub">Phones and smartphones</span>
                </button>

                <button type="button" class="reset-type-card laptop-card" onclick="submitQuickType('laptop')">
                    <span class="reset-type-title">Laptop</span>
                    <span class="reset-type-sub">Study, work, gaming laptops</span>
                </button>

                <button type="button" class="reset-type-card tablet-card" onclick="submitQuickType('tablet')">
                    <span class="reset-type-title">Tablet</span>
                    <span class="reset-type-sub">Portable touchscreen devices</span>
                </button>

                <button type="button" class="reset-type-card watch-card" onclick="submitQuickType('smartwatch')">
                    <span class="reset-type-title">Smartwatch</span>
                    <span class="reset-type-sub">Fitness and smart watches</span>
                </button>

                <button type="button" class="reset-type-card audio-card" onclick="submitQuickType('headphones')">
                    <span class="reset-type-title">Headphones</span>
                    <span class="reset-type-sub">Audio and wireless listening</span>
                </button>
            </div>
        </form>
    </div>
</div>

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

function openResetModal() {
    const modal = document.getElementById("resetFilterModal");
    if (modal) {
        modal.classList.add("show-reset-modal");
        document.body.classList.add("modal-open");
    }
}

function closeResetModal() {
    const modal = document.getElementById("resetFilterModal");
    if (modal) {
        modal.classList.remove("show-reset-modal");
        document.body.classList.remove("modal-open");
    }
}

function submitQuickType(type) {
    const input = document.getElementById("quickProductType");
    const form = document.getElementById("quickTypeForm");

    if (input && form) {
        input.value = type;
        form.submit();
    }
}

document.addEventListener("keydown", function(event) {
    if (event.key === "Escape") {
        closeResetModal();
    }
});
</script>
<%@ include file="footer.jsp" %>
</body>
</html>