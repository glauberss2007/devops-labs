# devops labs

## Vagrant lab

1. Install Vagrant on your machine.
2. Create a Vagrantfile to define your development environment.
3. Use Vagrant commands to manage and interact with your virtualized environment.

## Git 

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

## Architecture - Ansible Playbooks

![image](https://github.com/glauberss2007/devops-java-node-redis-mysql/assets/22028539/4150de89-d275-4451-a95a-95773fe3d11b)
  
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
SonarCube (formerly known as SonarQube) is an open-source platform for continuous inspection of code quality.

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

## Jenkins lab

![image](https://github.com/glauberss2007/devops-java-node-redis-mysql/assets/22028539/4f64ebf1-7488-42cf-b2e9-b531c888c953)

```
# Vagrantfile
Vagrant.configure("2") do |config|
  # Specify the base box as CentOS 7
  config.vm.box = "centos/7"
  
  # Set the hostname for the VM as "jenkins"
  config.vm.hostname = "jenkins"
  
  # Forward port 8080 from guest to host
  config.vm.network "forwarded_port", guest: 8080, host: 8080, host_ip: "127.0.0.1"
  
  # Provision the VM using a shell script named "provision.sh"
  config.vm.provision "shell", path: "provision.sh"
  
  # Configure memory allocation for the VM as 1024 MB
  config.vm.provider "virtualbox" do |v|
    v.memory = 1024
  end
end
```

```
#!/usr/bin/env bash
# Install Jenkins and its dependencies
echo "Installing Jenkins and dependencies..."
yum install -y java-1.8.0-openjdk

# Add Jenkins repository
curl --silent --location http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo | sudo tee /etc/yum.repos.d/jenkins.repo
sudo rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key

# Install Jenkins
sudo yum install jenkins -y

# Start Jenkins service
sudo systemctl start jenkins
sudo systemctl enable jenkins
```

Access Jenkins at http://localhost:8080

To retrieve the initial admin password, run:
```
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

Install the Plugins for GitHub and Maven.

### Jobs
```
pipeline {
    agent any 
    stages {
        stage("Hello") { 
            steps {
                echo 'Hello World' 
            }
        }
    }
}
```

Description of each step:

- **Pipeline:** This directive is mandatory at the beginning of the script and defines the overall structure of the pipeline.
- **Agent:** Specifies the node where the script will be executed.
- **Stages:** Defines the different stages that the job will go through.
- **Steps:** Contains the individual tasks to be executed within each stage of the pipeline. In this case, it simply prints 'Hello World'.

### ci pipeline with jenkis

![image](https://github.com/glauberss2007/devops-java-node-redis-mysql/assets/22028539/f3e8ed75-472e-4368-ac76-b2f0c965736f)


1. Create a new repository on GitHub named `redis-app`.
2. Create a `Jenkinsfile` at the root of the repository.
3. Create a `Dockerfile` at the root of the repository.
4. Create a `docker-compose.yml` file at the root of the repository.
5. Create a `teste-integracao.sh` script at the root of the repository.
6. Create a Jenkins job.

Teh jenkins file:
```
pipeline {
	agent any // Agent: Servidor que executa o pipeline (master)
	
	stages {
		stage('image build') { // Stage build: comando docker build para gerar imagem Docker
			steps {
				sh 'docker build -t devops/app .' // Build Docker image
			}
		}
		
		stage('Up docker compose - redis and app') { // Stage docker compose: Subir redis e app via docker compose
			steps {
				sh 'docker-compose up --build -d' // Start Redis and app using Docker Compose
			}
		}
		
		stage('Sleep hold until containers up') { // Stage sleep: sleep de 10 segundos para garantir subida do ambiente
			steps {
				sh 'sleep 10' // Wait for 10 seconds to ensure the environment is up
			}
		}
		
		stage('Test the app') { // Stage teste aplicação: executar teste integrado de chamada http
			steps {
				sh 'chmod +x teste-app.sh' // Make teste-app.sh executable
				sh './teste-app.sh' // Run integrated HTTP call test
			}
		}
		
		stage('Shutdown containers for test') { // Stage shutdown containers: Baixar containers via docker compose após o teste
			steps {
				sh 'docker-compose down' // Shut down containers after the test
			}
		}
	}
}
```

## Jenkins with Sonarqube

### Architecture

![image](https://github.com/glauberss2007/devops-java-node-redis-mysql/assets/22028539/d641aa55-1c17-4fb6-a191-15693b458efc)

1. Adjustments in the laboratories:
    1. Configure private network in the Vagrantfile of SonarQube and Jenkins.
        - Jenkins: `config.vm.network "private_network", ip: "192.168.1.5"`
        - SonarQube: `config.vm.network "private_network", ip: "192.168.1.6"`
   
2. Configurations in Jenkins:
    1. Install Sonar Scanner (via provision) on the operating system.
        ```bash
        yum install unzip -y
        wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.6.2.2472-linux.zip
        sudo unzip sonar-scanner-cli-4.6.2.2472-linux.zip -d /opt/
        mv /opt/sonar-scanner-4.6.2.2472-linux /opt/sonar-scanner
        chown -R jenkins:jenkins /opt/sonar-scanner
        echo 'export PATH=$PATH:/opt/sonar-scanner/bin' | sudo tee -a /etc/profile
        ```
    2. Install Sonar Scanner plugin in Jenkins.
    3. Modify Jenkinsfile and add Sonar Scanner invocation step.
    
3. Configurations in Sonar:
    1. Create application profile (if not existent) for `redis-app`.
    2. Create access token - if not yet created.
    3. Configure Custom Quality Gate.

## Multibranch jenkins

To utilize the multibranch Jenkins feature:

1. Create a new branch:
    ```
    git checkout -b new-feature
    ```
2. Add the following line to `teste-integracao.sh`:
    ```
    curl http://localhost:8090/api/notes
    ```
3. Commit your changes.
4. Push the branch to the remote repository:
    ```
    git push origin new-feature
    ```
5. View the job for the new branch in Jenkins.
6. Merge the changes:
    ```
    git checkout master
    git merge new-feature
    git push origin master
    ```

![image](https://github.com/glauberss2007/devops-java-node-redis-mysql/assets/22028539/a69a74d0-b1db-4b64-af45-33fcfb5253ef)

## Jenkins CD on Swarm

Use Case:
- Execute Deployment on Swarm
- Spin up the manager (and optionally, another node)
- Note 1: Change the port forward of the Manager if necessary.
- Note 2: If the lab has been destroyed, it's necessary to initialize the Docker Swarm again:
    - On the manager: `docker swarm init --advertise-addr 192.168.1.2`
    - On worker1: `docker swarm join --token <TOKEN> 192.168.1.2:2377`
- Enable SSH access on the manager:
    - Edit `/etc/ssh/sshd_config` and uncomment the line `PasswordAuthentication yes`
    - Restart the SSH service: `service sshd restart`

Configuration on the server manager:
- Installation of Git and JDK 8
- Permission for the vagrant user to execute Docker: `sudo usermod -aG docker ${USER}`

Configuration on the Jenkins server:
- Log in to the manager as the jenkins user: `sudo -u jenkins -g jenkins ssh -v vagrant@192.168.1.2`
- Configure an agent (manager node): 
    - Navigate to Manage Jenkins -> Managed Nodes and Clouds -> New Node
    - Name: swarm-manager
    - Remote root directory: /home/vagrant
    - Usage: Only build Jobs with label expressions matching this node
    - Launch method: Launch agents via ssh
    - Host: 192.168.1.2
    - Credentials: Add a new credential (vagrant /vagrant)
    - Host Key Verification: No verifying Strategy
    - Save

  Create a new Docker Compose for deployment and add a new stage in Jenkinsfile for deployment to Swarm.

  ![image](https://github.com/glauberss2007/devops-java-node-redis-mysql/assets/22028539/dc200009-760b-4d1b-911a-26e5360cb8b9)


  Validate if the deployment occurred correctly:
     ```
    docker service ls
    ```

- Scale the application to worker1 node:
    ```
    docker service scale app_app=2
    ```
- Validate containers on worker1:
    ```
    docker ps
    ```
## Jenkins with nexus

![image](https://github.com/glauberss2007/devops-labs/assets/22028539/bdd74c52-a625-4f15-a9db-be88d44b5523)

### Create Docker Volume

To create a Docker volume named `nexus-data`, run the following command:

```
docker volume create --name nexus-data
```
### Start the Nexus container

```
docker run -d -p 8091:8081 -p 8123:8123 --name nexus -v nexus-data:/nexus-data sonatype/nexus3
```

## Test image Upload, to nexus registry, via Command Line

Build the Docker image:
```
docker build -t devops/app .
```

Log in to the Nexus registry:
```
docker login localhost:8123
```

Alternatively, you can log in using the command:
```
docker login -u USER -p PASS localhost:8123
```

Tag the Docker image:
```
docker tag devops/app:latest localhost:8123/devops/app
```

Push the Docker image to the Nexus repository:
```
docker push localhost:8123/devops/app
```

## Kubernets

Initiate the machine used to deploy the k3s using the vragrant file.

Install k3s on it:
```
curl -sfL https://get.k3s.io | sh -s - --cluster-init --tls-san 192.168.1.2 --node-ip 192.168.1.2 --nodeexternal-ip 192.168.1.2
```

Execute the shell script "optional" to install kubens and k8s autocomplete tool.

Configure the private registry nexus created previoulsly by editing /etc/rancher/k3s/registries.yaml as bellow:

```
mirrors:
 docker.io:
  endpoint:
   - "http://192.168.1.5:8123"
configs:
 "192.1668.1.5:8123":
  auth:
   username: USER
   password: PASS	
```

Them start the nexus container and deploy the k3s manifests using:
```
kubectl apply -f redis-app.yaml
```

and confirm they are runing using:
```
kubectl get deployments -n devops
kubectl get services -n devops
kubectl get ingresses -n devops
```

## Integrate Jenkins with k8s

Install kubectl on the Jenkins Server

```
curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
```

Configure Jenkins User with Login Permission
```
sudo usermod -s /bin/bash jenkins
sudo su -s /bin/bash Jenkins
```

Add a deployment step for the application on Kubernetes as the last step:
```
stage('Apply Kubernetes files') {
    steps{
        sh '/usr/local/bin/kubectl apply -f ./k3s/redis.yaml'
        sh '/usr/local/bin/kubectl apply -f ./k3s/redis-app.yaml'
    }
}
```

Copy /etc/rancher/k3s/k3s.yaml on the manager server to Jenkins at ~/.kube/config.

Note: Replace localhost with 192.168.1.2.

Create a k3s directory in the application's Git repository.

Create redis.yaml and redis-app.yaml in the k3s directory.

Create the devops namespace and execute the pipeline.

Validate the application.




