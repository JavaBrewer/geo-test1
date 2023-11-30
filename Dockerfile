# Use the official OpenJDK base image
FROM openjdk:17

# Set the working directory in the container
WORKDIR /app

# Copy the application JAR file into the container
COPY build/libs/*.jar app.jar

# Specify the command to run on container start
CMD ["java", "-jar", "app.jar"]
