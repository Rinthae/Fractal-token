// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./interfaces/IERC20.sol";

/**
 * @title TokenEscrow
 * @dev Simple escrow allowing users to lock ERC20 tokens for a period.
 */
contract TokenEscrow {
    struct LockInfo {
        uint256 amount;
        uint256 unlockTime;
    }

    mapping(address => mapping(address => LockInfo)) public locks; // user => token => info

    event TokensLocked(address indexed user, address indexed token, uint256 amount, uint256 until);
    event TokensUnlocked(address indexed user, address indexed token, uint256 amount);

    function lockTokens(address token, uint256 amount, uint256 lockDuration) external {
        LockInfo storage info = locks[msg.sender][token];
        require(info.amount == 0, "already locked");
        require(IERC20(token).transferFrom(msg.sender, address(this), amount), "transfer failed");
        info.amount = amount;
        info.unlockTime = block.timestamp + lockDuration;
        emit TokensLocked(msg.sender, token, amount, info.unlockTime);
    }

    function unlockTokens(address token) external {
        LockInfo storage info = locks[msg.sender][token];
        require(info.amount > 0, "nothing locked");
        require(block.timestamp >= info.unlockTime, "still locked");
        uint256 amount = info.amount;
        info.amount = 0;
        info.unlockTime = 0;
        IERC20(token).transfer(msg.sender, amount);
        emit TokensUnlocked(msg.sender, token, amount);
    }
}
