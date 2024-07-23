// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract RNT is ERC20("RNT", "RNT") {

    constructor() {
        _mint(msg.sender, 1e9 * 10e18);
    }
}