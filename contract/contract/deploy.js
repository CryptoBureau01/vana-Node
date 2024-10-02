const { execSync } = require("child_process");
const fs = require("fs");
const readline = require("readline");
require("dotenv").config();
const { ethers } = require("ethers");

// Function to prompt user input
const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
});

const question = (query) => new Promise((resolve) => rl.question(query, resolve));

// Hardhat configuration in the same file
const hardhatConfig = `
require('dotenv').config();
require('@nomiclabs/hardhat-ethers');

module.exports = {
  defaultNetwork: "satori",
  networks: {
    satori: {
      url: process.env.SATORI_RPC_URL,
      accounts: [process.env.DEPLOYER_PRIVATE_KEY]
    }
  },
  solidity: "0.8.4"
};
`;

async function main() {
  // Step 1: Install dependencies
  console.log("Installing dependencies...");
  execSync("yarn install", { stdio: "inherit" });
  execSync("npm install", { stdio: "inherit" });

  // Step 2: Prompt the user for environment variables
  console.log("Please enter the following values:");

  const DEPLOYER_PRIVATE_KEY = await question("DEPLOYER_PRIVATE_KEY: ");
  const OWNER_ADDRESS = await question("OWNER_ADDRESS: ");
  const DLP_NAME = await question("DLP_NAME: ");
  const DLP_TOKEN_NAME = await question("DLP_TOKEN_NAME: ");
  const DLP_TOKEN_SYMBOL = await question("DLP_TOKEN_SYMBOL: ");
  const SATORI_RPC_URL = "https://rpc.satori.vana.org";

  // Step 3: Save these values in a .env file
  const envData = `
DEPLOYER_PRIVATE_KEY=${DEPLOYER_PRIVATE_KEY}
OWNER_ADDRESS=${OWNER_ADDRESS}
SATORI_RPC_URL=${SATORI_RPC_URL}
DLP_NAME=${DLP_NAME}
DLP_TOKEN_NAME=${DLP_TOKEN_NAME}
DLP_TOKEN_SYMBOL=${DLP_TOKEN_SYMBOL}
  `;
  fs.writeFileSync(".env", envData.trim());
  console.log("Environment variables saved to .env file.");

  // Step 4: Save hardhat.config.js
  fs.writeFileSync("hardhat.config.js", hardhatConfig);
  console.log("Hardhat configuration saved to hardhat.config.js");

  // Step 5: Create a simple deploy script inline (dlp-deploy.ts)
  const deployScript = `
  import { ethers } from "hardhat";

  async function main() {
    const [deployer] = await ethers.getSigners();
    console.log("Deploying contracts with account:", deployer.address);
    console.log("Account balance:", (await deployer.getBalance()).toString());

    const DLPToken = await ethers.getContractFactory("DLP");
    const dlpToken = await DLPToken.deploy(
      process.env.DLP_TOKEN_NAME, 
      process.env.DLP_TOKEN_SYMBOL, 
      process.env.OWNER_ADDRESS
    );
    await dlpToken.deployed();

    console.log("DLP Token deployed to:", dlpToken.address);

    // Call updateFileRewardDelay (for example) and set it to 0
    let tx = await dlpToken.updateFileRewardDelay(0);
    await tx.wait();
    console.log("updateFileRewardDelay set to 0");

    // Call addRewardsForContributors with 1 million tokens
    tx = await dlpToken.addRewardsForContributors(ethers.utils.parseEther("1000000"));
    await tx.wait();
    console.log("addRewardsForContributors called with 1 million tokens");
  }

  main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });
  `;
  fs.writeFileSync("scripts/dlp-deploy.ts", deployScript);
  console.log("Deploy script saved to scripts/dlp-deploy.ts");

  // Step 6: Deploy the contract
  console.log("Deploying contract...");
  execSync("npx hardhat run scripts/dlp-deploy.ts --network satori", { stdio: "inherit" });

  rl.close();
}

main().catch((err) => {
  console.error(err);
  rl.close();
});
