#!/bin/bash

curl -s https://raw.githubusercontent.com/CryptoBureau01/logo/main/logo.sh | bash
sleep 5

# Function to print info messages
print_info() {
    echo -e "\e[32m[INFO] $1\e[0m"
}

# Function to print error messages
print_error() {
    echo -e "\e[31m[ERROR] $1\e[0m"
}


install_dependency() {
    print_info "<=========== Install Dependency ==============>"
    print_info "Updating and upgrading system packages, and installing required tools..."

    # Update the system and install essential packages
    sudo apt update && sudo apt upgrade -y
    sudo apt install curl wget tar jq git 

    # Check if Docker is already installed
    if ! command -v docker &> /dev/null; then
        print_info "Docker is not installed. Installing Docker..."
        
        # Install Docker
        sudo apt install -y docker.io
        
        # Enable and start the Docker service
        sudo systemctl enable docker
        sudo systemctl start docker

        # Check for installation errors
        if [ $? -ne 0 ]; then
            print_error "Failed to install Docker. Please check your system for issues."
            exit 1
        fi
    else
        print_info "Docker is already installed."
    fi

    # Install Docker Compose
    if ! command -v docker-compose &> /dev/null; then
        print_info "Docker Compose is not installed. Installing Docker Compose..."
        # Install Docker Compose (replace version with the latest stable if needed)
        sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
    else
        print_info "Docker Compose is already installed."
    fi

    # Install Python3 and necessary dependencies from GitHub script
    print_info "Downloading and running Python installation script from GitHub..."

    # Download the script from your GitHub repository and execute it
    if curl -s https://raw.githubusercontent.com/CryptoBureau01/packages/main/python3.sh | bash; then
        print_info "Python installation script executed successfully."
    else
        print_error "Failed to run the Python installation script. Please check the link or your network connection."
        exit 1
    fi


    # Install Node and necessary dependencies from GitHub script
    print_info "Downloading and running Node installation script from GitHub..."

    # Download the script from your GitHub repository and execute it
    if curl -s https://raw.githubusercontent.com/CryptoBureau01/packages/main/node-js.sh | bash; then
        print_info "Python installation script executed successfully."
    else
        print_error "Failed to run the node installation script. Please check the link or your network connection."
        exit 1
    fi

    echo "All dependencies have been successfully installed."
    echo "All packages are up to date."

    # Display the installed version of Git
    echo "Checking Git version..."
    git --version

    # Display the installed version of Python 3.11
    echo "Checking Python 3.11 version..."
    python3 --version

    # Display the installed version of Poetry
    echo "Checking Poetry version..."
    poetry --version

    # Display the installed version of Node.js
    echo "Checking Node.js version..."
    node -v

    # Display the installed version of npm (Node Package Manager)
    echo "Checking npm version..."
    npm -v

    # remove back pack file
    rm -rf python3.sh
    rm -rf node-js.sh

    
    # Call the uni_menu function to display the menu
    node_menu
}







