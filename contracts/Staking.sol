//SPDC-License-Indentifier: MIT

pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

//custom error here which is more gas efficient
error Staking__TransferFailed();
error Staking_NeedsMoreThanZero();

contract Staking {
  //stored token is expensive to read and write
  //IERC20 is a interface with all the functions like erc20 but they are empty
  IERC20 public s_stakingToken;
  IERC20 public s_rewardsToken;

  uint256 public REWARD_RATE = 100;
  uint256 public s_totalSupply;
  uint256 public s_rewardPerTokenStored;
  uint256 public s_lastUpdateTime;

  //map address to how much they stake
  mapping(address => uint256) public s_balances;
  //map address to how much each address has been paid
  mapping(address => uint256) public s_userRewardPerTokenPaid;
  //map address to how much reward each address has to claim
  mapping(address => uint256) public s_rewards;

  modifier updateReward(address account) {
    //figure our the reward per token staked
    s_rewardPerTokenStored = rewardPerToken();
    s_lastUpdateTime = block.timestamp;
    //update how much reward in total each person has
    s_rewards[account] = earned(account);
    //
    s_userRewardPerTokenPaid[account] = s_rewardPerTokenStored;
    _;
  }

  modifier moreThanZero(uint256 amount) {
    if (amount == 0) {
      revert Staking_NeedsMoreThanZero();
    }
    _;
  }

  constructor(address stakingToken, address rewardsToken) {
    s_stakingToken = IERC20(stakingToken);
    s_rewardsToken = IERC20(rewardsToken);
  }

  function earned(address account) public view returns (uint256) {
    uint256 currentBalance = s_balances[account];
    // we need to know how much they have been paid already
    uint256 amountPaid = s_userRewardPerTokenPaid[account];
    uint256 currentRewardPerToken = rewardPerToken();
    uint256 pastRewards = s_rewards[account];

    uint256 _earned = ((currentBalance * (currentRewardPerToken - amountPaid)) /
      1e18) + pastRewards;
    return _earned;
  }

  //rewards are calculated based on how long its been during this
  //most recent snapshot
  function rewardPerToken() public view returns (uint256) {
    if (s_totalSupply == 0) {
      return s_rewardPerTokenStored;
    }
    //everytime we call stake or withdraw, the lastUpdateTime will be updated
    //this is added on top of the rewardPerTokenStored previously, so its constantly increasing
    return
      s_rewardPerTokenStored +
      (((block.timestamp - s_lastUpdateTime) * REWARD_RATE * 1e18) /
        s_totalSupply);
  }

  //here i am onlying 1 specific ERC20 token
  function stake(uint256 amount)
    external
    updateReward(msg.sender)
    moreThanZero(amount)
  {
    //here we are keeping track of how much a user has stake
    s_balances[msg.sender] = s_balances[msg.sender] + amount;
    //how much token we have in total in the contract ( staked )
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

  function withdraw(uint256 amount)
    external
    updateReward(msg.sender)
    moreThanZero(amount)
  {
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

  function claimReward() external updateReward(msg.sender) {
    // contract emit X tokens per seconds and disperse them to all token stakers in ratio
    uint256 reward = s_rewards[msg.sender];
    bool success = s_rewardsToken.transfer(msg.sender, reward);
    if (!success) {
      revert Staking__TransferFailed();
    }
  }
}
