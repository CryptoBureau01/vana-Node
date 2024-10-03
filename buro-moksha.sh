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

# Save the Moksha-Contract to moksha-contract.txt
MOKSHA_CONTRACT="/root/vana-Node/moksha-contract.txt"

{
    # Moksha-Contract Data
    echo "DataLiquidityPool Contract Address: $DLP_MOKSHA_CONTRACT"
    echo "DataLiquidityPoolToken Contract Address: $DLP_TOKEN_MOKSHA_CONTRACT"
} > "$MOKSHA_CONTRACT"

print_info "Moksha-Contract has been saved to $MOKSHA_CONTRACT"


# Validate if the input is empty
if [ -z "$DLP_MOKSHA_CONTRACT" ] || [ -z "$DLP_TOKEN_MOKSHA_CONTRACT" ]; then
  print_error "Error: Both contract addresses must be provided."
  exit 1
fi

# Show the provided addresses
print_info "DataLiquidityPool Contract Address: $DLP_MOKSHA_CONTRACT"
print_info "DataLiquidityPoolToken Contract Address: $DLP_TOKEN_MOKSHA_CONTRACT"

print_info "Deployment completed successfully!"


# Get OpenAI API Key from user
print_info "Enter your OpenAI API Key (get it from https://platform.openai.com/account/api-keys):"
read -p "OpenAI API Key: " OPENAI_API_KEY

# Update .env file in vana-dlp-chatgpt
print_info "Configuring .env file for vana-dlp-chatgpt..."
cd $HOME/vana-Node/vana-dlp-chatgpt

PUBLIC_KEY_BASE64=$(cat public_key_base64.asc)

cat > .env <<EOL
# The network to use, currently Vana Moksha testnet
OD_CHAIN_NETWORK=moksha
OD_CHAIN_NETWORK_ENDPOINT=https://rpc.moksha.vana.org

# Optional: OpenAI API key for additional data quality check
OPENAI_API_KEY="${OPENAI_API_KEY}"


# Your own DLP smart contract address once deployed to the network
DLP_MOKSHA_CONTRACT=${DLP_MOKSHA_CONTRACT}
# Your own DLP token contract address once deployed to the network
DLP_TOKEN_MOKSHA_CONTRACT=${DLP_TOKEN_MOKSHA_CONTRACT}

# The private key for the DLP
PRIVATE_FILE_ENCRYPTION_PUBLIC_KEY_BASE64="${PUBLIC_KEY_BASE64}"
EOL

# Fund Validator with DLP Tokens
print_info "Please import the DLP token to MetaMask using the DataLiquidityPoolToken address: ${DLP_TOKEN_MOKSHA_CONTRACT}"
print_info "Send 10 of your DLP tokens to your coldkey and hotkey addresses."
print_info "Press Enter after you have funded your wallets with DLP tokens..."
read -p ""

# Register as a Validator
print_info "Registering as a validator..."
cd $HOME/vana-Node/vana-dlp-chatgpt
./vanacli dlp register_validator --stake_amount 10

print_info "Approving validator..."
./vanacli dlp approve_validator --validator_address=${HOTKEY_ADDRESS}

# Run Validator
print_info "Setting up Vana validator service..."

# Find path of Poetry
POETRY_PATH=$(which poetry)

# Create systemd service
cat > /etc/systemd/system/vana.service <<EOL
[Unit]
Description=Vana Validator Service
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=$HOME/vana-dlp-chatgpt
ExecStart=${POETRY_PATH} run python -m chatgpt.nodes.validator
Restart=on-failure
RestartSec=10
Environment=PATH=$HOME/.local/bin:/usr/local/bin:/usr/bin:/bin:$HOME/vana-dlp-chatgpt/myenv/bin
Environment=PYTHONPATH=$HOME/vana-dlp-chatgpt

[Install]
WantedBy=multi-user.target
EOL

# Start service
print_info "Starting Vana validator service..."
systemctl daemon-reload
systemctl enable vana.service
systemctl start vana.service

# Check service status
systemctl status vana.service

# Show logs
print_info "Displaying validator logs..."
journalctl -u vana.service -f
