// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

// abstract cannot be deployed on the blockchain
interface BaseContract {
    function setX(int _x) external;
}

contract A is BaseContract {
    int public y = 3;
    int public x;

    function setX(int _x) public override {
        x = _x;
    }
}