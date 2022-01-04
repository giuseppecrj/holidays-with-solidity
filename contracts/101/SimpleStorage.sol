
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract SimpleStorage {
    uint favoriteNumber;
    bool favoriteBool;

    struct People {
        uint favoriteNumber;
        string name;
    }

    People[] public people;

    function store(uint _favoriteNumber) public {
        favoriteNumber = _favoriteNumber;
    }

    function retrieve() public view returns (uint) {
        return favoriteNumber;
    }

    // 2 ways to store info
    // memory during execution
    // storage persist after execution
    function addPerson(string memory _name, uint _favoriteNumber) public {
        people.push(People(_favoriteNumber, _name));
    }
}