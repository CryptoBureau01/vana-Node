import { ethers } from "hardhat";

async function main() {
  // Get the contract factory
  const DLPContract = await ethers.getContractFactory("DLP"); // Replace "DLP" with your contract name

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
