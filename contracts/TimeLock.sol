// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TimeLockedWallet {
    address public owner;
    uint256 public unlockTime;
    bool public fundsWithdrawn = false;

    event Deposited(uint256 amount, address indexed sender);
    event Withdrawn(uint256 amount, address indexed receiver);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    modifier onlyAfterUnlock() {
        require(block.timestamp >= unlockTime, "Funds are locked until the unlock time");
        _;
    }

    modifier onlyIfFundsAvailable() {
        require(address(this).balance > 0, "No funds to withdraw");
        _;
    }

    constructor(uint256 _unlockTime) payable {
        require(_unlockTime > block.timestamp, "Unlock time must be in the future");
        owner = msg.sender;
        unlockTime = _unlockTime;
    }

    function deposit() external payable {
        emit Deposited(msg.value, msg.sender);
    }

    function withdraw() external onlyOwner onlyAfterUnlock onlyIfFundsAvailable {
        uint256 balance = address(this).balance;
        fundsWithdrawn = true;
        (bool success, ) = owner.call{value: balance}("");
        require(success, "Withdrawal failed");
        emit Withdrawn(balance, owner);
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
