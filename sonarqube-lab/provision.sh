#!/usr/bin/bash

# Cria um usuário 'sonar'
useradd sonar

# Instala wget, unzip e JDK 11
yum install wget unzip java-11-openjdk-devel -y

# Baixa e extrai o arquivo zip do SonarQube
wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.1.0.47736.zip
unzip sonarqube-9.1.0.47736.zip -d /opt/
mv /opt/sonarqube-9.1.0.47736 /opt/sonarqube

# Define as permissões do diretório do SonarQube para o usuário 'sonar'
chown -R sonar:sonar /opt/sonarqube

# Cria o arquivo de serviço do systemd para o SonarQube
cat <<EOT >> /etc/systemd/system/sonar.service
[Unit]
Description=Sonarqube service
After=syslog.target network.target

[Service]
Type=forking
ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop
User=sonar
Group=sonar
Restart=always

[Install]
WantedBy=multi-user.target
EOT

# Inicia o serviço do SonarQube
systemctl start sonar

# Baixa e extrai o arquivo zip do SonarScanner
wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.6.2.2472-linux.zip
unzip sonar-scanner-cli-4.6.2.2472-linux.zip -d /opt/
mv /opt/sonar-scanner-cli-4.6.2.2472-linux /opt/sonar-scanner

# Define as permissões do diretório do SonarScanner para o usuário 'sonar'
chown -R sonar:sonar /opt/sonar-scanner

# Configura o PATH para o SonarScanner
echo 'export PATH=$PATH:/opt/sonar-scanner/bin' | sudo tee -a /etc/profile

# Instala o Node.js
curl -sL https://rpm.nodesource.com/setup_10.x | sudo bash -
sudo yum install nodejs -y
