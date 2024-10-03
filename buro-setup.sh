#!/bin/bash

# Update system
echo "Updating system..."
sudo apt update && sudo apt upgrade -y

# Install Git
echo "Installing Git..."
sudo apt install git -y
git --version

# Install Python 3.11
echo "Installing Python 3.11..."
sudo apt install software-properties-common -y
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt update
sudo apt install python3.11 python3.11-venv python3.11-dev -y
sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1
python3 --version

# Install pip
echo "Installing Python pip..."
sudo apt install python3-pip -y
python3 -m pip install --upgrade pip setuptools wheel

# Install build dependencies
echo "Installing build-essential..."
sudo apt install build-essential -y

# Install virtualenv
echo "Installing virtualenv..."
pip install virtualenv

# Install Poetry
echo "Installing Poetry..."
curl -sSL https://install.python-poetry.org | python3 -
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
poetry --version

# Install Node.js and npm
echo "Installing Node.js and npm..."
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs
node -v
npm -v

# Clone Vana DLP repository
echo "Cloning the Vana DLP repository..."
git clone https://github.com/vana-com/vana-dlp-chatgpt.git
cd vana-dlp-chatgpt

# Create .env file
echo "Creating .env file..."
cp .env.example .env

# Install dependencies using Poetry
echo "Installing dependencies..."
poetry install

# Set up virtual environment and install vana CLI
echo "Setting up virtual environment..."
virtualenv venv
source venv/bin/activate
pip install vana

# Create wallet
echo "Creating wallet..."

# Export coldkey/hotkey phase key :
echo "Creating a new Vana wallet with coldkey/hotkey..."
vanacli wallet create --wallet.name default --wallet.hotkey default


# Export Coldkey private key (interactive prompt)
echo "Exporting Coldkey private key..."
vanacli wallet export_private_key

# Notify user to follow prompts
echo "Please enter the wallet name (default), key type (coldkey), and password when prompted."
echo "Your coldkey private key will be displayed after you enter the correct information."

# Export Hotkey private key (interactive prompt)
echo "Exporting Hotkey private key..."
vanacli wallet export_private_key

# Notify user again to follow prompts for hotkey
echo "Please enter the wallet name (default), key type (hotkey), and password when prompted."
echo "Your hotkey private key will be displayed after you enter the correct information."


# Generate Encryption Keys
echo "Generating Encryption Keys..."
if ! ./keygen.sh > keygen_output.log 2>&1; then
    echo "Failed to generate encryption keys. Check keygen_output.log for details."
    exit 1
fi

# Copy encryption keys to the current folder
echo "Copying encryption keys to the current folder..."
sudo cp /root/vana-Node/vana-dlp-chatgpt/public_key.asc /root/vana-Node
sudo cp /root/vana-Node/vana-dlp-chatgpt/public_key_base64.asc /root/vana-Node
sudo cp /root/vana-Node/vana-dlp-chatgpt/private_key.asc /root/vana-Node
sudo cp /root/vana-Node/vana-dlp-chatgpt/private_key_base64.asc /root/vana-Node


echo "Coldkey and Hotkey private keys exported."


# Display output 
echo "Process completed!"
echo "Encryption keys successfully."
echo "default" | vanacli wallet export_private_key

