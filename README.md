# DevOps Labs

This repository contains a series of labs aimed at practicing various DevOps concepts and tools.

## Table of Contents

- [Vagrant Lab](#vagrant-lab)
- [Architecture - Ansible Playbooks](#architecture---ansible-playbooks)
- [Docker Lab](#docker-lab)
- [Sonarqube Lab](#sonarqube-lab)
- [Jenkins Lab](#jenkins-lab)
- [Jenkins with Sonarqube](#jenkins-with-sonarqube)
- [Multibranch Jenkins](#multibranch-jenkins)
- [Jenkins CD on Swarm](#jenkins-cd-on-swarm)
- [Jenkins with Nexus](#jenkins-with-nexus)
- [Kubernetes](#kubernets)
- [Integrate Jenkins with Kubernetes](#integrate-jenkins-with-k8s)
- [Git Strategies](#git-strategies)
- [Monitoring and Observability](#monitoring-and-observability)

## Summary

The DevOps labs cover a wide range of topics including infrastructure provisioning, configuration management, containerization, continuous integration/continuous deployment (CI/CD), code quality analysis, and monitoring.

Each lab provides step-by-step instructions for setting up environments, configuring tools, and performing various tasks related to DevOps practices. Key concepts covered include:

- Using Vagrant to manage virtualized development environments.
- Configuring infrastructure and application components with Ansible Playbooks.
- Containerizing applications using Docker and managing containers.
- Performing code quality analysis using Sonarqube.
- Setting up continuous integration pipelines with Jenkins.
- Integrating Jenkins with Sonarqube and Kubernetes.
- Implementing Git strategies for version control.
- Monitoring and observability using Prometheus and Grafana.

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

The folder and file structure can be founded into ansible-lab repository. Based on the following structure:

### Steps:
1. Navigate to each directory corresponding to the servers.
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

Use the Dockerfile into docker-lab folder in this repository to build the image:
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

Execute the vagrant file, located at sonarqube-lab folder, with the scrip bellow:

**Initial Configuration Parameters**

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

Execute the vagrantfile located at jenkins-lab folder and them access Jenkins at http://localhost:8080

To retrieve the initial admin password, run:
```
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

Install the Plugins for GitHub and Maven.

### Job example
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

### CI pipeline with jenkis

![image](https://github.com/glauberss2007/devops-java-node-redis-mysql/assets/22028539/f3e8ed75-472e-4368-ac76-b2f0c965736f)


1. Create a new repository on GitHub named `redis-app`.
2. Create a `Jenkinsfile` at the root of the repository.
3. Create a `Dockerfile` at the root of the repository.
4. Create a `docker-compose.yml` file at the root of the repository.
5. Create a `teste-integracao.sh` script at the root of the repository.
6. Create a Jenkins job.

The jenkins file is:
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

## Git strategies

### Trunk / Master Workflows (Alone)

![image](https://github.com/glauberss2007/devops-labs/assets/22028539/bbf2202f-4925-4933-8b1b-e7dad9d47534)

### Branch Workflow (Commom on business)

![image](https://github.com/glauberss2007/devops-labs/assets/22028539/d757d14e-ad3f-4379-98bd-d23051fd6e0e)

### Fork Workflow (Opensource projects)

![image](https://github.com/glauberss2007/devops-labs/assets/22028539/ae5253fa-d05e-4389-abe2-2c8f56a4ed5c)

### Git TAG (releases)

Semantic based on MAJOR(caompatibility),MINOR(features),PATCH(bugs).

Generate a tag:
```
git tag -a v1.0.0 -m "Release do novo componente”
```

Send the tag to remote:
```
git push origin v1.0.0
```

### Update jenkins file to use TAGs

Add environment tag:
```
environment { TAG = sh(script: 'git describe --abbrev=0', , returnStdout: true).trim() }
```

Add TAG param to stage build:
```
§ sh 'docker build -t devops/app:${TAG} .'
```

Update the stage of image push to nexus:
```
sh 'docker tag devops/app:${TAG} ${NEXUS_URL}/devops/app:${TAG}'
sh 'docker push ${NEXUS_URL}/devops/app:${TAG}'
```

### Update manifest onjects of k8s

Update image tag on k3s/redis-app.yaml from devops/app:latest to devops/app:TAG.

Add sed comand into k3s deploy stage to replace tags according to environment var:
```
sh "sed -i -e 's#TAG#${TAG}#' ./k3s/redis-app.yaml;"
```

## Monitoring and observability

![image](https://github.com/glauberss2007/devops-labs/assets/22028539/adaf228e-76b3-43af-bada-c8efc1c244d5)

Create VM using Vagrant

Install prometheus using docker
```
docker run –d -p 9090:9090 -v /vagrant/prometheus.yml:/etc/prometheus/prometheus.yml prom/prometheus
```
Start monitor

Install Grafana
```
docker run -d -p 3000:3000 --name grafana grafana/grafana:latest
```
Add prometheus datasource

IMport dashboard

### Stress test
Install epel ``yum install epel-release`` and the stress using the command ``yum install stress``.

Ecevute the command, and check the result in board:
```
stress --cpu 8 --io 4 --vm 2 --vm-bytes 128M --timeout 30s
```

## References

1. [Vagrant Documentation](https://www.vagrantup.com/docs)
2. [Ansible Documentation](https://docs.ansible.com/ansible/latest/index.html)
3. [Docker Documentation](https://docs.docker.com/)
4. [Sonarqube Documentation](https://docs.sonarqube.org/latest/)
5. [Jenkins Documentation](https://www.jenkins.io/doc/)
6. [Kubernetes Documentation](https://kubernetes.io/docs/)
7. [Grafana Documentation](https://grafana.com/docs/)
8. [Prometheus Documentation](https://prometheus.io/docs/)
9. [Git Documentation](https://git-scm.com/doc)
10. [Semantic Versioning Specification](https://semver.org/)
