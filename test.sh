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

# Update system
print_info "Updating system..."
sudo apt update && sudo apt upgrade -y
sudo apt-get install expect


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

# Get OpenAI API Key from user
print_info "Enter your OpenAI API Key (get it from https://platform.openai.com/account/api-keys):"
read -p "OpenAI API Key: " OPENAI_API_KEY

# Read contract addresses from the file
MOKSHA_CONTRACT="/root/vana-Node/moksha-contract.txt"
if [[ ! -f "$MOKSHA_CONTRACT" ]]; then
    print_error "Moksha contract file not found!"
    exit 1
fi

DLP_MOKSHA_CONTRACT=$(grep "DataLiquidityPool Contract Address:" "$MOKSHA_CONTRACT" | awk '{print $NF}')
DLP_TOKEN_MOKSHA_CONTRACT=$(grep "DataLiquidityPoolToken Contract Address:" "$MOKSHA_CONTRACT" | awk '{print $NF}')

# Update .env file in vana-dlp-chatgpt
print_info "Configuring .env file for vana-dlp-chatgpt..."
cd /root/vana-Node/vana-dlp-chatgpt

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
read -p "Press Enter to continue..."


# Your ColdKey Wallet Balance check automation :
print_info "Checking coldkey wallet balance..."
expect << EOF
spawn ./vanacli wallet balance
expect "Enter wallets path (~/.vana/wallets/):"
send "~/.vana/wallets/\r"
expect "Enter wallet name (default):"
send "default\r"
expect "Enter network [vana/satori/moksha/local/test/archive] (vana):"
send "moksha\r"
expect eof
EOF
read -p "Press Enter to continue..."


# Display the Moksha hotkey and coldkey wallet addresses
print_info "Moksha Coldkey and Hotkey Wallet Addresses:"
PRIVATE_DATA_FILE="/root/vana-Node/private-data.txt"  # Change this path if needed

if [[ -f "$PRIVATE_DATA_FILE" ]]; then
    # Extract addresses from the private-data.txt file
    COLDKEY_ADDRESS=$(grep "Coldkey Address:" "$PRIVATE_DATA_FILE" | awk '{print $NF}')
    HOTKEY_ADDRESS=$(grep "Hotkey Address:" "$PRIVATE_DATA_FILE" | awk '{print $NF}')

    # Print the addresses
    print_info "Coldkey Address: $COLDKEY_ADDRESS"
    print_info "Hotkey Address: $HOTKEY_ADDRESS"

     # Confirmation message
    print_info "Please confirm your coldkey and hotkey address. You can confirm after hitting Enter."
    read -p "Press Enter to continue..."

    # Thank you message
    print_info "Thanks for confirming! Now we will proceed with the Register as a Validator process."
else
    print_error "Private data file not found!"
fi


# Now we will proceed to register as a Validator
print_info "<=========================================>"

print_info "Total 8 steps we will follow to complete this process"

# Step 1
print_info "Registering as a validator..."
if ./vanacli dlp register_validator --stake_amount 10; then
    print_info "Step 1 Completed!"
else
    print_error "This Step not completed: Registering as a validator failed!"
fi

# Step 2
print_info "Approving validator..."
if ./vanacli dlp approve_validator --validator_address=${HOTKEY_ADDRESS}; then
    print_info "Step 2 Completed!"
else
    print_error "This Step not completed: Approving the validator failed!"
fi

# Step 3
# Run Validator
print_info "Setting up Vana validator service..."
# Assuming the command to set up the validator service goes here
if <command_to_setup_validator_service>; then
    print_info "Step 3 Completed!"
else
    print_error "This Step not completed: Setting up the Vana validator service failed!"
fi


# Now we will proceed to register as a Validator
print_info "<=========================================>"

print_info "Total 8 steps we will follow to complete this process"

# Step 1
print_info "Registering as a validator..."
if ./vanacli dlp register_validator --stake_amount 10; then
    print_info "Step 1 Completed!"
else
    print_error "This Step 1 not completed: Registering as a validator failed!"
fi

# Step 2
print_info "Approving validator..."
if ./vanacli dlp approve_validator --validator_address=${HOTKEY_ADDRESS}; then
    print_info "Step 2 Completed!"
else
    print_error "This Step 2 not completed: Approving the validator failed!"
fi

# Step 3
print_info "Setting up Vana validator service..."
# Assuming the command to set up the validator service goes here
if <command_to_setup_validator_service>; then
    print_info "Step 3 Completed!"
else
    print_error "This Step 3 not completed: Setting up the Vana validator service failed!"
fi

# Step 4
print_info "Finding path of Poetry..."
POETRY_PATH=$(which poetry)

if [[ -n "$POETRY_PATH" ]]; then
    print_info "Step 4 Completed!"
else
    print_error "This Step 4 not completed: Poetry path not found!"
fi

# Step 5
print_info "Creating systemd service..."
cat > /etc/systemd/system/vana.service <<EOL
[Unit]
Description=Vana Validator Service
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/root/vana-Node/vana-dlp-chatgpt
ExecStart=${POETRY_PATH} run python -m chatgpt.nodes.validator
Restart=on-failure
RestartSec=10
Environment=PATH=/root/.local/bin:/usr/local/bin:/usr/bin:/bin:/root/vana-dlp-chatgpt/myenv/bin
Environment=PYTHONPATH=/root/vana-dlp-chatgpt

[Install]
WantedBy=multi-user.target
EOL

print_info "Step 5 Completed!"

# Step 6
print_info "Starting Vana validator service..."
if systemctl daemon-reload && systemctl enable vana.service && systemctl start vana.service; then
    print_info "Step 6 Completed!"
else
    print_error "This Step 6 not completed: Starting Vana validator service failed!"
fi

# Step 7
print_info "Checking service status..."
if systemctl status vana.service; then
    print_info "Step 7 Completed!"
else
    print_error "This Step 7 not completed: Checking service status failed!"
fi

# Step 8
print_info "Displaying validator logs..."
if journalctl -u vana.service -f; then
    print_info "Step 8 Completed!"
else
    print_error "This Step 8 not completed: Displaying validator logs failed!"
fi
