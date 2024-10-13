#!/bin/bash

# Update the package index
sudo apt-get update -y

# Install prerequisites for Docker
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release -y

# Add Docker's official GPG key
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Set up the stable Docker repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update the package index again
sudo apt-get update -y

# Install Docker Engine
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# Start Docker and enable it to start on boot
sudo systemctl start docker
sudo systemctl enable docker

# Add the ubuntu user to the Docker group so it can run docker commands without sudo
sudo usermod -aG docker ubuntu

# Pull the Docker image for the FastAPI app
sudo docker pull bohuang910407/app:latest

# Run the FastAPI app container
sudo docker run -d --name fastapi-app -p 80:8000 bohuang910407/app:latest