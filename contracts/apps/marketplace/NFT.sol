// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "../../token/ERC721/ERC721.sol";
import "../../token/ERC721/extensions/ERC721URIStorage.sol";
import "../../utils/Counters.sol";

contract NFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    address contractAddress;

    constructor(address marketplaceAddress) ERC721("Metaverse Token", "MTT") {
        contractAddress = marketplaceAddress;
    }

    function createToken(string memory tokenURI) public returns(uint) {
        _tokenIds.increment();
        uint newItemId = _tokenIds.current();

        _safeMint(_msgSender(), newItemId);
        _setTokenURI(newItemId, tokenURI);
        setApprovalForAll(contractAddress, true);
        return newItemId;
    }
}