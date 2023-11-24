//SPX-License-Identifier:MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    address USER = makeAddr("user"); //mock address
    uint256 constant SEND_VALUE = 0.1 ether; //1000000000000000
    uint256 constant STARTING_BALANCE = 10 ether;

    // Deploy FundMe contract before each test
    function setUp() external {
        DeployFundMe deployfundMe = new DeployFundMe();
        fundMe = deployfundMe.run();
        vm.deal(USER, STARTING_BALANCE);
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
    function testPriceFeedVersionIsAccurate() public {
        uint256 version = fundMe.getVersion();
        console.log(version);
        assertEq(version, 4); // Update the expected version as needed
    }

    function testFundFailsWithoutEnoughETH() public {
        vm.expectRevert();
        fundMe.fund();//0 value
    }

    function testFundUpdatesFundedDataStructure() public{
        vm.prank(USER);//the next transaction will be sent by the user
        fundMe.fund{value: SEND_VALUE}();
        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFunded, SEND_VALUE);
    }
}
