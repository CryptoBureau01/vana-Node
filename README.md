# Vana Node

# Vana DLP Validator Node Setup Guide

Vana raised $25M from Tier1 investors. You can run a validator on your own hardware or on a cloud provider like GCP and AWS, ensuring the quality of data in the pool and earning rewards accordingly.

**DLP Incentives**

[Data Liquidity Pools (DLPs)](https://docs.vana.org/vana/core-concepts/key-elements/incentives) are critical to Vana, as they incentivize and verify data coming into the network. Our core strategy is to gather the highest quality data, build the best AI models, and monetize them, providing a programmable way to work with user-owned data and build the frontiers of decentralized AI. 

Site : [Vana](https://www.vana.org/) | Docs : [Vana Docs](https://docs.oceanprotocol.com/) | X : [Vana Twitter](https://x.com/withvana) |


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


 ## Note :

   - This script automates the setup of essential dependencies and the Vana wallet creation or restoration process. It performs the following key actions:

  - **System Updates :**
      - Updates and upgrades the system's package list and installed packages.

  - **Installations :**
      - Git: Installs Git and verifies the installation.
      - Python 3.11: Installs Python 3.11, necessary libraries, and sets it as the default Python version.
      - pip: Installs and upgrades Python's pip package manager.
      - Build-essential: Installs essential build dependencies for compiling software.
      - virtualenv: Installs virtualenv for Python virtual environment management.
      - Poetry: Installs the Poetry package manager for managing dependencies.
      - Node.js and npm: Installs Node.js and its package manager, npm, using the NodeSource setup script.

  - **Cloning Vana DLP Repository :**
      - Clones the Vana DLP project from GitHub and enters the project directory.
      - Creates an .env file based on the example template.

  - **Setting up Virtual Environment & Vana CLI :**
      - Sets up a Python virtual environment.
      - Installs the Vana CLI and dependencies using Poetry.

  - **Wallet Creation/Restoration :**
      - Allows users to either create a new Vana wallet or restore one using a mnemonic phrase.
      - Automates the creation of coldkey and hotkey private keys, and stores them securely.
      - Prompts the user to manually input their private keys and addresses.
      - Saves wallet-related private data (addresses, private keys, mnemonic phrases) in private-data.txt.

  - **Encryption Key Generation :**
      - Generates encryption keys using a separate keygen.sh script.
      - Copies generated encryption keys to the appropriate directories.

  - **Final Output :**
      - Outputs the process completion message and provides details about the exported private keys and encryption keys. > private-data.txt



# Step 2. Deploy DLP Smart Contracts :
 ## Moksha Contract Deploy Script 
 
  ```bash
   ./buro-moksha-contract.sh
  ```

## Note :

  - **System Updates and Prerequisites Installation :**
      - Updates your system packages.
      - Installs essential prerequisites such as Git, curl, Python 3.11, and other necessary tools.

  - **Installing Required Tools :**
      - Installs key development tools like Git, Python, Poetry, Node.js, npm, Yarn, and more to ensure the environment is properly set up.

  - **Setting up Moksha DLP Smart Contracts :**
      - Clones the `vana-dlp-smart-contracts` repository from GitHub.
      - Installs all the required dependencies using Yarn.
      - Configures the `.env` file by filling in the provided contract details.

  - **Smart Contract Deployment :**
      - Deploys the Data Liquidity Pool (DLP) and DLP token contracts using Hardhat on the Moksha Testnet.

  - **Saving Contract Addresses :**
      - Prompts the user to enter the deployed contract addresses.
      - Saves the contract details, including the DLP and token contract addresses, in the `moksha-contract.txt` file for future reference.

  - **Display of Contract Information :**
      - Displays all the entered and saved contract information during the deployment process, ensuring the user has a clear view of the deployed contract details.


  - **Important Links :**

      - Faucet, Contract Verify with ChatGpt, Moksha Explorer importent Link .
         - Faucet : https://faucet.vana.org
         - ChatGpt API : https://platform.openai.com/settings/profile?tab=api-keys
         - Moksha Explorer : https://moksha.vanascan.io/
 

# Step 3. DLP Validator Setup :
 ##  Moksha Validator Setup Script


```bash
   ./buro-moksha-node.sh
  ```

 ## Note :
     - This script is designed to automate the setup and deployment process for running a Vana validator. It handles everything from updating the system, installing necessary tools, setting up Python, Git, and Node.js environments, to deploying Moksha DLP smart contracts. Below is a step-by-step explanation of how the script works:

  - **Function Definitions :**
      - `print_info`: Prints messages in green to provide informative updates to the user.
      - `print_error`: Prints messages in red to signal errors.

  - **Root Check :**
      - The script ensures that it is run with root (administrator) privileges. If not, it exits.

  - **System Updates and Installation of Basic Tools :**
      - The script updates the system and installs `git`, `python3.11`, `pip`, `Poetry`, `Node.js`, and other essential development tools like `build-essential`.

  - **Installation and Version Checks :**
      - After installing Python, Git, Poetry, Node.js, and npm, the script checks and prints their installed versions to ensure everything was set up correctly.

  - **Prompt for OpenAI API Key :**
      - The user is asked to input their OpenAI API key, which is necessary for the setup.

  - **Reading Contract Addresses :**
      - The script reads contract details (such as the DLP and DLP token contract addresses) from a file called `moksha-contract.txt`, which stores essential contract information.

  - **Display of Contract Information :**
      - The extracted contract information is displayed for user confirmation.

  - **Environment Configuration :**
      - It sets up the `.env` file with the necessary contract details and OpenAI API key for the Vana validator.

  - **Wallet Funding :**
      - The user is prompted to fund their coldkey and hotkey wallets with DLP tokens. Afterward, the script checks the wallet balance.
 
  - **Validator Registration :**
      - The script walks through registering and approving the validator, guiding the user step by step.
      - It automates the validator registration process by interacting with the `vanacli` commands.

  - **Systemd Service Setup :**
      - The script creates a `systemd` service for running the Vana validator, ensuring that it starts automatically on boot and continues running.
      - It checks the service status and prints logs in real-time.

  - **Final Output :**
      - The script concludes by checking the validator logs to confirm the process has been completed successfully.









# Troubleshooting

For further assistance, please join our [Discord community](https://discord.com/invite/Wv2vtBazMR).


Join our Telegram Discussion [Telegram community](https://t.me/BuroGroupChat).


