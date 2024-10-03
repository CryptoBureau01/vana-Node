#!/bin/bash

# Create wallet
echo "Creating wallet..."

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
