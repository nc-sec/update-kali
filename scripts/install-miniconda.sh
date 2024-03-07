#!/bin/bash

# Function to check if Miniconda is already installed
check_miniconda_installed() {
    if [ -x "$(command -v conda)" ]; then
        echo "Miniconda is already installed."
        conda --version
        return 1
    else
        echo "Miniconda is not installed."
        return 0
    fi
}

# Function to install Miniconda
install_miniconda() {
    echo "Starting Miniconda installation..."

    # Define Miniconda installation script URL for Linux
    MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
    INSTALLER="Miniconda3-latest-Linux-x86_64.sh"

    # Download the latest Miniconda installer
    wget $MINICONDA_URL -O $INSTALLER

    # Run the Miniconda installer
    bash $INSTALLER -b -p $HOME/miniconda

    # Optionally, initialize Miniconda (adjust according to preference)
    # $HOME/miniconda/bin/conda init

    # Clean up installer
    rm $INSTALLER

    echo "Miniconda installation completed."
    echo "Please close and reopen your terminal session or run 'source ~/.bashrc' to use conda."
}

# Main script execution
main() {
    # Check if Miniconda is installed
    check_miniconda_installed

    # Install Miniconda if not installed
    if [ $? -eq 0 ]; then
        install_miniconda
    else
        echo "Skipping Miniconda installation."
    fi
}

# Call the main function
main
