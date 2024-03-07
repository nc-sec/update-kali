#!/bin/bash

# Function to check if nvidia-docker2 is installed
check_nvidia_docker_installed() {
    if dpkg -l | grep -qw nvidia-docker2; then
        echo "nvidia-docker2 is already installed."
        return 1
    else
        echo "nvidia-docker2 is not installed."
        return 0
    fi
}

# Function to install nvidia-docker2 and set up repository
install_nvidia_docker() {
    echo "Starting nvidia-docker2 installation..."

    # Setup the nvidia-docker repository
    distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
    curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
    curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

    # Update the APT package index
    sudo apt update

    # Install nvidia-docker2 package
    sudo apt install -y nvidia-docker2

    # Restart Docker service to apply changes
    sudo systemctl restart docker

    echo "nvidia-docker2 installation completed."
}

# Function to test nvidia-docker installation
test_nvidia_docker() {
    echo "Testing nvidia-docker installation..."
    sudo docker run --rm --gpus all nvidia/cuda:11.0-base nvidia-smi
}

# Main script execution
main() {
    # Check if nvidia-docker2 is installed
    check_nvidia_docker_installed

    # Install nvidia-docker2 if not installed
    if [ $? -eq 0 ]; then
        install_nvidia_docker
        test_nvidia_docker
    else
        echo "Skipping nvidia-docker2 installation."
        # Optionally, you can still choose to run the test even if nvidia-docker2 is already installed
        test_nvidia_docker
    fi
}

# Call the main function
main
