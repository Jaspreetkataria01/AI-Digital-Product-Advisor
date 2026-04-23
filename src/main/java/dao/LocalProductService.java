package dao;

import java.io.InputStream;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

import jakarta.json.Json;
import jakarta.json.JsonArray;
import jakarta.json.JsonObject;
import jakarta.json.JsonReader;
import jakarta.servlet.ServletContext;
import model.ApiProduct;

public class LocalProductService {

    public List<ApiProduct> getProducts(String type, String budget, String purpose,
                                        String brand, String ram, String storage,
                                        ServletContext context) {
        List<ApiProduct> exactMatches = new ArrayList<>();
        List<ApiProduct> relaxedMatches = new ArrayList<>();
        List<ApiProduct> typeOnlyMatches = new ArrayList<>();

        try {
            InputStream is = context.getResourceAsStream("/products.json");

            if (is == null) {
                System.out.println("products.json NOT FOUND");
                return exactMatches;
            }

            JsonReader reader = Json.createReader(is);
            JsonArray array = reader.readArray();

            for (int i = 0; i < array.size(); i++) {
                JsonObject obj = array.getJsonObject(i);

                ApiProduct p = buildProductFromJson(obj);

                // 1. exact match
                if (matchType(type, p)
                        && matchBudget(budget, p.getPrice())
                        && matchBrand(brand, p.getBrand())
                        && matchRam(ram, p.getRam())
                        && matchStorage(storage, p.getStorage())
                        && matchPurpose(purpose, p.getPurpose())) {

                    int score = calculateScore(p, purpose, brand, ram, storage, budget);
                    p.setScore(score);
                    exactMatches.add(p);
                }

                // 2. relaxed match
                if (matchType(type, p)
                        && matchBudget(budget, p.getPrice())
                        && matchBrandLoose(brand, p.getBrand())) {

                    int score = calculateScore(p, purpose, brand, ram, storage, budget);
                    p.setScore(score);
                    relaxedMatches.add(p);
                }

                // 3. type only fallback
                if (matchType(type, p)) {
                    int score = calculateScore(p, purpose, brand, ram, storage, budget);
                    p.setScore(score);
                    typeOnlyMatches.add(p);
                }
            }

            reader.close();
            is.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        if (!exactMatches.isEmpty()) {
            assignBadges(exactMatches, purpose);
            System.out.println("Showing exact matches: " + exactMatches.size());
            return exactMatches;
        }

        if (!relaxedMatches.isEmpty()) {
            for (ApiProduct p : relaxedMatches) {
                p.setReason("No exact match found. Showing closest products based on your main preferences.");
            }
            assignBadges(relaxedMatches, purpose);
            System.out.println("Showing relaxed matches: " + relaxedMatches.size());
            return relaxedMatches;
        }

        for (ApiProduct p : typeOnlyMatches) {
            p.setReason("No close match found. Showing products from your selected category.");
        }
        assignBadges(typeOnlyMatches, purpose);
        System.out.println("Showing type-only matches: " + typeOnlyMatches.size());
        return typeOnlyMatches;
    }

    public void sortProducts(List<ApiProduct> list, String sortBy) {
        if (list == null || sortBy == null || sortBy.trim().isEmpty()) return;

        switch (sortBy) {
            case "priceLow":
                list.sort((a, b) -> Double.compare(a.getPrice(), b.getPrice()));
                break;
            case "priceHigh":
                list.sort((a, b) -> Double.compare(b.getPrice(), a.getPrice()));
                break;
            case "rating":
                list.sort((a, b) -> Double.compare(b.getRating(), a.getRating()));
                break;
            case "score":
                list.sort((a, b) -> Integer.compare(b.getScore(), a.getScore()));
                break;
        }
    }

    public ApiProduct getProductById(int id, ServletContext context) {
        try {
            InputStream is = context.getResourceAsStream("/products.json");

            if (is == null) {
                return null;
            }

            JsonReader reader = Json.createReader(is);
            JsonArray array = reader.readArray();

            for (int i = 0; i < array.size(); i++) {
                JsonObject obj = array.getJsonObject(i);

                if (obj.getInt("id") == id) {
                    ApiProduct p = buildProductFromJson(obj);
                    p.setReason("Detailed product information based on your selected recommendation.");

                    int score = calculateScore(p, p.getPurpose(), p.getBrand(), p.getRam(), p.getStorage(), "");
                    p.setScore(score);
                    p.setBadge("Recommended");

                    reader.close();
                    is.close();
                    return p;
                }
            }

            reader.close();
            is.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public List<ApiProduct> searchProductsFromJson(String keyword, ServletContext context) {
        List<ApiProduct> results = new ArrayList<>();

        try {
            InputStream is = context.getResourceAsStream("/products.json");

            if (is == null) {
                System.out.println("products.json NOT FOUND");
                return results;
            }

            JsonReader reader = Json.createReader(is);
            JsonArray array = reader.readArray();

            String searchValue = keyword == null ? "" : keyword.trim().toLowerCase();

            for (int i = 0; i < array.size(); i++) {
                JsonObject obj = array.getJsonObject(i);
                ApiProduct p = buildProductFromJson(obj);

                String searchableText = (
                        safe(p.getTitle()) + " " +
                        safe(p.getBrand()) + " " +
                        safe(p.getCategory()) + " " +
                        safe(p.getPurpose()) + " " +
                        safe(p.getRam()) + " " +
                        safe(p.getStorage()) + " " +
                        safe(p.getProcessor()) + " " +
                        safe(p.getDescription())
                ).toLowerCase();

                if (searchValue.isEmpty() || searchableText.contains(searchValue)) {
                    p.setReason("Matched directly from product dataset search.");
                    p.setBadge("Search Match");
                    results.add(p);
                }
            }

            reader.close();
            is.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return results;
    }

    private ApiProduct buildProductFromJson(JsonObject obj) throws Exception {
        ApiProduct p = new ApiProduct();

        p.setId(obj.getInt("id"));
        p.setTitle(obj.getString("title", ""));
        p.setPrice(obj.containsKey("price") ? obj.getJsonNumber("price").doubleValue() : 0.0);
        p.setBrand(obj.getString("brand", ""));
        p.setCategory(obj.getString("category", ""));
        p.setRam(obj.getString("ram", ""));
        p.setStorage(obj.getString("storage", ""));
        p.setProcessor(obj.getString("processor", ""));
        p.setDisplay(obj.getString("display", ""));
        p.setBattery(obj.getString("battery", ""));
        p.setDescription(obj.getString("description", ""));
        p.setPurpose(obj.getString("purpose", ""));
        p.setRating(obj.containsKey("rating") ? obj.getJsonNumber("rating").doubleValue() : 0.0);
        p.setImageUrl(obj.getString("image", ""));
        p.setReason("Recommended based on your selected preferences.");

        p.setAmazonLink("https://www.amazon.ca/s?k=" +
                URLEncoder.encode(p.getTitle(), StandardCharsets.UTF_8.toString()));

        return p;
    }

    private String safe(String value) {
        return value == null ? "" : value;
    }

    private boolean matchType(String type, ApiProduct p) {
        if (type == null || type.trim().isEmpty()) return true;
        return p.getCategory().equalsIgnoreCase(type.trim());
    }

    private boolean matchBudget(String budget, double price) {
        if (budget == null || budget.trim().isEmpty()) return true;

        switch (budget) {
            case "300":
                return price < 300;
            case "500":
                return price >= 300 && price <= 500;
            case "800":
                return price > 500 && price <= 800;
            case "1200":
                return price > 800 && price <= 1200;
            case "1500":
                return price > 1200;
            default:
                return true;
        }
    }

    private boolean matchBrand(String brandInput, String productBrand) {
        if (brandInput == null || brandInput.trim().isEmpty()) return true;
        return productBrand != null && productBrand.equalsIgnoreCase(brandInput.trim());
    }

    private boolean matchBrandLoose(String brandInput, String productBrand) {
        if (brandInput == null || brandInput.trim().isEmpty()) return true;
        if (productBrand == null) return false;
        return productBrand.toLowerCase().contains(brandInput.trim().toLowerCase())
                || brandInput.trim().toLowerCase().contains(productBrand.toLowerCase());
    }

    private boolean matchRam(String selectedRam, String productRam) {
        if (selectedRam == null || selectedRam.trim().isEmpty() || selectedRam.equalsIgnoreCase("Select RAM")) {
            return true;
        }
        return productRam != null && productRam.equalsIgnoreCase(selectedRam.trim());
    }

    private boolean matchStorage(String selectedStorage, String productStorage) {
        if (selectedStorage == null || selectedStorage.trim().isEmpty() || selectedStorage.equalsIgnoreCase("Select Storage")) {
            return true;
        }
        return productStorage != null && productStorage.equalsIgnoreCase(selectedStorage.trim());
    }

    private boolean matchPurpose(String selectedPurpose, String productPurpose) {
        if (selectedPurpose == null || selectedPurpose.trim().isEmpty()) return true;
        if (productPurpose == null || productPurpose.trim().isEmpty()) return true;
        return productPurpose.equalsIgnoreCase(selectedPurpose.trim());
    }

    private int calculateScore(ApiProduct p, String purpose, String brand, String ram, String storage, String budget) {
        int score = 0;

        if (brand != null && !brand.trim().isEmpty() && p.getBrand().equalsIgnoreCase(brand.trim())) {
            score += 25;
        }

        if (ram != null && !ram.trim().isEmpty() && !ram.equalsIgnoreCase("Select RAM")
                && p.getRam().equalsIgnoreCase(ram.trim())) {
            score += 20;
        }

        if (storage != null && !storage.trim().isEmpty() && !storage.equalsIgnoreCase("Select Storage")
                && p.getStorage().equalsIgnoreCase(storage.trim())) {
            score += 20;
        }

        if (purpose != null && !purpose.trim().isEmpty()
                && p.getPurpose() != null
                && p.getPurpose().equalsIgnoreCase(purpose.trim())) {
            score += 20;
        }

        if (matchBudget(budget, p.getPrice())) {
            score += 15;
        }

        if (p.getRating() >= 4.8) {
            score += 15;
        } else if (p.getRating() >= 4.5) {
            score += 10;
        } else if (p.getRating() >= 4.0) {
            score += 5;
        }

        return score;
    }

    private void assignBadges(List<ApiProduct> result, String purpose) {
        if (result == null || result.isEmpty()) return;

        int highestScore = -1;
        double lowestPrice = Double.MAX_VALUE;

        for (ApiProduct p : result) {
            if (p.getScore() > highestScore) {
                highestScore = p.getScore();
            }
            if (p.getPrice() < lowestPrice) {
                lowestPrice = p.getPrice();
            }
        }

        for (ApiProduct p : result) {
            if (p.getScore() == highestScore) {
                p.setBadge("Top Pick");
            } else if (p.getPrice() == lowestPrice) {
                p.setBadge("Best Value");
            } else if ("Gaming".equalsIgnoreCase(purpose) && p.getScore() >= 60) {
                p.setBadge("Gaming Choice");
            } else if ("Study".equalsIgnoreCase(purpose) && p.getScore() >= 55) {
                p.setBadge("Student Pick");
            } else {
                p.setBadge("Recommended");
            }
        }
    }

    private String generateReason(String purpose) {
        if ("Gaming".equalsIgnoreCase(purpose))
            return "Best for gaming performance and strong overall speed.";
        if ("Study".equalsIgnoreCase(purpose))
            return "Perfect for study, online work, and daily use.";
        if ("Office Work".equalsIgnoreCase(purpose))
            return "Good for office tasks, productivity, and smooth performance.";
        if ("Content Creation".equalsIgnoreCase(purpose))
            return "Strong choice for editing, creativity, and multitasking.";
        return "Recommended based on your selected preferences.";
    }
}