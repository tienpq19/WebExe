<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mycompany.webexe2.model.Cart, com.mycompany.webexe2.model.CartItem" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<% Cart cart = (Cart) session.getAttribute("cart"); %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>🧾 Thanh toán đơn hàng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .order-summary {
            background-color: #f8f9fa;
            border-radius: .5rem;
            padding: 1.5rem;
        }
        .product-item img {
            max-width: 60px;
            border-radius: 5px;
        }
    </style>
</head>
<body class="bg-light">

<div class="container py-5">
    <div class="row g-5">
        <div class="col-lg-7">
            <h1 class="mb-4 text-primary">🧾 Thông tin thanh toán</h1>
            <div class="card shadow-sm border-0">
                <div class="card-header bg-primary text-white">
                    <h5 class="mb-0">Vui lòng điền thông tin nhận hàng</h5>
                </div>
                <div class="card-body p-4">
                    <form action="order" method="post" class="needs-validation" novalidate>
                        <div class="mb-3">
                            <label for="customerName" class="form-label fw-bold">Họ và tên:</label>
                            <input type="text" class="form-control" id="customerName" name="customerName" placeholder="Ví dụ: Nguyễn Văn A" required>
                            <div class="invalid-feedback">Vui lòng nhập họ và tên của bạn.</div>
                        </div>
                        <div class="mb-3">
                            <label for="phone" class="form-label fw-bold">Số điện thoại:</label>
                            <input type="tel" class="form-control" id="phone" name="phone" placeholder="Ví dụ: 0987xxxxxx" required pattern="[0-9]{10,11}">
                            <div class="invalid-feedback">Vui lòng nhập số điện thoại hợp lệ (10-11 số).</div>
                        </div>
                        <div class="mb-4">
                            <label for="address" class="form-label fw-bold">Địa chỉ nhận hàng:</label>
                            <input type="text" class="form-control" id="address" name="address" placeholder="Ví dụ: Số nhà, Tên đường, Phường/Xã, Quận/Huyện, Tỉnh/Thành phố" required>
                            <div class="invalid-feedback">Vui lòng nhập địa chỉ nhận hàng chi tiết.</div>
                        </div>
                        <div class="mb-4">
                            <label for="paymentMethod" class="form-label fw-bold">Phương thức thanh toán:</label>
                            <select class="form-select" id="paymentMethod" name="paymentMethod" required>
                                <option value="cod">Thanh toán khi nhận hàng (COD)</option>
                                <option value="online">Thanh toán online (quét QR / chuyển khoản)</option>
                            </select>
                        </div>
                        <button type="submit" class="btn btn-success btn-lg w-100 mt-3 shadow-sm">
                            <i class="bi bi-check-circle-fill"></i> Xác nhận đơn hàng
                        </button>
                    </form>
                </div>
            </div>
            <div class="text-start mt-3">
                <a href="cart.jsp" class="btn btn-outline-secondary">
                    <i class="bi bi-arrow-left"></i> Quay lại Giỏ hàng
                </a>
            </div>
        </div>

        <div class="col-lg-5">
            <div class="order-summary">
                <h2 class="mb-4">Tóm tắt đơn hàng</h2>
                <% if (cart != null && !cart.getItems().isEmpty()) { %>
                    <% for (CartItem item : cart.getItems().values()) { %>
                        <div class="d-flex justify-content-between align-items-center mb-3 product-item">
                            <div class="d-flex align-items-center">
                                <img src="images/<%= item.getProduct().getImageURL() %>" alt="<%= item.getProduct().getName() %>" class="me-3">
                                <div>
                                    <h6 class="mb-0"><%= item.getProduct().getName() %></h6>
                                    <% if (item.getDrinkOption() != null && !item.getDrinkOption().isEmpty()) { %>
                                        <small class="text-muted">Lựa chọn: <%= item.getDrinkOption() %></small><br>
                                    <% } %>
                                    <small class="text-muted">Số lượng: <%= item.getQuantity() %></small>
                                </div>
                            </div>
                            <span class="fw-bold">
                               <%= item.getTotalPrice() %> VNĐ

                            </span>
                        </div>
                        <hr class="my-2">
                    <% } %>
                    <div class="d-flex justify-content-between fw-bold fs-5 mt-3">
                        <span>Tổng cộng:</span>
                        <span class="text-danger">
                           <%= cart.getTotalAmount() %> VNĐ
                        </span>
                    </div>
                <% } else { %>
                    <p class="text-center">Giỏ hàng của bạn đang trống.</p>
                <% } %>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
// Kích hoạt tính năng form validation của Bootstrap
(function () {
  'use strict'
  var forms = document.querySelectorAll('.needs-validation')
  Array.prototype.slice.call(forms)
    .forEach(function (form) {
      form.addEventListener('submit', function (event) {
        if (!form.checkValidity()) {
          event.preventDefault()
          event.stopPropagation()
        }
        form.classList.add('was-validated')
      }, false)
    })
})()
</script>
</body>
</html>