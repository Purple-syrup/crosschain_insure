const { ethers } = require("hardhat");

const networkConfig = {
    31337: {
        name: "hardhat",
        verseToken: "0x37D4203FaE62CCd7b1a78Ef58A5515021ED8FD84",
        verseFarm: "0x184a05E261f1a1167295032FF09F160759dacc2b",
        minimumAmount: ethers.utils.parseEther("0.01"),
        caller: "",
    },
    5: {
        name: "goerli",
        verseToken: "0x37D4203FaE62CCd7b1a78Ef58A5515021ED8FD84",
        verseFarm: "0x184a05E261f1a1167295032FF09F160759dacc2b",
        minimumAmount: ethers.utils.parseEther("0.01"),
        oracleid: "0x6888BdA6a975eCbACc3ba69CA2c80d7d7da5A344",
        jobid: "d220e5e687884462909a03021385b7ae",
        fee: "500000000000000000",
        token: "0x326C977E6efc84E512bB9C30f76E30c160eD06FB",
    },
    97: {
        name: "BNB",
        verseToken: "0x37D4203FaE62CCd7b1a78Ef58A5515021ED8FD84",
        verseFarm: "0x184a05E261f1a1167295032FF09F160759dacc2b",
        minimumAmount: ethers.utils.parseEther("0.01"),
        caller: "",
    },
    80001: {
        name: "Polygon",
        verseToken: "0x37D4203FaE62CCd7b1a78Ef58A5515021ED8FD84",
        verseFarm: "0x184a05E261f1a1167295032FF09F160759dacc2b",
        minimumAmount: ethers.utils.parseEther("0.01"),
        caller: "",
    },
    4002: {
        name: "fantom",
        verseToken: "0x37D4203FaE62CCd7b1a78Ef58A5515021ED8FD84",
        verseFarm: "0x184a05E261f1a1167295032FF09F160759dacc2b",
        minimumAmount: ethers.utils.parseEther("0.01"),
        caller: "",
    },
};

const developmentChains = ["hardhat", "localhost"];

module.exports = { networkConfig, developmentChains };
