import { task } from "hardhat/config";
import "@nomiclabs/hardhat-waffle";
import { stakingContractAddress } from "../config";

task("claim", "claim reward")
.setAction(async (hre) => {
    const Staking = await hre.ethers.getContractAt("Staking", stakingContractAddress);
    const tx = await Staking.claim();
    await tx.wait();
    console.log("Reward claimed");
});