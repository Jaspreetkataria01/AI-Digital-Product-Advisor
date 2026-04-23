package controller;

import java.io.IOException;

import dao.SupportRequestDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/update-support-status")
public class UpdateSupportStatusServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String role = (String) request.getSession().getAttribute("role");
        if (role == null || !role.equals("admin")) {
            response.sendRedirect("dashboard.jsp");
            return;
        }

        String requestIdStr = request.getParameter("requestId");
        String status = safeTrim(request.getParameter("status"));
        String adminNote = safeTrim(request.getParameter("adminNote"));

        if (requestIdStr == null || requestIdStr.trim().isEmpty()) {
            request.getSession().setAttribute("supportError", "Request ID is missing.");
            response.sendRedirect("supportAdmin.jsp");
            return;
        }

        if (!isValidStatus(status)) {
            request.getSession().setAttribute("supportError", "Invalid status selected.");
            response.sendRedirect("supportAdmin.jsp");
            return;
        }

        try {
            int requestId = Integer.parseInt(requestIdStr);

            SupportRequestDAO dao = new SupportRequestDAO();
            boolean updated = dao.updateRequestStatus(requestId, status, adminNote);

            if (updated) {
                request.getSession().setAttribute("supportSuccess", "Support request updated successfully.");
            } else {
                request.getSession().setAttribute("supportError", "Could not update support request.");
            }

            response.sendRedirect("supportAdmin.jsp");

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("supportError", "Invalid request ID.");
            response.sendRedirect("supportAdmin.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("supportError", "Something went wrong while updating the request.");
            response.sendRedirect("supportAdmin.jsp");
        }
    }

    private String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }

    private boolean isValidStatus(String status) {
        return "Pending".equals(status)
                || "Approved".equals(status)
                || "Rejected".equals(status)
                || "Resolved".equals(status);
    }
}