<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>✅ Đặt hàng thành công!</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body { 
            background-color: #f8f9fa; 
        }
        .thank-you-container {
            max-width: 600px;
            margin: 5rem auto;
            padding: 3rem;
            background: white;
            border-radius: 10px;
            text-align: center;
            box-shadow: 0 4px 15px rgba(0,0,0,0.07);
            border-top: 5px solid #198754;
        }
        .thank-you-icon {
            font-size: 4rem;
            color: #198754;
        }
        .thank-you-container h1 {
            color: #333;
            margin-top: 1.5rem;
            margin-bottom: 1rem;
        }
        .thank-you-container p {
            color: #666;
            font-size: 1.1rem;
            line-height: 1.6;
        }
        .order-id {
            font-weight: bold;
            color: #0d6efd;
            font-size: 1.2rem;
            background-color: #e7f1ff;
            padding: 5px 15px;
            border-radius: 50px;
        }
    </style>
</head>
<body>

    <%@ include file="header.jsp" %>

    <div class="container">
        <div class="thank-you-container">
            <div class="thank-you-icon">
                <i class="bi bi-check-circle-fill"></i>
            </div>
            <h1>Cảm ơn bạn đã đặt hàng!</h1>
            <p>
                Đơn hàng của bạn đã được ghi nhận thành công. 
                Chúng tôi sẽ sớm liên hệ với bạn để xác nhận.
            </p>
            <div class="d-flex justify-content-center align-items-center mt-4 gap-2">
                <p class="mb-0">Mã đơn hàng của bạn là:</p>
                <div class="order-id"><%= session.getAttribute("latestOrderCode") %></div>
            </div>
            <a href="home" class="btn btn-primary mt-4">Tiếp tục mua sắm</a>
        </div>
    </div>

    <%@ include file="footer.jsp" %>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
