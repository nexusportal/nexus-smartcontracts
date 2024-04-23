// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

contract Test {
    address owner;
    string name;
    constructor(string memory _name) {
        owner = msg.sender;
        name = _name;
    }
}
