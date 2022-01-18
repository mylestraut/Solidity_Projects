// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

// Import must have the filepath to the imported contract
// ./ means in the same folder
import "./SimpleStorage.sol";

contract StorageFactory is SimpleStorage {
    // Initialse array to store simplestorage contracts
    SimpleStorage[] public simpleStorageArray;

    function createSimpleStorageContract() public {
        // Initialse a new simple storage contract of type SimpleStorage
        SimpleStorage simpleStorage = new SimpleStorage();
        //Push simple storage contracts to simpleStorageArray
        simpleStorageArray.push(simpleStorage);
    }

    // Fisrt parameter is the index in the SimpleStorageArray of the contract we want to interact with
    // Second number is the number we want to store when we call SimpleStorage.store()
    function sfStore(uint256 _simpleStorageIndex, uint256 _simpleStorageNumber)
        public
    {
        //Address
        //ABI
        // Get the address of the SimpleStorageContract at the _simpleStorageIndex in the simpleStorageArray
        SimpleStorage(address(simpleStorageArray[_simpleStorageIndex])).store(
            _simpleStorageNumber
        );
    }

    function sfGet(uint256 __simpleStorageIndex) public view returns (uint256) {
        SimpleStorage(address(simpleStorageArray[__simpleStorageIndex]))
            .retrieve();
    }
}
