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


# Setup

 ### Clone the repository

  ```bash
   git clone https://github.com/CryptoBuroMaster/vana-Node.git && cd vana-Node
  ```


 ### You can give both files execute permissions together using a single chmod command.

  ```bash
   chmod +x buro-deploy.sh buro-setup.sh
  ```


 ## Run the setup script 
 
  ```bash
   ./buro-setup.sh
  ```


**Final Output**

- Private.json will store the Coldkey and Hotkey private keys.
- The encryption keys will be saved as:
  - public_key.asc
  - public_key_base64.asc
  - private_key.asc
  - private_key_base64.asc





# Deploy DLP Smart Contracts















### 6. Congratulations, you've deployed the DLP smart contracts! You can confirm they're up by searching the address for each on the block explorer: 
 https://satori.vanascan.io/address/<DataLiquidityPool\>.

### 7. Configure the DLP contract:
    Visit https://satori.vanascan.io/address/<DataLiquidityPool address
    - Go to "Write proxy" tab
    - Connect your wallet
    - Call updateFileRewardDelay and set it to 0
    - Call addRewardsForContributors with 1000000000000000000000000 (1 million tokens )


After completing these steps, proceed to the [Validator Setup](#validator-setup) section.


# Validator Setup

Follow these steps whether you're a DLP creator or joining an existing DLP.

Before you start, ensure you have gone through the [Setup](#Setup) section.

## Setup
### Ensure you're in the `vana-dlp-chatgpt` directory:
   ```bash
   cd ..
   ```
   ```bash
   cd vana-dlp-chatgpt
   ```
   


### Update the `.env` file in the `vana-dlp-chatgpt` directory:

   ```bash
   sudo nano .env
   ```

   ```
   DLP_SATORI_CONTRACT=0x... (DataLiquidityPool address)
   DLP_TOKEN_SATORI_CONTRACT=0x... (DataLiquidityPoolToken address)
   PRIVATE_FILE_ENCRYPTION_PUBLIC_KEY_BASE64=... (content of public_key_base64.asc)
   ```
### Fund Validator with DLP Tokens

For DLP creators:
1. Import DLP token to Metamask using `<DataLiquidityPoolToken address>`
2. Send 10 tokens to your coldkey address


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


