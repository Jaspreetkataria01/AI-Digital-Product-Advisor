package controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import dao.LocalProductService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.ApiProduct;

@WebServlet("/product-detail")
public class ProductDetailServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");

        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendRedirect("preferences.jsp");
            return;
        }

        int id = Integer.parseInt(idParam);

        LocalProductService service = new LocalProductService();
        ApiProduct product = service.getProductById(id, getServletContext());

        if (product == null) {
            response.sendRedirect("preferences.jsp");
            return;
        }

        HttpSession session = request.getSession();

        List<ApiProduct> recentViewed = (List<ApiProduct>) session.getAttribute("recentViewed");
        if (recentViewed == null) {
            recentViewed = new ArrayList<>();
        }

        Iterator<ApiProduct> iterator = recentViewed.iterator();
        while (iterator.hasNext()) {
            ApiProduct old = iterator.next();
            if (old.getId() == product.getId()) {
                iterator.remove();
                break;
            }
        }

        recentViewed.add(0, product);

        if (recentViewed.size() > 5) {
            recentViewed = recentViewed.subList(0, 5);
        }

        session.setAttribute("recentViewed", recentViewed);

        request.setAttribute("product", product);
        request.getRequestDispatcher("productDetail.jsp").forward(request, response);
    }
}