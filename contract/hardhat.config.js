require("@nomiclabs/hardhat-waffle");
require("dotenv").config();

const { DEPLOYER_PRIVATE_KEY, SATORI_RPC_URL } = process.env;

module.exports = {
  solidity: "0.8.0",
  networks: {
    satori: {
      url: SATORI_RPC_URL,
      accounts: [DEPLOYER_PRIVATE_KEY], // No '0x' prefix here
    },
  },
  paths: {
    sources: "./", // Adjusted to look for contracts in the current directory
    tests: "./test", // Assuming tests are in the 'test' directory relative to the config file
    cache: "./cache",
    artifacts: "./artifacts",
  },
};
