//waffle is used for test
require("@nomiclabs/hardhat-waffle");
//hardhat-deploy is used for deployment
require("hardhat-deploy");

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: "0.8.7",
  namedAccounts: {
    deployer: {
      default: 0, // ethers(comes with hardhat) built in accounts at index 0
    },
  },
};
