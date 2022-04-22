import { ethers } from "hardhat";
import { tokenName, tokenSymbol, initialSupply, decimals } from "./config";


async function main() {

  const Token = await ethers.getContractFactory("RewardToken");
  const token = await Token.deploy(tokenName, tokenSymbol, initialSupply, decimals);

  await token.deployed();

  console.log("Token deployed to:", token.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
