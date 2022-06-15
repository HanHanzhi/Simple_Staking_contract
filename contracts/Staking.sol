//SPDC-License-Indentifier: MIT

pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

//custom error here which is more gas efficient
error Staking__TransferFailed();

contract Staking {
  //stored token is expensive to read and write
  //IERC20 is a interface with all the functions like erc20 but they are empty
  IERC20 public s_stakingToken;

  //map address to how much they stake
  mapping(address => uint256) public s_balances;

  uint256 public s_totalSupply;

  constructor(address stakingToken) {
    s_stakingToken = IERC20(stakingToken);
  }

  //here i am onlying 1 specific ERC20 token
  function stake(uint256 amount) external {
    //here we are keeping track of how much a user has stake
    s_balances[msg.sender] = s_balances[msg.sender] + amount;
    //how much token we have in total in the contract
    s_totalSupply = s_totalSupply + amount;
    //transfer the token to this current staking contract (using transferFrom in IERC20)
    bool success = s_stakingToken.transferFrom(
      msg.sender,
      address(this),
      amount
    );
    //require(success, "Failed");
    if (!success) {
      //this revert will reset al the changes done above, same as 'require'
      revert Staking__TransferFailed();
    }
  }

  function withdraw(uint256 amount) external {
    s_balances[msg.sender] = s_balances[msg.sender] - amount;
    s_totalSupply = s_totalSupply - amount;

    /*TransferFrom is when we are grabbing token from the user, but since we have 
    token in our contract now , we can use Transfer. Here we are transfering amount 
    to msg.sender*/
    //Same as s_stakingToken.transferFrom(address(this),msg.sender, amount)
    bool success = s_stakingToken.transfer(msg.sender, amount);
    if (!success) {
      revert Staking__TransferFailed();
    }
  }

  function claimReward() external {
    // contract emit X tokens per seconds and disperse them to all token stakers in ratio
  }
}
