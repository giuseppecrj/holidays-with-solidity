// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "../../access/Ownable.sol";
import "../../security/ReentrancyGuard.sol";

contract Auction is Ownable, ReentrancyGuard {
    uint public startBlock;
    uint public endBlock;
    string public ipfsHash;

    enum State {
        Started,
        Running, 
        Ended,
        Cancelled
    }
    State public auctionState;

    uint public highestBindingbid;
    address payable public highestBidder;
    
    mapping(address => uint) public bids;

    uint bidIncrement;

    constructor() {
        auctionState = State.Running;
        startBlock = block.number;
        endBlock = startBlock + 3; // a week
        ipfsHash = "";
        bidIncrement = 1 ether;
    }

    modifier notOwner() {
        require(_msgSender() != owner());
        _;
    }

    modifier afterStart() {
        require(block.number >= startBlock);
        _;
    }

    modifier beforeEnd() {
        require(block.number <= endBlock);
        _;
    }

    function min(uint a, uint b) internal pure returns (uint) {
        if ( a <= b) {
            return a;
        } else {
            return b;
        }
    }

    function placeBid() public payable notOwner afterStart beforeEnd {
        require(auctionState == State.Running, "!running");
        require(msg.value >= 100, "!enough cash");

        uint currentBid = bids[_msgSender()] + msg.value;
        require(currentBid > highestBindingbid);

        bids[_msgSender()] = currentBid;

        if (currentBid <= bids[highestBidder]) {
            highestBindingbid = min(currentBid + bidIncrement, bids[highestBidder]);
        } else {
            highestBindingbid = min(currentBid, bids[highestBidder] + bidIncrement);
            highestBidder = payable(_msgSender());
        }
    }

    function cancelAuction() public onlyOwner {
        auctionState = State.Cancelled;
    } 

    function finalizeAuction() public {
        require(auctionState == State.Cancelled || block.number > endBlock);
        require(_msgSender() == owner() || bids[_msgSender()] > 0);

        address payable recipient;
        uint value;

        if (auctionState == State.Cancelled) { // auction was cancelled
            recipient = payable(_msgSender());
            value = bids[_msgSender()];
        } else { // auction ended (not cancelled)
            if (_msgSender() == owner()) { // this is the owner
                recipient = payable(owner());
                value = highestBindingbid;
            } else { // this is the bidder
                if (_msgSender() == highestBidder) { // this is the highes bidder
                    recipient = highestBidder;
                    value = bids[highestBidder] - highestBindingbid; // return the difference
                } else { // this is just a bidder
                    recipient = payable(_msgSender());
                    value = bids[_msgSender()];
                }
            }
        }

        // reset the bids of the recipient to zero
        bids[recipient] = 0;

        (bool sent,) = recipient.call{ value: value }("");
        require(sent, "tx failed");
    }
}