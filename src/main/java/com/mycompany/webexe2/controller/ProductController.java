package com.mycompany.webexe2.controller;

import com.mycompany.webexe2.dao.ProductDAO;
import com.mycompany.webexe2.model.Product;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.File;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/products")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,     // 1MB
        maxFileSize = 1024 * 1024 * 10,      // 10MB
        maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class ProductController extends HttpServlet {
    private static final int PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        if (session.getAttribute("manager") == null) {
            response.sendRedirect("../login.jsp");
            return;
        }

        ProductDAO dao = new ProductDAO();
        String action = request.getParameter("action");

        if (action == null) {
            // Hiển thị danh sách phân trang
            int page = 1;
            try { page = Integer.parseInt(request.getParameter("page")); } catch (Exception ignored) {}

            int totalProducts = dao.getTotalProducts();
            int totalPages = (int) Math.ceil((double) totalProducts / PAGE_SIZE);

            List<Product> list = dao.getProductsByPage(page, PAGE_SIZE);
            request.setAttribute("products", list);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);

            request.getRequestDispatcher("/admin-products.jsp").forward(request, response);
        }
        else if (action.equals("add")) {
            request.getRequestDispatcher("/product-form.jsp").forward(request, response);
        }
        else if (action.equals("edit")) {
            int id = Integer.parseInt(request.getParameter("id"));
            Product p = dao.getProductById(id);
            request.setAttribute("product", p);
            request.getRequestDispatcher("/product-form.jsp").forward(request, response);
        }
        else if (action.equals("delete")) {
            int id = Integer.parseInt(request.getParameter("id"));
            dao.deleteProduct(id);
            response.sendRedirect("products");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        ProductDAO dao = new ProductDAO();

        String idStr = request.getParameter("id");
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        double price = Double.parseDouble(request.getParameter("price"));

        // ✅ Upload ảnh
        Part filePart = request.getPart("imageFile");
        String fileName = null;
        if (filePart != null && filePart.getSize() > 0) {
            fileName = new File(filePart.getSubmittedFileName()).getName();

            // ✅ Đường dẫn thực tế trong thư mục Web Pages/images
            String uploadPath = request.getServletContext().getRealPath("/images");
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();

            // ✅ Lưu ảnh thật vào /images/
            filePart.write(uploadPath + File.separator + fileName);
        }

        Product p = new Product();
        p.setName(name);
        p.setDescription(description);
        p.setPrice(price);

        if (idStr == null || idStr.isEmpty()) {
            // THÊM MỚI
            if (fileName != null) {
                p.setImageURL("images/" + fileName);  // đường dẫn tương đối để hiển thị
            }
            dao.addProduct(p);
        } else {
            // CẬP NHẬT
            p.setId(Integer.parseInt(idStr));
            Product old = dao.getProductById(p.getId());
            if (fileName != null) {
                p.setImageURL("images/" + fileName);
            } else {
                p.setImageURL(old.getImageURL());
            }
            dao.updateProduct(p);
        }

        response.sendRedirect("products");
    }
}
