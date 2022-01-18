// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// Use import statement instead of copying redunded code to top of file
import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";

// Above import and below interface are the same
/*interface AggregatorV3Interface {
    function decimals() external view returns (uint8);

    function description() external view returns (string memory);

    function version() external view returns (uint256);

    // getRoundData and latestRoundData should both raise "No data present"
    // if they do not have data to report, instead of returning unset values
    // which could be misinterpreted as actual reported values.
    function getRoundData(uint80 _roundId)
        external
        view
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        );

    function latestRoundData()
        external
        view
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        );
}*/

contract FundMe {
    using SafeMathChainlink for uint256;
    // Create a mapping of addresses to see who funded which amount
    mapping(address => uint256) public addressToAmountFunded;
    address[] funders;
    address public owner;

    // create owner for this contract
    // constructor is called as soon as contract is created
    constructor() public {
        // owner is whoever creates this contract
        owner = msg.sender;
    }

    // Create function that can accept payment
    // Payable keyword says that function can accept payment in eth, gwei or wei
    // Msg.sender & Msg.value are keywords in every transaction
    function fund() public payable {
        // fund a min of $50
        // 50$ x 10 to the power 18 to get the qmount in wei
        uint256 minimumAmount = 50 * 10 * 18;
        require(
            getConversionRate(msg.value) >= minimumAmount,
            "You need to spend more eth"
        );
        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
    }

    function getVersion() public view returns (uint256) {
        // Type - visibility - name
        // Must have the location(address) of the pricefeed on specific network eg Rinkeby
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0x8A753747A1Fa494EC906cE90E9f37563A8AF630e
        );
        // We now have access to the functions in the AggregatorV3Interface contract
        return priceFeed.version();
    }

    function getPrice() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0x8A753747A1Fa494EC906cE90E9f37563A8AF630e
        );
        // Commas take the place of usnused variables that are returned
        (, int256 answer, , , ) = priceFeed.latestRoundData();
        return uint256(answer * 100000000);
    }

    // 1000000000
    function getConversionRate(uint256 ethAmount)
        public
        view
        returns (uint256)
    {
        uint256 ethPrice = getPrice();
        uint256 ethUsdAmount = (ethPrice * ethAmount) / 10000000000000000000;
        return ethUsdAmount;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function withdraw() public payable onlyOwner {
        // this says transfer to whoever calls this function the balance of funds in THIS contract.
        // whenever this is called it refers to the current contract you are in
        msg.sender.transfer(address(this).balance);
        // reset all funders balances to zero after withdrawal
        for (
            uint256 fundersIndex = 0;
            fundersIndex < funders.length;
            fundersIndex++
        ) {
            address funder = funders[fundersIndex];
            addressToAmountFunded[funder] = 0;
        }
        // create new funders array once all balances have been set to zero
        funders = new address[](0);
    }
}
