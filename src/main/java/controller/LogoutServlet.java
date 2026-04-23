package controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public LogoutServlet() {
        super();
    }

    // Handle GET request
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        logoutUser(request, response);
    }

    // Handle POST request (extra secure)
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        logoutUser(request, response);
    }

    private void logoutUser(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        // Destroy session
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }

        // Prevent browser caching (IMPORTANT SECURITY)
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1
        response.setHeader("Pragma", "no-cache"); // HTTP 1.0
        response.setDateHeader("Expires", 0); // Proxies

        // Redirect to login page
        response.sendRedirect("login.jsp");
    }
}