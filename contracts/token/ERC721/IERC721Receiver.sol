// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

interface IERC721Receiver {
    // Whenever an {IERC721} `tokenId` token is tranferred to this contract via {IERC721-safeTransferFrom}
    // by `operator` from `from`, this function si called
    // It must returns its Solidity selector to confirm the token transfer
    function onERC721Received(address operator, address from, uint tokenId, bytes calldata data) external returns (bytes4);
}