<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.mycompany.webexe2.model.Product" %>

<%
if (session.getAttribute("manager") == null) {
    response.sendRedirect("login.jsp");
    return;
}
List<Product> list = (List<Product>) request.getAttribute("products");
Integer currentPageObj = (Integer) request.getAttribute("currentPage");
Integer totalPagesObj = (Integer) request.getAttribute("totalPages");

int currentPage = (currentPageObj != null) ? currentPageObj : 1;
int totalPages = (totalPagesObj != null) ? totalPagesObj : 1;
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Quản lý sản phẩm</title>
        <style>
            body {
                font-family: Arial;
                padding: 30px;
                background: #f4f6f8;
            }
            h2 {
                color: #007bff;
            }
            table {
                border-collapse: collapse;
                width: 100%;
                background: white;
            }
            th, td {
                border: 1px solid #ccc;
                padding: 10px;
                text-align: center;
                vertical-align: middle;
            }
            th {
                background: #007bff;
                color: white;
            }
            a.btn {
                padding: 5px 10px;
                text-decoration: none;
                color: white;
                border-radius: 4px;
            }
            .add {
                background: #28a745;
            }
            .edit {
                background: #ffc107;
                color: black;
            }
            .delete {
                background: #dc3545;
            }
            .pagination {
                text-align: center;
                margin-top: 20px;
            }
            .pagination a {
                display: inline-block;
                padding: 6px 12px;
                margin: 0 3px;
                border: 1px solid #007bff;
                color: #007bff;
                text-decoration: none;
                border-radius: 5px;
            }
            .pagination a.active {
                background-color: #007bff;
                color: white;
            }
            img {
                border-radius: 8px;
                max-height: 80px;
            }
        </style>
    </head>
    <body>
        <h2>Danh sách sản phẩm</h2>
        <a href="products?action=add" class="btn add">+ Thêm sản phẩm</a>
        <br><br>

        <table>
            <tr>
                <th>ID</th><th>Tên sản phẩm</th><th>Mô tả</th><th>Giá (VNĐ)</th><th>Ảnh</th><th>Hành động</th>
            </tr>
            <% if (list != null) {
           for(Product p : list) { %>
            <tr>
                <td><%= p.getId() %></td>
                <td><%= p.getName() %></td>
                <td style="text-align:left;"><%= p.getDescription() %></td>
                <td><%= String.format("%,.0f", p.getPrice()) %></td>
                <td>
                    <% if (p.getImageURL() != null && !p.getImageURL().isEmpty()) { %>
                    <img src="<%= request.getContextPath() + "/" + p.getImageURL() %>" alt="Ảnh sản phẩm">
                    <% } else { %>
                    <span style="color:gray;">(Không có ảnh)</span>
                    <% } %>
                </td>
                <td>
                    <a href="products?action=edit&id=<%= p.getId() %>" class="btn edit">Sửa</a>
                    <a href="products?action=delete&id=<%= p.getId() %>" class="btn delete"
                       onclick="return confirm('Bạn có chắc muốn xóa sản phẩm này?');">Xóa</a>
                </td>
            </tr>
            <%   }
       } else { %>
            <tr><td colspan="6">Không có sản phẩm nào.</td></tr>
            <% } %>
        </table>

        <div class="pagination">
            <% for(int i = 1; i <= totalPages; i++) { %>
            <a href="products?page=<%= i %>" class="<%= (i == currentPage) ? "active" : "" %>"><%= i %></a>
            <% } %>
        </div>

        <br>
        <a href="../admin-dashboard.jsp">⬅ Quay lại Dashboard</a>
    </body>
</html>
