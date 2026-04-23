package controller;

import java.io.IOException;
import java.util.List;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.UserSummary;

@WebServlet("/admin-users")
public class AdminUsersServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String role = (String) request.getSession().getAttribute("role");

        if (role == null || !"admin".equals(role)) {
            response.sendRedirect("dashboard.jsp");
            return;
        }

        UserDAO dao = new UserDAO();

        int totalUsers = dao.getTotalUsersCount();
        int totalAdmins = dao.getTotalAdminsCount();
        int totalNormalUsers = dao.getTotalNormalUsersCount();
        List<UserSummary> users = dao.getAllUserSummaries();

        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("totalAdmins", totalAdmins);
        request.setAttribute("totalNormalUsers", totalNormalUsers);
        request.setAttribute("users", users);

        request.getRequestDispatcher("adminUsers.jsp").forward(request, response);
    }
}