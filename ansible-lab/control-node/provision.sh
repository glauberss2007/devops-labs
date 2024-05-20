#!/bin/sh

# Install the EPEL repository to get access to additional packages
sudo yum -y install epel-release

# Print message indicating the start of Ansible installation
echo "inicio da instalacao do ansible"

# Install Ansible
sudo yum -y install ansible

# Append host entries to the /etc/hosts file
cat <<EOT >> /etc/hosts
192.168.1.2 control-node  # IP and hostname for control node
192.168.1.3 app01         # IP and hostname for application server
192.168.1.4 db01          # IP and hostname for database server
EOT
