// SPDX-License-Identifier: MIT 
pragma solidity 0.8.18; //stating out version

contract SimpleStorage {
    uint256 public myFavouriteNumber; //0

    struct Person {
        uint256 favoriteNumber; //defaulted to 0
        string name;
    }

    Person[] public listOfPerson;//[]
    mapping (string => uint256) public nameToFavoriteNumber;

    function store(uint256 _favouriteNumber) public  {
        myFavouriteNumber = _favouriteNumber;
        retrieve();
    }

    //
    //view --read the state of the blockchain
    function retrieve() public view returns (uint256){
        return  myFavouriteNumber;
    }

     function addPerson(string memory _name, uint256 _favoriteNumber) public {
        listOfPerson.push( Person(_favoriteNumber, _name));
    }

}