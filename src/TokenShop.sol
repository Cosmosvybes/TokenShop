// SPDX-License-Identifier:MIT
pragma solidity 0.8.26;
//?? ////////////////////////////////
//DATA FEED AGGREGATOR

import "../lib/chainlink-brownie-contracts/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
//?? ////////////////////////////////
//SAFE MATH
import "../src/SafeMath/SafeMath.sol";

//?? ////////////////////////////////
//TOKEN INTERFACE

interface ITOKEN {
    function mint(address _to, uint256 _value) external returns (bool);
}

//?? ////////////////////////////////
// TOKEN SHOP
contract TokenShop {
    using SafeMath for uint256;
    uint256 tokenPrice = 1000; // $10
    address token;

    constructor(address token_) {
        token = token_;
    }

    function getPrice() internal view returns (uint256) {
        AggregatorV3Interface dataFeed = AggregatorV3Interface(
            0x694AA1769357215DE4FAC081bf1f309aDC325306
        );
        (, int256 price, , , ) = dataFeed.latestRoundData();
        return uint256(price);
    }

    function tokenQoutes(uint256 _ethAmount) internal view returns (uint256) {
        uint256 ethUsdPrice = getPrice();
        uint256 ethAmount = ethUsdPrice.mul(_ethAmount).div(10 ** 18);
        uint256 tokenAmount = ethAmount.div(tokenPrice).div(10 ** (8 / 2));
        return tokenAmount;
    }
    receive() external payable {
        uint256 tokens = tokenQoutes(msg.value);
        ITOKEN(token).mint(msg.sender, tokens);
    }
}
