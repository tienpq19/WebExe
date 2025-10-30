package com.mycompany.webexe2.util;

import java.util.Properties;
import jakarta.mail.*;
import jakarta.mail.internet.*;

public class EmailService {

    public static void sendOrderNotification(String adminEmail, String orderDetails) {
        // THÔNG TIN CẤU HÌNH - BẠN CẦN THAY ĐỔI CHO PHÙ HỢP
        final String fromEmail = "quangtienhoihop@gmail.com"; // <-- THAY ĐỔI: Email của bạn
        final String password = "xdan xzoj ydqb wdfc";    // <-- THAY ĐỔI: Mật khẩu ứng dụng Google

        // Cấu hình thuộc tính cho SMTP server của Gmail
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com"); // SMTP Host
        props.put("mail.smtp.port", "587"); // TLS Port
        props.put("mail.debug", "true");
        props.put("mail.smtp.auth", "true"); // Bật xác thực
        props.put("mail.smtp.starttls.enable", "true"); // Bật STARTTLS

        // Tạo session với authenticator
        Authenticator auth = new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(fromEmail, password);
            }
        };
        Session session = Session.getInstance(props, auth);

        try {
              Transport transport = session.getTransport("smtp");
            System.out.println("🔗 Đang thử kết nối tới Gmail SMTP...");
            transport.connect();
            System.out.println("✅ Kết nối SMTP thành công!");
            transport.close();
            // Tạo đối tượng MimeMessage
            MimeMessage msg = new MimeMessage(session);
            // Thiết lập người gửi
            msg.setFrom(new InternetAddress(fromEmail));
            // Thiết lập người nhận
            msg.addRecipient(Message.RecipientType.TO, new InternetAddress(adminEmail));
            // Thiết lập tiêu đề
            msg.setSubject("[WebEXE] Thông báo có đơn hàng mới!");
            // Thiết lập nội dung email (hỗ trợ HTML)
            msg.setContent(orderDetails, "text/html; charset=UTF-8");

            System.out.println("Đang gửi email thông báo...");
            // Gửi email
            Transport.send(msg);
            System.out.println("✅ Email đã được gửi thành công!");

        } catch (MessagingException e) {
            e.printStackTrace();
            System.err.println("Lỗi khi gửi email: " + e.getMessage());
        }
    }   
    // Hàm main để test nhanh
    public static void main(String[] args) {
        String recipient = "recipient-email@example.com"; // <-- THAY ĐỔI: Email người nhận để test
        String orderInfo = "<h1>Có đơn hàng mới!</h1>"
                         + "<p><b>Mã đơn:</b> #12345</p>"
                         + "<p><b>Khách hàng:</b> Nguyễn Văn A</p>"
                         + "<p><b>Tổng tiền:</b> 500,000 VNĐ</p>"
                         + "<p>Vui lòng kiểm tra trang quản trị để xử lý.</p>";
        
        // Nhớ thay đổi email và mật khẩu ứng dụng ở trên trước khi chạy
        sendOrderNotification(recipient, orderInfo);
    }
}
