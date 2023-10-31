// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18; 

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

    event PriceReceived(int256 price); 
    uint256 public mininumUsd = 5e18; //5 eth(in wei)
    //50000000000000000000

    function fund() public payable  {
      //Allow users to send $
      //Have a minumum $ snet $5
        require(getConversionRate(msg.value) >= mininumUsd, "didn't send the transaction");
    }

    function withdraw() public {
        // Address 0x694AA1769357215DE4FAC081bf1f309aDC325306
    }

    function getVersion() public view returns(uint256) {
      return AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306).version();
    }

    function logPrice() public {
       AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
       (, int256 price, , ,) = priceFeed.latestRoundData();
       
       // Answer = price of eth in USD
       // Log the received price for debugging
      emit PriceReceived(price);
       
      require(price >= 0, "Negative price not supported");
    }

      function getPrice() public view returns(uint256) {
       AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
       (, int256 price, , ,) = priceFeed.latestRoundData();
      
       return uint256(price * 1e10);
    }

    function getConversionRate(uint256 ethAmount) public view returns(uint256) {
      uint256 ethPrice = getPrice();
      uint256 ethAmountInUsd = (ethPrice * ethAmount)/ 1e18;
      return ethAmountInUsd;
    }
}
 
 
//returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound);
//uint256: 1829445376950000000000
//uint256: 182944537695
