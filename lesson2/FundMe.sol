// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18; 

contract Fundme {
    function fund() public payable  {
        require(msg.value > 1e18, "didn't send the transaction");
    }

    // function withdraw () public  {
        
    // }
}