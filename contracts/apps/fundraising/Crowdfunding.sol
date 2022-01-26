// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "../../access/Ownable.sol";
import "../../security/ReentrancyGuard.sol";

interface ICrowdFunding {
    event ContributeEvent(address _sender, uint _value);
    event CreateRequestEvent(string _description, address _recipient, uint _value);
    event MakePaymentEvent(address _recipient, uint _value);
}

contract CrowdFunding is Ownable, ReentrancyGuard, ICrowdFunding {
    mapping(address => uint) public contributors;
    uint public noOfContributors;
    uint public minimumContribution;
    uint public deadline; // timestamp
    uint public goal;
    uint public raisedAmount;

    struct Request { 
        string description;
        address payable recipient;
        uint value; 
        bool completed;
        uint noOfVoters;
        mapping(address => bool) voters;
    }
    mapping(uint => Request) public requests;
    uint public numRequests;

    constructor (uint goal_, uint deadline_) {
        goal = goal_;
        deadline = block.timestamp + deadline_;
        minimumContribution = 100 wei;
    }

    receive() payable external {
        contribute();
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    function contribute() public payable {
        require(block.timestamp < deadline, "CrowdFunding: deadline has passed");
        require(msg.value >= minimumContribution, "CrowdFunding: min contribution not met");

        if (contributors[_msgSender()] == 0) {
            noOfContributors++;
        }

        contributors[_msgSender()] += msg.value;
        raisedAmount += msg.value;

        emit ContributeEvent(_msgSender(), msg.value);
    }

    function refund() public {
        require(block.timestamp > deadline && raisedAmount < goal, "CrowdFunding: goal not met yet");
        require(contributors[_msgSender()] > 0, "CrowdFunding: not a contributor");

        address payable recipient = payable(_msgSender());
        uint value = contributors[_msgSender()];
        (bool sent,) = recipient.call{ value: value }("");
        require(sent, "Crowdfunding: refund failed");

        contributors[_msgSender()] = 0;
    }

    function createRequest(
        string memory _description,
        address payable _recipient,
        uint _value
    ) public onlyOwner {
        Request storage newRequest = requests[numRequests];
        numRequests++;

        newRequest.description = _description;
        newRequest.recipient = _recipient;
        newRequest.value = _value;
        newRequest.completed = false;
        newRequest.noOfVoters = 0;

        emit CreateRequestEvent(_description, _recipient, _value);
    }

    function voteRequest(uint _requestNo) public {
        require(contributors[_msgSender()] > 0, "CrowdFunding: not a contributor");
        Request storage thisRequest = requests[_requestNo];

        require(thisRequest.voters[_msgSender()] == false, "CrowdFunding: already voted");
        thisRequest.voters[_msgSender()] = true;
        thisRequest.noOfVoters++;
    }

    function makePayment(uint _requestNo) public onlyOwner nonReentrant {
        require(raisedAmount >= goal, "CrowdFunding: not enough money raised");
        Request storage thisRequest = requests[_requestNo];

        require(thisRequest.completed == false, "CrowdFunding: request has been completed");
        require(thisRequest.noOfVoters > noOfContributors / 2, "CrowdFunding: not enought contributers have voted"); // need 50% of contributors to vote

        (bool sent,) = thisRequest.recipient.call{ value: thisRequest.value }("");
        require(sent, "CrowdFunding: payment failed");
        thisRequest.completed = true;

        emit MakePaymentEvent(thisRequest.recipient, thisRequest.value);
    }
}