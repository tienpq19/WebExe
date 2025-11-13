# Giai đoạn 1: Build ứng dụng Java bằng Maven
# Sử dụng một ảnh (image) Maven chính thức để build file .war
FROM maven:3.8.5-openjdk-11 AS build
WORKDIR /app
COPY . .
RUN mvn clean install -DskipTests

# Giai đoạn 2: Chạy ứng dụng trên server Tomcat
# Sử dụng một ảnh Tomcat chính thức đã có sẵn Java
FROM tomcat:9.0-jdk11-corretto-al2
WORKDIR /usr/local/tomcat/webapps

# Copy file .war đã được build ở giai đoạn 1 vào thư mục webapps của Tomcat
# Đổi tên thành ROOT.war để ứng dụng chạy ngay tại trang chủ (/)
COPY --from=build /app/target/*.war ./ROOT.war

# Cổng mặc định của Tomcat là 8080, không cần EXPOSE vì Render tự quản lý cổng
CMD ["catalina.sh", "run"]
