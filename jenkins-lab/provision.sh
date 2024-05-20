#!/bin/bash

# Instala o repositório EPEL
yum install epel-release -y

# Instala wget e git
yum install wget git -y

# Adiciona o repositório do Jenkins e importa a chave GPG
sudo wget --no-check-certificate -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key

# Instala o JDK 11 e o Jenkins
yum install java-11-openjdk-devel -y
yum install jenkins -y

# Recarrega o daemon e inicia o serviço do Jenkins
systemctl daemon-reload
service jenkins start

# Instala o Docker e o Docker Compose
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install docker-ce docker-ce-cli containerd.io -y
sudo systemctl start docker
sudo systemctl enable docker
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
systemctl daemon-reload
systemctl restart docker

# Adiciona o usuário "jenkins" ao grupo "docker"
usermod -aG docker jenkins

# Instala o SonarScanner
yum install wget unzip -y
wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.6.2.2472-linux.zip
unzip sonar-scanner-cli-4.6.2.2472-linux.zip -d /opt/
mv /opt/sonar-scanner-4.6.2.2472-linux /opt/sonar-scanner
chown -R jenkins:jenkins /opt/sonar-scanner
echo 'export PATH=$PATH:/opt/sonar-scanner/bin' | sudo tee -a /etc/profile

# Instala o Node.js
curl -sL https://rpm.nodesource.com/setup_10.x | sudo bash -
sudo yum install nodejs -y
