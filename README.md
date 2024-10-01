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



# Follow our TG : https://t.me/CryptoBuroOfficial



### Setup Steps

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


   
