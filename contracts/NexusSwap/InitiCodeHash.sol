// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "./NexusSwapPair.sol";

contract InitiCodeHash {
    function getInitHash() public pure returns (bytes32) {
        bytes memory bytecode = type(NexusSwapPair).creationCode;
        return keccak256(abi.encodePacked(bytecode));
    }
}
