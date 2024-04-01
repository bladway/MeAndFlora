FROM openjdk:22-ea-19-slim-bullseye
ARG JAR_FILE=targer/*.jar
COPY ${JAR_FILE} application.jar
ENTRYPOINT ["java", "-jar", "/application.jar"]