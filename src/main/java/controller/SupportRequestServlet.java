package controller;

import java.io.IOException;

import dao.SupportRequestDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.SupportRequest;

@WebServlet("/submit-support")
public class SupportRequestServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = (String) request.getSession().getAttribute("userName");

        if (username == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String productName = safeTrim(request.getParameter("productName"));
        String issueTitle = safeTrim(request.getParameter("issueTitle"));
        String issueDescription = safeTrim(request.getParameter("issueDescription"));

        if (productName.isEmpty() || issueTitle.isEmpty() || issueDescription.isEmpty()) {
            response.sendRedirect("mySupport.jsp?error=All fields are required");
            return;
        }

        SupportRequest support = new SupportRequest();
        support.setUsername(username);
        support.setProductName(productName);
        support.setIssueTitle(issueTitle);
        support.setIssueDescription(issueDescription);
        support.setPriority(generatePriority(issueTitle + " " + issueDescription));

        SupportRequestDAO dao = new SupportRequestDAO();
        boolean status = dao.addRequest(support);

        if (status) {
            response.sendRedirect("mySupport.jsp?success=Request submitted successfully");
        } else {
            response.sendRedirect("mySupport.jsp?error=Could not submit request");
        }
    }

    private String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }

    private String generatePriority(String text) {
        String value = text.toLowerCase();

        if (value.contains("broken") || value.contains("damage") || value.contains("not working")
                || value.contains("dead") || value.contains("crack")) {
            return "High";
        }

        if (value.contains("slow") || value.contains("battery") || value.contains("heating")) {
            return "Medium";
        }

        return "Low";
    }
}