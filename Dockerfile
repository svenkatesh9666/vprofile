FROM maven as build
WORKDIR /app
COPY . .
RUN mvn install

FROM openjdk
WORKDIR /app

FROM tomcat:8-jre11
RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=build /app/target/vprofile-v2.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
CMD ["catalina.sh", "run"]
