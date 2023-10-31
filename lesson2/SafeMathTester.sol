// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TestNumber {
    uint8 public NumberTest = 255; //max number

    function add() public {
       unchecked { NumberTest += 1;} //makes it efficient
    }
}