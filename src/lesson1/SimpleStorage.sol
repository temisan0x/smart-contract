// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.18; //stating out version

contract SimpleStorage {
    uint256 myFavoriteNumber; //0

    struct Person {
        uint256 favoriteNumber; //defaulted to 0
        string name;
    }

    Person[] public listOfPerson;//[]

    //eg. temy => 9
    mapping (string => uint256) public nameToFavoriteNumber;

    function store(uint256 _favoriteNumber) public virtual  {
        myFavoriteNumber = _favoriteNumber;
    }

    //view --read the state of the blockchain
    function retrieve() public view returns (uint256){
        return  myFavoriteNumber;
    }

    //memory can be modified, unlike callback
    function addPerson(string memory _name, uint256 _favoriteNumber)public  {
        listOfPerson.push(Person(_favoriteNumber, _name));
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }
}