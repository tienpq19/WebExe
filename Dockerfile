# ====================================================================
# Dockerfile tối ưu cho Java 17 + Maven + Tomcat trên Render
# ====================================================================

# GIAI ĐOẠN 1: BUILD
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app
COPY . .
RUN mvn clean install -DskipTests

# GIAI ĐOẠN 2: CHẠY
FROM tomcat:10.1-jdk17-temurin-jammy

# Xóa các ứng dụng mẫu của Tomcat (tùy chọn, giúp giảm dung lượng)
RUN rm -rf /usr/local/tomcat/webapps/*

WORKDIR /usr/local/tomcat/webapps
COPY --from=build /app/target/*.war ./ROOT.war

# Expose port (Render sẽ tự động map)
EXPOSE 8080

CMD ["catalina.sh", "run"]
