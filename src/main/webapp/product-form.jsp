<%@ page import="model.Product" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    Product p = (Product) request.getAttribute("product");
    boolean editing = (p != null);
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><%= editing ? "Chỉnh sửa sản phẩm" : "Thêm sản phẩm mới" %></title>
    <style>
        body { font-family: Arial; background-color: #f4f6f8; display: flex; justify-content: center; align-items: center; height: 100vh; }
        form { background: white; padding: 30px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.2); width: 400px; }
        h2 { text-align: center; color: #007bff; margin-bottom: 25px; }
        label { display: block; margin-bottom: 5px; font-weight: bold; }
        input, textarea { width: 100%; padding: 10px; margin-bottom: 15px; border: 1px solid #ccc; border-radius: 6px; }
        button { width: 100%; padding: 10px; background-color: #007bff; color: white; border: none; border-radius: 6px; cursor: pointer; }
        button:hover { background-color: #0056b3; }
        a { display: block; margin-top: 15px; text-align: center; color: #007bff; text-decoration: none; }
    </style>
</head>
<body>
<form action="products" method="post" enctype="multipart/form-data">
    <h2><%= editing ? "Chỉnh sửa sản phẩm" : "Thêm sản phẩm mới" %></h2>
    <% if (editing) { %>
        <input type="hidden" name="id" value="<%= p.getId() %>">
    <% } %>

    <label>Tên sản phẩm:</label>
    <input type="text" name="name" value="<%= editing ? p.getName() : "" %>" required>

    <label>Mô tả:</label>
    <textarea name="description" required><%= editing ? p.getDescription() : "" %></textarea>

    <label>Giá (VNĐ):</label>
    <input type="number" step="1000" name="price" value="<%= editing ? p.getPrice() : "" %>" required>

    <label>Ảnh sản phẩm:</label>
    <input type="file" name="imageFile" accept="image/*" <%= editing ? "" : "required" %> >
    <% if (editing && p.getImageURL() != null) { %>
        <img src="<%= request.getContextPath() + "/" + p.getImageURL() %>" width="100" style="margin-top:10px;">
    <% } %>

    <button type="submit"><%= editing ? "Cập nhật sản phẩm" : "Thêm sản phẩm" %></button>
    <a href="products">⬅ Quay lại danh sách</a>
</form>
</body>
</html>
