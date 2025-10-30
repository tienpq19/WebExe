<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <title>🔒 Đăng nhập quản lý</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        
        <style>
            /* CSS Variables để dễ dàng quản lý màu sắc */
            :root {
                --primary-color: #0d6efd; /* Màu xanh dương chủ đạo */
                --background-color: #f0f2f5; /* Màu nền nhẹ nhàng */
                --shadow-color: rgba(0, 0, 0, 0.15);
                --error-color: #dc3545;
            }

            /* BASE & LAYOUT */
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background-color: var(--background-color);
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
                margin: 0;
            }

            /* LOGIN BOX (Thay thế Card) */
            .login-box {
                background: white;
                padding: 40px;
                border-radius: 12px;
                box-shadow: 0 8px 25px var(--shadow-color); /* Shadow sâu hơn */
                width: 100%;
                max-width: 380px;
                text-align: center;
                transition: transform 0.3s ease;
            }
            .login-box:hover {
                 transform: translateY(-3px); /* Hiệu ứng nâng nhẹ khi hover */
            }

            /* HEADER */
            .header {
                margin-bottom: 30px;
            }
            .header h3 {
                color: #333;
                font-weight: 600;
                margin-top: 10px;
            }
            .header p {
                color: #6c757d;
                font-size: 0.9rem;
            }
            .icon-lock {
                font-size: 3rem;
                color: var(--primary-color);
                /* Giả định sử dụng icon, nếu không có, có thể thay bằng chữ */
            }

            /* FORM ELEMENTS (Thay thế Form Control) */
            .input-group {
                display: flex;
                margin-bottom: 20px;
                border: 1px solid #ced4da;
                border-radius: 6px;
                overflow: hidden; /* Cắt góc bo cho input group */
            }
            
            .input-icon {
                background-color: #e9ecef;
                color: #495057;
                padding: 10px 12px;
                display: flex;
                align-items: center;
                font-size: 1.2rem; /* Giả định dùng ký tự thay icon */
            }

            .login-box input[type="text"],
            .login-box input[type="password"] {
                flex-grow: 1; /* Chiếm hết phần còn lại của input-group */
                padding: 12px;
                border: none;
                outline: none;
                font-size: 1rem;
            }
            
            .login-box input:focus {
                border-color: var(--primary-color);
                box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.25);
            }

            /* BUTTON (Thay thế btn) */
            .btn-submit {
                background-color: var(--primary-color);
                color: white;
                border: none;
                padding: 12px 20px;
                border-radius: 6px;
                cursor: pointer;
                width: 100%;
                font-size: 1.1rem;
                font-weight: 600;
                transition: background-color 0.2s ease, box-shadow 0.2s ease;
            }
            
            .btn-submit:hover {
                background-color: #0b5ed7;
                box-shadow: 0 4px 10px rgba(13, 110, 253, 0.4);
            }
            
            /* ERROR MESSAGE */
            .error-message {
                color: white;
                background-color: var(--error-color);
                padding: 10px;
                border-radius: 6px;
                margin-top: 20px;
                font-size: 0.95rem;
                font-weight: 500;
            }
        </style>
    </head>
    <body>
        
        <div class="login-box">
            
            <div class="header">
                <span class="icon-lock">🔒</span> 
                <h3>Đăng nhập Quản trị</h3>
                <p>Truy cập hệ thống quản lý nội bộ</p>
            </div>

            <% if (request.getAttribute("error") != null) { %>
            <p class="error-message"><%= request.getAttribute("error") %></p>
            <% } %>

            <form action="login" method="post">
                <div class="input-group">
                    <span class="input-icon">👤</span> 
                    <input type="text" name="username" placeholder="Tên đăng nhập" required>
                </div>
                
                <div class="input-group">
                    <span class="input-icon">🔑</span> 
                    <input type="password" name="password" placeholder="Mật khẩu" required>
                </div>
                
                <button type="submit" class="btn-submit">Đăng nhập</button>
            </form>
            
        </div>
        
    </body>
</html>