# !/bin/bash

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



#Function to check system type and root privileges
master_fun() {
    echo "Checking system requirements..."

    # Check if the system is Ubuntu
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        if [ "$ID" != "ubuntu" ]; then
            echo "This script is designed for Ubuntu. Exiting."
            exit 1
        fi
    else
        echo "Cannot detect operating system. Exiting."
        exit 1
    fi

    # Check if the user is root
    if [ "$EUID" -ne 0 ]; then
        echo "You are not running as root. Please enter root password to proceed."
        sudo -k  # Force the user to enter password
        if sudo true; then
            echo "Switched to root user."
        else
            echo "Failed to gain root privileges. Exiting."
            exit 1
        fi
    else
        echo "You are running as root."
    fi

    echo "System check passed. Proceeding to package installation..."
}




# Function to install dependencies (Rust in this case)
install_dependency() {
    print_info "<=========== Install Dependency ==============>"
    print_info "Updating and upgrading system packages, and installing curl..."
    sudo apt update && sudo apt upgrade -y && sudo apt install expect curl git wget build-essential -y

    # Download and execute the Python 3.12 installation script
    if curl -s https://raw.githubusercontent.com/CryptoBureau01/packages/main/python3.12.sh | bash; then
        echo "Pyhton 3.12 installation script executed successfully."
        sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.12 1
        sudo update-alternatives --set python3 /usr/bin/python3.12
    else
        echo "Error: Failed to run the Rust installation script. Please check the link or your network connection."
        exit 1
    fi

    # Download and execute the Node.js v23.1.0 installation script
    if curl -s https://raw.githubusercontent.com/CryptoBureau01/packages/main/node.sh | bash; then
        echo "Node.js v23.1.0 installation script executed successfully."
    else
        echo "Error: Failed to run the Rust installation script. Please check the link or your network connection."
        exit 1
    fi

    # Install Yarn
    print_info "Installing Yarn..."
    npm install -g yarn
    yarn --version

    # Install Poetry
    echo "Installing Poetry..."
    curl -sSL https://install.python-poetry.org | python3 -

    # Add Poetry to PATH by updating .bashrc
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
    source ~/.bashrc

    # Verify Poetry installation
    poetry --version

    # Install web3 globally using pip3
    pip3 install web3
    
    # Install pip3 for Python 3.10
    sudo apt install -y python3-pip
    python3 -m pip install --upgrade pip setuptools wheel virtualenv
    
    print_info "Checking Python3 version..."
    python3 --version
    pip3 --version

    print_info "Check Node.js Version..."
    node -v
    npm -v

    # Call the uni_menu function to display the menu
    master

}



# Function to set up Vana Node
setup_vana() {
    # Create /root/vanaNode directory
    echo "Creating /root/vanaNode directory..."
    sudo mkdir -p /root/vanaNode

    # Navigate to /root/vanaNode
    cd /root/vanaNode

    # Clone the Vana repository
    echo "Cloning Vana repository into /root/vanaNode..."
    sudo git clone https://github.com/vana-com/vana-dlp-chatgpt.git

    # Change to the cloned directory
    cd vana-dlp-chatgpt
    echo "Successfully navigated to /root/vanaNode/vana-dlp-chatgpt"

    # Create .env file
    echo "Creating .env file..."
    cp .env.example .env

    # Install dependencies with Poetry
    echo "Installing dependencies..."
    poetry install

    # Set up virtual environment and install 'vana' package
    echo "Setting up virtual environment..."
    virtualenv venv
    source venv/bin/activate
    pip install vana

    echo "Vana Node setup complete."

    # Call the uni_menu function to display the menu
    master
}


