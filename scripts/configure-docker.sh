#!/bin/bash

# Function to check if Docker is installed
check_docker_installed() {
    if [ -x "$(command -v docker)" ]; then
        echo "Docker is already installed."
        docker --version
        return 1
    else
        echo "Docker is not installed."
        return 0
    fi
}

# Function to install Docker
install_docker() {
    echo "Starting Docker installation..."
    # Add Docker’s official GPG key
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -

    # Add Docker repository to APT sources
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"

    # Update APT package index
    sudo apt update

    # Install Docker CE
    sudo apt install -y docker-ce docker-ce-cli containerd.io

    # Verify installation
    sudo docker run hello-world
}

# Main script execution
main() {
    # Check if Docker is installed
    check_docker_installed

    # Install Docker if not installed
    if [ $? -eq 0 ]; then
        install_docker
    else
        echo "Skipping Docker installation."
    fi
}

# Call the main function
main
