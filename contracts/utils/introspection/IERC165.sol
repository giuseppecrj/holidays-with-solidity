// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

interface IERC165 {
    /**
    * @dev returns true if this contract implements the interface defined by `interfaceId`
    */
    function supportsInterface(bytes4 interfaceId) external view returns(bool);
}