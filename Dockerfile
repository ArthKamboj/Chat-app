# Step 1: Use Maven to build the app
FROM maven:3.9.4-eclipse-temurin-17 AS builder
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# Step 2: Use a smaller runtime image for deployment
FROM eclipse-temurin:17-jdk-alpine
WORKDIR /app
COPY --from=builder /app/target/Chat-app-0.0.1-SNAPSHOT.jar app.jar

# Optional: reduce JVM memory usage in constrained environments
ENV JAVA_OPTS="-XX:+UseContainerSupport -Xmx512m"

EXPOSE 8080
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]
