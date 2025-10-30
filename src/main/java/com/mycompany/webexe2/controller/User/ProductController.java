package com.mycompany.webexe2.controller.User;

import com.mycompany.webexe2.dao.ProductDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import com.mycompany.webexe2.model.Product;
import java.io.IOException;
import java.util.List;

@WebServlet("/home")
public class ProductController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int page = 1;
        int pageSize = 8; // mỗi trang 10 sản phẩm

        try {
            String pageParam = request.getParameter("page");
            if (pageParam != null) {
                page = Integer.parseInt(pageParam);
            }
        } catch (NumberFormatException ignored) {}

        ProductDAO dao = new ProductDAO();
        int totalProducts = dao.getTotalProducts();
        int totalPages = (int) Math.ceil((double) totalProducts / pageSize);

        List<Product> products = dao.getProductsByPage(page, pageSize);

        request.setAttribute("products", products);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher("/home.jsp").forward(request, response);
    }
}
