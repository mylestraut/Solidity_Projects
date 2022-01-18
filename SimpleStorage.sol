// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

contract SimpleStorage {
    // This will initialise to 0!
    // Automatically initializes to internal if not otherwise stated
    uint256 favouriteNumber;

    function store(uint256 _favouriteNumber) public {
        favouriteNumber = _favouriteNumber;
    }

    // Structs are like custom types or objects.
    // The below struct is of type: People
    struct People {
        uint256 favouriteNumber;
        string name;
    }

    // Create a dymanic array for storing people
    People[] public people;

    // Mapping are like dicts that store one key/value pair
    mapping(string => uint256) public nameToFavouriteNum;

    // Create function that adds people to the array
    // Memory keyword says the variable will only exist during that function call
    // Storage keyword says it will persist after the function has completed
    function addPerson(string memory _name, uint256 _favouriteNumber) public {
        // Long way
        // people.push(People({favouriteNumber: _favouriteNumber, name: _name}));
        // Short Way
        people.push(People(_favouriteNumber, _name));
        nameToFavouriteNum[_name] = _favouriteNumber;
    }

    // View and pure functions have a blue block
    // They do not change the state of the blockchain
    // Pure functions simply do som kind of math with no saving of state
    function retrieve() public view returns (uint256) {
        return favouriteNumber;
    }
}
