// SPDX-License-Identifier: UNLICENSED
// Author: Temisan Momodu
pragma solidity ^0.8.13;
import {PriceConverter} from "./PriceConverter.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

// Custom error for ownership check
error FundMe__NotOwner();

contract FundMe {
    using PriceConverter for uint256;

    // Chainlink Price Feed Interface
    AggregatorV3Interface private s_priceFeed;

    // Event emitted when a new price is received
    event PriceReceived(int256 price);

    // Minimum amount in USD required for funding
    uint256 public constant MINIMUM_USD = 5e18;

    // Array of Ethereum addresses of funders
    address[] public funders;

    // Mapping to track the amount funded by each address
    mapping(address => uint256) public addressToAmountFunded;

    // Owner's address
    address public immutable i_owner;

    // Contract constructor
    constructor(address priceFeed) {
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeed);
    }

    // Function to allow users to fund the contract
    function fund() public payable {
        // Ensure the sent amount meets the minimum USD requirement
        require(
            msg.value.getConversionRate(s_priceFeed) >= MINIMUM_USD,
            "Insufficient funds sent"
        );

        // Record the funder's address and the funded amount
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    // Function for the owner to withdraw funds
    function withdraw() public onlyOwner {
        // Reset amounts funded by each funder
        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }

        // Reset the funders array
        funders = new address[](0);

        // Transfer the contract balance to the owner
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Withdrawal failed");
    }

    // Function to log the latest price from the Chainlink Price Feed
    function logPrice() public {
        (, int256 price, , , ) = s_priceFeed.latestRoundData();

        // Log the received price for debugging
        emit PriceReceived(price);

        // Ensure the price is not negative (sanity check)
        require(price >= 0, "Negative price not supported");
    }

    // Function to get the version of the Chainlink Price Feed
    function getVersion() public view returns (uint256) {
        return s_priceFeed.version();
    }

    // Modifier to check if the sender is the owner
    modifier onlyOwner() {
        require(msg.sender == i_owner, "Not the owner");
        _;
    }
}
