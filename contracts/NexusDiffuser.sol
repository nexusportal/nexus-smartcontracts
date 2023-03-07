// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

// File contracts/uniswapv2/interfaces/IUniswapV2ERC20.sol

pragma solidity >=0.5.0;

interface IUniswapV2ERC20 {
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
    event Transfer(address indexed from, address indexed to, uint256 value);

    function name() external pure returns (string memory);

    function symbol() external pure returns (string memory);

    function decimals() external pure returns (uint8);

    function totalSupply() external view returns (uint256);

    function balanceOf(address owner) external view returns (uint256);

    function allowance(
        address owner,
        address spender
    ) external view returns (uint256);

    function approve(address spender, uint256 value) external returns (bool);

    function transfer(address to, uint256 value) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);

    function PERMIT_TYPEHASH() external pure returns (bytes32);

    function nonces(address owner) external view returns (uint256);

    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;
}

// File contracts/uniswapv2/interfaces/IUniswapV2Pair.sol

pragma solidity >=0.5.0;

interface IUniswapV2Pair {
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
    event Transfer(address indexed from, address indexed to, uint256 value);

    function name() external pure returns (string memory);

    function symbol() external pure returns (string memory);

    function decimals() external pure returns (uint8);

    function totalSupply() external view returns (uint256);

    function balanceOf(address owner) external view returns (uint256);

    function allowance(
        address owner,
        address spender
    ) external view returns (uint256);

    function approve(address spender, uint256 value) external returns (bool);

    function transfer(address to, uint256 value) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);

    function PERMIT_TYPEHASH() external pure returns (bytes32);

    function nonces(address owner) external view returns (uint256);

    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    event Mint(address indexed sender, uint256 amount0, uint256 amount1);
    event Burn(
        address indexed sender,
        uint256 amount0,
        uint256 amount1,
        address indexed to
    );
    event Swap(
        address indexed sender,
        uint256 amount0In,
        uint256 amount1In,
        uint256 amount0Out,
        uint256 amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint256);

    function factory() external view returns (address);

    function token0() external view returns (address);

    function token1() external view returns (address);

    function getReserves()
        external
        view
        returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);

    function price0CumulativeLast() external view returns (uint256);

    function price1CumulativeLast() external view returns (uint256);

    function kLast() external view returns (uint256);

    function mint(address to) external returns (uint256 liquidity);

    function burn(
        address to
    ) external returns (uint256 amount0, uint256 amount1);

    function swap(
        uint256 amount0Out,
        uint256 amount1Out,
        address to,
        bytes calldata data
    ) external;

    function skim(address to) external;

    function sync() external;

    function initialize(address, address) external;
}

// File contracts/uniswapv2/interfaces/IUniswapV2Factory.sol

pragma solidity >=0.5.0;

interface IUniswapV2Factory {
    event PairCreated(
        address indexed token0,
        address indexed token1,
        address pair,
        uint256
    );

    function feeTo() external view returns (address);

    function feeToSetter() external view returns (address);

    function migrator() external view returns (address);

    function getPair(
        address tokenA,
        address tokenB
    ) external view returns (address pair);

    function allPairs(uint256) external view returns (address pair);

    function allPairsLength() external view returns (uint256);

    function createPair(
        address tokenA,
        address tokenB
    ) external returns (address pair);

    function setFeeTo(address) external;

    function setFeeToSetter(address) external;

    function setMigrator(address) external;
}

// File contracts/Ownable.sol

// Audit on 5-Jan-2021 by Keno and BoringCrypto

// P1 - P3: OK
pragma solidity 0.6.12;

// Source: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol + Claimable.sol
// Edited by BoringCrypto

// T1 - T4: OK
contract OwnableData {
    // V1 - V5: OK
    address public owner;
    // V1 - V5: OK
    address public pendingOwner;
}

