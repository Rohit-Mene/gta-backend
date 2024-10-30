FROM maven AS maven-container

RUN mkdir /usr/src/app
WORKDIR /usr/src/app

COPY pom.xml .
RUN mvn -B -f pom.xml -s /usr/share/maven/ref/settings-docker.xml dependency:resolve
COPY . .
RUN mvn -B -s /usr/share/maven/ref/settings-docker.xml package

FROM openjdk:17-alpine
RUN adduser -Dh /home/gta gta
WORKDIR /app
COPY --from=maven-container /usr/src/app/target/gta-0.0.1-SNAPSHOT.jar .
ENTRYPOINT ["java", "-jar", "/app/gta-0.0.1-SNAPSHOT.jar"]