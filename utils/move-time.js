const { network } = require("hardhat");

async function moveTime(amount) {
  console.log("Moving blocks...");
  await network.provider.send("evm_increaseTime", [amount]);
  console.log("Moved forward in time %d seconds", amount);
}

module.exports = {
  moveTime,
};
