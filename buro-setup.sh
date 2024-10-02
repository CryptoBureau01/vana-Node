#!/bin/bash

# Function to print info messages
print_info() {
    echo -e "\e[32m$1\e[0m" # Green text
}

# Function to print error messages
print_error() {
    echo -e "\e[31m$1\e[0m" # Red text
}

# File to save wallet data
DATA_FILE="data.json"

# Wallet creation or restoration
print_info "Wallet Setup"
echo "Choose an option:"
echo "1) Create a new wallet"
echo "2) Restore a wallet using mnemonic"

read -p "Enter your choice (1 or 2): " wallet_choice

if [ "$wallet_choice" -eq 1 ]; then
    # Create a new wallet
    print_info "Creating a new Vana wallet..."
    vanacli wallet create --wallet.name default --wallet.hotkey default
    print_info "Please follow the prompts to set a secure password and save the mnemonic phrases securely."

    # Prompt user to input private keys manually
    read -p "Enter Coldkey Private Key: " COLDKEY_PRIVATE_KEY
    read -p "Enter Hotkey Private Key: " HOTKEY_PRIVATE_KEY

    # Prompt user to input wallet addresses manually
    read -p "Enter Coldkey Address: " COLDKEY_ADDRESS
    read -p "Enter Hotkey Address: " HOTKEY_ADDRESS

elif [ "$wallet_choice" -eq 2 ]; then
    # Restore wallets using mnemonics
    print_info "Restoring coldkey and hotkey wallets using mnemonic phrases."

    # Restore coldkey wallet
    read -p "Enter your Coldkey Mnemonic Phrase: " COLDKEY_MNEMONIC
    vanacli wallet regen_coldkey --mnemonic "$COLDKEY_MNEMONIC"

    # Restore hotkey wallet
    read -p "Enter your Hotkey Mnemonic Phrase: " HOTKEY_MNEMONIC
    vanacli wallet regen_hotkey --mnemonic "$HOTKEY_MNEMONIC"

    print_info "Wallet restoration completed. Please verify your coldkey and hotkey wallets."

    # Prompt user to input private keys manually
    read -p "Enter Coldkey Private Key: " COLDKEY_PRIVATE_KEY
    read -p "Enter Hotkey Private Key: " HOTKEY_PRIVATE_KEY

    # Prompt user to input wallet addresses manually
    read -p "Enter Coldkey Address: " COLDKEY_ADDRESS
    read -p "Enter Hotkey Address: " HOTKEY_ADDRESS

else
    print_error "Invalid choice. Exiting..."
    exit 1
fi

# Prepare JSON data
json_data=$(cat <<EOF
{
  "coldkey_private": "$COLDKEY_PRIVATE_KEY",
  "hotkey_private": "$HOTKEY_PRIVATE_KEY",
  "coldkey_address": "$COLDKEY_ADDRESS",
  "hotkey_address": "$HOTKEY_ADDRESS"
}
EOF
)

# Save data to data.json
echo "$json_data" > "$DATA_FILE"
print_info "Wallet data saved to $DATA_FILE."

# Display the inputted private keys and addresses
print_info "Coldkey Private Key: $COLDKEY_PRIVATE_KEY"
print_info "Hotkey Private Key: $HOTKEY_PRIVATE_KEY"
print_info "Coldkey Address: $COLDKEY_ADDRESS"
print_info "Hotkey Address: $HOTKEY_ADDRESS"

# Prompt user to add wallets to MetaMask and fund with testnet VANA
print_info "Please add your coldkey and hotkey addresses to MetaMask and fund them with testnet VANA from https://faucet.vana.org"
print_info "Press Enter after you have funded your wallets..."
read -p ""

# Generate Encryption Keys
print_info "Generating encryption keys..."
chmod +x keygen.sh
./keygen.sh

# Move generated encryption keys files to the current folder
echo "Moving generated encryption key files to current folder..."
mv public_key.asc public_key_base64.asc private_key.asc private_key_base64.asc .

# Display output for private keys and generated files
echo "Process completed!"
echo "Coldkey and Hotkey private keys saved in data.json."
echo "Encryption keys saved in the current folder: public_key.asc, public_key_base64.asc, private_key.asc, private_key_base64.asc."
