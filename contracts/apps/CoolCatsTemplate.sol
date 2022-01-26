// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "../token/ERC721/extensions/ERC721Enumerable.sol";
import "../access/Ownable.sol";

/**
 * Solidity Contract Template based on CoolCatsNFT
 * Source: https://etherscan.io/address/0x1a92f7381b9f03921564a437210bb9396471050c#contracts
 *
 * The SimpleTemplate contract is very well written and very gas efficient. 
 * Consider using this approach if you're creating NFTs off-chain.
 * Can cost as low as $100 at 14 October 2021 ETH Price of $3,527. 
 * SimpleTemplate team deployed this contract for $55.59 at $1,983 ETH Price from 27 June 2021.
 *
 * The trick is to just use _safeMint without using _setTokenURI at all. Hence no ERC721Metadata.sol imported.
 * tokenURI function will just concatenate the baseURI with the token id when calling the function.
 */

contract SimpleTemplate is ERC721Enumerable, Ownable {
    using Strings for uint;

    string _baseTokenURI;
    uint private _reserved = 100;
    uint private _price = 0.06 ether;

    bool public _paused = true;

    address t1 = 0x8016401D260726539BcbF1c05f6620944C04eD46;

    constructor(string memory baseURI) ERC721("Cool Dogs", "COLD") {
        setBaseURI(baseURI);

        _safeMint(t1, 0);
    }

    // Minting function
    function adopt(uint num) public payable {
        uint supply = totalSupply();

        require(!_paused, "SimpleTemplate: Sale paused");

        require(num < 21, "SimpleTemplate: You can adopt a max of 20 NFT");

        require(supply + num < 1000 - _reserved, "SimpleTemplate: Exceeds max NFT supply");

        require(msg.value >= _price * num, "SimpleTemplate: Ether sent is not correct");

        for (uint i; i < num; i++) {
            _safeMint(_msgSender(), supply + i);
        }
    }

    function walletOfOwner(address _owner) public view returns (uint[] memory) {
        uint tokenCount = balanceOf(_owner);

        uint[] memory tokensId = new uint[](tokenCount);
        for (uint i; i < tokenCount; i++) {
            tokensId[i] = tokenOfOwnerByIndex(_owner, i);
        }
        return tokensId;
    }

    // Ability to change the price if ETH gets too expensive
    function setPrice(uint _newPrice) public onlyOwner {
        _price = _newPrice;
    }

    function _baseURI() internal view override returns (string memory) {
        return _baseTokenURI;
    }

    function setBaseURI(string memory baseURI) public onlyOwner {
        _baseTokenURI = baseURI;
    }

    function getPrice() public view returns (uint) {
        return _price;
    }

    function giveAway(address _to, uint _amount) external onlyOwner {
        require(_amount <= _reserved, "SimpleTemplate: Exceeds reserved NFT supply");

        uint supply = totalSupply();
        for (uint i; i < _amount; i++) {
            _safeMint( _to, supply + i );
        }

        _reserved -= _amount;
    }

    function pause(bool val) public onlyOwner {
        _paused = val;
    }

    function withdrawAll() public payable onlyOwner {
        uint _each = address(this).balance / 1;
        require(payable(t1).send(_each));

    }
}