<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mycompany.webexe2.model.Manager" %>
<%
// Giả định đối tượng Manager có phương thức getFullName()
Manager manager = (Manager) session.getAttribute("manager");
if (manager == null) {
    response.sendRedirect("login.jsp");
    return;
}
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Trang Quản Trị - Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        /* Tùy chỉnh nhỏ để màu nền và căn chỉnh đẹp hơn */
        .dashboard-container {
            max-width: 700px;
        }
        .welcome-card {
            border-left: 5px solid #0d6efd; /* Màu xanh Primary */
        }
    </style>
</head>
<body class="bg-light">

<div class="container py-5">
    <div class="dashboard-container mx-auto">
        <h1 class="text-center mb-5 text-dark">
            <i class="bi bi-speedometer2"></i> Bảng Điều Khiển Quản Trị
        </h1>

        <div class="card shadow-sm mb-4 welcome-card">
            <div class="card-body">
                <h4 class="card-title text-primary">Xin chào, <%= manager.getFullName() %>! 👋</h4>
                <p class="card-text text-muted mb-0">
                    Bạn đã đăng nhập thành công với quyền <span class="badge bg-success fw-bold">Manager</span>.
                </p>
            </div>
        </div>

        <div class="card shadow">
            <div class="card-header bg-white">
                <h5 class="mb-0 text-secondary"><i class="bi bi-gear-fill"></i> Các chức năng chính</h5>
            </div>
            
            <ul class="list-group list-group-flush">
                
                <li class="list-group-item d-flex justify-content-between align-items-center p-3">
                    <span class="fw-bold"><i class="bi bi-box-seam me-2"></i> Quản lý sản phẩm</span>
                    <a href="admin/products" class="btn btn-primary btn-sm">
                        Truy cập <i class="bi bi-chevron-right"></i>
                    </a>
                </li>
                
                <li class="list-group-item d-flex justify-content-between align-items-center p-3">
                    <span class="fw-bold"><i class="bi bi-receipt me-2"></i> Quản lý đơn hàng</span>
                    <a href="admin/orders" class="btn btn-primary btn-sm">
                        Truy cập <i class="bi bi-chevron-right"></i>
                    </a>
                </li>
                
                <li class="list-group-item d-flex justify-content-between align-items-center p-3 text-muted">
                    <span class="fw-bold"><i class="bi bi-people me-2"></i> Quản lý người dùng (Tùy chọn)</span>
                    <button class="btn btn-outline-secondary btn-sm" disabled>Sắp ra mắt</button>
                </li>
            </ul>

            <div class="card-footer text-center bg-light p-3">
                <a href="logout" class="btn btn-danger">
                    <i class="bi bi-box-arrow-right"></i> Đăng xuất
                </a>
            </div>
        </div>

    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>