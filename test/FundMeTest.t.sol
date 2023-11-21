// SPDX-License-Identifier: MIT
// Author: Temisan Momodu
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src//lesson2/FundMe.sol";
import {DeployFundMe} from "../srcipt/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    // Deploy FundMe contract before each test
    function setUp() external {
        DeployFundMe deployfundMe = new DeployFundMe();
        fundMe = deployfundMe.run();
    }

    // Test that the minimum USD value is set to 5 ETH
    function testMinimumDollarIsFive() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    // Test that the owner is the address that deployed the contract
    function testOwnerIsMsgSender() public {
        console.log(fundMe.i_owner());
        console.log(msg.sender);
        assertEq(fundMe.i_owner(), msg.sender);
    }

    // Test the version of the Chainlink Price Feed in the FundMe contract
    function testPriceFeedVersion() public {
        uint256 version = fundMe.getVersion();
        console.log(version);
        assertEq(version, 4); // Update the expected version as needed
    }
}
