#!/bin/bash

# Function to print information
print_info() {
    echo -e "\e[32m$1\e[0m"
}

# Update system
print_info "Updating system..."
sudo apt update && sudo apt upgrade -y

# Install Python 3.11
print_info "Installing Python 3.11..."
sudo apt install software-properties-common -y
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt update
sudo apt install python3.11 python3.11-venv python3.11-dev -y
sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1
python3 --version

# Install Poetry
print_info "Installing Poetry..."
curl -sSL https://install.python-poetry.org | python3 -
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
poetry --version

# Get OpenAI API Key from user
print_info "Enter your OpenAI API Key (get it from https://platform.openai.com/account/api-keys):"
read -p "OpenAI API Key: " OPENAI_API_KEY

# Update .env file in vana-dlp-chatgpt
print_info "Configuring .env file for vana-dlp-chatgpt..."
cd $HOME/vana-Node/vana-dlp-chatgpt

# Get the public key for encryption
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