# Function to create a new Vana wallet
create_wallet() {
    echo "Creating a new Vana wallet..."

    # Step 1: Creating new wallet phrase key
    echo "Step 1. Creating new wallet Phrase key..."
    echo "Please follow the prompts to set a secure password and save the mnemonic phrases securely."
    vanacli wallet create --wallet.name default --wallet.hotkey default

    # Step 2: Creating new Coldkey wallet private key
    echo "Step 2. Creating new Coldkey wallet private key..."
    echo "Enter wallet name (default): Press Enter"
    echo "Enter key type [coldkey/hotkey] (coldkey): Type coldkey"
    echo "Enter your coldkey password: Enter Your new Password"
    vanacli wallet export_private_key

    # Step 3: Creating new Hotkey wallet private key
    echo "Step 3. Creating new Hotkey wallet private key..."
    echo "Enter wallet name (default): Press Enter"
    echo "Enter key type [coldkey/hotkey] (coldkey): Type hotkey"
    echo "Enter your coldkey password: Enter Your new Password"
    vanacli wallet export_private_key

    # Step 4: Verify private keys and mnemonic words
    echo ""
    echo "Now, please verify your private key and address information."

    # Prompt for mnemonic words
    echo "Enter your ColdKey mnemonic phrase:"
    read -p "Coldkey Mnemonic Phrase: " COLDKEY_MNEMONIC
    echo ""
    echo "Enter your HotKey mnemonic phrase:"
    read -p "Hotkey Mnemonic Phrase: " HOTKEY_MNEMONIC

    # Prompt for private keys
    echo "Please enter your private keys manually:"
    read -p "Enter Coldkey Private Key: " COLDKEY_PRIVATE_KEY
    echo ""
    read -p "Enter Hotkey Private Key: " HOTKEY_PRIVATE_KEY

    # Prompt for wallet addresses
    echo ""
    echo "Please import both private keys into MetaMask and copy both your addresses."
    echo "Enter your wallet addresses manually:"
    read -p "Enter Coldkey Address: " COLDKEY_ADDRESS
    echo ""
    read -p "Enter Hotkey Address: " HOTKEY_ADDRESS

    # Step 5: Display entered private keys and addresses
    echo ""
    echo "You have entered the following private keys and wallet addresses:"
    echo "Coldkey Private Key: $COLDKEY_PRIVATE_KEY"
    echo "Hotkey Private Key: $HOTKEY_PRIVATE_KEY"
    echo "Coldkey Address: $COLDKEY_ADDRESS"
    echo "Hotkey Address: $HOTKEY_ADDRESS"

    # Step 6: Save private data to file
    PRIVATE_DATA_FILE="/root/vanaNode/priv-data.txt"

    # Check if the file exists, if yes, delete it
    if [[ -f "$PRIVATE_DATA_FILE" ]]; then
       echo "Existing private-data.txt found. Deleting the old file..."
       rm "$PRIVATE_DATA_FILE"
       echo "Old private-data.txt deleted."
    fi
    
    {
        echo "Vana-Node Wallet Private Data"
        echo ""
        echo "Coldkey Address: $COLDKEY_ADDRESS"
        echo "Coldkey Private Key: $COLDKEY_PRIVATE_KEY"
        echo "Coldkey Mnemonic Words: $COLDKEY_MNEMONIC"
        echo ""
        echo "Hotkey Address: $HOTKEY_ADDRESS"
        echo "Hotkey Private Key: $HOTKEY_PRIVATE_KEY"
        echo "Hotkey Mnemonic Words: $HOTKEY_MNEMONIC"
    } > "$PRIVATE_DATA_FILE"

    echo "Private data has been saved to $PRIVATE_DATA_FILE"
    echo "Wallet creation successfully completed."

    # Call the uni_menu function to display the menu
    master
}


