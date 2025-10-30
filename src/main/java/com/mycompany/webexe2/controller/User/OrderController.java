package com.mycompany.webexe2.controller.User;

import com.mycompany.webexe2.dao.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.mycompany.webexe2.model.Cart;
import com.mycompany.webexe2.model.CartItem;
import com.mycompany.webexe2.util.EmailService;

import java.io.IOException;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.TimeZone;
import java.util.concurrent.ThreadLocalRandom;

@WebServlet("/order")
public class OrderController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();

        // Lấy giỏ hàng từ session, sử dụng đúng kiểu 'Cart'
        Cart cart = (Cart) session.getAttribute("cart");

        if (cart == null || cart.getItems().isEmpty()) {
            response.sendRedirect("cart.jsp");
            return;
        }

        // Lấy thông tin khách hàng từ form
        String customerName = request.getParameter("customerName");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String paymentMethod = request.getParameter("paymentMethod");

        // Lưu đơn hàng vào CSDL
        OrderDAO orderDAO = new OrderDAO();
        double totalAmount = cart.getTotalAmount();

        // Tạo mã đơn hàng mới, an toàn hơn
        String orderCode = generateSafeOrderCode();

        // Tạo đơn hàng và lấy lại ID
        int orderId = orderDAO.insertOrder(customerName, phone, address, totalAmount, orderCode);

        if (orderId != -1) {
            // Lưu chi tiết đơn hàng
            for (CartItem item : cart.getItems().values()) {
                orderDAO.insertOrderDetail(orderId, item.getProduct().getId(), item.getQuantity(), item.getProduct().getPrice());
            }

            // Gửi email thông báo cho admin
            sendNotificationEmail(orderId, customerName, address, phone, totalAmount, cart);

            // Xóa giỏ hàng và chuyển hướng
            session.removeAttribute("cart");
            session.setAttribute("latestOrderCode", orderCode); // Lưu mã mới vào session
            
            if ("online".equals(paymentMethod)) {
                // Chuyển khoản thủ công
                request.setAttribute("totalAmount", totalAmount);
                // Yêu cầu nội dung chuyển khoản là mã đơn hàng để dễ đối soát
                request.setAttribute("transferContent", orderCode);
                request.getRequestDispatcher("manual_payment.jsp").forward(request, response);
            } else {
                // Thanh toán khi nhận hàng (COD)
                response.sendRedirect("thankyou.jsp");
            }

        } else {
            // Xử lý lỗi nếu không tạo được đơn hàng
            request.setAttribute("errorMessage", "Đã có lỗi xảy ra khi xử lý đơn hàng của bạn. Vui lòng thử lại.");
            request.getRequestDispatcher("checkout.jsp").forward(request, response);
        }
    }

    private void sendNotificationEmail(int orderId, String customerName, String address, String phone, double totalAmount, Cart cart) {
        // THAY ĐỔI: Email của bạn để nhận thông báo
        String adminEmail = "quangtienhoihop@gmail.com";

        StringBuilder orderDetailsHtml = new StringBuilder();
        orderDetailsHtml.append("<html><body style='font-family: Arial, sans-serif;'>");
        orderDetailsHtml.append("<h1>Bạn có một đơn hàng mới!</h1>");
        orderDetailsHtml.append("<p><b>Mã đơn hàng:</b> #").append(orderId).append("</p>");
        orderDetailsHtml.append("<p><b>Tên khách hàng:</b> ").append(customerName).append("</p>");
        orderDetailsHtml.append("<p><b>Số điện thoại:</b> ").append(phone).append("</p>");
        orderDetailsHtml.append("<p><b>Địa chỉ:</b> ").append(address).append("</p>");
        orderDetailsHtml.append("<p><b>Tổng tiền:</b> <span style='color: red; font-weight: bold;'>").append(String.format("%,.0f", totalAmount)).append(" VNĐ</span></p>");
        orderDetailsHtml.append("<h3>Chi tiết sản phẩm:</h3>");
        orderDetailsHtml.append("<table border='1' cellpadding='10' cellspacing='0' style='border-collapse: collapse; width: 100%;'>");
        orderDetailsHtml.append("<tr style='background-color: #f2f2f2;'><th>Sản phẩm</th><th>Số lượng</th><th>Đơn giá</th><th>Thành tiền</th></tr>");

        for (CartItem item : cart.getItems().values()) {
            orderDetailsHtml.append("<tr>");
            String productName = item.getProduct().getName();
            if (item.getDrinkOption() != null) {
                productName += " (" + item.getDrinkOption() + ")";
            }
            orderDetailsHtml.append("<td>").append(productName).append("</td>");
            orderDetailsHtml.append("<td>").append(item.getQuantity()).append("</td>");
            orderDetailsHtml.append("<td>").append(String.format("%,.0f", item.getProduct().getPrice())).append(" VNĐ</td>");
            orderDetailsHtml.append("<td>").append(String.format("%,.0f", item.getTotalPrice())).append(" VNĐ</td>");
            orderDetailsHtml.append("</tr>");
        }

        orderDetailsHtml.append("</table>");
        orderDetailsHtml.append("<p style='margin-top: 20px;'>Vui lòng truy cập trang quản trị để xử lý đơn hàng.</p>");
        orderDetailsHtml.append("</body></html>");

        EmailService.sendOrderNotification(adminEmail, orderDetailsHtml.toString());
    }
    
    private String generateSafeOrderCode() {
        SimpleDateFormat sdf = new SimpleDateFormat("yyMMddHHmmss");
        String dateTimePart = sdf.format(new java.util.Date());
        int randomPart = ThreadLocalRandom.current().nextInt(10, 100); // 2 chữ số ngẫu nhiên
        return "VM-" + dateTimePart + "-" + randomPart;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("checkout.jsp");
    }
}
