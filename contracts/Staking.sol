//SPDC-License-Indentifier: MIT

pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

//custom error here which is more gas efficient
error Staking__TransferFailed();

contract Staking {
  //stored token is expensive to read and write
  //IERC20 is a interface with all the functions like erc20 but they are empty
  IERC20 public stored_stakingToken;

  //map address to how much they stake
  mapping(address => uint256) public stored_balances;

  uint256 public stored_totalSupply;

  constructor(address stakingToken) {
    stored_stakingToken = IERC20(stakingToken);
  }

  //here i am onlying 1 specific ERC20 token
  function stake(uint256 amount) external {
    //here we are keeping track of how much a user has stake
    stored_balances[msg.sender] = stored_balances[msg.sender] + amount;
    //how much token we have in total
    stored_totalSupply = stored_totalSupply + amount;
    //transfer the token to this current staking contract (using transferFrom in IERC20)
    bool success = stored_stakingToken.transferFrom(
      msg.sender,
      address(this),
      amount
    );
    //require(success, "Failed");
    if (!success) {
      revert Staking__TransferFailed();
    }
  }
}
