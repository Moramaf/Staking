import { HardhatUserConfig, task } from "hardhat/config";
import "@nomiclabs/hardhat-waffle";
import { stakingContractAddress } from "./config";


task("unstake", "unstake tokens")
.addOptionalParam("amount", "amount of token to unstake")
.setAction(async (taskArgs, hre) => {
    const Token = (await hre.ethers.getContractFactory("Staking"));
    const token = await Token.attach(stakingContractAddress);
    const tx = token.unstake(taskArgs.amount);
    await tx.wait();
    console.log(`${taskArgs.amount} unstaked`);
});