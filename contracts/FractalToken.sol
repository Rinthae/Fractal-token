// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

< codex/configura-proyecto-fractal-token-en-termux
/// @title FractalToken
/// @notice ERC-3643 inspired real estate token with fractional ownership and governance features
contract FractalToken {
    // Immutable token parameters
    uint256 public immutable property_id;
    uint256 public immutable fractional_ownership; // expressed in basis points (100 = 1%)
    bool public immutable yield_right;
    bytes32 public immutable KYC_hash;
    address public immutable rental_income_flow;
    string public use_rights;
    uint256 public immutable governance_power;
    uint256 public immutable lock_period;
    bool public immutable transfer_restrictions;

    // Whitelist mapping for transfer restrictions
    mapping(address => bool) public whitelist;

    // Basic balances tracking for demonstration purposes
    mapping(address => uint256) private _balances;
    uint256 private _totalSupply;
    mapping(address => uint256) private _lastTransfer;

    /// @notice Emitted when yield is claimed by an eligible holder
    event YieldClaimed(address indexed holder, uint256 amount);

    /// @notice Emitted on transfers between whitelisted addresses
    event Transfer(address indexed from, address indexed to, uint256 amount);

    constructor(
        uint256 _property_id,
        uint256 _fractional_ownership,
        bool _yield_right,
        bytes32 _KYC_hash,
        address _rental_income_flow,
        string memory _use_rights,
        uint256 _governance_power,
        uint256 _lock_period,
        address[] memory initialWhitelist,
        uint256 initialSupply,
        bool _transfer_restrictions
    ) {
        property_id = _property_id;
        fractional_ownership = _fractional_ownership;
        yield_right = _yield_right;
        KYC_hash = _KYC_hash;
        rental_income_flow = _rental_income_flow;
        use_rights = _use_rights;
        governance_power = _governance_power;
        lock_period = _lock_period;
        transfer_restrictions = _transfer_restrictions;

        for (uint256 i = 0; i < initialWhitelist.length; i++) {
            whitelist[initialWhitelist[i]] = true;
        }

        _balances[msg.sender] = initialSupply;
        _totalSupply = initialSupply;
        _lastTransfer[msg.sender] = block.timestamp;
    }

    /// @notice Returns total token supply
    function totalSupply() external view returns (uint256) {
        return _totalSupply;
    }

    /// @notice Returns balance of a holder
    function balanceOf(address account) external view returns (uint256) {
        return _balances[account];
    }

    /// @notice Allows a whitelisted holder to claim accumulated yield
    function claimYield() external {
        require(yield_right, "Yield not enabled");
        // In a real implementation, the yield amount would be calculated
        uint256 amount = 0; // placeholder
        emit YieldClaimed(msg.sender, amount);
    }

    /// @notice Transfers tokens to another whitelisted address respecting lock period
    function transfer(address recipient, uint256 amount) external returns (bool) {
        if (transfer_restrictions) {
            require(whitelist[msg.sender], "Sender not whitelisted");
            require(whitelist[recipient], "Recipient not whitelisted");
        }
        if (lock_period > 0) {
            require(block.timestamp - _lastTransfer[msg.sender] >= lock_period, "Tokens locked");
        }
        require(_balances[msg.sender] >= amount, "Insufficient balance");

        _balances[msg.sender] -= amount;
        _balances[recipient] += amount;
        _lastTransfer[msg.sender] = block.timestamp;
        _lastTransfer[recipient] = block.timestamp;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }
}

=======
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
}> main
