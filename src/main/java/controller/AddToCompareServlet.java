package controller;

import java.io.IOException;

import dao.UserProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/add-to-compare")
public class AddToCompareServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userName") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("Please login first");
            return;
        }

        String username = (String) session.getAttribute("userName");
        int productId = Integer.parseInt(request.getParameter("id"));

        UserProductDAO dao = new UserProductDAO();
        boolean added = dao.addCompareProduct(username, productId);

        response.setContentType("text/plain");
        response.getWriter().write(added ? "added" : "limit_or_exists");
    }
}