// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract MinimalProxy {
    function clone(address target) external returns (address result) {
        // convert address to 20 bytes
        bytes20 targetBytes = bytes(target);

        
    }
}