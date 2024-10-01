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


   
