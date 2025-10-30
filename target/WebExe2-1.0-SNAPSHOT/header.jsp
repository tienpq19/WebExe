<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>VieMood – Healthy Lifestyle</title>
    <link rel="icon" href="<%= request.getContextPath() %>/images/qr.png" type="image/png">

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">

    <style>
        /* 🌿 Reset + Layout */
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: "Poppins", Arial, sans-serif; background: #f9fafb; }

        /* 🌿 Header */
        header {
            background: linear-gradient(90deg, #86efac, #34d399);
            color: #fff;
            padding: 20px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        .logo {
            font-size: 24px;
            font-weight: bold;
            letter-spacing: 1px;
        }

        .logo span {
            color: #065f46;
        }

        nav ul {
            list-style: none;
            display: flex;
            gap: 25px;
        }

        nav ul li a {
            color: white;
            text-decoration: none;
            font-weight: 500;
            transition: 0.3s;
        }

        nav ul li a:hover {
            color: #065f46;
            border-bottom: 2px solid #065f46;
            padding-bottom: 3px;
        }

        /* 🌿 CTA Buttons */
        .btn-cart {
            background: white;
            color: #059669;
            padding: 8px 15px;
            border-radius: 20px;
            font-weight: 600;
            text-decoration: none;
            transition: 0.3s;
        }

        .btn-cart:hover {
            background: #065f46;
            color: white;
        }

        /* 🌿 Container for main body */
        .content {
            padding: 40px 80px;
        }

        @media (max-width: 768px) {
            header {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }
            nav ul {
                flex-direction: column;
                gap: 10px;
            }
            .content {
                padding: 20px;
            }
        }
    </style>
</head>
<body>

<header>
    <div class="logo">🍃 <span>VieMood</span> | Healthy Living</div>

    <nav>
        <ul>
            <li><a href="<%= request.getContextPath() %>/home">Trang chủ</a></li>
            <li><a href="<%= request.getContextPath() %>/cart.jsp">Giỏ hàng</a></li>
            <li><a href="<%= request.getContextPath() %>/checkout.jsp">Thanh toán</a></li>
            <li><a href="<%= request.getContextPath() %>/about.jsp">Về VieMood</a></li>
        </ul>
    </nav>

    <a href="<%= request.getContextPath() %>/cart.jsp" class="btn-cart">🛒 Xem giỏ</a>
</header>

<div class="content">
