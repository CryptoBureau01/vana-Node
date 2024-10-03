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

# Wallet creation or restoration
print_info "Wallet Setup"
echo "Choose an option:"
echo "1) Create a new wallet"
echo "2) Restore a wallet using mnemonic"

read -p "Enter your choice (1 or 2): " wallet_choice

if [ "$wallet_choice" -eq 1 ]; then
    # Create a new wallet
    print_info "Creating a new Vana wallet..."

    # Step=>1
    print_info "Step 1. Creating new wallet Phrase key..."
    print_info "Please follow the prompts to set a secure password and save the mnemonic phrases securely."
    
    vanacli wallet create --wallet.name default --wallet.hotkey default
    
    # Step=>2
    print_info "Step 2. Creating new Coldkey wallet privte key..."
    print_info "Enter wallet name (default): Press Enter "
    print_info "Enter key type [coldkey/hotkey] (coldkey): Type coldkey"
    print_info "Enter your coldkey password: Enter Your new Password"
    vanacli wallet export_private_key

    # Step=>3
    print_info "Step 3. Creating new Hotkey wallet privte key..."
    print_info "Enter wallet name (default): Press Enter "
    print_info "Enter key type [coldkey/hotkey] (coldkey): Type hotkey"
    print_info "Enter your coldkey password: Enter Your new Password"
    vanacli wallet export_private_key

    # Step=>4
    print_info "Now Please Verfiy Your Phrase/ Private Key/ Address..."

    # Restore coldkey wallet
    read -p "Enter your Coldkey Mnemonic Phrase: " COLDKEY_MNEMONIC
    vanacli wallet regen_coldkey --mnemonic "$COLDKEY_MNEMONIC"

    # Restore hotkey wallet
    read -p "Enter your Hotkey Mnemonic Phrase: " HOTKEY_MNEMONIC
    vanacli wallet regen_hotkey --mnemonic "$HOTKEY_MNEMONIC"
    
    # Prompt user to input private keys manually
    print_info "Please enter your private keys manually:"

    read -p "Enter Coldkey Private Key: " COLDKEY_PRIVATE_KEY
    read -p "Enter Hotkey Private Key: " HOTKEY_PRIVATE_KEY

    print_info "Please import your both private keys in metamask && copy both your address :"

    # Prompt user to input wallet addresses manually
    print_info "Please enter your wallet addresses manually:"

    read -p "Enter Coldkey Address: " COLDKEY_ADDRESS
    read -p "Enter Hotkey Address: " HOTKEY_ADDRESS


    # Step=>5
    # Display the inputted private keys
    print_info "You have entered the following private keys:"
    print_info "Coldkey Private Key: $COLDKEY_PRIVATE_KEY"
    print_info "Hotkey Private Key: $HOTKEY_PRIVATE_KEY"

    # Display the inputted wallet addresses
    print_info "You have entered the following wallet addresses:"
    print_info "Coldkey Address: $COLDKEY_ADDRESS"
    print_info "Hotkey Address: $HOTKEY_ADDRESS"


    # Step=>6
    # Save the private keys and addresses to private-data.txt
    PRIVATE_DATA_FILE="/root/vana-Node/private-data.txt"

    {
        # ColdKey Data
        echo "Coldkey Address: $COLDKEY_ADDRESS"
        echo "Coldkey Private Key: $COLDKEY_PRIVATE_KEY"
        

        # HotKey Data
        echo "Hotkey Address: $HOTKEY_ADDRESS"
        echo "Hotkey Private Key: $HOTKEY_PRIVATE_KEY"
        
     } > "$PRIVATE_DATA_FILE"

    print_info "Private data has been saved to $PRIVATE_DATA_FILE"

    print_info "Wallet Creating successfully."

    
elif [ "$wallet_choice" -eq 2 ]; then

    # Step=>1
    # Restore wallets using mnemonics
    print_info "Restoring coldkey and hotkey wallets using mnemonic phrases."

    # Restore coldkey wallet
    read -p "Enter your Coldkey Mnemonic Phrase: " COLDKEY_MNEMONIC
    vanacli wallet regen_coldkey --mnemonic "$COLDKEY_MNEMONIC"

    # Restore hotkey wallet
    read -p "Enter your Hotkey Mnemonic Phrase: " HOTKEY_MNEMONIC
    vanacli wallet regen_hotkey --mnemonic "$HOTKEY_MNEMONIC"

    # Prompt user to input private keys manually
    print_info "Please enter your private keys manually:"

    read -p "Enter Coldkey Private Key: " COLDKEY_PRIVATE_KEY
    read -p "Enter Hotkey Private Key: " HOTKEY_PRIVATE_KEY

    # Prompt user to input wallet addresses manually
    print_info "Please enter your wallet addresses manually:"

    read -p "Enter Coldkey Address: " COLDKEY_ADDRESS
    read -p "Enter Hotkey Address: " HOTKEY_ADDRESS


    # Step=>2
    # Display the inputted private keys
    print_info "You have entered the following private keys:"
    print_info "Coldkey Private Key: $COLDKEY_PRIVATE_KEY"
    print_info "Hotkey Private Key: $HOTKEY_PRIVATE_KEY"

    # Display the inputted wallet addresses
    print_info "You have entered the following wallet addresses:"
    print_info "Coldkey Address: $COLDKEY_ADDRESS"
    print_info "Hotkey Address: $HOTKEY_ADDRESS"


    # Step=>3
    # Save the private keys and addresses to private-data.txt
    PRIVATE_DATA_FILE="/root/vana-Node/private-data.txt"

    {
        # ColdKey Data
        echo "Coldkey Address: $COLDKEY_ADDRESS"
        echo "Coldkey Private Key: $COLDKEY_PRIVATE_KEY"
        

        # HotKey Data
        echo "Hotkey Address: $HOTKEY_ADDRESS"
        echo "Hotkey Private Key: $HOTKEY_PRIVATE_KEY"
        
     } > "$PRIVATE_DATA_FILE"

    print_info "Private data has been saved to $PRIVATE_DATA_FILE"

    print_info "Wallet restoration completed. Please verify your coldkey and hotkey wallets."
else
    print_error "Invalid choice. Exiting..."
    exit 1
fi


# Generate Encryption Keys

print_info "Generating Encryption Keys..."
chmod +x keygen.sh
./keygen.sh

# Copy encryption keys to the current folder
print_info "Copying encryption keys to the current folder..."
sudo cp /root/vana-Node/vana-dlp-chatgpt/public_key.asc /root/vana-Node
sudo cp /root/vana-Node/vana-dlp-chatgpt/public_key_base64.asc /root/vana-Node
sudo cp /root/vana-Node/vana-dlp-chatgpt/private_key.asc /root/vana-Node
sudo cp /root/vana-Node/vana-dlp-chatgpt/private_key_base64.asc /root/vana-Node



# Display output 
print_info "Process completed!"
print_info "Encryption keys successfully import."
print_info "Coldkey and Hotkey private keys exported."