// T1 - T4: OK
contract Ownable is OwnableData {
    // E1: OK
    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    constructor() internal {
        owner = msg.sender;
        emit OwnershipTransferred(address(0), msg.sender);
    }

    // F1 - F9: OK
    // C1 - C21: OK
    function transferOwnership(
        address newOwner,
        bool direct,
        bool renounce
    ) public onlyOwner {
        if (direct) {
            // Checks
            require(
                newOwner != address(0) || renounce,
                "Ownable: zero address"
            );

            // Effects
            emit OwnershipTransferred(owner, newOwner);
            owner = newOwner;
        } else {
            // Effects
            pendingOwner = newOwner;
        }
    }

    // F1 - F9: OK
    // C1 - C21: OK
    function claimOwnership() public {
        address _pendingOwner = pendingOwner;

        // Checks
        require(
            msg.sender == _pendingOwner,
            "Ownable: caller != pending owner"
        );

        // Effects
        emit OwnershipTransferred(owner, _pendingOwner);
        owner = _pendingOwner;
        pendingOwner = address(0);
    }

    // M1 - M5: OK
    // C1 - C21: OK
    modifier onlyOwner() {
        require(msg.sender == owner, "Ownable: caller is not the owner");
        _;
    }
}

// File contracts/NexusDistributor.sol

// P1 - P3: OK
pragma solidity 0.6.12;

