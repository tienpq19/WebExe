<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.mycompany.webexe2.model.Product" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    List<Product> products = (List<Product>) request.getAttribute("products");
    Integer currentPageObj = (Integer) request.getAttribute("currentPage");
    Integer totalPagesObj = (Integer) request.getAttribute("totalPages");
    int currentPage = (currentPageObj != null) ? currentPageObj : 1;
    int totalPages = (totalPagesObj != null) ? totalPagesObj : 1;
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="header.jsp" %>
    <meta charset="UTF-8">
    <title>🛍 Danh sách sản phẩm</title>

    <style>
        /* BASE & LAYOUT */
        :root {
            --primary-color: #0d6efd;
            --success-color: #198754;
            --danger-color: #dc3545;
            --background-color: #f8f9fa;
            --card-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        body {
            font-family: 'Arial', sans-serif;
            background: var(--background-color);
            margin: 0;
            padding: 0;
        }

        .container {
            width: 90%;
            max-width: 1200px;
            margin: 3rem auto;
        }

        .page-title {
            text-align: center;
            margin-bottom: 2rem;
            color: var(--primary-color);
            font-size: 2.5rem;
        }
        
        .separator {
            border: 0;
            height: 1px;
            background-color: #dee2e6;
            margin-bottom: 3rem;
        }

        .product-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
        }

        .product-card {
            background: white;
            border: 1px solid #e9ecef;
            border-radius: 10px;
            box-shadow: var(--card-shadow);
            overflow: hidden;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            display: flex;
            flex-direction: column;
        }

        .product-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
        }

        .card-body {
            padding: 20px;
            display: flex;
            flex-direction: column;
            flex-grow: 1;
            text-align: center; /* Căn giữa nội dung */
        }

        .product-title {
            font-size: 1.1rem; /* Giảm nhẹ cỡ chữ */
            font-weight: 600;
            margin-bottom: 0.5rem; /* Giảm khoảng cách dưới */
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            cursor: pointer;
        }
        .product-title:hover {
            color: var(--primary-color);
        }


        .price-text {
            color: var(--danger-color);
            font-size: 1.25rem; /* Điều chỉnh cỡ chữ giá */
            font-weight: bold;
            margin-top: auto; /* Đẩy giá và nút xuống cuối */
            margin-bottom: 1.25rem; /* Tăng khoảng cách dưới */
        }

        .btn-add-to-cart {
            background: var(--success-color);
            color: white;
            border: none;
            padding: 10px 15px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 1rem;
            width: 100%;
            transition: background 0.2s ease;
        }
        .btn-add-to-cart:hover {
            background: #146c43;
        }
        
        .alert-warning {
            padding: 15px;
            background-color: #fff3cd;
            border: 1px solid #ffeeba;
            color: #856404;
            text-align: center;
            border-radius: 5px;
            grid-column: 1 / -1;
        }
        
        /* MODAL / POPUP STYLES */
        .modal-overlay {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0,0,0,0.6);
            justify-content: center;
            align-items: center;
        }

        .modal-content {
            background-color: #fefefe;
            margin: auto;
            padding: 20px;
            border: 1px solid #888;
            width: 90%;
            max-width: 850px;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.3);
            position: relative;
            display: grid;
            grid-template-columns: 1fr;
            gap: 1.5rem;
            animation: fadeIn 0.3s;
        }

        @media (min-width: 768px) {
            .modal-content {
                grid-template-columns: 350px 1fr; /* Cột ảnh cố định, cột thông tin co giãn */
            }
        }

        @keyframes fadeIn {
            from {opacity: 0; transform: scale(0.9);}
            to {opacity: 1; transform: scale(1);}
        }

        .modal-close {
            position: absolute;
            top: 10px;
            right: 20px;
            color: #aaa;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
        }
        .modal-close:hover {
            color: black;
        }

        #modal-img {
            width: 100%;
            border-radius: 8px;
        }
        #modal-name {
            font-size: 2rem;
            font-weight: bold;
            margin-bottom: 1rem;
        }
        #modal-price {
            font-size: 1.8rem;
            color: var(--danger-color);
            font-weight: bold;
            margin-bottom: 1.5rem;
        }
        #modal-desc {
            font-size: 0.95rem; /* Giảm kích thước font chữ */
            line-height: 1.6;
            color: #555;
            max-height: 400px; /* Tăng chiều cao tối đa */
            overflow-y: auto;
            padding-right: 10px; /* Thêm khoảng đệm để thanh cuộn không che chữ */
        }

        /* PAGINATION */
        .pagination-container { text-align: center; margin-top: 3rem; display: flex; justify-content: center; }
        .pagination-link { display: inline-block; margin: 0 4px; padding: 8px 15px; border: 1px solid var(--primary-color); color: var(--primary-color); border-radius: 5px; text-decoration: none; transition: background 0.2s, color 0.2s; }
        .pagination-link:hover { background: #e9ecef; }
        .pagination-link.active { background: var(--primary-color); color: white; border-color: var(--primary-color); font-weight: bold; }
        
        .modal-purchase-section {
            grid-column: 1 / -1; /* Chiếm toàn bộ chiều rộng ở hàng thứ 2 */
            padding-top: 1rem;
            border-top: 1px solid #eee;
        }

        @media (min-width: 768px) {
            .modal-content {
                grid-template-columns: 1fr 1.5fr; /* 2 cột trên màn hình lớn */
                grid-template-rows: auto auto; /* 2 hàng */
            }
            .modal-image-section {
                grid-row: 1 / 3; /* Ảnh chiếm cả 2 hàng */
            }
            .modal-info-section {
                grid-row: 1 / 2; /* Thông tin ở hàng 1 */
            }
            .modal-purchase-section {
                grid-column: 2 / 3; /* Phần mua hàng ở cột 2, hàng 2 */
                grid-row: 2 / 3;
                padding-top: 0;
                border-top: none;
            }
        }

        @media (max-width: 767px) {
            .modal-content { grid-template-columns: 1fr; }
            .product-grid { grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); }
        }
        /* --- FORM MUA HÀNG --- */
