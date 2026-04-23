package controller;

import java.io.IOException;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public RegisterServlet() {
        super();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("register.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = safeTrim(request.getParameter("name"));
        String email = safeTrim(request.getParameter("email"));
        String password = request.getParameter("password");
        String phone = safeTrim(request.getParameter("phone"));
        String city = safeTrim(request.getParameter("city"));
        String bio = safeTrim(request.getParameter("bio"));

        // Required validation
        if (name.isEmpty() || email.isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Name, email, and password are required.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // Name validation
        if (name.length() < 2 || name.length() > 50) {
            request.setAttribute("error", "Name must be between 2 and 50 characters.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // Email validation
        if (!isValidEmail(email)) {
            request.setAttribute("error", "Please enter a valid email address.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // Password validation
        if (!isStrongPassword(password)) {
            request.setAttribute("error",
                    "Password must be at least 8 characters and include uppercase, lowercase, and a number.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // Optional phone validation
        if (!phone.isEmpty() && !isValidPhone(phone)) {
            request.setAttribute("error", "Phone number must contain only digits and be 10 to 15 digits long.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // Optional city validation
        if (!city.isEmpty() && city.length() > 100) {
            request.setAttribute("error", "City is too long.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // Optional bio validation
        if (!bio.isEmpty() && bio.length() > 500) {
            request.setAttribute("error", "Bio must be under 500 characters.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        UserDAO userDAO = new UserDAO();

        if (userDAO.emailExists(email)) {
            request.setAttribute("error", "Email already exists. Try another email.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        User user = new User();
        user.setName(name);
        user.setEmail(email);
        user.setPassword(password); // DAO will hash it
        user.setPhone(phone);
        user.setCity(city);
        user.setBio(bio);

        boolean status = userDAO.registerUser(user);

        if (status) {
            request.setAttribute("success", "Registration successful. Please login.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Registration failed. Please try again.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }

    private String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }

    private boolean isValidEmail(String email) {
        return email != null && email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$");
    }

    private boolean isValidPhone(String phone) {
        return phone != null && phone.matches("^[0-9]{10,15}$");
    }

    private boolean isStrongPassword(String password) {
        return password != null
                && password.length() >= 8
                && password.matches(".*[A-Z].*")
                && password.matches(".*[a-z].*")
                && password.matches(".*[0-9].*");
    }
}