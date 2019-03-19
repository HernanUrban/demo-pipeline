FROM openjdk:8-jdk-alpine
RUN apk --update add curl
VOLUME /tmp
ADD target/demo-pipeline.jar app.jar
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar"]