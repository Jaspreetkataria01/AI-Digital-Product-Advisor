package controller;

import java.io.IOException;

import dao.UserProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/save-product")
public class SaveProductServlet extends HttpServlet {
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
        String idParam = request.getParameter("id");

        if (idParam == null || idParam.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("Missing product id");
            return;
        }

        int productId = Integer.parseInt(idParam);

        UserProductDAO dao = new UserProductDAO();
        boolean saved = dao.saveProduct(username, productId);

        response.setContentType("text/plain");
        response.getWriter().write(saved ? "saved" : "already_saved");
    }
}