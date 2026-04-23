package controller;

import java.io.IOException;

import dao.UserProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/remove-saved-product")
public class RemoveSavedProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userName") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String username = (String) session.getAttribute("userName");
        int productId = Integer.parseInt(request.getParameter("id"));

        UserProductDAO dao = new UserProductDAO();
        dao.removeSavedProduct(username, productId);

        response.sendRedirect("savedProducts.jsp?removed=true");
    }
}