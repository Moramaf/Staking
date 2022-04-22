import { HardhatUserConfig, task } from "hardhat/config";
import "@nomiclabs/hardhat-waffle";
import { stakingContractAddress } from "./config";


task("claim", "claim reward")
.setAction(async (hre) => {
    const Token = (await hre.ethers.getContractFactory("Staking"));
    const token = await Token.attach(stakingContractAddress);
    const tx = token.claim();
    await tx.wait();
    console.log("Reward claimed");
});