package com.mycompany.webexe2.controller.User;

import com.mycompany.webexe2.dao.ProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.mycompany.webexe2.model.Cart;
import com.mycompany.webexe2.model.Product;

import java.io.IOException;

@WebServlet("/cart")
public class CartController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Chỉ hiển thị trang giỏ hàng
        request.getRequestDispatcher("/cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Cart cart = (Cart) session.getAttribute("cart");

        // Nếu chưa có giỏ hàng trong session, tạo mới
        if (cart == null) {
            cart = new Cart();
            session.setAttribute("cart", cart);
        }

        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect("home");
            return;
        }

        try {
            switch (action) {
                case "add": {
                    int productId = Integer.parseInt(request.getParameter("id"));
                    int quantity = Integer.parseInt(request.getParameter("quantity"));
                    ProductDAO productDAO = new ProductDAO();
                    Product product = productDAO.getProductById(productId);
                    
                    if (product != null) {
                        String drinkOption = null;
                        // Chỉ lấy drinkOption nếu sản phẩm là đồ uống
                        if (product.isDrink()) {
                            drinkOption = request.getParameter("drinkOption");
                        }
                        cart.addItem(product, quantity, drinkOption);
                    }
                    // Sau khi thêm, quay lại trang chủ hoặc trang trước đó
                    response.sendRedirect(request.getHeader("Referer"));
                    break;
                }
                case "update": {
                    String itemKey = request.getParameter("itemKey");
                    int quantity = Integer.parseInt(request.getParameter("quantity"));
                    cart.updateItem(itemKey, quantity);
                    response.sendRedirect("cart");
                    break;
                }
                case "remove": {
                    String itemKey = request.getParameter("itemKey");
                    cart.removeItem(itemKey);
                    response.sendRedirect("cart");
                    break;
                }
                default:
                    response.sendRedirect("home");
                    break;
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect("home");
        }
    }
}
