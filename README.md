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

### python3-pip install 
```
sudo apt install python3-pip
```

### latest versions of pip, setuptools, and wheel
```
python3 -m pip install --upgrade pip setuptools wheel
```

### Install build dependencies
```
sudo apt install build-essential
```

### Install virtualenv
```
pip install virtualenv
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
   virtualenv venv
   ```

   ```bash
   source venv/bin/activate
   ```
   
   ```bash
   pip install vana
   ```

6. Create a wallet:
   ```bash
   vanacli wallet create --wallet.name default --wallet.hotkey default
   ```
   This creates two key pairs:
   - Coldkey: for human-managed transactions (like staking)
   - Hotkey: for validator-managed transactions (like submitting scores)

   Follow the prompts to set a secure password. Save the mnemonic phrases securely; you'll need these to recover your wallet if needed.

7. Add Satori Testnet to Metamask:
   - Network name: Satori Testnet
   - RPC URL: https://rpc.satori.vana.org
   - Chain ID: 14801
   - Currency: VANA

8. Export your private keys. Follow the prompts and securely save the displayed private keys:

   ### Cold wallet Private Key
   - Enter wallet name (default):
   - Enter key type [coldkey/hotkey] (coldkey): coldkey
   - Enter your coldkey password:
   - Your coldkey private key:

   ```bash
   vanacli wallet export_private_key
   ```

   ### Hotkey wallet private key
   - Enter wallet name (default):
   - Enter key type [coldkey/hotkey] (coldkey): hotkey
   - Your hotkey private key:

   
   ```bash
   vanacli wallet export_private_key
   ```

10. Import your coldkey and hotkey addresses to Metamask:
   - Click your account icon in MetaMask and select "Import Account"
   - Select "Private Key" as the import method
   - Paste the private key for your coldkey
   - Repeat the process for your hotkey

11. Fund both addresses with testnet VANA:
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

### 1. Clone the DLP Smart Contract repo:
   ```bash
   cd ..
   ```
   ```
   git clone https://github.com/vana-com/vana-dlp-smart-contracts.git
   ```
   ```
   cd vana-dlp-smart-contracts
   ```
   ```
   npm install --global yarn --force
   ```

    
### 2. Install dependencies:
   ```bash
   yarn install
   ```

### 3. Export your private key from Metamask (see [official instructions](https://support.metamask.io/managing-my-wallet/secret-recovery-phrase-and-private-keys/how-to-export-an-accounts-private-key)).

### 4. Edit the `.env` file in the `vana-dlp-smart-contracts` directory:

   ```bash
   sudo nano .env
   ```

   ```
   DEPLOYER_PRIVATE_KEY=0x... (your coldkey private key)
   OWNER_ADDRESS=0x... (your coldkey address)
   SATORI_RPC_URL=https://rpc.satori.vana.org
   DLP_NAME=CryptoBuro
   DLP_TOKEN_NAME=Buro
   DLP_TOKEN_SYMBOL=CB
   ```

### 5. Deploy contracts:
   ```bash
   npx hardhat deploy --network satori --tags DLPDeploy
   ```
   Note the deployed addresses for DataLiquidityPool and DataLiquidityPoolToken.

### 6. Congratulations, you've deployed the DLP smart contracts! You can confirm they're up by searching the address for each on the block explorer: 
 https://satori.vanascan.io/address/<DataLiquidityPool\>.

### 7. Configure the DLP contract:
    Visit https://satori.vanascan.io/address/<DataLiquidityPool address
    - Go to "Write proxy" tab
    - Connect your wallet
    - Call updateFileRewardDelay and set it to 0
    - Call addRewardsForContributors with 1000000000000000000000000 (1 million tokens )

### 8. Update the `.env` file in the `vana-dlp-chatgpt` directory:
   ```
   DLP_SATORI_CONTRACT=0x... (DataLiquidityPool address)
   DLP_TOKEN_SATORI_CONTRACT=0x... (DataLiquidityPoolToken address)
   PRIVATE_FILE_ENCRYPTION_PUBLIC_KEY_BASE64=... (content of public_key_base64.asc)
   ```

After completing these steps, proceed to the [Validator Setup](#validator-setup) section.


# Validator Setup

Follow these steps whether you're a DLP creator or joining an existing DLP.

Before you start, ensure you have gone through the [Setup](#setup) section.

### Required Information

For non-DLP creators, request from the DLP creator:
- DLP contract address (DataLiquidityPool)
- DLP token contract address (DataLiquidityPoolToken)
- Public key for the DLP validator network (`public_key.asc`)
- Base64-encoded private key for the DLP validator network (`private_key_base64.asc`)

### Setup

1. Ensure you're in the `vana-dlp-chatgpt` directory:
   ```bash
   cd vana-dlp-chatgpt
   ```

2. If you're a non-DLP creator, edit the `.env` file with the information provided by the DLP creator:
   ```
   DLP_SATORI_CONTRACT=0x... (DataLiquidityPool address)
   DLP_TOKEN_SATORI_CONTRACT=0x... (DataLiquidityPoolToken address)
   PRIVATE_FILE_ENCRYPTION_PUBLIC_KEY_BASE64=... (base64-encoded private key--yes, PUBLIC is a misnomer)
   ```

### Fund Validator with DLP Tokens

For DLP creators:
1. Import DLP token to Metamask using `<DataLiquidityPoolToken address>`
2. Send 10 tokens to your coldkey address

For non-DLP creators:
1. Request DLP tokens from the DLP creator
2. Once received, ensure they are in your coldkey address



### Register as a Validator

Note that the following commands use the local chatgpt vanacli tool that supports custom `dlp` commands.

### Register setup:
   ```bash
   ./vanacli dlp register_validator --stake_amount 10
   ```


### Run Validator Node

Start the validator node:

```bash
poetry run python -m chatgpt.nodes.validator
```

Monitor the logs for any errors. If set up correctly, you'll see the validator waiting for new files to verify.

### Test Your Validator

#### For the Public ChatGPT DLP

If you're validating in the [Public ChatGPT DLP](gptdatadao.org), follow these steps:

1. Visit the [official ChatGPT DLP UI](https://gptdatadao.org/claim).
2. Connect your wallet (must hold some VANA).
3. Follow the instructions on the UI to upload a file (to submit the `addFile` transaction).
4. Wait for your validator to process the file and write scores on-chain (`verifyFile` transaction).
5. Check the UI for a reward claiming dialog and test claiming rewards.


#### For Custom DLPs

If you're validating with your own or a custom DLP, follow these steps:

1. Visit [the demo DLP UI](https://dlp-ui.vercel.vana.com/claim/upload).
2. Connect your wallet (must hold some VANA).
3. Use the gear icon to set the DLP contract address and public encryption key.
4. Upload a file (to submit the `addFile` transaction).
5. In the console logs, note the uploaded file URL and encryption key (you can also add files manually via https://satori.vanascan.io/address/<DataLiquidityPool address>?tab=write_contract).
6. Wait for your validator to process the file and write scores on-chain (`verifyFile` transaction).
7. Check the UI for a reward claiming dialog and test claiming rewards.



## Troubleshooting

If you encounter issues:
- Ensure all prerequisites are correctly installed
- Double-check your `.env` file contents in both repositories
- Verify your wallet has sufficient VANA and DLP tokens in both coldkey and hotkey addresses
- Check the validator logs for specific error messages

For further assistance, please join our [Discord community](https://discord.com/invite/Wv2vtBazMR).


Join our Telegram Discussion [Telegram community](https://t.me/BuroGroupChat).


