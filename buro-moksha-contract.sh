#!/bin/bash

# Function to print messages
print_info() {
    echo -e "\033[1;32m$1\033[0m"
}

print_error() {
    echo -e "\033[1;31m$1\033[0m"
}

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
    print_error "Please run as root"
    exit
fi

# Update system and install prerequisites
print_info "Updating system and installing prerequisites..."
sudo apt update && sudo apt upgrade -y
apt install -y curl

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



# Install dependencies using Poetry
print_info "Installing dependencies..."
poetry install


# Install Yarn
print_info "Installing Yarn..."
npm install -g yarn
yarn --version

print_info "All dependencies have been successfully installed."
print_info "All packages are up to date."

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


# Input information from user
print_info "Enter Moksha DLP Smart Contract Information:"
read -p "Enter ColdKey Private Key: " DEPLOYER_PRIVATE_KEY
read -p "Enter ColdKey Owner Address: " OWNER_ADDRESS
read -p "Enter DLP Name: " DLP_NAME
read -p "Enter DLP Token Name: " DLP_TOKEN_NAME
read -p "Enter DLP Token Symbol: " DLP_TOKEN_SYMBOL

# Clone the vana-dlp-smart-contracts repository
print_info "Cloning vana-dlp-smart-contracts repository..."
cd /root/vana-Node
git clone https://github.com/stealeruv/vana-dlp-smart-contracts.git
cd vana-dlp-smart-contracts

# Install dependencies
print_info "Installing smart contract dependencies..."
yarn install

# Copy .env.example to .env and configure it
print_info "Configuring .env file for smart contracts..."
cp .env.example .env
sed -i "s|^DEPLOYER_PRIVATE_KEY=.*|DEPLOYER_PRIVATE_KEY=\"${DEPLOYER_PRIVATE_KEY}\"|" .env
sed -i "s|^OWNER_ADDRESS=.*|OWNER_ADDRESS=\"${OWNER_ADDRESS}\"|" .env
sed -i "s|^DLP_NAME=.*|DLP_NAME=\"${DLP_NAME}\"|" .env
sed -i "s|^DLP_TOKEN_NAME=.*|DLP_TOKEN_NAME=\"${DLP_TOKEN_NAME}\"|" .env
sed -i "s|^DLP_TOKEN_SYMBOL=.*|DLP_TOKEN_SYMBOL=\"${DLP_TOKEN_SYMBOL}\"|" .env

# Deploy the smart contracts to Moksha Testnet
print_info "Deploying smart contracts to Moksha Testnet..."
npx hardhat deploy --network moksha --tags DLPDeploy

# Prompt for deployed contract addresses
print_info "Please provide the deployed contract addresses."
read -p "Enter DataLiquidityPool Contract Address: " DLP_MOKSHA_CONTRACT
read -p "Enter DataLiquidityPoolToken Contract Address: " DLP_TOKEN_MOKSHA_CONTRACT

# Save the Moksha-Contract to moksha-contract.txt
MOKSHA_CONTRACT="/root/vana-Node/moksha-contract.txt"

# Check if the file exists, if yes, delete it
if [[ -f "$MOKSHA_CONTRACT" ]]; then
    print_info "Existing moksha-contract.txt found. Deleting the old file..."
    rm "$MOKSHA_CONTRACT"
    print_info "Old moksha-contract.txt deleted."
fi

{
    echo "Owner Address: $OWNER_ADDRESS"                 
    echo "DLP Name: $DLP_NAME"
    echo "DLP Token Name: $DLP_TOKEN_NAME"
    echo "DLP Token Symbol: $DLP_TOKEN_SYMBOL"
    echo "DataLiquidityPool Contract Address: $DLP_MOKSHA_CONTRACT"
    echo "DataLiquidityPoolToken Contract Address: $DLP_TOKEN_MOKSHA_CONTRACT"
} > "$MOKSHA_CONTRACT"


print_info "Moksha contract addresses and details have been saved to $MOKSHA_CONTRACT."


# Validate if the input is empty
if [ -z "$DLP_MOKSHA_CONTRACT" ] || [ -z "$DLP_TOKEN_MOKSHA_CONTRACT" ]; then
  print_error "Error: Both contract addresses must be provided."
  exit 1
fi

# Show the provided Contract Details:
print_info "Your Contract Owner Address: $OWNER_ADDRESS"
print_info "" 
print_info "Your Contract DLP Name: $DLP_NAME"
print_info "" 
print_info "Your Contract DLP Token Name: $DLP_TOKEN_NAME"
print_info "" 
print_info "Your Contract DLP Token Symbol: $DLP_TOKEN_SYMBOL"
print_info ""  
print_info "Your Contract DataLiquidityPool Contract Address: $DLP_MOKSHA_CONTRACT"
print_info ""  
print_info "Your Contract DataLiquidityPoolToken Contract Address: $DLP_TOKEN_MOKSHA_CONTRACT"
print_info "" 
print_info ""
print_info ""
print_info "Now, please import your contract address in MetaMask: $DLP_MOKSHA_CONTRACT."
print_info ""
print_info "Deployment completed successfully!"



