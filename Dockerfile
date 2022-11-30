FROM openjdk:18-jdk-alpine AS gogle
ADD Gogle-Shopping-Cart.tar .
WORKDIR Gogle-Shopping-Cart
RUN chmod +x mvnw
RUN ./mvnw clean install -DskipTests=true

FROM openjdk:18-jdk-alpine
COPY --from=gogle /Gogle-Shopping-Cart/target/SpringShoppingCart2-0.0.1-SNAPSHOT.jar /
CMD ["java", "-jar", "-Dspring.profiles.active=mysql", "/SpringShoppingCart2-0.0.1-SNAPSHOT.jar"]
