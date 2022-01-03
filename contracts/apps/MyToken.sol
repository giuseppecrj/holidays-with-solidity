// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "../token/ERC20/ERC20.sol";
import "../utils/Context.sol";

contract MyToken is Context, ERC20 {
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        _mint(_msgSender(), 100 * 10**uint(decimals()));
    }
}