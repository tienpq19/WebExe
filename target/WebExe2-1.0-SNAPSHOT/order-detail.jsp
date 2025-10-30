<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.mycompany.webexe2.model.Order, com.mycompany.webexe2.model.OrderDetail, java.text.SimpleDateFormat" %>
<%
Order o = (Order) request.getAttribute("order");
if (o == null) {
    response.sendRedirect("orders");
    return;
}
SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết đơn hàng</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f4f6f8;
            padding: 40px;
            color: #333;
        }
        h2 {
            color: #007bff;
            margin-bottom: 15px;
        }
        .info {
            background: white;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 25px;
            box-shadow: 0 1px 5px rgba(0,0,0,0.1);
        }
        .info p {
            margin: 5px 0;
            line-height: 1.5;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 1px 5px rgba(0,0,0,0.1);
        }
        th, td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: center;
            vertical-align: middle;
        }
        th {
            background-color: #007bff;
            color: white;
            font-weight: bold;
        }
        img {
            width: 70px;
            height: auto;
            border-radius: 6px;
        }
        a.back {
            display: inline-block;
            margin-top: 20px;
            padding: 8px 14px;
            background-color: #007bff;
            color: white;
            border-radius: 5px;
            text-decoration: none;
        }
        a.back:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>

<h2>Chi tiết đơn hàng #<%= o.getId() %></h2>

<div class="info">
    <p><b>Khách hàng:</b> <%= o.getCustomerName() %></p>
    <p><b>SĐT:</b> <%= o.getPhone() %></p>
    <p><b>Địa chỉ:</b> <%= o.getAddress() %></p>
    <p><b>Ngày đặt:</b> <%= (o.getOrderDate() != null ? sdf.format(o.getOrderDate()) : "Không xác định") %></p>
    <p><b>Tổng tiền:</b> <%= String.format("%,.0f", o.getTotal()) %> VNĐ</p>
    <p><b>Trạng thái:</b> <%= o.getStatus() %></p>
</div>

<table>
    <tr>
        <th>ID</th>
        <th>Sản phẩm</th>
        <th>Ảnh</th>
        <th>Số lượng</th>
        <th>Giá (VNĐ)</th>
        <th>Thành tiền (VNĐ)</th>
    </tr>
    <% 
    if (o.getDetails() != null && !o.getDetails().isEmpty()) {
        for (OrderDetail d : o.getDetails()) { 
    %>
    <tr>
        <td><%= d.getId() %></td>
        <td><%= d.getProduct().getName() %></td>
        <td><img src="<%= request.getContextPath() + "/" + d.getProduct().getImageURL() %>" alt="Ảnh sản phẩm"></td>
        <td><%= d.getQuantity() %></td>
        <td><%= String.format("%,.0f", d.getPrice()) %></td>
        <td><%= String.format("%,.0f", d.getPrice() * d.getQuantity()) %></td>
    </tr>
    <% 
        }
    } else { 
    %>
    <tr><td colspan="6">Không có sản phẩm trong đơn hàng này.</td></tr>
    <% } %>
</table>

<a href="orders" class="back">⬅ Quay lại danh sách đơn hàng</a>

</body>
</html>
