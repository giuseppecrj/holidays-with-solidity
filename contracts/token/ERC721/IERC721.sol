// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "../../utils/introspection/IERC165.sol";

interface IERC721 is IERC165 {
    // Emitted when tokenId token is transferred from `from` to `to`.
    event Transfer(address indexed from, address indexed to, uint indexed tokenId);

    // Emitted when `owner` enables `approved` to mangae the `tokenId` token.
    event Approval(address indexed owner, address indexed approved, uint indexed tokenId);

    // Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    // Returns the number of tokens in `owner`'s account
    function balanceOf(address owner) external view returns(uint balance);

    // Returns the owner of the `tokenId` token
    function ownerOf(uint tokenId) external view returns(address owner);

    // Safely transfers `tokenId` token from `from` to `to`
    function safeTransferFrom(address from, address to, uint tokenId) external;

    // Transfer `tokenId` token from `from` to `to`
    function transferFrom(address from, address to, uint tokenId) external;

    // Gives permission to `to` to transfer `tokenId` token to another account.
    // The approval is cleared when the token is transferred.
    // Only a single account can be approved at a time, so approving the zero address clears previous approvals.
    function approve(address to, uint tokenId) external;

    // Returns the account approved for `tokenId` token.
    function getApproved(uint tokenId) external view returns (address operator);

    // Approve or remove `operator` as an operator for the caller.
    // Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
    function setApprovalForAll(address operator, bool _approved) external;

    // Returns if the `operator` is allowed to manage all of the assets of `owner`.
    function isApprovedForAll(address owner, address operator) external view returns (bool);

    // Safely transfers `tokenId` token from `from` to `to`.
    function safeTransferFrom(address from, address to, uint tokenId, bytes calldata data) external;
}