#!/usr/bin/env bash

# Displaying message indicating the beginning of the installation process
echo "Installing Apache and others..."

# Update package repositories
sudo yum update -y

# Install Apache web server
sudo yum install -y httpd

# Copy files from /home/vagrant/data_guest/ to /var/www/html
sudo cp -R /home/vagrant/data_guest/* /var/www/html

# Ensure proper ownership of copied files
sudo chown -R apache:apache /var/www/html

# Start Apache service
service httpd start
