// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Test {
    using SafeERC20 for IERC20;

    function safeTransfer(address token, uint256 amount) public {
        IERC20(token).safeTransfer(address(msg.sender), amount);
    }

    function transfer(address token, uint256 amount) public {
        IERC20(token).transfer(address(msg.sender), amount);
    }
}
