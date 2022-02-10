#!/usr/bin/env sh

# This script was written and confirmed on an AWS EC2 Instance running:
# Ubuntu Server 20.04 LTS (HVM)

echo "Updating Linux..."
sudo apt update

echo "Installing Make and Docker..."
sudo sudo apt install -y make docker.io

echo "Installing Docker Compose..."
sudo curl -L https://github.com/docker/compose/releases/download/v2.2.2/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo usermod -aG docker $USER

echo "Rebooting..."
sudo reboot
