const chai = require("chai");
const { ethers, upgrades, deployments } = require("hardhat");
const { expect } = require("chai");
const { inputToConfig } = require("@ethereum-waffle/compiler");
const { moveBlocks } = require("../utils/move-blocks");
const { moveTime } = require("../utils/move-time");

const SECONDS_IN_A_DAY = 86400;

describe("Staking test", function () {
  let staking;
  let rewardToken;
  let deployer;
  let dai;
  let stakeAmount;
  let addr1;

  beforeEach(async function () {
    [deployer, addr1] = await ethers.getSigners();
    RewardToken = await ethers.getContractFactory("RewardToken");
    rewardToken = await RewardToken.deploy();
    Staking = await ethers.getContractFactory("Staking");
    staking = await Staking.deploy(rewardToken.address, rewardToken.address);
    stakeAmount = ethers.utils.parseEther("100000");
  });

  it("allows users to stake and earn rewards", async function () {
    await rewardToken.approve(staking.address, stakeAmount);
    await staking.stake(stakeAmount);
    const startingEarned = await staking.earned(deployer.address);
    console.log("Earned: %d", startingEarned);

    //movetime
    await moveTime(SECONDS_IN_A_DAY);
    await moveBlocks(1);
    const endingEarned = await staking.earned(deployer.address);
    console.log("Earned: %d after 1 day and 1 block", endingEarned);
  });
});
