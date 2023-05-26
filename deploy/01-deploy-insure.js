const { network, ethers } = require("hardhat");
const fs = require("fs");
const {
    developmentChains,
    networkConfig,
} = require("../helper-hardhat-config");
require("dotenv").config();
const { verify } = require("../utils/verify");

module.exports = async ({ getNamedAccounts, deployments }) => {
    const { log, deploy } = deployments;
    const { deployer } = await getNamedAccounts();
    const chainId = network.config.chainId;

    let deployedContract = "DefiInsure";

    const helpers = networkConfig[chainId];
    let args = [
        helpers.verseToken,
        helpers.verseFarm,
        helpers.minimumAmount,
        helpers.oracleid,
        helpers.jobid,
        helpers.fee,
        helpers.token,
    ];
    console.log(args);
    log("---------------------------------------------------------------");

    log("deploying DefiInsure contract and waiting for confirmations");
    if (chainId == 5) {
        const contract = await deploy(deployedContract, {
            from: deployer,
            args: args,
            log: true,
            waitConfirmations: network.config.blockConfirmations || 1,
        });

        log(`contract deployed at ${contract.address}`);

        if (
            !developmentChains.includes(network.name) &&
            process.env.BLOCKSCAN_API
        ) {
            console.log(args);
            await verify(contract.address, args);
        }
    } else {
        console.log("skipped 5");
    }
};

module.exports.tags = ["all", "insure"];
