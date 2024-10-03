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

# Export coldkey private key
print_info "Creating a new Vana wallet with coldkey..."
vanacli wallet create --wallet.name default --wallet.coldkey default

# Export hotkey private key
print_info "Creating a new Vana wallet with hotkey..."
vanacli wallet create --wallet.name default --wallet.hotkey default

# Export private keys for coldkey
echo "Exporting Coldkey private key..."
if ! vanacli wallet export_private_key --wallet.name default --keytype coldkey; then
    echo "Failed to export Coldkey private key."
    exit 1
fi

# Export private keys for hotkey
echo "Exporting Hotkey private key..."
if ! vanacli wallet export_private_key --wallet.name default --keytype hotkey; then
    echo "Failed to export Hotkey private key."
    exit 1
fi

# Generate Encryption Keys
echo "Generating Encryption Keys..."
if ! ./keygen.sh; then
    echo "Failed to generate encryption keys."
    exit 1
fi

echo "Coldkey and Hotkey private keys exported."
echo "Encryption keys generated: public_key.asc, public_key_base64.asc, private_key.asc, private_key_base64.asc"


# Display output 
echo "Process completed!"
