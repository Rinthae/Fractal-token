// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./FractalToken.sol";

/// @title FractalTokenFactory
/// @notice Deploys FractalToken instances for different properties
contract FractalTokenFactory {
    /// @dev List of all deployed token addresses
    FractalToken[] public allTokens;

    event TokenDeployed(address tokenAddress, uint256 propertyId);

    /// @notice Deploy a new FractalToken
    function createToken(
        uint256 property_id,
        uint256 fractional_ownership,
        bool yield_right,
        bytes32 KYC_hash,
        address rental_income_flow,
        string memory use_rights,
        uint256 governance_power,
        uint256 lock_period,
        address[] memory initialWhitelist,
        uint256 initialSupply,
        bool transfer_restrictions
    ) external returns (address) {
        FractalToken token = new FractalToken(
            property_id,
            fractional_ownership,
            yield_right,
            KYC_hash,
            rental_income_flow,
            use_rights,
            governance_power,
            lock_period,
            initialWhitelist,
            initialSupply,
            transfer_restrictions
        );
        allTokens.push(token);
        emit TokenDeployed(address(token), property_id);
        return address(token);
    }

    /// @notice Returns all deployed token contracts
    function getAllTokens() external view returns (FractalToken[] memory) {
        return allTokens;
    }
}
