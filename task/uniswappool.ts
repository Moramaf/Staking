import { task } from "hardhat/config";
import "@nomiclabs/hardhat-waffle";
import { uniswapAddress, firstERC20Address, secondERC20Address } from "../config";

task("createPairUniSwap", "to create Uniswap pair")
.addOptionalParam("erc20TokenAddress", "tokens to swap")
.setAction(async (taskArgs, hre) => {
    const Uni = await hre.ethers.getContractAt("Uni", uniswapAddress);
    const tx = Uni.createPair(taskArgs.amount);
    await tx.wait();
    console.log(`${taskArgs.amount} unstaked`);
});