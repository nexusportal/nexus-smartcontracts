// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface IUniswapV2Factory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);
    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);
    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);
    function createPair(address tokenA, address tokenB) external returns (address pair);
    function setFeeTo(address) external;
    function setFeeToSetter(address) external;
}

interface IUniswapV2Router02 {
    function factory() external pure returns (address);
    
    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
}

abstract contract Ownable {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() {
        _transferOwnership(msg.sender);
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(owner() == msg.sender, "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

abstract contract ReentrancyGuard {
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;
    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    modifier nonReentrant() {
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
        _status = _ENTERED;
        _;
        _status = _NOT_ENTERED;
    }
}

contract TokenFactory is Ownable, ReentrancyGuard {
    IUniswapV2Factory public immutable uniswapFactory;
    IUniswapV2Router02 public immutable uniswapRouter;
    
    uint256 public platformFeePercent = 1; // 1% platform fee
    mapping(address => bool) public acceptedPaymentTokens;
    mapping(address => uint256) public tokenFees;
    uint256 public nativeFee;
    
    event TokenCreated(address tokenAddress, string name, string symbol, uint256 totalSupply);
    event FeeUpdated(address token, uint256 newFee);
    event PaymentTokenAdded(address token);
    event PaymentTokenRemoved(address token);
    event FeesWithdrawn(address token, uint256 amount);
    event LiquidityAdded(address token, uint256 tokenAmount, uint256 ethAmount, uint256 liquidity);
    
    constructor(address _uniswapFactory, address _uniswapRouter) {
        uniswapFactory = IUniswapV2Factory(_uniswapFactory);
        uniswapRouter = IUniswapV2Router02(_uniswapRouter);
    }
    
    function createToken(
        string memory name,
        string memory symbol,
        uint256 totalSupply,
        uint256 lpPercent,
        uint256 devPercent,
        address paymentToken,
        uint256 initialLiquidity,
        bool useNativeFee
    ) external payable nonReentrant {
        // Ensure the total distribution percentages add up to 100%
        require(lpPercent + devPercent + platformFeePercent == 100, "Invalid percentages: Total must be 100");
        
        // Ensure the developer cannot receive more than 50% of the supply
        require(devPercent <= 50, "Dev percentage cannot exceed 50%");

        // Check for correct fee payment
        if (useNativeFee) {
            require(msg.value >= nativeFee + initialLiquidity, "Insufficient native fee and liquidity");
            uint256 excessFee = msg.value - (nativeFee + initialLiquidity);
            if (excessFee > 0) {
                payable(msg.sender).transfer(excessFee); // Refund excess fee
            }
        } else {
            require(acceptedPaymentTokens[paymentToken], "Invalid payment token");
            require(
                IERC20(paymentToken).transferFrom(msg.sender, address(this), tokenFees[paymentToken]),
                "Fee transfer failed"
            );
            require(msg.value >= initialLiquidity, "Insufficient liquidity");
        }

        // Deploy the new token contract
        NewToken token = new NewToken(name, symbol, totalSupply);
        
        // Calculate token allocations based on percentages
        uint256 lpAmount = (totalSupply * lpPercent) / 100;
        uint256 devAmount = (totalSupply * devPercent) / 100;
        uint256 platformAmount = (totalSupply * platformFeePercent) / 100;

        // Distribute tokens
        token.transfer(msg.sender, devAmount);
        token.transfer(address(this), platformAmount); // Send platform fee to this contract

        // Approve the router to spend tokens for liquidity addition
        token.approve(address(uniswapRouter), lpAmount);

        // Add liquidity using native currency paired with the new token
        (,, uint liquidity) = uniswapRouter.addLiquidityETH{value: initialLiquidity}(
            address(token),
            lpAmount,
            0,
            0,
            address(0xdead), // Send LP tokens to dead address
            block.timestamp
        );

        emit TokenCreated(address(token), name, symbol, totalSupply);
        emit LiquidityAdded(address(token), lpAmount, initialLiquidity, liquidity);
    }
    
    function withdrawNativeFees() external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No native fees to withdraw");
        (bool success, ) = payable(owner()).call{value: balance}("");
        require(success, "Native withdrawal failed");
        emit FeesWithdrawn(address(0), balance);
    }
    
    function withdrawTokenFees(address token, uint256 amount) external onlyOwner {
        require(token != address(0), "Use withdrawNativeFees for native token");
        uint256 balance = IERC20(token).balanceOf(address(this));
        require(balance >= amount, "Insufficient balance");
        require(IERC20(token).transfer(owner(), amount), "Token withdrawal failed");
        emit FeesWithdrawn(token, amount);
    }
    
    function setFee(address token, uint256 fee) external onlyOwner {
        if (token == address(0)) {
            nativeFee = fee;
        } else {
            tokenFees[token] = fee;
        }
        emit FeeUpdated(token, fee);
    }
    
    function addPaymentToken(address token) external onlyOwner {
        require(token != address(0), "Cannot add native token");
        acceptedPaymentTokens[token] = true;
        emit PaymentTokenAdded(token);
    }
    
    function removePaymentToken(address token) external onlyOwner {
        acceptedPaymentTokens[token] = false;
        emit PaymentTokenRemoved(token);
    }
    
    receive() external payable {}
}

contract NewToken is IERC20 {
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    
    string private _name;
    string private _symbol;
    uint256 private _totalSupply;
    
    constructor(string memory name_, string memory symbol_, uint256 totalSupply_) {
        _name = name_;
        _symbol = symbol_;
        _totalSupply = totalSupply_;
        _balances[msg.sender] = totalSupply_;
        emit Transfer(address(0), msg.sender, totalSupply_);
    }
    
    function name() public view returns (string memory) {
        return _name;
    }
    
    function symbol() public view returns (string memory) {
        return _symbol;
    }
    
    function decimals() public pure returns (uint8) {
        return 18;
    }
    
    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }
    
    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }
    
    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }
    
    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }
    
    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }
    
    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        _transfer(sender, recipient, amount);
        uint256 currentAllowance = _allowances[sender][msg.sender];
        require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
        unchecked {
            _approve(sender, msg.sender, currentAllowance - amount);
        }
        return true;
    }
    
    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender] + addedValue);
        return true;
    }
    
    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        uint256 currentAllowance = _allowances[msg.sender][spender];
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        unchecked {
            _approve(msg.sender, spender, currentAllowance - subtractedValue);
        }
        return true;
    }
    
    function _transfer(address sender, address recipient, uint256 amount) internal {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
        require(_balances[sender] >= amount, "ERC20: transfer amount exceeds balance");
        unchecked {
            _balances[sender] = _balances[sender] - amount;
            _balances[recipient] = _balances[recipient] + amount;
        }
        emit Transfer(sender, recipient, amount);
    }
    
    function _approve(address owner, address spender, uint256 amount) internal {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
} 