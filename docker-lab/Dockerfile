# Use OpenJDK 8 on Alpine Linux as base image
FROM openjdk:8-jdk-alpine

# Create a system group and user 'notes' to run the application
RUN addgroup -S notes && adduser -S notes -G notes

# Set environment variables for Maven
ENV MAVEN_VERSION 3.5.4
ENV MAVEN_HOME /usr/lib/mvn
ENV PATH $MAVEN_HOME/bin:$PATH

# Download and install Maven
RUN wget http://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz && \
  tar -zxvf apache-maven-$MAVEN_VERSION-bin.tar.gz && \
  rm apache-maven-$MAVEN_VERSION-bin.tar.gz && \
  mv apache-maven-$MAVEN_VERSION /usr/lib/mvn

# Install git
RUN apk --update add git

# Create a directory for the application
RUN mkdir /opt/note

# Change ownership of the application directory to the 'notes' user
RUN chown -R notes:notes /opt/note

# Switch to the 'notes' user
USER notes:notes

# Set the working directory to the application directory
WORKDIR /opt/note

# Clone the application source code from the repository
RUN git clone https://github.com/callicoder/spring-boot-mysql-rest-api-tutorial.git /opt/note

# Build the application package using Maven, skipping tests
RUN mvn package -Dmaven.test.skip=true

# Define an argument for the JAR file
ARG JAR_FILE=*.jar

# Copy the built JAR file to the application directory
RUN cp ./target/easy-notes-1.0.0.jar /opt/note/easy-note.jar

# Copy the application properties file
COPY application.properties application.properties

# Specify the entrypoint command to run the application
ENTRYPOINT ["java","-jar","/opt/note/easy-note.jar"]
