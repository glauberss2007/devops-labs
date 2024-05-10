# devops labs
![image](https://github.com/glauberss2007/devops-java-node-redis-mysql/assets/22028539/e3cb9b54-45c7-4fc9-bd36-ec25becc3dfd)

## Vagrant lab
Vagrant is an open-source tool for building and managing virtualized development environments. It simplifies the process of creating reproducible, portable, and shareable development environments.

### Key Features:

- **Environment Management:** Define development environments using a simple text file called a "Vagrantfile."
- **Provisioning:** Automate the setup and configuration of environments, including operating systems, software packages, and networking settings.
- **Portability:** Share Vagrantfiles to ensure consistent environments across different machines and team members.
- **Integration:** Works with various virtualization providers such as VirtualBox, VMware, Hyper-V, and others.
- **Productivity:** Streamline development workflows by removing the complexities of manual environment setup.

### Getting Started:

1. Install Vagrant on your machine.
2. Create a Vagrantfile to define your development environment.
3. Use Vagrant commands to manage and interact with your virtualized environment.

## Git 
### Git: Summary of Key Commands

- **Create a Repository (GitHub):**Create a new repository on GitHub to store your project.
- **Install Git on Your Local Machine:** Install Git on your local machine to start using the version control system.
- **Initialize a Local Repository:** Use the `git init` command to initialize a new repository locally or `git clone` to clone an existing repository.
- **Add Remote Origin:** Execute the `git remote add origin` command followed by the URL of the remote repository on GitHub to add a remote origin.
- **Retrieve Remote Data:** Use `git pull` to retrieve remote data and incorporate it into your local repository.
- **Add Files to the Repository:** Use `git add` to stage files for commit and add them to the repository.
- **Commit Changes:** Commit changes using `git commit` to save staged changes to the repository.
- **Upload Local Changes:** Upload local changes to the remote repository using `git push`.
- **Check Repository Status:** Verify the status of the repository using `git status` to see what is in the staging area or already committed.

## Ansible lab
Ansible is an open-source automation platform designed for simplifying IT orchestration, configuration management, and application deployment tasks.

### Key Features:

- **Agentless:** No need to install agents on managed nodes, operates over SSH.
- **Declarative Syntax:** Uses human-readable YAML-based playbooks for defining tasks and configurations.
- **Idempotent Execution:** Ensures consistent results regardless of initial system state.
- **Inventory Management:** Dynamically manages hosts and groups for scalability.
- **Modules:** Offers a wide range of built-in modules and supports custom module development.
- **Roles:** Organizes and reuses sets of tasks, promoting code modularity and maintainability.
- **Integration:** Seamlessly integrates with version control systems, CI tools, and cloud platforms.

![image](https://github.com/glauberss2007/devops-java-node-redis-mysql/assets/22028539/4150de89-d275-4451-a95a-95773fe3d11b)

## Architecture - Ansible Playbooks
  
### APP01:
- **Components:**
  - Java (OpenJDK)
  - Notes App (REST)
  - Maven

### DB01:
- **Components:**
  - MySQL

### Configuration Tasks for All Hosts:
- Setup of a private network
- Configuration of hostnames

### Additional Configuration for app01:
- Port forwarding for application on port 8080
- Port forwarding for database on port 3306

The folder and file structure can be founded into this repository. Based on the following structure:

![image](https://github.com/glauberss2007/devops-java-node-redis-mysql/assets/22028539/eb874f90-2fad-4848-9f8d-5bffdf0010e2)

### Steps:
1. Navigate to each directory corresponding to the server.
2. Execute `vagrant init` in each directory.

## Docker lab

Docker is a platform designed to make it easier to create, deploy, and run applications using containers. Containers allow a developer to package up an application with all of its dependencies, such as libraries and other components, and ship it all out as one package. This ensures that the application will run consistently across various computing environments.

### Steps
The objective is to set up a server environment using Vagrant (docker-lab), install Docker within this environment using the provided provision.sh script, utilize two Docker images - one for the database and another for the application, expose ports 8080 and 3306 for the application and database respectively, and establish a connection between a Java service (notes) and the database.

### Setting Up Internal Network and MariaDB Container

To accomplish this task, follow these steps:

- Run the following command to create an internal network named `devops`:
     ```
     docker network create devops
     ```
- Create the directory `/root/docker/mariadb/datadir` on your host machine. This directory will serve as the persistent data storage for MariaDB.

- Launch a MariaDB container named `mariadb` with the following command:
     ```
     docker run --net devops --name mariadb -v /root/docker/mariadb/datadir:/var/lib/mysql -e MARIADB_ROOT_PASSWORD=devopsmaonamassa -e MARIADB_DATABASE=notes -d mariadb:latest
     ```
     This command creates a container named `mariadb` connected to the `devops` network, mounts the `/root/docker/mariadb/datadir` directory on the host to `/var/lib/mysql` in the container for persistent data storage, sets the root password to `devopsmaonamassa`, and creates a database named `notes`.

- To access the MariaDB container, run the following command:
     ```
     docker exec -it mariadb /bin/bash
     ```
- Once inside the container, connect to the MariaDB server using the following command:
     ```
     mysql -uroot -pdevopsmaonamassa
     ```
- After logging in, you can verify that the `notes` database has been created by running the following commands:
     ```
     show databases;
     use notes;
     show tables;
     ```
- This ensures that the MariaDB container is properly set up and the `notes` database is available for use.

### Dockerizing Notes Application with OpenJDK

Create a Dockerfile with the following content:

```Dockerfile
FROM openjdk:8-jdk-alpine
RUN addgroup -S notes && adduser -S notes -G notes
USER notes:notes
ARG JAR_FILE=*.jar
COPY ${JAR_FILE} easy-note.jar
COPY application.properties application.properties
ENTRYPOINT ["java","-jar","/easy-note.jar"]
```

Build the image:

```
docker build -t devops/notes-docker .
```

Start the container

```
docker run --network devops --hostname app -p 8080:8080 -d devops/notes-docker
```

## Sonarqube lab
SonarCube (formerly known as SonarQube) is an open-source platform for continuous inspection of code quality. It's designed to analyze and measure code quality, security vulnerabilities, and code smells in various programming languages. SonarCube provides detailed reports and insights to help developers and teams identify and address issues early in the development process.

### Lab arquitecture

![image](https://github.com/glauberss2007/devops-java-node-redis-mysql/assets/22028539/68e7d18a-fac0-4fe6-88a3-e27d473b9a48)

- **Database Server**: This server hosts the database used by the application for storing data.
- **Web Application**: This component consists of dashboards and reports accessible via the web interface.
- **Compute Engine**: Responsible for processing the code analysis tasks.
- **Search Server (ELK)**: This server hosts the ELK stack (Elasticsearch, Logstash, Kibana) for log management and analysis.

### Instalation using vagrant and shell script

1. Execute the vagrant file with the scrip bellow:

Vagrantfile
```
Vagrant.configure("2") do |config|
  # Specify the base box for the VM
  config.vm.box = "centos/7" 
  # Set the hostname for the VM
  config.vm.hostname = "sonarqube"
  # Forward port 9000 from the guest to port 9000 on the host
  config.vm.network "forwarded_port", guest: 9000, host: 9000, host_ip: "127.0.0.1"
  # Provision the VM using a shell script
  config.vm.provision "shell", path: "provision.sh"
  # Configure VirtualBox provider settings
  config.vm.provider "virtualbox" do |v|
    # Set the amount of memory for the VM
    v.memory = 1024
  end
end
```

provsion.sh
```
#!/usr/bin/bash
# Create a new user for SonarQube
useradd sonar

# Install required packages
yum install wget unzip java-11-openjdk-devel -y

# Download and extract SonarQube
wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.1.0.47736.zip
unzip sonarqube-9.1.0.47736.zip -d /opt/
mv /opt/sonarqube-9.1.0.47736 /opt/sonarqube
chown -R sonar:sonar /opt/sonarqube

# Download and extract SonarScanner
wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.6.2.2472-linux.zip
unzip sonar-scanner-cli-4.6.2.2472-linux.zip -d /opt/sonar-scanner
chown -R sonar:sonar /opt/sonar-scanner
```

### Initial config and analyses run
**Initial Configuration**

1. Initial Password: admin / admin
2. Reset Default Password
3. Manually Create Project
4. Create redis-appSonarqube Project - Configure First Project
5. Analyze Locally
6. Name Token
7. Copy Token

**Runing sonar scanner**

Copy the `redis-app` application to the server:
1. Run `vagrant upload redis-app`.

Execute SonarScanner:
2. Run the following command using the login information:

```
sonar-scanner -Dsonar.projectKey=redis-app -Dsonar.sources=. -Dsonar.host.url=http://localhost:9000 -Dsonar.login=##
```






