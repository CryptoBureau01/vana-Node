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
   chmod +x buro-setup.sh buro-moksha-contract.sh buro-moksha-node.sh
  ```


# Step 1. DLP Wallet Setup :
 ## Run the wallet setup script 
 
  ```bash
   ./buro-setup.sh
  ```


**Note :**


**Final Output**

- Private.json will store the Coldkey and Hotkey private keys.
- The encryption keys will be saved as:
  - public_key.asc
  - public_key_base64.asc
  - private_key.asc
  - private_key_base64.asc





# Step 2. Deploy DLP Smart Contracts :
 ## Moksha Contract Deploy Script 
 
  ```bash
   ./buro-moksha-contract.sh
  ```

**Note :**

**Important Links:**

- Faucet, Contract Verify with ChatGpt, Moksha Explorer importent Link .
  - Faucet : https://faucet.vana.org
  - ChatGpt API : https://platform.openai.com/settings/profile?tab=api-keys
  - Moksha Explorer : https://moksha.vanascan.io/
 

# Step 3. DLP Validator Setup :
 ##  Moksha Validator Setup Script


```bash
   ./buro-moksha-node.sh
  ```

**Note :**









## Troubleshooting

If you encounter issues:
- Ensure all prerequisites are correctly installed
- Double-check your `.env` file contents in both repositories
- Verify your wallet has sufficient VANA and DLP tokens in both coldkey and hotkey addresses
- Check the validator logs for specific error messages

For further assistance, please join our [Discord community](https://discord.com/invite/Wv2vtBazMR).


Join our Telegram Discussion [Telegram community](https://t.me/BuroGroupChat).


