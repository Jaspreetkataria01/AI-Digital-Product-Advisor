<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.ApiProduct" %>
<%@ page import="dao.UserProductDAO" %>
<%@ page import="dao.LocalProductService" %>

<%
    String username = (String) session.getAttribute("userName");
    List<ApiProduct> compareProducts = new ArrayList<>();

    if (username != null) {
        UserProductDAO dao = new UserProductDAO();
        LocalProductService service = new LocalProductService();
        List<Integer> ids = dao.getCompareProductIds(username);

        for (Integer id : ids) {
            ApiProduct p = service.getProductById(id, application);
            if (p != null) {
                compareProducts.add(p);
            }
        }
    }

    double minPrice = Double.MAX_VALUE;
    double maxRating = -1;
    int maxRam = -1;
    int maxStorage = -1;

    for (ApiProduct p : compareProducts) {
        if (p.getPrice() < minPrice) minPrice = p.getPrice();
        if (p.getRating() > maxRating) maxRating = p.getRating();

        int ramValue = 0;
        int storageValue = 0;

        try {
            String ramStr = p.getRam().replaceAll("[^0-9]", "");
            if (!ramStr.isEmpty()) ramValue = Integer.parseInt(ramStr);
        } catch (Exception e) {}

        try {
            String storageStr = p.getStorage().replaceAll("[^0-9]", "");
            if (!storageStr.isEmpty()) storageValue = Integer.parseInt(storageStr);
        } catch (Exception e) {}

        if (ramValue > maxRam) maxRam = ramValue;
        if (storageValue > maxStorage) maxStorage = storageValue;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Compare Products</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

<%@ include file="navbar.jsp" %>

<div class="compare-container">
    <div class="compare-topbar">
        <div>
            <h1 class="compare-title">Compare Products</h1>
            <p class="compare-sub">Compare up to 3 products side by side with smart highlights</p>
        </div>
        <div class="compare-count-box">
            <span><%= compareProducts.size() %></span>
            <small>Compared Items</small>
        </div>
    </div>

<% if (compareProducts != null && !compareProducts.isEmpty()) { %>

    <div class="compare-grid">

    <% for (ApiProduct p : compareProducts) {
        int ramValue = 0;
        int storageValue = 0;

        try {
            String ramStr = p.getRam().replaceAll("[^0-9]", "");
            if (!ramStr.isEmpty()) ramValue = Integer.parseInt(ramStr);
        } catch (Exception e) {}

        try {
            String storageStr = p.getStorage().replaceAll("[^0-9]", "");
            if (!storageStr.isEmpty()) storageValue = Integer.parseInt(storageStr);
        } catch (Exception e) {}

        boolean bestPrice = p.getPrice() == minPrice;
        boolean bestRating = p.getRating() == maxRating;
        boolean bestRam = ramValue == maxRam;
        boolean bestStorage = storageValue == maxStorage;

        int winCount = 0;
        if (bestPrice) winCount++;
        if (bestRating) winCount++;
        if (bestRam) winCount++;
        if (bestStorage) winCount++;

        String winnerClass = winCount >= 2 ? "compare-card winner-card" : "compare-card";
    %>

        <div class="<%= winnerClass %>">
            <div class="compare-header smart-compare-header <%= p.getCategory() %>">
                <span class="compare-brand"><%= p.getBrand() %></span>

                <% if (winCount >= 2) { %>
                    <span class="winner-badge">Top Choice</span>
                <% } %>

                <h2><%= p.getTitle() %></h2>
                <p class="compare-category"><%= p.getCategory().toUpperCase() %></p>
            </div>

            <div class="compare-body">
                <div class="compare-row <%= bestPrice ? "best-spec" : "" %>">
                    <span>Price</span>
                    <strong>$<%= p.getPrice() %></strong>
                </div>

                <div class="compare-row">
                    <span>Brand</span>
                    <strong><%= p.getBrand() %></strong>
                </div>

                <div class="compare-row <%= bestRam ? "best-spec" : "" %>">
                    <span>RAM</span>
                    <strong><%= p.getRam() %></strong>
                </div>

                <div class="compare-row <%= bestStorage ? "best-spec" : "" %>">
                    <span>Storage</span>
                    <strong><%= p.getStorage() %></strong>
                </div>

                <div class="compare-row">
                    <span>Processor</span>
                    <strong><%= p.getProcessor() %></strong>
                </div>

                <div class="compare-row">
                    <span>Display</span>
                    <strong><%= p.getDisplay() %></strong>
                </div>

                <div class="compare-row">
                    <span>Battery</span>
                    <strong><%= p.getBattery() %></strong>
                </div>

                <div class="compare-row <%= bestRating ? "best-spec" : "" %>">
                    <span>Rating</span>
                    <strong><%= p.getRating() %></strong>
                </div>
            </div>

            <div class="compare-actions">
                <a href="product-detail?id=<%= p.getId() %>" class="compare-btn blue">View Details</a>
                <button type="button" class="compare-btn red" onclick="removeCompare(<%= p.getId() %>, this)">Remove</button>
                

    <button type="button"

            class="save-btn save-product-btn compare-save-btn"

            data-id="<%= p.getId() %>"

            onclick="handleSaveClick(this)">

        <span class="save-text">Save Product</span>

        <span class="saved-text" style="display:none;">Saved Product</span>

    </button>
            </div>
        </div>

    <% } %>

    </div>

<% } else { %>
    <div class="empty-saved-box">
        <h2>No products added for comparison</h2>
        <p>Add products from the recommendation page to compare them here.</p>
        <a href="preferences.jsp" class="go-find-btn">Find Products</a>
    </div>
<% } %>
</div>

<div id="compare-toast" class="toast-message">Product removed</div>
<div id="action-toast" class="toast-message">Done</div>

<script>
function removeCompare(id, btn) {
    const ok = confirm("Remove this product from compare list?");
    if (!ok) return;

    const card = btn.closest(".compare-card");
    btn.innerText = "Removing...";
    btn.disabled = true;

    fetch("remove-compare?id=" + id)
    .then(response => {
        if (!response.ok) throw new Error("Remove failed");

        if (card) {
            card.classList.add("compare-remove-anim");
            setTimeout(() => {
                card.remove();
                showCompareToast("Product removed from compare");
            }, 400);
        }
    })
    .catch(() => {
        btn.innerText = "Remove";
        btn.disabled = false;
        showCompareToast("Could not remove product", true);
    });
}

function showCompareToast(message, isError = false) {
    const toast = document.getElementById("compare-toast");
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
</script>
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

            const card = button.closest(".compare-card") || button.closest(".product-card");
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
</script>
<%@ include file="footer.jsp" %>
</body>
</html>