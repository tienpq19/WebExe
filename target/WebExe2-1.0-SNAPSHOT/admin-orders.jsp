<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.mycompany.webexe2.model.Order" %>

<%
if (session.getAttribute("manager") == null) {
    response.sendRedirect("login.jsp");
    return;
}
List<Order> list = (List<Order>) request.getAttribute("orders");
Integer currentPageObj = (Integer) request.getAttribute("currentPage");
Integer totalPagesObj = (Integer) request.getAttribute("totalPages");
int currentPage = (currentPageObj != null) ? currentPageObj : 1;
int totalPages = (totalPagesObj != null) ? totalPagesObj : 1;
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý đơn hàng</title>
    <style>
        body { font-family: Arial; background: #f4f6f8; padding: 30px; }
        table { width: 100%; border-collapse: collapse; background: white; }
        th, td { border: 1px solid #ccc; padding: 10px; text-align: center; }
        th { background: #007bff; color: white; }
        select { padding: 5px; border-radius: 5px; }
        .update-btn { background: #28a745; color: white; border: none; border-radius: 4px; padding: 5px 10px; cursor: pointer; }
        .view { background: #17a2b8; color: white; padding: 5px 10px; border-radius: 5px; text-decoration: none; }
        .pagination { text-align: center; margin-top: 20px; }
        .pagination a { display: inline-block; padding: 6px 12px; border: 1px solid #007bff; color: #007bff; margin: 0 3px; border-radius: 5px; text-decoration: none; }
        .pagination a.active { background: #007bff; color: white; }
    </style>
</head>
<body>

<h2>Danh sách đơn hàng</h2>

<table>
    <tr>
        <th>ID</th>
        <th>Khách hàng</th>
        <th>SĐT</th>
        <th>Địa chỉ</th>
        <th>Ngày đặt</th>
        <th>Tổng (VNĐ)</th>
        <th>Trạng thái</th>
        <th>Chi tiết</th>
    </tr>
    <% if (list != null && !list.isEmpty()) {
           for (Order o : list) { %>
    <tr>
        <td><%= o.getId() %></td>
        <td><%= o.getCustomerName() %></td>
        <td><%= o.getPhone() %></td>
        <td><%= o.getAddress() %></td>
        <td><%= o.getOrderDate() %></td>
        <td><%= String.format("%,.0f", o.getTotal()) %></td>
        <td>
            <form action="orders" method="get" style="display:flex;gap:5px;justify-content:center;">
                <input type="hidden" name="action" value="updateStatus">
                <input type="hidden" name="id" value="<%= o.getId() %>">
                <select name="status">
                    <option <%= "Đặt đơn thành công".equals(o.getStatus()) ? "selected" : "" %>>Đặt đơn thành công</option>
                    <option <%= "Đang vận chuyển".equals(o.getStatus()) ? "selected" : "" %>>Đang vận chuyển</option>
                    <option <%= "Giao hàng thành công".equals(o.getStatus()) ? "selected" : "" %>>Giao hàng thành công</option>
                    <option <%= "Hoàn thành đơn".equals(o.getStatus()) ? "selected" : "" %>>Hoàn thành đơn</option>
                    <option <%= "Hủy đơn hàng".equals(o.getStatus()) ? "selected" : "" %>>Hủy đơn hàng</option>
                </select>
                <button type="submit" class="update-btn">Cập nhật</button>
            </form>
        </td>
        <td><a href="orders?action=detail&id=<%= o.getId() %>" class="view">Xem</a></td>
    </tr>
    <% } } else { %>
    <tr><td colspan="8">Không có đơn hàng nào.</td></tr>
    <% } %>
</table>

<div class="pagination">
    <% for (int i = 1; i <= totalPages; i++) { %>
        <a href="orders?page=<%= i %>" class="<%= (i == currentPage) ? "active" : "" %>"><%= i %></a>
    <% } %>
</div>

</body>
</html>
