package controller;

import java.io.IOException;
import java.util.List;

import dao.LocalProductService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.ApiProduct;

@WebServlet("/search-product")
public class SearchProductServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");
        if (keyword == null) {
            keyword = "";
        }

        LocalProductService service = new LocalProductService();
        List<ApiProduct> searchResults = service.searchProductsFromJson(keyword, getServletContext());

        request.setAttribute("searchKeyword", keyword);
        request.setAttribute("searchResults", searchResults);

        request.getRequestDispatcher("searchResults.jsp").forward(request, response);
    }
}