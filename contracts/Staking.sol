//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";


contract Staking is AccessControl {

    IERC20 public rewardToken;
    IERC20 public stakingToken;

    struct Balance {
        uint unclaimableBalance; // balance can not be claimed, lockup time dosn't over
        uint claimableBalance; // balance can be claimed, lockup time was over
        uint totalBalance;
        uint unstakeTime; //time when unstake is available
    }

    struct Reward {
        uint claimableReward; //reward can be claim
        uint rewardsPaid; // reward paid
        uint pendingRewards; //reward time does not over
        uint timeToReward;
    }

    mapping(address => Balance) public balances;
    mapping(address => Reward) public rewards;

    uint public rewardTime = 10; //minutes
    uint public lockUpTime = 20; //minutes
    uint public rewardRate = 20; //% of reward tokens
    
    uint public totalSupply;

    constructor(address _rewardToken, address _stakingToken) {
        stakingToken = IERC20(_stakingToken);
        rewardToken = IERC20(_rewardToken);
    }

    function stake(uint _amount) external updateBalance(msg.sender) updateReward(msg.sender) { //stake lp tokens 
        balances[msg.sender].totalBalance += _amount;
        balances[msg.sender].unclaimableBalance += _amount;
        balances[msg.sender].totalBalance += _amount;
        balances[msg.sender].unstakeTime = block.timestamp + lockUpTime * 1 minutes;
        rewards[msg.sender].pendingRewards += _amount*rewardRate/100;
        rewards[msg.sender].timeToReward = block.timestamp + rewardTime * 1 minutes;
        totalSupply += _amount;
        stakingToken.transferFrom(msg.sender, address(this), _amount); // необходимао approve в контракте токена
    }

    function claim() external updateBalance(msg.sender) updateReward(msg.sender) { //withdraw reward
        uint reward = rewards[msg.sender].claimableReward;
        require(reward>= 0, "Reward is not available");
        rewards[msg.sender].claimableReward = 0;
        stakingToken.transfer(msg.sender, reward);
    }

    function unstake(uint _amount) external updateBalance(msg.sender) updateReward(msg.sender) {
        require(balances[msg.sender].totalBalance > 0, "No tokens staked");
        uint unstakeAmount = balances[msg.sender].claimableBalance;
        require(unstakeAmount > 0, "Lockup time doesn't over");
        require(unstakeAmount > _amount, "Don't have enough tokens unstake");
        balances[msg.sender].totalBalance -= _amount;
        unstakeAmount -= _amount;
        rewardToken.transfer(msg.sender, _amount);
    }

    modifier updateReward(address _account) { //update information about accessible reward in current time
        if(balances[_account].totalBalance == 0) {
            _;
        } else {
            if(block.timestamp >= rewards[_account].timeToReward) {
                rewards[_account].claimableReward += rewards[_account].pendingRewards;
                rewards[_account].pendingRewards = 0;
                _;
            } else {
                _;
            }
        }
    }

    modifier updateBalance(address _account) {//update information about accessible balanse to unstake in current time
        if(balances[_account].totalBalance == 0) {
            _;
        } else {
            if(block.timestamp >= balances[_account].unstakeTime) {
                balances[_account].claimableBalance += balances[_account].unclaimableBalance;
                balances[_account].unclaimableBalance = 0;
                _;
            } else {
                _;
            }
        }
    }
        //admin functions:
    function changeRewardTime(uint _time) public onlyAdmin {
        rewardTime = _time;
    }
    function changeLockUpTime(uint _time) public onlyAdmin {
        lockUpTime = _time;
    }
     function changeRewardRate(uint _newRate) public onlyAdmin {
        rewardRate = _newRate;
    }
}