// SPDX-License-Identifier: MIT
// Author: Temisan Momodu
pragma solidity ^0.8.18;
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    // Get the latest price from the Chainlink Price Feed
    function getPrice(AggregatorV3Interface priceFeed) public view returns (uint256) {
        (, int256 price, , , ) = priceFeed.latestRoundData();
        // Multiply by 1e10 to convert to a uint256 value
        return uint256(price) * 1e10;
    }

    // Get the conversion rate for a given amount of ETH
    function getConversionRate(uint256 ethAmount, AggregatorV3Interface priceFeed) public view returns (uint256) {
        uint256 ethPrice = getPrice(priceFeed);
        // Calculate the amount in USD
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }

    // Get the version of the Chainlink Price Feed
    function getVersion(AggregatorV3Interface priceFeed) public view returns (uint256) {
        // Use a specific address for Chainlink Price Feed to get the version
        return priceFeed.version();
    }
}
