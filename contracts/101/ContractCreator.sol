// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "../access/Ownable.sol";
import "../security/ReentrancyGuard.sol";

contract A is Ownable {   
}

contract Creator is Ownable {
    A[] public deployed;

    function deploy() public {
        A child = new A();
        child.transferOwnership(_msgSender());
        deployed.push(child);
    }
}