# ---------- Stage 1: Build ----------
FROM gradle:8.5-jdk17 AS builder

WORKDIR /app

# Copy entire project
COPY . .

# Build ONLY app module (important!)
RUN gradle :app:build -x test

# ---------- Stage 2: Run ----------
FROM eclipse-temurin:17-jdk-alpine

# Create non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

# Copy JAR from app module
COPY --from=builder /app/app/build/libs/*.jar app.jar

# Set permissions
RUN chown -R appuser:appgroup /app

# Switch to non-root user
USER appuser

ENTRYPOINT ["java", "-jar", "app.jar"]