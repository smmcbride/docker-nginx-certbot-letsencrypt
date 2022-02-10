#!/usr/bin/env sh

# This script was written and confirmed on an AWS EC2 Instance running:
# Amazon Linux 2 AMI (HVM) - Kernel 5.10 AMI

echo "Updating Linux..."
sudo yum -y update

echo "Installing Git and Docker..."
sudo yum -y install git docker

echo "Installing Docker Compose..."
sudo curl -L https://github.com/docker/compose/releases/download/v2.2.2/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo chkconfig docker on
sudo usermod -aG docker $USER

echo "Rebooting..."
sudo reboot
