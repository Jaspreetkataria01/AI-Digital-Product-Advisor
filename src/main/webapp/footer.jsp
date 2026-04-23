<%
    String loggedUserName = (String) session.getAttribute("userName");
    boolean isLoggedIn = loggedUserName != null;
%>

<% if (!isLoggedIn) { %>
    <footer class="site-footer public-footer">
        <div class="footer-glow footer-glow-left"></div>
        <div class="footer-glow footer-glow-right"></div>

        <div class="footer-container">
            <div class="footer-top-grid">
                <div class="footer-brand-block">
                    <h2>AI Digital Product Advisor</h2>
                    <p>
                        Discover smart digital products based on your budget, purpose, and preferences.
                        Compare better, save time, and choose with confidence.
                    </p>

                    <div class="footer-tag-row">
                        <span class="footer-tag">Smart Search</span>
                        <span class="footer-tag">Easy Compare</span>
                        <span class="footer-tag">AI Ready</span>
                    </div>
                </div>

                <div class="footer-links-block">
                    <h3>Quick Links</h3>
                    <a href="index.jsp">Home</a>
                    <a href="login.jsp">Login</a>
                    <a href="register.jsp">Register</a>
                    <a href="preferences.jsp">Explore</a>
                </div>

                <div class="footer-links-block">
                    <h3>Features</h3>
                    <a href="preferences.jsp">Product Search</a>
                    <a href="recommendation.jsp">Recommendations</a>
                    <a href="comparison.jsp">Comparison</a>
                    <a href="savedProducts.jsp">Wishlist</a>
                </div>

                <div class="footer-contact-block">
                    <h3>Why Use This Platform</h3>
                    <p>Get smarter suggestions with fewer clicks.</p>
                    <p>Find products faster with guided filters.</p>
                    <p>Compare, save, and decide more confidently.</p>
                </div>
            </div>

            <div class="footer-bottom-bar">
                <p>© 2026 AI Digital Product Advisor. Built for smarter digital decisions.</p>
                <div class="footer-bottom-links">
                    <span>Secure Access</span>
                    <span>Responsive UI</span>
                    <span>J2EE MVC Project</span>
                </div>
            </div>
        </div>
    </footer>

<% } else { %>

    <footer class="site-footer app-footer">
        <div class="footer-container">
            <div class="app-footer-grid">
                <div class="app-footer-brand">
                    <h2>AI Digital Product Advisor</h2>
                    <p>
                        Welcome back, <%= loggedUserName %>. Manage recommendations, saved products,
                        comparisons, and support requests from one place.
                    </p>
                </div>

                <div class="app-footer-status">
                    <div class="app-footer-mini-card">
                        <span>Session</span>
                        <strong>Active</strong>
                    </div>

                    <div class="app-footer-mini-card">
                        <span>Access</span>
                        <strong>Protected</strong>
                    </div>

                    <div class="app-footer-mini-card">
                        <span>Mode</span>
                        <strong>Smart Panel</strong>
                    </div>
                </div>
            </div>

            <div class="footer-bottom-bar app-footer-bottom">
                <p>Logged in as <strong><%= loggedUserName %></strong></p>
                <div class="footer-bottom-links">
                    <a href="dashboard.jsp">Dashboard</a>
                    <a href="mySupport.jsp">Support</a>
                    <a href="savedProducts.jsp">Saved</a>
                    <a href="logout">Logout</a>
                </div>
            </div>
        </div>
    </footer>

<% } %>