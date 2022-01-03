// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "../IERC20.sol";

interface IERC20Metadata is IERC20 {
    /**
    * @dev returns name of the token
    */
    function name() external view returns(string memory);

    /**
    * @dev returns the symbol of the token
    */
    function symbol() external view returns(string memory);

    /**
    * @dev returns the decimals places of the token
    */
    function decimals() external view returns(uint8);
}