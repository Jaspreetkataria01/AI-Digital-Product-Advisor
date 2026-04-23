package controller;

import java.io.IOException;

import dao.SupportRequestDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/delete-support-request")
public class DeleteSupportRequestServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = (String) request.getSession().getAttribute("userName");

        if (username == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String requestIdStr = request.getParameter("requestId");

        if (requestIdStr == null || requestIdStr.trim().isEmpty()) {
            response.sendRedirect("mySupport.jsp?error=Invalid request");
            return;
        }

        try {
            int requestId = Integer.parseInt(requestIdStr);

            SupportRequestDAO dao = new SupportRequestDAO();
            boolean deleted = dao.deleteRequestByUser(requestId, username);

            if (deleted) {
                response.sendRedirect("mySupport.jsp?success=Request deleted successfully");
            } else {
                response.sendRedirect("mySupport.jsp?error=Could not delete request");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("mySupport.jsp?error=Something went wrong");
        }
    }
}