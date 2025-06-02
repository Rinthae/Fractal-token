// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./FractalToken.sol";

/// @title FractalTokenFactory
/// @notice Deploys FractalToken instances
contract FractalTokenFactory {
    FractalToken[] public allTokens;

    event TokenCreated(address token);

    function createToken(uint256 initialSupply) external returns (address) {
        FractalToken token = new FractalToken(initialSupply);
        allTokens.push(token);
        emit TokenCreated(address(token));
        return address(token);
    }

    function getAllTokens() external view returns (FractalToken[] memory) {
        return allTokens;
    }
}
