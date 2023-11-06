// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18; 
import {PriceConverter} from "./PriceConverter.sol";


interface AggregatorV3Interface {
  function decimals() external view returns (uint8);

  function description() external view returns (string memory);

  function version() external view returns (uint256);

  function getRoundData(
    uint80 _roundId
  ) external view returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound);

  function latestRoundData()
    external
    view
    returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound);
}



contract FundMe {
    using PriceConverter for uint256;

    event PriceReceived(int256 price); 
    address public owner;

    constructor() {
      owner = msg.sender;
    }

    uint256 public mininumUsd = 5e18; //5 eth(in wei)
    //50000000000000000000
    mapping(address funder => uint256 amountFunded) public addressToAmountFunded;
    address [] public funders; //this will represent an array of Ethereum addresses for funders 


    function fund() public payable  {
      //Allow users to send $
      //Have a minumum $ snet $5
     require(msg.value.getConversionRate() >= mininumUsd, "didn't send the transaction");
     funders.push(msg.sender);//push the sender of the transaction to the contract
    }


    function withdraw() public onlyOwner{

        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex ++){
          address funder = funders[funderIndex];
          addressToAmountFunded[funder] = 0;//reset the amount sent to 0;
        }
        //reset array
        funders = new address[](0);

        //Lower level functions
        //transfer
        //payable (msg.sender).transfer(address(this).balance);
        //send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "Send failed");
        //call
       (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
       require(callSuccess, "call failed");

    }

    function logPrice() public {
       AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
       (, int256 price, , ,) = priceFeed.latestRoundData();
        
       // Answer = price of eth in USD
       // Log the received price for debugging
      emit PriceReceived(price);  
      require(price >= 0, "Negative price not supported");
    }

    //executes the modifier first
    modifier onlyOwner(){
      require(msg.sender == owner, "Sender is no the owner");
      _;
    }
}
 
 
//returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound);
//uint256: 1829445376950000000000
//uint256: 182944537695
