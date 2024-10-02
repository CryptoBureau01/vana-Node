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
apt update && apt upgrade -y
apt install -y curl git nodejs npm

# Install Yarn
print_info "Installing Yarn..."
npm install -g yarn
yarn --version

# Input information from user
print_info "Enter DLP Smart Contract Information:"
read -p "Enter Private Key: " DEPLOYER_PRIVATE_KEY
read -p "Enter Owner Address: " OWNER_ADDRESS
read -p "Enter DLP Name: " DLP_NAME
read -p "Enter DLP Token Name: " DLP_TOKEN_NAME
read -p "Enter DLP Token Symbol: " DLP_TOKEN_SYMBOL

# Clone the vana-dlp-smart-contracts repository
print_info "Cloning vana-dlp-smart-contracts repository..."
cd $HOME
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

# Validate if the input is empty
if [ -z "$DLP_MOKSHA_CONTRACT" ] || [ -z "$DLP_TOKEN_MOKSHA_CONTRACT" ]; then
  print_error "Error: Both contract addresses must be provided."
  exit 1
fi

# Show the provided addresses
print_info "DataLiquidityPool Contract Address: $DLP_MOKSHA_CONTRACT"
print_info "DataLiquidityPoolToken Contract Address: $DLP_TOKEN_MOKSHA_CONTRACT"

print_info "Deployment completed successfully!"
