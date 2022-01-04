// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./Auction.sol";
import "../../access/Ownable.sol";

contract AuctionCreator is Ownable {
    Auction[] public auctions;

    function createAuction() public {
        Auction newAuction = new Auction();
        newAuction.transferOwnership(_msgSender());
        auctions.push(newAuction);
    }
}