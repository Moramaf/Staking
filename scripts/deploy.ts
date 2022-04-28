import { ethers } from "hardhat";
import { stakedTokenContractAddress, rewardTokenContractAddress } from "../config";


async function main() {

  const Token = await ethers.getContractFactory("Staking");
  const token = await Token.deploy(stakedTokenContractAddress,rewardTokenContractAddress);

  await token.deployed();

  console.log("Token deployed to:", token.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});