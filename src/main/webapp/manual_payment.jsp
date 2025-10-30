<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thông tin thanh toán</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body { 
            background-color: #f8f9fa; 
        }
        .payment-container {
            max-width: 600px;
            margin: 5rem auto;
            padding: 3rem;
            background: white;
            border-radius: 10px;
            text-align: center;
            box-shadow: 0 4px 15px rgba(0,0,0,0.07);
        }
        .payment-container h1 {
            color: #333;
            margin-bottom: 2rem;
        }
        .qr-code {
            max-width: 250px;
            margin: 1rem auto;
            border: 1px solid #ddd;
            padding: 5px;
            border-radius: 5px;
        }
        .payment-info p {
            font-size: 1.1rem;
            color: #555;
        }
        .payment-info .amount {
            font-size: 1.8rem;
            font-weight: bold;
            color: #dc3545;
        }
        .payment-info .content {
            font-weight: bold;
            color: #0d6efd;
            background-color: #e7f1ff;
            padding: 8px 15px;
            border-radius: 5px;
            display: inline-block;
            margin-top: 5px;
        }
    </style>
</head>
<body>

    <%@ include file="header.jsp" %>

    <div class="container">
        <div class="payment-container">
            <h1>Quét mã QR để thanh toán</h1>
            
            <img src="images/qr.png" alt="Mã QR thanh toán" class="img-fluid qr-code"/>
            
            <div class="payment-info mt-4">
                <p>Tổng số tiền cần thanh toán:</p>
                <p class="amount">
${requestScope.totalAmount}VNĐ
    
                </p>

                <p class="mt-4">Nội dung chuyển khoản:</p>
                <p class="content">${requestScope.transferContent}</p>
                <p class="text-muted">(Vui lòng ghi đúng nội dung để chúng tôi xác nhận đơn hàng)</p>
            </div>

            <a href="thankyou.jsp" class="btn btn-success mt-4">Tôi đã thanh toán</a>
        </div>
    </div>

    <%@ include file="footer.jsp" %>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
