// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title InvestorRegistry
 * @dev Placeholder registry that manages investor whitelists.
 */
contract InvestorRegistry {
    enum InvestorType { Retail, Accredited, Institutional }

    mapping(address => bool) public whitelisted;
    mapping(address => InvestorType) public investorType;

    event InvestorRegistered(address indexed user, InvestorType investorType);
    event AddressWhitelisted(address indexed user);

    function registerInvestor(address user, InvestorType invType) external {
        investorType[user] = invType;
        emit InvestorRegistered(user, invType);
    }

    function whitelistAddress(address user) external {
        whitelisted[user] = true;
        emit AddressWhitelisted(user);
    }

    function isWhitelisted(address user) external view returns (bool) {
        return whitelisted[user];
    }

    function getInvestorType(address user) external view returns (InvestorType) {
        return investorType[user];
    }
}
