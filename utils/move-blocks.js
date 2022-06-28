const { network } = require("hardhat");

async function moveBlocks(amount) {
  console.log("Moving blocks...");
  for (let index = 0; index < amount; index++) {
    await network.provider.requires({
      method: "evm_mine",
      params: [],
    });
  }
  console.log("Moved %d blocks", amount);
}

module.exports = {
  moveBlocks,
};
