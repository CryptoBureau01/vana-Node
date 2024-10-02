#!/bin/bash

# Function to print info messages
print_info() {
    echo -e "\e[32m$1\e[0m" # Green text
}

# Update system
print_info "Updating system..."
sudo apt update && sudo apt upgrade -y

# Install Git
print_info "Installing Git..."
sudo apt install git -y
git --version

# Install Python 3.11
print_info "Installing Python 3.11..."
sudo apt install software-properties-common -y
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt update
sudo apt install python3.11 python3.11-venv python3.11-dev -y
sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1
python3 --version

# Install pip
print_info "Installing Python pip..."
sudo apt install python3-pip -y
python3 -m pip install --upgrade pip setuptools wheel

# Install build dependencies
print_info "Installing build-essential..."
sudo apt install build-essential -y

# Install virtualenv
print_info "Installing virtualenv..."
pip install virtualenv

# Install Poetry
print_info "Installing Poetry..."
curl -sSL https://install.python-poetry.org | python3 -
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
poetry --version

# Install Node.js and npm
print_info "Installing Node.js and npm..."
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs
node -v
npm -v

# Clone Vana DLP repository
print_info "Cloning the Vana DLP repository..."
git clone https://github.com/vana-com/vana-dlp-chatgpt.git
cd vana-dlp-chatgpt

# Create .env file
print_info "Creating .env file..."
cp .env.example .env

# Install dependencies using Poetry
print_info "Installing dependencies..."
poetry install

# Set up virtual environment and install vana CLI
print_info "Setting up virtual environment..."
virtualenv venv
source venv/bin/activate
pip install vana


# Function to print information
print_info() {
    echo "$1"
}

# Create Vana wallet for coldkey
print_info "Creating a new Vana wallet (coldkey)..."
vanacli wallet create --wallet.name default --wallet.coldkey default

# Export coldkey private key
print_info "Exporting coldkey private key..."
coldkey_private=$(vanacli wallet export_private_key --wallet.name default --keytype coldkey 2>&1)
if [[ $? -ne 0 ]]; then
    echo "Failed to export coldkey private key: $coldkey_private"
    exit 1
fi

# Create Vana wallet for hotkey
print_info "Creating a new Vana wallet (hotkey)..."
vanacli wallet create --wallet.name default --wallet.hotkey default

# Export hotkey private key
print_info "Exporting hotkey private key..."
hotkey_private=$(vanacli wallet export_private_key --wallet.name default --keytype hotkey 2>&1)
if [[ $? -ne 0 ]]; then
    echo "Failed to export hotkey private key: $hotkey_private"
    exit 1
fi

# Save private keys to private.json
DATA_FILE="private.json"
print_info "Saving private keys to $DATA_FILE..."
json_data=$(cat <<EOF
{
  "coldkey_private": "$coldkey_private",
  "hotkey_private": "$hotkey_private"
}
EOF
)

# Save data to private.json
echo "$json_data" > "$DATA_FILE"
print_info "Wallet data saved to $DATA_FILE."

# Move generated encryption keys files to the current folder
print_info "Moving generated encryption key files to the current folder..."
mv public_key.asc public_key_base64.asc private_key.asc private_key_base64.asc .

# Display output for private keys and generated files
print_info "Process completed!"
print_info "Coldkey and Hotkey private keys saved in private.json."
print_info "Encryption keys saved in the current folder: public_key.asc, public_key_base64.asc, private_key.asc, private_key_base64.asc."
