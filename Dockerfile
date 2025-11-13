# ====================================================================
# Dockerfile chuẩn để deploy ứng dụng Java Web (Maven) lên Render
# ====================================================================

# --------------------------------------------------------------------
# GIAI ĐOẠN 1: BUILD ỨNG DỤNG
# - Sử dụng image Maven chính thức (đã có sẵn Java) để build file .war
# - Đặt tên cho giai đoạn này là "build" để có thể tham chiếu sau này
# --------------------------------------------------------------------
FROM maven:3.8-openjdk-11 AS build

# Tạo thư mục làm việc bên trong container
WORKDIR /app

# Sao chép toàn bộ mã nguồn của bạn vào thư mục /app
COPY . .

# Chạy lệnh Maven để build dự án.
# -DskipTests để bỏ qua việc chạy test, giúp build nhanh hơn khi deploy.
RUN mvn clean install -DskipTests

# --------------------------------------------------------------------
# GIAI ĐOẠN 2: CHẠY ỨNG DỤNG
# - Sử dụng một image Tomcat chính thức, nhẹ và đã có sẵn Java.
# - Image này được tối ưu để chạy trong môi trường production.
# --------------------------------------------------------------------
FROM tomcat:9.0-jdk11-corretto-al2

# Đặt thư mục làm việc là thư mục webapps của Tomcat
WORKDIR /usr/local/tomcat/webapps

# Sao chép file .war đã được build ở Giai đoạn 1 vào thư mục webapps.
# --from=build: Chỉ định lấy file từ giai đoạn "build" ở trên.
# /app/target/*.war: Lấy file .war (tên bất kỳ) từ thư mục target.
# ./ROOT.war: Sao chép vào thư mục hiện tại và đổi tên thành ROOT.war.
#             Việc đổi tên thành ROOT.war giúp ứng dụng chạy ngay tại
#             đường dẫn gốc (your-app-name.onrender.com/) thay vì
#             (your-app-name.onrender.com/your-project-name/).
COPY --from=build /app/target/*.war ./ROOT.war

# Lệnh để khởi động server Tomcat.
# Render sẽ tự động gán cổng, nên chúng ta không cần expose cổng 8080.
CMD ["catalina.sh", "run"]