.modal-purchase-section {
    background-color: #f9f9f9;
    border-radius: 12px;
    padding: 1.5rem;
    box-shadow: 0 3px 10px rgba(0, 0, 0, 0.1);
    margin-top: 1rem;
}

.modal-purchase-section label {
    font-weight: 600;
    color: #333;
    margin-bottom: 0.5rem;
    display: block;
}

/* Nút chọn Nóng / Lạnh */
#drink-option-group .btn {
    border-radius: 30px;
    padding: 0.5rem 1rem;
    transition: all 0.25s ease;
}

#drink-option-group .btn:hover {
    transform: translateY(-2px);
}

#drink-option-group .btn-outline-danger.active,
#drink-option-group .btn-outline-danger:checked,
#option-hot:checked + label {
    background-color: #dc3545;
    color: white;
    border-color: #dc3545;
}

#drink-option-group .btn-outline-primary.active,
#drink-option-group .btn-outline-primary:checked,
#option-cold:checked + label {
    background-color: #0d6efd;
    color: white;
    border-color: #0d6efd;
}

/* Số lượng */
.input-group {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 5px;
}

.input-group button {
    width: 36px;
    height: 36px;
    font-size: 18px;
    border-radius: 50%;
    border: 1px solid #ccc;
    background-color: white;
    cursor: pointer;
    transition: all 0.2s;
}

.input-group button:hover {
    background-color: #f1f1f1;
}

.input-group input {
    width: 70px;
    text-align: center;
    border-radius: 6px;
    border: 1px solid #ccc;
    height: 36px;
}

/* Nút thêm vào giỏ hàng */
.btn.btn-success.btn-lg {
    border-radius: 30px;
    font-size: 1.1rem;
    padding: 12px;
    margin-top: 1rem;
    box-shadow: 0 3px 6px rgba(25, 135, 84, 0.3);
}

.btn.btn-success.btn-lg:hover {
    background-color: #157347;
    transform: translateY(-2px);
}

    </style>
</head>
<body>

<div class="container">
    <h1 class="page-title">🛍 Danh sách sản phẩm 🛒</h1>
    <hr class="separator">

    <div class="product-grid">
    <%
    if (products != null && !products.isEmpty()) {
        for (Product p : products) {
    %>
        <div class="product-card <%= p.isDrink() ? "is-drink" : "" %>"
             data-id="<%= p.getId() %>"
             data-name="<%= p.getName() %>"
             data-price="<%= String.format("%,.0f", p.getPrice()) %> VNĐ"
             data-image="<%= request.getContextPath() + "/" + p.getImageURL() %>"
             data-description="<%= p.getDescription().replace("\"", "&quot;") %>"
             onclick="showProductPopup(this)">
            
            <img src="<%= request.getContextPath() + "/" + p.getImageURL() %>" class="card-img" alt="<%= p.getName() %>">

            <div class="card-body">
                <h5 class="product-title">
                    <%= p.getName() %>
                </h5>

                <p class="price-text"><%= String.format("%,.0f", p.getPrice()) %> VNĐ</p>

                <button class="btn-add-to-cart">Xem chi tiết</button>
            </div>
        </div>
    <%
        }
    } else {
    %>
        <div class="alert-warning">Không có sản phẩm nào. Vui lòng kiểm tra lại.</div>
    <% } %>
    </div>

    <% if (totalPages > 1) { %>
    <div class="pagination-container">
        <nav aria-label="Phân trang sản phẩm">
            <% for (int i = 1; i <= totalPages; i++) { %>
                <a href="home?page=<%= i %>" class="pagination-link <%= (i == currentPage) ? "active" : "" %>">
                    <%= i %>
                </a>
            <% } %>
        </nav>
    </div>
    <% } %>
