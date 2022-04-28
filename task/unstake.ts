import { task } from "hardhat/config";
import "@nomiclabs/hardhat-waffle";
import { stakingContractAddress } from "../config";

task("unstake", "unstake tokens")
.addOptionalParam("amount", "amount of token to unstake")
.setAction(async (taskArgs, hre) => {
    const Staking = await hre.ethers.getContractAt("Staking", stakingContractAddress);
    const tx = await Staking.unstake(taskArgs.amount);
    await tx.wait();
    console.log(`${taskArgs.amount} unstaked`);
});