# Function to restore a Vana wallet
restore_wallet() {
    echo ""
    echo "Restoring coldkey and hotkey wallets using mnemonic phrases."
    echo ""

    # Step 1: Restore coldkey wallet
    echo ""
    read -p "Enter your Coldkey Mnemonic Phrase: " COLDKEY_MNEMONIC
    ./vanacli wallet regen_coldkey --mnemonic "$COLDKEY_MNEMONIC" --wallet.path /root/.vana/wallets --wallet.name default

    echo ""
    echo "Coldkey wallet has been restored."
    echo ""

    # Step 2: Restore hotkey wallet
    echo ""
    read -p "Enter your Hotkey Mnemonic Phrase: " HOTKEY_MNEMONIC
    vanacli wallet regen_hotkey --mnemonic "$HOTKEY_MNEMONIC" --wallet.path /root/.vana/wallets --wallet.name default

    echo ""
    echo "Hotkey wallet has been restored."
    echo ""

    # Prompt user to input private keys manually
    echo ""
    echo "Please enter your private keys manually:"
    read -p "Enter Coldkey Private Key: " COLDKEY_PRIVATE_KEY
    echo ""
    read -p "Enter Hotkey Private Key: " HOTKEY_PRIVATE_KEY

    # Prompt user to input wallet addresses manually
    echo ""
    echo "Please enter your wallet addresses manually:"
    read -p "Enter Coldkey Address: " COLDKEY_ADDRESS
    echo ""
    read -p "Enter Hotkey Address: " HOTKEY_ADDRESS

    # Display entered private keys and addresses
    echo ""
    echo "You have entered the following private keys:"
    echo "Coldkey Private Key: $COLDKEY_PRIVATE_KEY"
    echo "Hotkey Private Key: $HOTKEY_PRIVATE_KEY"
    echo ""
    echo "You have entered the following wallet addresses:"
    echo "Coldkey Address: $COLDKEY_ADDRESS"
    echo "Hotkey Address: $HOTKEY_ADDRESS"

    # Step 3: Save private data to file
    PRIVATE_DATA_FILE="/root/vanaNode/priv-data.txt"

    # Check if the file exists, if yes, delete it
    if [[ -f "$PRIVATE_DATA_FILE" ]]; then
       echo "Existing private-data.txt found. Deleting the old file..."
       rm "$PRIVATE_DATA_FILE"
       echo "Old private-data.txt deleted."
    fi
    
    {
        echo "Vana-Node Wallet Private Data"
        echo ""
        echo "Coldkey Address: $COLDKEY_ADDRESS"
        echo "Coldkey Private Key: $COLDKEY_PRIVATE_KEY"
        echo "Coldkey Mnemonic Words: $COLDKEY_MNEMONIC"
        echo ""
        echo "Hotkey Address: $HOTKEY_ADDRESS"
        echo "Hotkey Private Key: $HOTKEY_PRIVATE_KEY"
        echo "Hotkey Mnemonic Words: $HOTKEY_MNEMONIC"
    } > "$PRIVATE_DATA_FILE"

    echo "Private data has been saved to $PRIVATE_DATA_FILE"
    echo ""
    echo "Wallet restoration completed. Please verify your coldkey and hotkey wallets."

    # Call the uni_menu function to display the menu
    master
}


generate_key() {
    echo ""
    echo "Generating Encryption Keys..."
    
    # Run the keygen script
    chmod +x keygen.sh
    ./keygen.sh

    # Copy encryption keys to /root/vanaNode folder
    echo ""
    echo "Copying encryption keys to the current folder..."
    sudo cp /root/vanaNode/vana-dlp-chatgpt/public_key.asc /root/vanaNode
    sudo cp /root/vanaNode/vana-dlp-chatgpt/public_key_base64.asc /root/vanaNode
    sudo cp /root/vanaNode/vana-dlp-chatgpt/private_key.asc /root/vanaNode
    sudo cp /root/vanaNode/vana-dlp-chatgpt/private_key_base64.asc /root/vanaNode

    # Display completion message
    echo ""
    echo "Process completed!"
    echo "Encryption keys successfully imported."

    # Call the uni_menu function to display the menu
    master
}



