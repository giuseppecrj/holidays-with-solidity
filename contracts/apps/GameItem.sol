// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "../token/ERC721/ERC721.sol";
import "../token/ERC721/extensions/ERC721URIStorage.sol";
import "../utils/Counters.sol";

contract GameItem is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    mapping(uint => address) public holders;

    constructor() ERC721("GameItem", "ITM") {
        _tokenIds.increment();
    }

    function awardItem() public returns (uint) {
        uint itemId = _tokenIds.current();

        _safeMint(_msgSender(), itemId);
        _tokenIds.increment();

        return itemId;
    }
}