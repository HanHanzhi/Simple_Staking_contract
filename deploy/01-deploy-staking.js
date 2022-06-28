/*const { ethers, upgrades } = require("hardhat");
async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  const weiAmount = (await deployer.getBalance()).toString();

  console.log("Account123 balance:", await ethers.utils.formatEther(weiAmount));

  const rewardToken = await ethers.getContract("RewardToken");

  // make sure to replace the "GoofyGoober" reference with your own ERC-20 name!
  const Staking = await ethers.getContractFactory("Staking");

  const staking = await Staking.deploy(
    rewardToken.address,
    rewardToken.address
  );

  await staking.deployed();

  console.log("Stacking address:", token.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });*/

const { ethers } = require("hardhat");

module.exports = async ({ getNamedAccounts, deployments }) => {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();
  const rewardToken = await ethers.getContract("RewardToken");
  const staking = await deploy("Staking", {
    from: deployer,
    args: [rewardToken.address, rewardToken.address],
    log: true,
  });
};
module.exports.tags = ["all", "rewardToken"];
