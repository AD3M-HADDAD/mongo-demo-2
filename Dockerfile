FROM openjdk:17-alpine
WORKDIR /app
COPY target/mongo-demo-0.0.1-SNAPSHOT.jar /app.jar
EXPOSE 8080
ENV NAME World
CMD ["java", "-jar", "app.jar"]
