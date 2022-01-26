// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "../token/ERC1155/ERC1155.sol";
import "../utils/Context.sol";
import "../utils/Strings.sol";
import "../access/Ownable.sol";

contract GameItem is ERC1155, Ownable {
    uint public constant GOLD = 0;
    uint public constant SILVER = 1;
    uint public constant THORS_HAMMER = 2;
    uint public constant SWORD = 3;
    uint public constant SHIELD = 4;

    mapping(uint => string) private _uris;

    constructor () ERC1155("https://game.example.com/api/item/{id}.json") {
        _mint(_msgSender(), GOLD, 10**18, "");
        _mint(_msgSender(), SILVER, 10**27, "");
        _mint(_msgSender(), THORS_HAMMER, 1, "");
        _mint(_msgSender(), SWORD, 10**9, "");
        _mint(_msgSender(), SHIELD, 10**9, "");
    }

    function setTokenURI(uint tokenId, string memory _uri) public onlyOwner {
        require(bytes(_uris[tokenId]).length == 0, "Cannot set uri twice");
        _uris[tokenId] = _uri;
    }

    function uri(uint tokenId) override public view returns (string memory) {
        if (bytes(_uris[tokenId]).length > 0) {
            return _uris[tokenId];
        } else {
            return (
                string(
                    abi.encodePacked(
                        "https://game.example.com/api/item/",
                        Strings.toString(tokenId),
                        ".json"
                    )
                )
            );
        }
    }
}
