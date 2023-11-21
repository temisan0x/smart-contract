// SPDX-License-Identifier: MIT
// Author: Temisan Momodu
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/lesson2/FundMe.sol";

contract DeployFundMe is Script {
    // Deploy a new instance of the FundMe contract
    function run() external returns (FundMe) {
        // Start broadcasting transactions
        vm.startBroadcast();

        // Deploy FundMe with a specific Chainlink Price Feed address
        FundMe fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);

        // Stop broadcasting transactions
        vm.stopBroadcast();

        // Return the deployed FundMe contract
        return fundMe;
    }
}
