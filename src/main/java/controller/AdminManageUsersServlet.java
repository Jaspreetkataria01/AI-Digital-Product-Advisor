package controller;

import java.io.IOException;
import java.util.List;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;
import model.UserSummary;

@WebServlet("/admin-manage-users")
public class AdminManageUsersServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String role = (String) request.getSession().getAttribute("role");
        if (role == null || !"admin".equals(role)) {
            response.sendRedirect("dashboard.jsp");
            return;
        }

        UserDAO dao = new UserDAO();

        String editId = request.getParameter("editId");
        if (editId != null && !editId.trim().isEmpty()) {
            try {
                int userId = Integer.parseInt(editId);
                User editUser = dao.getUserById(userId);
                request.setAttribute("editUser", editUser);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        List<UserSummary> users = dao.getAllUserSummaries();
        request.setAttribute("users", users);

        request.getRequestDispatcher("adminManageUsers.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String role = (String) request.getSession().getAttribute("role");
        if (role == null || !"admin".equals(role)) {
            response.sendRedirect("dashboard.jsp");
            return;
        }

        String action = request.getParameter("action");
        UserDAO dao = new UserDAO();

        try {
            if ("add".equals(action)) {
                User user = new User();
                user.setName(request.getParameter("name"));
                user.setEmail(request.getParameter("email"));
                user.setPassword(request.getParameter("password"));
                user.setPhone(request.getParameter("phone"));
                user.setCity(request.getParameter("city"));
                user.setBio(request.getParameter("bio"));
                user.setRole(request.getParameter("role"));

                boolean status = dao.addUserByAdmin(user);

                if (status) {
                    response.sendRedirect("admin-manage-users?success=User added successfully");
                } else {
                    response.sendRedirect("admin-manage-users?error=Could not add user");
                }
                return;
            }

            if ("update".equals(action)) {
                User user = new User();
                user.setUserId(Integer.parseInt(request.getParameter("userId")));
                user.setName(request.getParameter("name"));
                user.setEmail(request.getParameter("email"));
                user.setPhone(request.getParameter("phone"));
                user.setCity(request.getParameter("city"));
                user.setBio(request.getParameter("bio"));
                user.setRole(request.getParameter("role"));

                boolean status = dao.updateUserByAdmin(user);

                if (status) {
                    response.sendRedirect("admin-manage-users?success=User updated successfully");
                } else {
                    response.sendRedirect("admin-manage-users?error=Could not update user");
                }
                return;
            }

            if ("delete".equals(action)) {
                int userId = Integer.parseInt(request.getParameter("userId"));
                boolean status = dao.deleteUserByAdmin(userId);

                if (status) {
                    response.sendRedirect("admin-manage-users?success=User deleted successfully");
                } else {
                    response.sendRedirect("admin-manage-users?error=Could not delete user");
                }
                return;
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin-manage-users?error=Something went wrong");
            return;
        }

        response.sendRedirect("admin-manage-users");
    }
}