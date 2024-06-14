#!/bin/bash
# Install tutor

# Update package information
sudo apt update

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if python3 is installed
if command_exists python3; then
    echo "Python 3 is already installed."
else
    echo "Python 3 is not installed. Installing Python 3..."
    sudo apt update
    sudo apt install -y python3
fi

# Check if pip3 is installed
if command_exists pip3; then
    echo "pip3 is already installed."
else
    echo "pip3 is not installed. Installing pip3..."
    sudo apt update
    sudo apt install -y python3-pip
fi

# Install Tutor using pip
sudo curl -L "https://github.com/overhangio/tutor/releases/download/v16.1.1/tutor-$(uname -s)_$(uname -m)" -o /usr/local/bin/tutor

sudo chmod 0755 /usr/local/bin/tutor

# Verify Tutor installation
tutor --version

# Install docker

# Install prerequisites
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

# Add Docker’s official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add Docker's APT repository
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package database again with Docker packages
sudo apt update

# Install Docker
sudo apt install -y docker-ce

# Enable Docker to start on boot
sudo systemctl enable docker

# Start Docker
sudo systemctl start docker

# Add the current user to the Docker group
sudo usermod -aG docker $USER

# Verify Docker installation
docker --version

echo "Please log out and log back in so that your group membership is re-evaluated."
