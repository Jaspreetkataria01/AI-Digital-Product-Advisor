package controller;

import java.io.IOException;
import java.util.List;

import dao.ProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Product;

@WebServlet("/admin-products")
public class AdminProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String role = (String) request.getSession().getAttribute("role");
        if (role == null || !role.equals("admin")) {
            response.sendRedirect("dashboard.jsp");
            return;
        }

        ProductDAO dao = new ProductDAO();
        List<Product> productList = dao.getAllProducts();

        request.setAttribute("productList", productList);
        request.getRequestDispatcher("admin.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String role = (String) request.getSession().getAttribute("role");
        if (role == null || !role.equals("admin")) {
            response.sendRedirect("dashboard.jsp");
            return;
        }

        String action = request.getParameter("action");
        ProductDAO dao = new ProductDAO();

        try {
            if ("add".equals(action)) {
                Product p = buildProductFromRequest(request);

                if (!isValidProduct(p)) {
                    request.getSession().setAttribute("adminError", "Please enter valid product details.");
                    response.sendRedirect("admin-products");
                    return;
                }

                dao.addProduct(p);

            } else if ("update".equals(action)) {
                Product p = buildProductFromRequest(request);

                String productIdStr = request.getParameter("productId");
                if (productIdStr == null || productIdStr.trim().isEmpty()) {
                    request.getSession().setAttribute("adminError", "Product ID is required for update.");
                    response.sendRedirect("admin-products");
                    return;
                }

                p.setProductId(Integer.parseInt(productIdStr));

                if (!isValidProduct(p)) {
                    request.getSession().setAttribute("adminError", "Please enter valid product details.");
                    response.sendRedirect("admin-products");
                    return;
                }

                dao.updateProduct(p);

            } else if ("delete".equals(action)) {
                String productIdStr = request.getParameter("productId");

                if (productIdStr == null || productIdStr.trim().isEmpty()) {
                    request.getSession().setAttribute("adminError", "Product ID is required for delete.");
                    response.sendRedirect("admin-products");
                    return;
                }

                int productId = Integer.parseInt(productIdStr);
                dao.deleteProduct(productId);
            }

            request.getSession().setAttribute("adminSuccess", "Action completed successfully.");
            response.sendRedirect("admin-products");

        } catch (NumberFormatException e) {
            request.getSession().setAttribute("adminError", "Invalid numeric value entered.");
            response.sendRedirect("admin-products");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("adminError", "Something went wrong. Please try again.");
            response.sendRedirect("admin-products");
        }
    }

    private Product buildProductFromRequest(HttpServletRequest request) {
        Product p = new Product();

        p.setTitle(safeTrim(request.getParameter("title")));
        p.setBrand(safeTrim(request.getParameter("brand")));
        p.setCategory(safeTrim(request.getParameter("category")));
        p.setPrice(parseDouble(request.getParameter("price")));
        p.setRam(safeTrim(request.getParameter("ram")));
        p.setStorage(safeTrim(request.getParameter("storage")));
        p.setProcessor(safeTrim(request.getParameter("processor")));
        p.setDisplay(safeTrim(request.getParameter("display")));
        p.setBattery(safeTrim(request.getParameter("battery")));
        p.setRating(parseDouble(request.getParameter("rating")));
        p.setDescription(safeTrim(request.getParameter("description")));
        p.setPurpose(safeTrim(request.getParameter("purpose")));
        p.setImageUrl(safeTrim(request.getParameter("imageUrl")));

        return p;
    }

    private boolean isValidProduct(Product p) {
        if (p.getTitle() == null || p.getTitle().isEmpty()) return false;
        if (p.getBrand() == null || p.getBrand().isEmpty()) return false;
        if (p.getCategory() == null || p.getCategory().isEmpty()) return false;
        if (p.getPrice() < 0) return false;
        if (p.getRating() < 0 || p.getRating() > 5) return false;
        return true;
    }

    private String safeTrim(String value) {
        return value == null ? "" : value.trim();
    }

    private double parseDouble(String value) {
        if (value == null || value.trim().isEmpty()) {
            return 0;
        }
        return Double.parseDouble(value.trim());
    }
}