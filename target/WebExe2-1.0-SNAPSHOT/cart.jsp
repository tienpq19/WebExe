<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mycompany.webexe2.model.Cart, com.mycompany.webexe2.model.CartItem, java.util.Map" %>
<%
    Cart cart = (Cart) session.getAttribute("cart");
    if (cart == null) {
        cart = new Cart(); // Tạo giỏ hàng rỗng nếu chưa có
    }
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>🛒 Giỏ hàng của bạn</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body { 
            background-color: #f8f9fa; 
        }
        .cart-container { 
            max-width: 1000px; 
        }
        .cart-table img {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: 8px;
        }
        .quantity-form {
            width: 150px;
        }
        .quantity-input {
            width: 70px;
        }
        .product-name {
            font-weight: 500;
            color: #333;
        }
        .drink-option {
            font-size: 0.85rem;
            color: #6c757d;
        }
        .empty-cart-section {
            padding: 4rem 0;
        }
    </style>
</head>
<body>

    <%@ include file="header.jsp" %>

    <div class="container cart-container py-5">
        <h1 class="text-center mb-4">Giỏ hàng của bạn</h1>

        <% if (cart != null && !cart.getItems().isEmpty()) { %>
            <div class="card shadow-sm border-0">
                <div class="table-responsive">
                    <table class="table table-borderless table-hover align-middle mb-0 cart-table">
                        <thead class="table-light">
                            <tr class="text-center">
                                <th scope="col" class="text-start ps-4">Sản phẩm</th>
                                <th scope="col">Giá</th>
                                <th scope="col">Số lượng</th>
                                <th scope="col" class="text-end pe-4">Tổng</th>
                            </tr>
                        </thead>
                        <tbody>
                        <% for (Map.Entry<String, CartItem> entry : cart.getItems().entrySet()) {
                            String itemKey = entry.getKey();
                            CartItem item = entry.getValue();
                        %> 
                            <tr class="text-center">
                                <td class="text-start ps-4">
                                    <div class="d-flex align-items-center">
                                        <img src="<%= request.getContextPath() + "/" + item.getProduct().getImageURL() %>" alt="<%= item.getProduct().getName() %>" class="me-3">
                                        <div>
                                            <div class="product-name"><%= item.getProduct().getName() %></div>
                                            <% if (item.getDrinkOption() != null) { %>
                                                <div class="drink-option">(<%= item.getDrinkOption() %>)</div>
                                            <% } %>
                                        </div>
                                    </div>
                                </td>
                                <td><%= String.format("%,.0f", item.getProduct().getPrice()) %> VNĐ</td>
                                <td>
                                    <form action="cart" method="post" class="d-flex justify-content-center align-items-center quantity-form">
                                        <input type="hidden" name="action" value="update">
                                        <input type="hidden" name="itemKey" value="<%= itemKey %>">
                                        <input type="number" name="quantity" class="form-control form-control-sm text-center quantity-input" value="<%= item.getQuantity() %>" min="1" onchange="this.form.submit()">
                                        
                                        <!-- Nút xóa giờ là một form riêng -->
                                        <form action="cart" method="post" class="ms-2">
                                            <input type="hidden" name="action" value="remove">
                                            <input type="hidden" name="itemKey" value="<%= itemKey %>">
                                            <button type="submit" class="btn btn-link text-danger p-0" title="Xóa sản phẩm">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </form>
                                    </form>
                                </td>
                                <td class="text-end pe-4 fw-bold"><%= String.format("%,.0f", item.getTotalPrice()) %> VNĐ</td>
                            </tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="row mt-4 justify-content-end">
                <div class="col-md-5">
                    <div class="card shadow-sm border-0">
                        <div class="card-body p-4">
                            <h5 class="card-title mb-3">Tổng cộng</h5>
                            <div class="d-flex justify-content-between mb-3">
                                <span>Tạm tính:</span>
                                <span><%= String.format("%,.0f", cart.getTotalAmount()) %> VNĐ</span>
                            </div>
                            <hr>
                            <div class="d-flex justify-content-between fw-bold fs-5">
                                <span>Thành tiền:</span>
                                <span class="text-danger"><%= String.format("%,.0f", cart.getTotalAmount()) %> VNĐ</span>
                            </div>
                            <div class="d-grid mt-4">
                                <a href="checkout.jsp" class="btn btn-primary btn-lg">Tiến hành thanh toán</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        <% } else { %>
            <div class="text-center empty-cart-section">
                <i class="bi bi-cart-x" style="font-size: 5rem; color: #6c757d;"></i>
                <h2 class="mt-3">Giỏ hàng của bạn đang trống</h2>
                <p class="text-muted">Hãy thêm sản phẩm vào giỏ để tiếp tục mua sắm nhé.</p>
                <a href="home" class="btn btn-primary mt-3">Bắt đầu mua sắm</a>
            </div>
        <% } %>
    </div>

    <%@ include file="footer.jsp" %>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>