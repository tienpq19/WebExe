package com.mycompany.webexe2.controller;

import java.io.IOException;
import java.util.List;

import com.mycompany.webexe2.dao.OrderDAO;
import com.mycompany.webexe2.model.Order;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/orders")
public class OrderController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        if (session.getAttribute("manager") == null) {
            response.sendRedirect("../login.jsp");
            return;
        }

        OrderDAO dao = new OrderDAO();
        String action = request.getParameter("action");

        if (action == null) {
            // 🔹 Hiển thị danh sách có phân trang
            int page = 1;
            int pageSize = 10;
            try {
                page = Integer.parseInt(request.getParameter("page"));
            } catch (Exception ignored) {}

            int totalOrders = dao.getTotalOrders();
            int totalPages = (int) Math.ceil((double) totalOrders / pageSize);

            List<Order> list = dao.getOrdersByPage(page, pageSize);
            request.setAttribute("orders", list);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);

            request.getRequestDispatcher("/admin-orders.jsp").forward(request, response);
        }
        else if (action.equals("detail")) {
            int id = Integer.parseInt(request.getParameter("id"));
            Order o = dao.getOrderById(id);
            request.setAttribute("order", o);
            request.getRequestDispatcher("/order-detail.jsp").forward(request, response);
        }
        else if (action.equals("updateStatus")) {
            int id = Integer.parseInt(request.getParameter("id"));
            String newStatus = request.getParameter("status");
            dao.updateStatus(id, newStatus);
            response.sendRedirect("orders");
        }
    }
}
