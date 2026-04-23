package controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

import dao.LocalProductService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.ApiProduct;

@WebServlet("/recommendation")
public class RecommendationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String type = request.getParameter("productType");
        String budget = request.getParameter("budget");
        String purpose = request.getParameter("purpose");
        String brand = request.getParameter("brand");
        String ram = request.getParameter("ram");
        String storage = request.getParameter("storage");
        String sortBy = request.getParameter("sortBy");

        LocalProductService service = new LocalProductService();

        List<ApiProduct> list = service.getProducts(
                type, budget, purpose, brand, ram, storage, getServletContext()
        );

        service.sortProducts(list, sortBy);

        if (list != null && !list.isEmpty()) {
            boolean exactMatchFound = false;

            for (ApiProduct p : list) {
                boolean brandOk = (brand == null || brand.trim().isEmpty())
                        || p.getBrand().equalsIgnoreCase(brand.trim());

                boolean ramOk = (ram == null || ram.trim().isEmpty()
                        || ram.equalsIgnoreCase("Select RAM"))
                        || p.getRam().equalsIgnoreCase(ram.trim());

                boolean storageOk = (storage == null || storage.trim().isEmpty()
                        || storage.equalsIgnoreCase("Select Storage"))
                        || p.getStorage().equalsIgnoreCase(storage.trim());

                boolean purposeOk = (purpose == null || purpose.trim().isEmpty())
                        || p.getPurpose().equalsIgnoreCase(purpose.trim());

                if (brandOk && ramOk && storageOk && purposeOk) {
                    exactMatchFound = true;
                    break;
                }
            }

            if (!exactMatchFound) {
                request.setAttribute(
                        "infoMessage",
                        "No exact match found. Showing the closest products based on your preferences."
                );
            }
        }

        // AI smart summary cards
        List<ApiProduct> aiPicks = buildSmartPicks(list, purpose);
        request.setAttribute("aiPicks", aiPicks);

        int recommendationCount = (list != null) ? list.size() : 0;
        request.getSession().setAttribute("lastRecommendationCount", recommendationCount);

        Integer totalSearches = (Integer) request.getSession().getAttribute("totalSearches");
        if (totalSearches == null) {
            totalSearches = 0;
        }
        request.getSession().setAttribute("totalSearches", totalSearches + 1);

        request.setAttribute("productList", list);
        request.getRequestDispatcher("recommendation.jsp").forward(request, response);
    }

    private List<ApiProduct> buildSmartPicks(List<ApiProduct> list, String purpose) {
        List<ApiProduct> picks = new ArrayList<>();

        if (list == null || list.isEmpty()) {
            return picks;
        }

        ApiProduct bestOverall = null;
        ApiProduct bestBudget = null;
        ApiProduct bestPerformance = null;

        double bestOverallScore = -1;
        double lowestPrice = Double.MAX_VALUE;
        int highestRam = -1;
        double highestRating = -1;

        for (ApiProduct p : list) {
            int ramValue = extractNumber(p.getRam());

            double overallScore = (p.getRating() * 10) + p.getScore() + (ramValue / 2.0);

            if (overallScore > bestOverallScore) {
                bestOverallScore = overallScore;
                bestOverall = p;
            }

            if (p.getPrice() < lowestPrice) {
                lowestPrice = p.getPrice();
                bestBudget = p;
            }

            if (ramValue > highestRam || (ramValue == highestRam && p.getRating() > highestRating)) {
                highestRam = ramValue;
                highestRating = p.getRating();
                bestPerformance = p;
            }
        }

        if (bestOverall != null) {
            bestOverall.setAiTag("Best Overall");
            bestOverall.setAiSummary(buildOverallSummary(bestOverall, purpose));
            picks.add(bestOverall);
        }

        if (bestBudget != null && !containsSameProduct(picks, bestBudget)) {
            bestBudget.setAiTag("Best Budget");
            bestBudget.setAiSummary(buildBudgetSummary(bestBudget));
            picks.add(bestBudget);
        }

        if (bestPerformance != null && !containsSameProduct(picks, bestPerformance)) {
            bestPerformance.setAiTag("Best Performance");
            bestPerformance.setAiSummary(buildPerformanceSummary(bestPerformance, purpose));
            picks.add(bestPerformance);
        }

        return picks;
    }

    private boolean containsSameProduct(List<ApiProduct> list, ApiProduct product) {
        for (ApiProduct p : list) {
            if (p.getId() == product.getId()) {
                return true;
            }
        }
        return false;
    }

    private int extractNumber(String value) {
        try {
            String num = value.replaceAll("[^0-9]", "");
            if (!num.isEmpty()) {
                return Integer.parseInt(num);
            }
        } catch (Exception e) {
        }
        return 0;
    }

    private String buildOverallSummary(ApiProduct p, String purpose) {
        String useCase = (purpose == null || purpose.trim().isEmpty()) ? "daily use" : purpose.toLowerCase();
        return "This is the strongest overall choice because it balances price, rating, specs, and suitability for " 
                + useCase + ".";
    }

    private String buildBudgetSummary(ApiProduct p) {
        return "This is the best low-price option in your result list and still offers practical value for regular use.";
    }

    private String buildPerformanceSummary(ApiProduct p, String purpose) {
        String useCase = (purpose == null || purpose.trim().isEmpty()) ? "performance-focused tasks" : purpose.toLowerCase();
        return "This is the performance-focused pick with stronger hardware specs, making it a solid option for " 
                + useCase + ".";
    }
}