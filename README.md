# Vana Node

# Vana DLP Validator Node Setup Guide

Vana raised $25M from Tier1 investors. You can run a validator on your own hardware or on a cloud provider like GCP and AWS, ensuring the quality of data in the pool and earning rewards accordingly.


## System Requirements

| **Hardware** | **Minimum Requirement** |
|--------------|-------------------------|
| **CPU**      | 1 Cores                 |
| **RAM**      | 6-8 GB                  |
| **Disk**     | 10 GB                   |
| **Bandwidth**| 10 MBit/s               |



## Follow our TG : https://t.me/CryptoBuroOfficial


# Setup dependencies

## 1. Install Git
```
sudo apt update
sudo apt install git -y
```

### Git Version Check
```
git --version
```

## 2. Install Python 3.11+

**Ubuntu might not have the latest Python version by default, so first, add the deadsnakes PPA (which contains newer Python versions):**

```
sudo apt update
sudo apt install software-properties-common -y
sudo add-apt-repository ppa:deadsnakes/ppa
```

### Now, install Python 3.11:
```
sudo apt update
sudo apt install python3.11 python3.11-venv python3.11-dev -y
```

### Set Python 3.11 as the default version
```
sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1
```

### Check Python3 Version 
```
python3 --version
```

## 3. Install Poetry
```
curl -sSL https://install.python-poetry.org | python3 -
```

### Set Poetry Path
```
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### Check Poetry Version
```
poetry --version
```

## 4. Install Node.js and npm

**First, add the NodeSource repository for Node.js 18.x (the latest LTS version):**
```
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
```

### Install Node.js
```
sudo apt install -y nodejs
```

### Check Npm && Node Version 
```
node -v
npm -v
```



# Node Setup Steps

1. Clone the repository:
   ```bash
   git clone https://github.com/vana-com/vana-dlp-chatgpt.git
   cd vana-dlp-chatgpt
   ```

2. Create your `.env` file:
   ```bash
   cp .env.example .env
   ```
   We'll populate this file later with DLP-specific information.

3. Install dependencies:
   ```bash
   poetry install
   ```

4. Install Vana CLI:
   ```bash
   # To install vanacli system-wide, run the following command:
   pip install vana
   ```

5. Create a wallet:
   ```bash
   vanacli wallet create --wallet.name default --wallet.hotkey default
   ```
   This creates two key pairs:
   - Coldkey: for human-managed transactions (like staking)
   - Hotkey: for validator-managed transactions (like submitting scores)

   Follow the prompts to set a secure password. Save the mnemonic phrases securely; you'll need these to recover your wallet if needed.

6. Add Satori Testnet to Metamask:
   - Network name: Satori Testnet
   - RPC URL: https://rpc.satori.vana.org
   - Chain ID: 14801
   - Currency: VANA

7. Export your private keys. Follow the prompts and securely save the displayed private keys:
   ```bash
   vanacli wallet export_private_key
   Enter wallet name (default):
   Enter key type [coldkey/hotkey] (coldkey): coldkey
   Enter your coldkey password:
   Your coldkey private key:
   ```
   ```bash
   vanacli wallet export_private_key
   Enter wallet name (default):
   Enter key type [coldkey/hotkey] (coldkey): hotkey
   Your hotkey private key:
   ```

8. Import your coldkey and hotkey addresses to Metamask:
   - Click your account icon in MetaMask and select "Import Account"
   - Select "Private Key" as the import method
   - Paste the private key for your coldkey
   - Repeat the process for your hotkey

9. Fund both addresses with testnet VANA:
   - Visit https://faucet.vana.org
   - Connect your Metamask wallet
   - Request VANA for both your coldkey and hotkey addresses

   Note: you can only use the faucet once per day. Use the testnet faucet available at https://faucet.vana.org to fund your wallets, or ask a VANA holder to send you some test VANA tokens.

Always keep your private keys and mnemonic phrases secure. Never share them with anyone.



# Creating a DLP

If you're joining an existing DLP as a validator, skip to the [Validator Setup](#validator-setup) section.

Before you start, ensure you have gone through the [Setup](#setup) section.

### Generate Encryption Keys

1. Run the key generation script:
   ```bash
   ./keygen.sh
   ```
   This script generates RSA key pairs for file encryption/decryption in the DLP.

2. Follow the prompts to enter your name, email, and key expiration.

3. The script generates four files:
    - `public_key.asc` and `public_key_base64.asc` (for UI)
    - `private_key.asc` and `private_key_base64.asc` (for validators)


# Deploy DLP Smart Contracts

1. Clone the DLP Smart Contract repo:
   ```bash
   cd ..
   git clone https://github.com/vana-com/vana-dlp-smart-contracts.git
   cd vana-dlp-smart-contracts
   ```

2. Install dependencies:
   ```bash
   yarn install
   ```

3. Export your private key from Metamask (see [official instructions](https://support.metamask.io/managing-my-wallet/secret-recovery-phrase-and-private-keys/how-to-export-an-accounts-private-key)).

4. Edit the `.env` file in the `vana-dlp-smart-contracts` directory:
   ```
   DEPLOYER_PRIVATE_KEY=0x... (your coldkey private key)
   OWNER_ADDRESS=0x... (your coldkey address)
   SATORI_RPC_URL=https://rpc.satori.vana.org
   DLP_NAME=CryptoBuro
   DLP_TOKEN_NAME=Buro
   DLP_TOKEN_SYMBOL=CB
   ```

5. Deploy contracts:
   ```bash
   npx hardhat deploy --network satori --tags DLPDeploy
   ```
   Note the deployed addresses for DataLiquidityPool and DataLiquidityPoolToken.

6. Congratulations, you've deployed the DLP smart contracts! You can confirm they're up by searching the address for each on the block explorer: https://satori.vanascan.io/address/<DataLiquidityPool\>.
