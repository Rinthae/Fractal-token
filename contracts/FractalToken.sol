// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract FractalToken {
    string public name = "FractalToken";
    string public symbol = "FCT";
    uint8 public decimals = 18;
    uint256 public totalSupply;

    address public owner;

    mapping(address => uint256) private balances;
    mapping(address => mapping(address => uint256)) private allowances;

    mapping(address => bool) private whitelist;
    mapping(address => uint8) private _investorType;
    mapping(address => uint256) private pendingYield;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event YieldClaimed(address indexed account, uint256 amount);
    event AddressWhitelisted(address indexed account);
    event InvestorTypeSet(address indexed account, uint8 investorType);

    modifier onlyOwner() {
        require(msg.sender == owner, "not owner");
        _;
    }

    modifier onlyWhitelisted(address account) {
        require(whitelist[account], "not whitelisted");
        _;
    }

    modifier onlyWhitelistedSender() {
        require(whitelist[msg.sender], "not whitelisted");
        _;
    }

    constructor(uint256 initialSupply) {
        owner = msg.sender;
        totalSupply = initialSupply;
        balances[owner] = initialSupply;
        whitelist[owner] = true;
    }

    function balanceOf(address account) public view returns (uint256) {
        return balances[account];
    }

    function transfer(address to, uint256 amount)
        public
        onlyWhitelistedSender
        onlyWhitelisted(to)
        returns (bool)
    {
        require(balances[msg.sender] >= amount, "balance too low");
        balances[msg.sender] -= amount;
        balances[to] += amount;
        emit Transfer(msg.sender, to, amount);
        return true;
    }

    function approve(address spender, uint256 amount) public returns (bool) {
        allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount)
        public
        onlyWhitelisted(from)
        onlyWhitelisted(to)
        returns (bool)
    {
        require(balances[from] >= amount, "balance too low");
        uint256 allowed = allowances[from][msg.sender];
        require(allowed >= amount, "allowance too low");
        allowances[from][msg.sender] = allowed - amount;
        balances[from] -= amount;
        balances[to] += amount;
        emit Transfer(from, to, amount);
        return true;
    }

    function whitelistAddress(address account) external onlyOwner {
        whitelist[account] = true;
        emit AddressWhitelisted(account);
    }

    function isWhitelisted(address account) external view returns (bool) {
        return whitelist[account];
    }

    function setInvestorType(address account, uint8 investorType_) external onlyOwner {
        _investorType[account] = investorType_;
        emit InvestorTypeSet(account, investorType_);
    }

    function getInvestorType(address account) external view returns (uint8) {
        return _investorType[account];
    }

    function allocateYield(address account, uint256 amount) external onlyOwner {
        pendingYield[account] += amount;
    }

    function yield_right(address account) external view returns (uint256) {
        return pendingYield[account];
    }

    function claimYield() external onlyWhitelistedSender {
        uint256 amount = pendingYield[msg.sender];
        require(amount > 0, "no yield");
        pendingYield[msg.sender] = 0;
        balances[msg.sender] += amount;
        totalSupply += amount;
        emit YieldClaimed(msg.sender, amount);
    }

    function governance_power(address account) external view returns (uint256) {
        return balances[account];
    }
}