# Function to deploy contract by cloning the repository if not already present
contract_deploy() {
    # Define the target directory
    TARGET_DIR="/root/vanaNode/vana-dlp-smart-contracts"

    # Check if the directory already exists
    if [ -d "$TARGET_DIR" ]; then
        print_info "The vana-dlp-smart-contracts repository already exists in $TARGET_DIR. Skipping clone."
    else
        # Clone the vana-dlp-smart-contracts repository
        print_info "Cloning vana-dlp-smart-contracts repository..."
        cd /root/vanaNode
        git clone https://github.com/stealeruv/vana-dlp-smart-contracts.git
        cd vana-dlp-smart-contracts
    fi

    # Continue with contract deployment steps here (if any)
    # e.g., building contracts, setting environment variables, etc.
    print_info "Contract deployment folder is set up in $TARGET_DIR"

    # Input information from user
    print_info "Enter Moksha DLP Smart Contract Information:"
    read -p "Enter ColdKey Private Key: " DEPLOYER_PRIVATE_KEY
    read -p "Enter ColdKey Owner Address: " OWNER_ADDRESS
    read -p "Enter DLP Name: " DLP_NAME
    read -p "Enter DLP Token Name: " DLP_TOKEN_NAME
    read -p "Enter DLP Token Symbol: " DLP_TOKEN_SYMBOL

    # Copy .env.example to .env and configure it
    print_info "Configuring .env file for smart contracts..."
    cp .env.example .env
    sed -i "s|^DEPLOYER_PRIVATE_KEY=.*|DEPLOYER_PRIVATE_KEY=\"${DEPLOYER_PRIVATE_KEY}\"|" .env
    sed -i "s|^OWNER_ADDRESS=.*|OWNER_ADDRESS=\"${OWNER_ADDRESS}\"|" .env
    sed -i "s|^DLP_NAME=.*|DLP_NAME=\"${DLP_NAME}\"|" .env
    sed -i "s|^DLP_TOKEN_NAME=.*|DLP_TOKEN_NAME=\"${DLP_TOKEN_NAME}\"|" .env
    sed -i "s|^DLP_TOKEN_SYMBOL=.*|DLP_TOKEN_SYMBOL=\"${DLP_TOKEN_SYMBOL}\"|" .env

    # Install dependencies
    print_info "Installing smart contract dependencies..."
    yarn install

    # Deploy the smart contracts to Moksha Testnet
    print_info "Deploying smart contracts to Moksha Testnet..."
    npx hardhat deploy --network moksha --tags DLPDeploy

    # Prompt for deployed contract addresses
    print_info "Please provide the deployed contract addresses."
    read -p "Enter DataLiquidityPool Contract Address: " DLP_MOKSHA_CONTRACT
    read -p "Enter DataLiquidityPoolToken Contract Address: " DLP_TOKEN_MOKSHA_CONTRACT

    # Save the Moksha-Contract to moksha-contract.txt
    MOKSHA_CONTRACT="/root/vanaNode/moksha-contract.txt" 

    # Check if the file exists, if yes, delete it
    if [[ -f "$MOKSHA_CONTRACT" ]]; then
        print_info "Existing moksha-contract.txt found. Deleting the old file..."
        rm "$MOKSHA_CONTRACT"
        print_info "Old moksha-contract.txt deleted."
    fi

    {
        # Moksha Contract Data :
        echo ""
        echo ""
        echo "Owner Address: $OWNER_ADDRESS"
        echo ""
        echo ""
        echo "DLP Name: $DLP_NAME"
        echo ""
        echo "DLP Token Name: $DLP_TOKEN_NAME"
        echo ""
        echo "DLP Token Symbol: $DLP_TOKEN_SYMBOL"
        echo ""
        echo ""
        echo "DataLiquidityPool Contract Address: $DLP_MOKSHA_CONTRACT"
        echo ""
        echo "DataLiquidityPoolToken Contract Address: $DLP_TOKEN_MOKSHA_CONTRACT"
        echo ""
        echo ""
        echo "Now, please import your contract address in MetaMask: $DLP_TOKEN_MOKSHA_CONTRACT."
        echo ""
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
    print_info "Now, please import your contract address in MetaMask: $DLP_TOKEN_MOKSHA_CONTRACT."
    print_info ""
    print_info "Deployment completed successfully!"

    # Call the uni_menu function to display the menu
    master
}


node_setup() {
    # Get OpenAI API Key from user
    print_info "Enter your OpenAI API Key (get it from https://platform.openai.com/account/api-keys):"
    read -p "OpenAI API Key: " OPENAI_API_KEY

    # Read contract addresses and details from the file
    MOKSHA_CONTRACT="/root/vanaNode/moksha-contract.txt"
    if [[ ! -f "$MOKSHA_CONTRACT" ]]; then
        print_error "Moksha contract file not found!"
        exit 1
    fi

    # Extract contract details from the moksha-contract.txt file
    OWNER_ADDRESS=$(grep "Owner Address:" "$MOKSHA_CONTRACT" | awk '{print $NF}')
    DLP_NAME=$(grep "DLP Name:" "$MOKSHA_CONTRACT" | awk '{print $NF}')
    DLP_TOKEN_NAME=$(grep "DLP Token Name:" "$MOKSHA_CONTRACT" | awk '{print $NF}')
    DLP_TOKEN_SYMBOL=$(grep "DLP Token Symbol:" "$MOKSHA_CONTRACT" | awk '{print $NF}')
    DLP_MOKSHA_CONTRACT=$(grep "DataLiquidityPool Contract Address:" "$MOKSHA_CONTRACT" | awk '{print $NF}')
    DLP_TOKEN_MOKSHA_CONTRACT=$(grep "DataLiquidityPoolToken Contract Address:" "$MOKSHA_CONTRACT" | awk '{print $NF}')

    # Display contract details
    print_info "Contract Owner Address: $OWNER_ADDRESS"
    print_info ""
    print_info "DLP Name: $DLP_NAME"
    print_info "DLP Token Name: $DLP_TOKEN_NAME"
    print_info "DLP Token Symbol: $DLP_TOKEN_SYMBOL"
    print_info "DataLiquidityPool Contract Address: $DLP_MOKSHA_CONTRACT"
    print_info "DataLiquidityPoolToken Contract Address: $DLP_TOKEN_MOKSHA_CONTRACT"

    # Confirm with the user that all the details are correct
    print_info "Please review the above contract details to confirm if everything is correct."
    print_info ""
    read -p "If everything is correct, press Enter to continue or Ctrl+C to abort."

    # Update .env file in vana-dlp-chatgpt
    print_info "Configuring .env file for vana-dlp-chatgpt..."
    cd /root/vanaNode/vana-dlp-chatgpt

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
    ./vanacli wallet balance --wallet.path /root/.vana/wallets --wallet.name default --network moksha

    read -p "Press Enter to continue..."

    # Display the Moksha hotkey and coldkey wallet addresses
    print_info "Moksha Coldkey and Hotkey Wallet Addresses:"
    PRIVATE_DATA_FILE="/root/vanaNode/priv-data.txt"  # Change this path if needed

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

    # Call the uni_menu function to display the menu
    master
}


connect_node() {
    # Step 1: Register as a validator
    print_info "Registering as a validator..."
    if ./vanacli dlp register_validator --stake_amount 10; then
        print_info "Step 1 Completed!"
    else
        print_error "This Step 1 not completed: Registering as a validator failed!"
        return 1
    fi

    # Step 2: Approve validator
    print_info "Approving validator..."
    if ./vanacli dlp approve_validator --validator_address=${HOTKEY_ADDRESS}; then
        print_info "Step 2 Completed!"
    else
        print_error "This Step 2 not completed: Approving the validator failed!"
        return 1
    fi

    # Step 3: Find Poetry Path
    print_info "Finding path of Poetry..."
    POETRY_PATH=$(which poetry)

    if [[ -n "$POETRY_PATH" ]]; then
        print_info "Step 3 Completed!"
    else
        print_error "This Step 3 not completed: Poetry path not found!"
        return 1
    fi

    # Step 4: Create systemd service
    print_info "Creating systemd service..."
    cat > /etc/systemd/system/vana.service <<EOL
[Unit]
Description=Vana Validator Service
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/root/vanaNode/vana-dlp-chatgpt
ExecStart=${POETRY_PATH} run python -m chatgpt.nodes.validator
Restart=on-failure
RestartSec=10
Environment=PATH=/root/.local/bin:/usr/local/bin:/usr/bin:/bin:/root/vana-dlp-chatgpt/myenv/bin
Environment=PYTHONPATH=/root/vana-dlp-chatgpt

[Install]
WantedBy=multi-user.target
EOL

    print_info "Step 4 Completed!"

    # Step 5: Start Vana validator service
    print_info "Starting Vana validator service..."
    if systemctl daemon-reload && systemctl enable vana.service && systemctl start vana.service; then
        print_info "Step 5 Completed!"
    else
        print_error "This Step 5 not completed: Starting Vana validator service failed!"
        return 1
    fi

    print_info "Node connection and setup complete!"

    # Call the uni_menu function to display the menu
    master
}



# Function to check if Vana validator service is running
connect_status() {
    print_info "Checking status of Vana validator service..."

    # Check if the service is active
    if systemctl is-active --quiet vana.service; then
        print_info "Vana validator service is running."
    else
        print_error "Vana validator service is not running."
    fi

    # Call the uni_menu function to display the menu
    master
}


# Function to check the logs of the Vana validator service
check_logs() {
    print_info "Fetching the last 100 lines of Vana validator service logs..."

    # Display the last 100 lines of logs
    journalctl -u vana.service -n 100 -f


    # Call the uni_menu function to display the menu
    master
}


# Function to stop the Vana node service
stop_node() {
    print_info "Stopping the Vana validator service..."

    # Stop the service using systemctl
    if systemctl stop vana.service; then
        print_info "Vana validator service stopped successfully!"
    else
        print_error "Failed to stop the Vana validator service!"
    fi

    # Call the uni_menu function to display the menu
    master
}


# Function to delete the Vana node
delete_node() {
    print_info "Are you sure you want to delete the Vana node? This will remove all files and services related to the Vana node."

    # Prompt the user for confirmation
    read -p "Do you want to proceed? (y/n): " confirm

    # Check if the user entered 'y' for yes
    if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
        # Deleting the Vana Node directory
        print_info "Deleting /root/vanaNode..."
        rm -rf /root/vanaNode
        print_info "/root/vanaNode has been deleted."

        # Deleting the systemd service
        print_info "Deleting /etc/systemd/system/vana.service..."
        rm -rf /etc/systemd/system/vana.service
        print_info "/etc/systemd/system/vana.service has been deleted."

        # Optionally, reload systemd to reflect the changes
        systemctl daemon-reload
        print_info "Systemd daemon reloaded successfully."

    # If the user entered 'n', abort the operation
    elif [[ "$confirm" == "n" || "$confirm" == "N" ]]; then
        print_info "Operation aborted. The Vana node was not deleted."
        return
    else
        # Invalid input
        print_error "Invalid input! Please enter 'y' for yes or 'n' for no."
        return
    fi

    # Call the uni_menu function to display the menu
    master
}


# Function to start the Vana node
start_node() {
    print_info "Starting Vana node..."

    # Reload systemd to ensure the service is recognized
    print_info "Reloading systemd daemon..."
    if systemctl daemon-reload; then
        print_info "Systemd daemon reloaded successfully."
    else
        print_error "Failed to reload systemd daemon."
        return
    fi

    # Enable the Vana service to start on boot
    print_info "Enabling Vana service to start on boot..."
    if systemctl enable vana.service; then
        print_info "Vana service enabled to start on boot."
    else
        print_error "Failed to enable Vana service."
        return
    fi

    # Start the Vana service
    print_info "Starting Vana service..."
    if systemctl start vana.service; then
        print_info "Vana node started successfully."
    else
        print_error "Failed to start Vana service."
        return
    fi

    # Check if the Vana service is active
    if systemctl is-active --quiet vana.service; then
        print_info "Vana node is running."
    else
        print_error "Vana node failed to start."
    fi

    # Call the uni_menu function to display the menu
    master
    
}



# Function to display Moksha wallet addresses (Coldkey and Hotkey)
wallet_address() {
    print_info "Displaying Moksha Coldkey and Hotkey Wallet Addresses..."

    # Define the path to the private data file
    PRIVATE_DATA_FILE="/root/vanaNode/priv-data.txt"  # Change this path if needed

    # Check if the private data file exists
    if [[ -f "$PRIVATE_DATA_FILE" ]]; then
        # Extract coldkey and hotkey addresses from the private-data.txt file
        COLDKEY_ADDRESS=$(grep "Coldkey Address:" "$PRIVATE_DATA_FILE" | awk '{print $NF}')
        HOTKEY_ADDRESS=$(grep "Hotkey Address:" "$PRIVATE_DATA_FILE" | awk '{print $NF}')

        # Print the extracted addresses
        print_info "Coldkey Address: $COLDKEY_ADDRESS"
        print_info "Hotkey Address: $HOTKEY_ADDRESS"
    else
        # Error if the private data file is not found
        print_error "Private data file not found!"
    fi

    # Call the uni_menu function to display the menu
    master
}


mining_setup() {
    # Step 1: Navigate to /root/vanaNode folder
    print_info "Navigating to /root/vanaNode directory..."
    cd /root/vanaNode || { print_error "Failed to navigate to /root/vanaNode directory."; exit 1; }

    # Step 2: Clone the miner repository
    print_info "Cloning the miner repository..."
    git clone https://github.com/sixgpt/miner

    # Step 3: Change directory to miner
    cd miner || { print_error "Failed to navigate to the miner directory."; exit 1; }

    # Step 4: Import private key from priv-data.txt
    PRIVATE_DATA_FILE="/root/vanaNode/priv-data.txt"
    if [[ -f "$PRIVATE_DATA_FILE" ]]; then
        # Extract ColdKey private key from priv-data.txt
        COLDKEY_PRIVATE_KEY=$(grep "ColdKey" "$PRIVATE_DATA_FILE" | awk '{print $NF}')
        
        if [[ -n "$COLDKEY_PRIVATE_KEY" ]]; then
            print_info "Successfully extracted ColdKey private key."
        else
            print_error "ColdKey private key not found in $PRIVATE_DATA_FILE!"
            exit 1
        fi
    else
        print_error "$PRIVATE_DATA_FILE not found!"
        exit 1
    fi

    # Step 5: Create docker-compose.yml with the private key injected
    print_info "Creating docker-compose.yml with the private key..."

    echo "version: '3.8'" > docker-compose.yml
    echo "" >> docker-compose.yml
    echo "services:" >> docker-compose.yml
    echo "  ollama:" >> docker-compose.yml
    echo "    image: ollama/ollama:0.3.12" >> docker-compose.yml
    echo "    ports:" >> docker-compose.yml
    echo "      - \"11439:11434\"" >> docker-compose.yml
    echo "    volumes:" >> docker-compose.yml
    echo "      - ollama:/root/.ollama" >> docker-compose.yml
    echo "    restart: unless-stopped" >> docker-compose.yml
    echo "" >> docker-compose.yml
    echo "  sixgpt3:" >> docker-compose.yml
    echo "    image: sixgpt/miner:latest" >> docker-compose.yml
    echo "    ports:" >> docker-compose.yml
    echo "      - \"3030:3000\"" >> docker-compose.yml
    echo "    depends_on:" >> docker-compose.yml
    echo "      - ollama" >> docker-compose.yml
    echo "    environment:" >> docker-compose.yml
    echo "      - VANA_PRIVATE_KEY=${COLDKEY_PRIVATE_KEY}" >> docker-compose.yml
    echo "      - VANA_NETWORK=moksha" >> docker-compose.yml
    echo "      - OLLAMA_API_URL=http://ollama:11434/api" >> docker-compose.yml
    echo "    restart: no" >> docker-compose.yml
    echo "" >> docker-compose.yml
    echo "volumes:" >> docker-compose.yml
    echo "  ollama:" >> docker-compose.yml

    print_info "docker-compose.yml file created and private key added successfully!"

    sudo ufw allow 3030
    
    print_info "Mining setup completed and ready!"

    # Call the uni_menu function to display the menu
    master
}


mining_logs() {
    # Step 1: Navigate to /root/vanaNode/miner directory
    print_info "Navigating to /root/vanaNode/miner directory..."
    cd /root/vanaNode/miner || { print_error "Failed to navigate to /root/vanaNode/miner directory."; exit 1; }

    # Step 2: Run docker compose up and show only the first 100 lines of logs
    print_info "Starting Docker containers and displaying the first 100 lines of logs..."

    # Running docker-compose up and limiting the output to 100 lines
    docker compose up | head -n 100

    print_info "Logs displayed successfully!"

    # Call the uni_menu function to display the menu
    master
}


mining_stop() {
    # Step 1: Navigate to /root/vanaNode/miner directory
    print_info "Navigating to /root/vanaNode/miner directory..."
    cd /root/vanaNode/miner || { print_error "Failed to navigate to /root/vanaNode/miner directory."; exit 1; }

    # Step 2: Stop the Docker containers
    print_info "Stopping Docker containers..."

    # Running docker-compose down to stop and remove the containers
    docker compose down

    print_info "Docker containers stopped successfully!"

    # Call the uni_menu function to display the menu
    master
}



# Function to display menu and prompt user for input
master() {
    print_info "==============================="
    print_info "    Vana Node Tool Menu    "
    print_info "==============================="
    print_info ""
    print_info "1. Install-Dependency"
    print_info "2. Setup-Vana"
    print_info "3. Create-Wallet"
    print_info "4. Restore-Wallet"
    print_info "5. Wallet-Address"
    print_info "6. Generate-Key"
    print_info "7. Contract-Deploy"
    print_info "8. Node-Setup"
    print_info "9. Connect-Node"
    print_info "10. Service-Status"
    print_info "11. Check-Logs"
    print_info "12. Stop-Node"
    print_info "13. Start-Node"
    print_info "14. Mining-Setup"
    print_info "15. Mining-Start"
    print_info "16. Mining-Stop"
    print_info "17. Mining-Logs"
    print_info "18. Full-Setup-Delete"
    print_info "19. Exit"
    print_info "==============================="
    print_info " Created By : CB-Master "
    print_info "==============================="
    print_info ""
    
    read -p "Enter your choice (1 or 19): " user_choice

    case $user_choice in
        1)
            install_dependency
            ;;
        2)
            setup_vana
            ;;
        3) 
            create_wallet
            ;;
        4)
            restore_wallet
            ;;
        5) 
            wallet_address
            ;;
        6)
            generate_key
            ;;
        7)
            contract_deploy
            ;;
        8)
            node_setup
            ;;
        9) 
            connect_node
            ;;
        10)
            connect_status
            ;;
        11)
            check_logs
            ;;
        12)
            stop_node
            ;;
        13)
            start_node
            ;;
        14)
            mining_setup
            ;;
        15)
            mining_logs
            ;;
        16)
            mining_stop
            ;;
        17) 
            mining_logs
            ;;
        18)
            delete_node
            ;;
        19)
            exit 0  # Exit the script after breaking the loop
            ;;
        *)
            print_error "Invalid choice. Please enter 1 or 19 : "
            ;;
    esac
}

# Call the uni_menu function to display the menu
master_fun
master
