import { HardhatUserConfig, task } from "hardhat/config";
import "@nomiclabs/hardhat-waffle";
import { stakingContractAddress } from "./config";


task("stake", "transfer approved tokens to stake")
.addOptionalParam("amount", "amount of token to stake. Approve amont before")
.setAction(async (taskArgs, hre) => {
    const Token = (await hre.ethers.getContractFactory("Staking"));
    const token = await Token.attach(stakingContractAddress);
    const tx = token.stake(taskArgs.amount);
    await tx.wait();
    console.log(`${taskArgs.amount} staked`);
});