// T1 - T4: OK
contract NexusDistributor is Ownable {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    IUniswapV2Factory public immutable factory;

    address public immutable xNexus;

    address public immutable nexus;

    address public immutable weth;

    address public nexusTreasurySetter;

    address public multiStakingGetter;

    mapping(address => bool) public convertLpToBurnNxs;

    address public nexusBurnSetter;

    uint256 public MIN_LP_AMOUNT = 0.003 * 10 ** 18;

    uint256 public limit_gas = 160000;

    uint256 public nexusDiffuserTotalAmount = 0;
    uint256 public nexusTreasuryTotalAmount = 0;
    uint256 public nexusBurnTotalAmount = 0;
    uint256 public nexusTotalAmount = 0;
    uint256 public nexusBurnerTotalAmount = 0;

    bool private onlyNexusLp = true;

    // V1 - V5: OK
    mapping(address => address) internal _bridges;

    // E1: OK
    event LogBridgeSet(address indexed token, address indexed bridge);
    // E1: OK
    event LogConvert(
        address indexed server,
        address indexed token0,
        address indexed token1,
        uint256 amount0,
        uint256 amount1,
        uint256 amountNXS
    );

    event DiffuserConvert(uint256 amountNXS);

    event TreasuryConvert(uint256 amountNXS);

    event BurnConvert(uint256 amountNXS);

    event NexusBurnerConvert(uint256 amountNXS);

    event TotalConvert(uint256 amountNXS);

    address public nexusTreasury;
    address public constant deadAddress =
        0x000000000000000000000000000000000000dEaD;

    address public nexusBurn;

    modifier onlyHolder() {
        require(IERC20(nexus).balanceOf(msg.sender) > 0, "should hold nexus");
        _;
    }

    constructor(
        address _factory,
        address _xNexus,
        address _nexus,
        address _weth
    ) public {
        factory = IUniswapV2Factory(_factory);
        xNexus = _xNexus;
        nexus = _nexus;
        weth = _weth;
        nexusTreasurySetter = address(msg.sender);
        nexusBurnSetter = address(msg.sender);
    }

    function bridgeFor(address token) public view returns (address bridge) {
        bridge = _bridges[token];
        if (bridge == address(0)) {
            bridge = weth;
        }
    }

    function setBridge(address token, address bridge) external onlyOwner {
        // Checks
        require(
            token != nexus && token != weth && token != bridge,
            "NexusDistributor: Invalid bridge"
        );

        // Effects
        _bridges[token] = bridge;
        emit LogBridgeSet(token, bridge);
    }

    function setMinLPAmount(uint256 _amount) external onlyOwner {
        MIN_LP_AMOUNT = _amount;
    }

    function setGasLimit(uint256 _limit_gas) external onlyOwner {
        limit_gas = _limit_gas;
    }

    function setNexusLPEnable(bool _onlyNexusLp) external onlyOwner {
        onlyNexusLp = _onlyNexusLp;
    }

    // C6: It's not a fool proof solution, but it prevents flash loans, so here it's ok to use tx.origin
    modifier onlyEOA() {
        // Try to make flash-loan exploit harder to do by only allowing externally owned addresses.
        require(msg.sender == tx.origin, "NexusDistributor: must use EOA");
        _;
    }

    function LPConvert() external onlyEOA onlyHolder {
        uint256 len = factory.allPairsLength();

        uint256 gasUsed = 0;

        uint256 gasLeft = gasleft();

        uint256 iterations = 0;

        while (gasUsed < limit_gas && iterations < len) {
            IUniswapV2Pair pair = IUniswapV2Pair(factory.allPairs(iterations));
            uint256 lpBalance = pair.balanceOf(address(this));

            if (lpBalance > MIN_LP_AMOUNT) {
                if (convertLpToBurnNxs[address(pair)]) {
                    if (onlyNexusLp) {
                        if (
                            pair.token0() == nexus ||
                            pair.token0() == weth ||
                            pair.token1() == nexus ||
                            pair.token1() == weth
                        ) {
                            _convert(pair.token0(), pair.token1());
                        }
                    } else {
                        _convert(pair.token0(), pair.token1());
                    }
                } else {
                    IERC20(address(pair)).safeTransfer(
                        multiStakingGetter,
                        pair.balanceOf(address(this))
                    );
                }
            }

            iterations++;

            uint256 newGasLeft = gasleft();

            if (gasLeft > newGasLeft) {
                gasUsed = gasUsed.add(gasLeft.sub(newGasLeft));
            }

            gasLeft = newGasLeft;
        }
    }

    function LPEnalbe() external view returns (bool) {
        uint256 len = factory.allPairsLength();
        for (uint256 i = 0; i < len; i++) {
            IUniswapV2Pair pair = IUniswapV2Pair(factory.allPairs(i));
            uint256 lpBalance = pair.balanceOf(address(this));
            if (lpBalance > MIN_LP_AMOUNT) {
                if (onlyNexusLp) {
                    if (
                        pair.token0() == nexus ||
                        pair.token0() == weth ||
                        pair.token1() == nexus ||
                        pair.token1() == weth
                    ) {
                        return true;
                    }
                } else {
                    return true;
                }
            }
        }
        return false;
    }

    // F1 - F10: OK
    // F3: _convert is separate to save gas by only checking the 'onlyEOA' modifier once in case of convertMultiple
    // F6: There is an exploit to add lots of NXS to the xNexus, run convert, then remove the NXS again.
    //     As the size of the xNexus has grown, this requires large amounts of funds and isn't super profitable anymore
    //     The onlyEOA modifier prevents this being done with a flash loan.
    // C1 - C24: OK
    function convert(
        address token0,
        address token1
    ) external onlyEOA onlyHolder {
        _convert(token0, token1);
    }

    // F1 - F10: OK, see convert
    // C1 - C24: OK
    // C3: Loop is under control of the caller
    function convertMultiple(
        address[] calldata token0,
        address[] calldata token1
    ) external onlyEOA onlyHolder {
        // TODO: This can be optimized a fair bit, but this is safer and simpler for now
        uint256 len = token0.length;
        for (uint256 i = 0; i < len; i++) {
            _convert(token0[i], token1[i]);
        }
    }

    function _convert(address token0, address token1) internal {
        // Interactions
        IUniswapV2Pair pair = IUniswapV2Pair(factory.getPair(token0, token1));
        require(address(pair) != address(0), "NexusDistributor: Invalid pair");
        IERC20(address(pair)).safeTransfer(
            address(pair),
            pair.balanceOf(address(this))
        );
        (uint256 amount0, uint256 amount1) = pair.burn(address(this));
        if (token0 != pair.token0()) {
            (amount0, amount1) = (amount1, amount0);
        }
        emit LogConvert(
            msg.sender,
            token0,
            token1,
            amount0,
            amount1,
            _convertStep(token0, token1, amount0, amount1)
        );
    }

    // All safeTransfer, _swap, _toNXS, _convertStep
    function _convertStep(
        address token0,
        address token1,
        uint256 amount0,
        uint256 amount1
    ) internal returns (uint256 nexusOut) {
        // Interactions
        if (token0 == token1) {
            uint256 amount = amount0.add(amount1);
            if (token0 == nexus) {
                IERC20(nexus).safeTransfer(xNexus, amount);
                nexusOut = amount;
            } else if (token0 == weth) {
                nexusOut = _toNXS(weth, amount);
            } else {
                address bridge = bridgeFor(token0);
                amount = _swap(token0, bridge, amount, address(this));
                nexusOut = _convertStep(bridge, bridge, amount, 0);
            }
        } else if (token0 == nexus) {
            // eg. NXS - ETH
            IERC20(nexus).safeTransfer(xNexus, amount0);
            nexusOut = _toNXS(token1, amount1).add(amount0);
        } else if (token1 == nexus) {
            // eg. USDT - NXS
            IERC20(nexus).safeTransfer(xNexus, amount1);
            nexusOut = _toNXS(token0, amount0).add(amount1);
        } else if (token0 == weth) {
            // eg. ETH - USDC
            nexusOut = _toNXS(
                weth,
                _swap(token1, weth, amount1, address(this)).add(amount0)
            );
        } else if (token1 == weth) {
            // eg. USDT - ETH
            nexusOut = _toNXS(
                weth,
                _swap(token0, weth, amount0, address(this)).add(amount1)
            );
        } else {
            // eg. MIC - USDT
            address bridge0 = bridgeFor(token0);
            address bridge1 = bridgeFor(token1);
            if (bridge0 == token1) {
                // eg. MIC - USDT - and bridgeFor(MIC) = USDT
                nexusOut = _convertStep(
                    bridge0,
                    token1,
                    _swap(token0, bridge0, amount0, address(this)),
                    amount1
                );
            } else if (bridge1 == token0) {
                // eg. WBTC - DSD - and bridgeFor(DSD) = WBTC
                nexusOut = _convertStep(
                    token0,
                    bridge1,
                    amount0,
                    _swap(token1, bridge1, amount1, address(this))
                );
            } else {
                nexusOut = _convertStep(
                    bridge0,
                    bridge1, // eg. USDT - DSD - and bridgeFor(DSD) = WBTC
                    _swap(token0, bridge0, amount0, address(this)),
                    _swap(token1, bridge1, amount1, address(this))
                );
            }
        }
    }

    // All safeTransfer, swap: X1 - X5: OK
    function _swap(
        address fromToken,
        address toToken,
        uint256 amountIn,
        address to
    ) internal returns (uint256 amountOut) {
        // Checks
        IUniswapV2Pair pair = IUniswapV2Pair(
            factory.getPair(fromToken, toToken)
        );
        require(
            address(pair) != address(0),
            "NexusDistributor: Cannot convert"
        );

        // Interactions
        (uint256 reserve0, uint256 reserve1, ) = pair.getReserves();
        uint256 amountInWithFee = amountIn.mul(997);
        if (fromToken == pair.token0()) {
            amountOut =
                amountInWithFee.mul(reserve1) /
                reserve0.mul(1000).add(amountInWithFee);
            IERC20(fromToken).safeTransfer(address(pair), amountIn);

            try pair.swap(0, amountOut, to, new bytes(0)) {} catch (
                bytes memory /** */
            ) {}

            // TODO: Add maximum slippage?
        } else {
            amountOut =
                amountInWithFee.mul(reserve0) /
                reserve1.mul(1000).add(amountInWithFee);
            IERC20(fromToken).safeTransfer(address(pair), amountIn);

            try pair.swap(amountOut, 0, to, new bytes(0)) {} catch (
                bytes memory /** */
            ) {}

            // TODO: Add maximum slippage?
        }
    }

    function _toNXS(
        address token,
        uint256 amountIn
    ) internal returns (uint256 amountOut) {
        if (nexusTreasury != address(0)) {
            uint256 diffuserAmount = _swap(
                token,
                nexus,
                amountIn.mul(7).div(10),
                xNexus
            );
            nexusDiffuserTotalAmount = nexusDiffuserTotalAmount.add(
                diffuserAmount
            );

            uint256 treasuryAmount = _swap(
                token,
                nexus,
                amountIn.div(10),
                nexusTreasury
            );
            nexusTreasuryTotalAmount = nexusTreasuryTotalAmount.add(
                treasuryAmount
            );

            uint256 nexusBurnerAmount = _swap(
                token,
                nexus,
                amountIn.div(10),
                nexusBurn
            );
            nexusBurnerTotalAmount = nexusBurnerTotalAmount.add(
                nexusBurnerAmount
            );

            uint256 burnAmount = _swap(
                token,
                nexus,
                amountIn.div(10),
                deadAddress
            );
            nexusBurnTotalAmount = nexusBurnTotalAmount.add(burnAmount);

            amountOut = diffuserAmount.add(treasuryAmount).add(burnAmount);
            nexusTotalAmount = nexusTotalAmount.add(amountOut);

            emit DiffuserConvert(diffuserAmount);
            emit TreasuryConvert(treasuryAmount);
            emit BurnConvert(burnAmount);
            emit NexusBurnerConvert(nexusBurnerAmount);
            emit TotalConvert(amountOut);
        } else {
            uint256 diffuserAmount = _swap(
                token,
                nexus,
                amountIn.mul(7).div(10),
                xNexus
            );
            nexusDiffuserTotalAmount = nexusDiffuserTotalAmount.add(
                diffuserAmount
            );

            uint256 nexusBurnerAmount = _swap(
                token,
                nexus,
                amountIn.mul(2).div(10),
                nexusBurn
            );
            nexusBurnerTotalAmount = nexusBurnerTotalAmount.add(
                nexusBurnerAmount
            );

            uint256 burnAmount = _swap(
                token,
                nexus,
                amountIn.div(10),
                deadAddress
            );
            nexusBurnTotalAmount = nexusBurnTotalAmount.add(burnAmount);

            amountOut = diffuserAmount.add(burnAmount);
            nexusTotalAmount = nexusTotalAmount.add(amountOut);

            emit DiffuserConvert(diffuserAmount);
            emit NexusBurnerConvert(nexusBurnerAmount);
            emit BurnConvert(burnAmount);
            emit TotalConvert(amountOut);
        }
    }

    function setNexusTreasury(address _treasury) external {
        require(
            msg.sender == nexusTreasurySetter,
            "NexusDistributor: FORBIDDEN"
        );
        nexusTreasury = _treasury;
    }

    function setNexusTreasurySetter(address _nexusTreasurySetter) external {
        require(
            msg.sender == nexusTreasurySetter,
            "NexusDistributor: FORBIDDEN"
        );
        nexusTreasurySetter = _nexusTreasurySetter;
    }

    function setNexusBurn(address _nexusBurn) external {
        require(msg.sender == nexusBurnSetter, "NexusDistributor: FORBIDDEN");
        nexusBurn = _nexusBurn;
    }

    function setNexusBurnSetter(address _nexusBurnSetter) external {
        require(msg.sender == nexusBurnSetter, "NexusDistributor: FORBIDDEN");
        nexusBurnSetter = _nexusBurnSetter;
    }

    function setLpToBurnNxs(address _lp, bool _enable) external onlyOwner {
        convertLpToBurnNxs[_lp] = _enable;
    }

    function setMultiStakingGetter(address _getter) external onlyOwner {
        multiStakingGetter = _getter;
    }
}
