require("@nomiclabs/hardhat-waffle");
require("dotenv").config();

const { DEPLOYER_PRIVATE_KEY, SATORI_RPC_URL } = process.env;

module.exports = {
  solidity: "0.8.0",
  networks: {
    satori: {
      url: SATORI_RPC_URL,
      accounts: [`0x${DEPLOYER_PRIVATE_KEY}`],
    },
  },
  paths: {
    sources: "./contracts",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts",
  },
};