</div>

<!-- MODAL STRUCTURE -->
<div id="productModal" class="modal-overlay">
    <div class="modal-content">
        <span class="modal-close" onclick="closeProductPopup()">&times;</span>
        <div> <!-- Cột 1 -->
            <div class="modal-image-section">
                <img id="modal-img" src="" alt="Product Image">
            </div>
            <div class="modal-purchase-section">
                 <form action="cart" method="post" class="mt-3">
                    <input type="hidden" name="action" value="add">
                    <input type="hidden" id="modal-product-id" name="id" value="">

                    <div id="drink-option-group" class="mb-3 d-none">
                        <label class="form-label fw-bold">Lựa chọn:</label>
                        <div class="d-grid gap-2 d-sm-flex">
                            <input type="radio" class="btn-check" name="drinkOption" id="option-hot" value="Nong" autocomplete="off">
                            <label class="btn btn-outline-danger w-100" for="option-hot"><i class="bi bi-cup-hot-fill"></i> Nóng</label>

                            <input type="radio" class="btn-check" name="drinkOption" id="option-cold" value="Lanh" autocomplete="off" checked>
                            <label class="btn btn-outline-primary w-100" for="option-cold"><i class="bi bi-snow"></i> Lạnh</label>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="quantity" class="form-label fw-bold">Số lượng:</label>
                        <div class="input-group">
                            <button class="btn btn-outline-secondary" type="button" onclick="changeQuantity(-1)">-</button>
                            <input type="number" class="form-control text-center" id="quantity" name="quantity" value="1" min="1" max="20">
                            <button class="btn btn-outline-secondary" type="button" onclick="changeQuantity(1)">+</button>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-success btn-lg w-100">
                        <i class="bi bi-cart-plus-fill"></i> Thêm vào giỏ hàng
                    </button>
                </form>
            </div>
        </div>
        <div> <!-- Cột 2 -->
            <div class="modal-info-section d-flex flex-column h-100">
                <h2 id="modal-name"></h2>
                <p id="modal-price"></p>
                <div id="modal-desc" class="flex-grow-1" style="overflow-y: auto; max-height: 450px;"></div>
            </div>
        </div>
    </div>
</div>

<%@ include file="footer.jsp" %>

<script>
    const modal = document.getElementById('productModal');

    function showProductPopup(cardElement) {
        // Lấy dữ liệu từ thuộc tính data-*
        const id = cardElement.dataset.id;
        const name = cardElement.dataset.name;
        const price = cardElement.dataset.price;
        const image = cardElement.dataset.image;
        const description = cardElement.dataset.description;
        // KIỂM TRA BẰNG CLASS CSS
        const isDrink = cardElement.classList.contains('is-drink');
         console.log(isDrink);
        // Điền dữ liệu vào modal
        document.getElementById('modal-product-id').value = id;
        document.getElementById('modal-name').textContent = name;
        document.getElementById('modal-price').textContent = price;
        document.getElementById('modal-img').src = image;
        document.getElementById('modal-desc').innerHTML = description; // Dùng innerHTML để render HTML

        // Xử lý hiển thị lựa chọn đồ uống
        const drinkOptionGroup = document.getElementById('drink-option-group');
        
        // 1. Luôn reset về trạng thái ẩn mặc định
        drinkOptionGroup.classList.add('d-none');
        
        // 2. Chỉ hiện ra nếu là đồ uống
        if (isDrink) {
              console.log("hiện");
            drinkOptionGroup.classList.remove('d-none');
        } 

        // Hiển thị modal
        modal.style.display = 'flex';
    }

    function closeProductPopup() {
        modal.style.display = 'none';
    }

    // Đóng modal khi click ra ngoài
    window.onclick = function(event) {
        if (event.target === modal) {
            closeProductPopup();
        }
    }

    function changeQuantity(amount) {
        const quantityInput = document.getElementById('quantity');
        let currentValue = parseInt(quantityInput.value);
        currentValue += amount;
        if (currentValue < 1) currentValue = 1;
        if (currentValue > 20) currentValue = 20;
        quantityInput.value = currentValue;
    }
</script>

</body>
</html>