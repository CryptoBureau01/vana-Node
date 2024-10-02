require("@nomiclabs/hardhat-waffle");
require("dotenv").config();

const { DEPLOYER_PRIVATE_KEY, SATORI_RPC_URL } = process.env;

async function main() {
  // Get the contract factory
  const DLPContract = await ethers.getContractFactory("DataLiquidityPoolImplementation"); // Use the correct contract name here

  // Deploy the contract
  const dlp = await DLPContract.deploy(); // Pass constructor arguments if needed
  await dlp.deployed();

  console.log("DLP Contract deployed to:", dlp.address);
}

// Handle errors
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
