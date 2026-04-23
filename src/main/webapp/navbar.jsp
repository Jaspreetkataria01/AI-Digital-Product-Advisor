<%@ page import="dao.UserProductDAO" %>

<%
    String navUser = (String) session.getAttribute("userName");
    String navEmail = (String) session.getAttribute("userEmail");

    int savedNavCount = 0;
    int compareNavCount = 0;

    if (navUser != null) {
        UserProductDAO navDao = new UserProductDAO();
        savedNavCount = navDao.getSavedProductsCount(navUser);
        compareNavCount = navDao.getCompareProductsCount(navUser);
    }

    String userInitial = "U";
    if (navUser != null && !navUser.trim().isEmpty()) {
        userInitial = navUser.substring(0, 1).toUpperCase();
    }
%>

<div class="navbar">
    <div class="logo">
        AI <span>Digital Product Advisor</span>
    </div>

    <div class="nav-links">
        <a href="dashboard.jsp">Dashboard</a>
        <a href="preferences.jsp">Preferences</a>
        <a href="recommendation.jsp">Recommendations</a>

        <a href="comparison.jsp" class="nav-badge-link">
            Compare
            <span class="nav-count-badge"><%= compareNavCount %></span>
        </a>

        <a href="savedProducts.jsp" class="nav-badge-link">
            Saved
            <span class="nav-count-badge"><%= savedNavCount %></span>
        </a>

        <div class="nav-profile">
            <button type="button" class="profile-icon-btn" onclick="toggleProfileMenu(event)">
                <span class="profile-icon"><%= userInitial %></span>
            </button>

            <div id="profileDropdown" class="profile-dropdown">
                <div class="profile-dropdown-top">
                    <div class="profile-dropdown-avatar"><%= userInitial %></div>
                    <div class="profile-dropdown-user">
                        <h4><%= navUser != null ? navUser : "User" %></h4>
                        <p><%= navEmail != null ? navEmail : "No email" %></p>
                    </div>
                </div>

                <div class="profile-dropdown-links">
                    <a href="profile.jsp">Edit Profile</a>
                    <a href="#" onclick="openLogoutModal(event)">Logout</a>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
function toggleProfileMenu(event) {
    event.stopPropagation();
    const menu = document.getElementById("profileDropdown");
    if (!menu) return;
    menu.classList.toggle("show-profile-dropdown");
}

document.addEventListener("click", function(event) {
    const menu = document.getElementById("profileDropdown");
    const profile = document.querySelector(".nav-profile");

    if (!menu || !profile) return;

    if (!profile.contains(event.target)) {
        menu.classList.remove("show-profile-dropdown");
    }
});
</script>
<div id="logoutModal" class="logout-modal">
    <div class="logout-overlay" onclick="closeLogoutModal()"></div>

    <div class="logout-box">
        <div class="logout-icon">!</div>
        <h2>Are you sure?</h2>
        <p>You are about to logout from your account.</p>

        <div class="logout-actions">
            <button class="logout-cancel" onclick="closeLogoutModal()">Cancel</button>
            <a href="logout" class="logout-confirm">Yes, Logout</a>
        </div>
    </div>
</div>

<script>
function openLogoutModal(e) {
    e.preventDefault();
    document.getElementById("logoutModal").classList.add("show");
}

function closeLogoutModal() {
    document.getElementById("logoutModal").classList.remove("show");
}
</script>