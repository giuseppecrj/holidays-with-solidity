// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "../../utils/Counters.sol";
import "../../utils/Context.sol";
import "../../security/ReentrancyGuard.sol";
import "../../access/Ownable.sol";
import "../../token/ERC721/ERC721.sol";

interface INFTMarket {
  event MarketItemCreated (
    uint indexed itemId,
    address indexed nftContract,
    uint256 indexed tokenId,
    address seller,
    address owner,
    uint256 price,
    bool sold
  );
}

contract NFTMarket is INFTMarket, ReentrancyGuard, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _itemIds;
    Counters.Counter private _itemsSold;

    uint private listingPrice = 0.025 ether;

    struct MarketItem {
        uint itemId;
        address nftContract;
        uint tokenId;
        address payable seller;
        address payable owner;
        uint price;
        bool sold;
    }

    mapping(uint => MarketItem) private idToMarketItem;


    function getListingPrice() public view returns(uint) {
        return listingPrice;
    }

    // Places an item for sale on the marketplace
    function createMarketItem(address nftContract, uint tokenId, uint price) public payable nonReentrant {
        require(price > 0, "NFTMarket: Price must be at least 1 wei");
        require(msg.value == listingPrice,"NFTMarket: Value must be equal to listing price");

        _itemIds.increment();
        uint itemId = _itemIds.current();

        idToMarketItem[itemId] = MarketItem(
            itemId,
            nftContract,
            tokenId,
            payable(_msgSender()),
            payable(address(0)),
            price,
            false
        );

        // Transfer ownership of nft to our marketplace
        IERC721(nftContract).transferFrom(_msgSender(), address(this), tokenId);

        emit MarketItemCreated(
            itemId,
            nftContract,
            tokenId,
            _msgSender(),
            address(0),
            price,
            false
        );
    }

    // Create the sale of a marketplate item
    // Transfer ownership of the item, as well as funds between parties
    function createMarketSale(address nftContract, uint itemId) public payable nonReentrant {
        address buyer = _msgSender();
        uint price = idToMarketItem[itemId].price;
        uint tokenId = idToMarketItem[itemId].tokenId;
        require(msg.value == price, "NFTMarket: Please submit asking price");

        (bool success,) = idToMarketItem[itemId].seller.call{value: msg.value}("");
        require(success, "NFTMarket: Sale did not go through");

        IERC721(nftContract).transferFrom(address(this), buyer, tokenId);
        idToMarketItem[itemId].owner = payable(buyer);
        idToMarketItem[itemId].sold = true;
        _itemsSold.increment();
        
        // transfer money to owner
        (bool royalty,) = payable(owner()).call{ value: listingPrice}("");
        require(royalty, "NFTMarket: Royalty transfer did not work");
    }

    // Returns all unsold market items
    function fetchMarketItems() public view returns (MarketItem[] memory) {
        uint itemCount = _itemIds.current();
        uint unsoldItemCount = _itemIds.current() - _itemsSold.current();
        uint currentIndex = 0;

        MarketItem[] memory items = new MarketItem[](unsoldItemCount);
        for (uint i = 0; i < itemCount; i++) {            
            if (idToMarketItem[i + 1].owner == address(0)) {
                uint currentId = i + 1;
                MarketItem storage currentItem = idToMarketItem[currentId];
                items[currentIndex] = currentItem;
                currentIndex += 1;
            }
        }
        return items;
    }

    // Returns only items that a user has purchased
    function fetchMyNFTs() public view returns(MarketItem[] memory) {
        uint totalItemCount = _itemIds.current();
        uint itemCount = 0 ;
        uint currentIndex = 0;

        // go through all items and if owner is equal to sender then up the count
        for (uint i = 0; i < totalItemCount; i++) {
            if (idToMarketItem[i + 1].owner == _msgSender()) {
                itemCount += 1;
            }
        }

        // create static array
        MarketItem[] memory items = new MarketItem[](itemCount);

        // go through all items and if owner is equal to sender then push to items
        for (uint i = 0; i < totalItemCount; i++) {
            if (idToMarketItem[i + 1].owner == _msgSender()) {
                uint currentId = i + 1;
                MarketItem storage currentItem = idToMarketItem[currentId];
                items[currentIndex] = currentItem;
                currentIndex += 1;
            }
        }

        return items;
    }

    // Return only items a user has created
    function fetchItemsCreated() public view returns (MarketItem[] memory) {
        uint totalItemCount = _itemIds.current();
        uint itemCount = 0;
        uint currentIndex = 0;

        for (uint i = 0; i < totalItemCount; i++) {
            if (idToMarketItem[i + 1].seller == _msgSender()) {
                itemCount += 1;
            }
        }

        MarketItem[] memory items = new MarketItem[](itemCount);

        for (uint i = 0; i < totalItemCount; i++) {
            if (idToMarketItem[i + 1].seller == _msgSender()) {
                uint currentId = i + 1;
                MarketItem storage currentItem = idToMarketItem[currentId];
                items[currentIndex] = currentItem;
                currentIndex += 1;
            }
        }

        return items;
    }
}
