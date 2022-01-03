// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "../IERC721.sol";

// Optional metadata extension
interface IERC721Metadata is IERC721 {
    // returns token collection name.
    function name() external view returns (string memory);

    // returns token collection symbol.
    function symbol() external view returns (string memory);

    // returns thr Uniform Resource Identifier (URI) for `tokenId` token.
    function tokenURI(uint tokenId) external view returns (string memory);
}