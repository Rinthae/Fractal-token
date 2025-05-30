// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function transfer(address to, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}

interface IFractalToken {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
}

/**
 * @title RevenueSplitter
 * @dev Accepts rental income and splits it among FractalToken holders.
 *      Supports both push and pull distribution models.
 */
contract RevenueSplitter {
    IFractalToken public immutable token;
    address public owner;

    // pending ether yield for pull model
    mapping(address => uint256) public pendingYield;

    // pending token yield for pull model: stablecoin => holder => amount
    mapping(address => mapping(address => uint256)) public pendingTokenYield;

    address[] public holders;

    event DepositReceived(address indexed from, uint256 amount);
    event YieldDistributed(uint256 totalAmount);
    event YieldClaimed(address indexed account, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "not owner");
        _;
    }

    constructor(IFractalToken _token) {
        require(address(_token) != address(0), "token address zero");
        token = _token;
        owner = msg.sender;
    }

    /** Receive ether deposits */
    receive() external payable {
        _allocateEther(msg.value);
        emit DepositReceived(msg.sender, msg.value);
    }

    /** Deposit ether manually */
    function deposit() external payable {
        _allocateEther(msg.value);
        emit DepositReceived(msg.sender, msg.value);
    }

    /** Deposit a stablecoin (ERC20) */
    function depositToken(address stable, uint256 amount) external {
        require(IERC20(stable).transferFrom(msg.sender, address(this), amount), "transfer failed");
        _allocateToken(stable, amount);
        emit DepositReceived(msg.sender, amount);
    }

    /** Set token holders list used for distribution */
    function setHolders(address[] calldata _holders) external onlyOwner {
        holders = _holders;
    }

    /** Allocate ether deposit proportionally to holders */
    function _allocateEther(uint256 amount) internal {
        uint256 supply = token.totalSupply();
        if (amount == 0 || supply == 0) return;
        for (uint256 i = 0; i < holders.length; i++) {
            address account = holders[i];
            uint256 bal = token.balanceOf(account);
            uint256 share = (amount * bal) / supply;
            if (share > 0) {
                pendingYield[account] += share;
            }
        }
    }

    /** Allocate stablecoin deposit proportionally to holders */
    function _allocateToken(address stable, uint256 amount) internal {
        uint256 supply = token.totalSupply();
        if (amount == 0 || supply == 0) return;
        for (uint256 i = 0; i < holders.length; i++) {
            address account = holders[i];
            uint256 bal = token.balanceOf(account);
            uint256 share = (amount * bal) / supply;
            if (share > 0) {
                pendingTokenYield[stable][account] += share;
            }
        }
    }

    /**
     * @dev Push style distribution of ether yield.
     */
    function distributeYield() external {
        uint256 totalDistributed = 0;
        for (uint256 i = 0; i < holders.length; i++) {
            address account = holders[i];
            uint256 amount = pendingYield[account];
            if (amount > 0) {
                pendingYield[account] = 0;
                totalDistributed += amount;
                payable(account).transfer(amount);
            }
        }
        require(totalDistributed > 0, "no yield to distribute");
        emit YieldDistributed(totalDistributed);
    }

    /**
     * @dev Push style distribution of stablecoin yield.
     */
    function distributeTokenYield(address stable) external {
        uint256 totalDistributed = 0;
        for (uint256 i = 0; i < holders.length; i++) {
            address account = holders[i];
            uint256 amount = pendingTokenYield[stable][account];
            if (amount > 0) {
                pendingTokenYield[stable][account] = 0;
                totalDistributed += amount;
                IERC20(stable).transfer(account, amount);
            }
        }
        require(totalDistributed > 0, "no yield to distribute");
        emit YieldDistributed(totalDistributed);
    }

    /**
     * @dev Claim pending ether yield for msg.sender.
     */
    function claimYield() external {
        uint256 amount = pendingYield[msg.sender];
        require(amount > 0, "nothing to claim");
        pendingYield[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
        emit YieldClaimed(msg.sender, amount);
    }

    /**
     * @dev Claim pending stablecoin yield for msg.sender.
     */
    function claimTokenYield(address stable) external {
        uint256 amount = pendingTokenYield[stable][msg.sender];
        require(amount > 0, "nothing to claim");
        pendingTokenYield[stable][msg.sender] = 0;
        IERC20(stable).transfer(msg.sender, amount);
        emit YieldClaimed(msg.sender, amount);
    }
}

