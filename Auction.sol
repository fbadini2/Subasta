// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
    This contract implements a public auction where the time is extended if bids are received near the end.
    It uses events, bid history, and custom modifiers for clarity and security.
*/

contract Auction {

    // address of the contract owner (who can end the auction)
    address public owner;

    // address of the current highest bidder
    address public highestBidder;

    // current best offer amount
    uint public bestBid;

    // time at which the auction ends
    uint public endTime;

    // auction status
    bool public finished;

    // duration in seconds that the auction is extended if a bid is close to the end
    uint public constantExtension = 600; // 10 minutes = 600
    
    // return commission
    uint public constantCommission = 2; // 2% commission

    // Accumulate the retained commissions
    uint public totalCommissions; 

    

    // Save the best offer per bidder
    mapping(address => uint) public totalOffers;


    // mapping to record amounts to be returned to losing bidders
    mapping(address => uint) public refounds;


    // structure for the offer
    struct Bid {
        address bidder;
        uint amount;
    }

    // Complete history of offers made
    Bid[] public offerHistory;

    /*
        EVENTS
    */

    // It is emitted when a new bid is made
    event newOffer(address indexed bidder, uint amount);

    // It is emitted when the auction time is extended
    event extendedTime(uint newEndTime);

    // It is emitted at the end of the auction
    event auctionCompleted(address winner, uint finalAmount);

    // It is emitted when a bidder withdraws funds
    event withdrawnFunds(address indexed withdrawer, uint amount);

    // It is emitted when a refund of funds is processed
    event refundProcessed(address indexed bidder, uint amountProcessed, uint commission);

    // It is emitted when the owner collects his commissions
    event commissionsWithdrawn(uint amount);

    /*
        MODIFIERS
    */

    // Restricts execution to only the owner of the contract
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can run it");
        _;
    }

    // Requires that the auction has not been completed
    modifier activeAuction() {
        require(!finished, "The auction is over");
        _;
    }

    // Requires us to be there before the closing time
    modifier beforeTheEnd() {
        require(block.timestamp < endTime, "The auction is over");
        _;
    }

    // Requires us to be there after the closing time
    modifier despuesDelFin() {
        require(block.timestamp >= endTime, "The auction period has not yet ended");
        _;
    }

    /*
        CONSTRUCTOR
    
    */

    // Initializes the auction ( _initialDurationSeconds: Initial duration time in seconds )
    constructor(uint _initialDurationSeconds) {
        owner = msg.sender;
        endTime = block.timestamp + _initialDurationSeconds;
    }

    /*
        FUNCTIONS
    
    */



    // Allows bidders to bid. Each new offer must be at least 5% higher than the current highest offer
    function bid() external payable activeAuction beforeTheEnd {
        require(msg.value > bestBid * 105/100, "Must exceed the current offer by at least 5%");


        highestBidder = msg.sender;
        bestBid = msg.value;

        offerHistory.push(Bid({
            bidder: msg.sender,
            amount: msg.value
        }));

        emit newOffer(msg.sender, msg.value);

        if (endTime - block.timestamp < constantExtension) {
            endTime = block.timestamp + constantExtension;
            emit extendedTime(endTime);
        }
    }

    // Allows withdraw funds from the auction for non-winning bidders
    function withdraw() external {
        uint amount = refounds[msg.sender];
        require(amount > 0, "There are no funds to withdraw");
        payable(msg.sender).transfer(amount);
        refounds[msg.sender] = 0;
    }


    // End the auction and transfer the funds to the owner
    function endAuction() external onlyOwner activeAuction {
        finished = true;
        payable(owner).transfer(bestBid);

        // Process refunds to all non-winning bidders
        for (uint i = 0; i < offerHistory.length; i++) {
            address bidder = offerHistory[i].bidder;

            if (bidder == highestBidder) {
                continue;
            }

            uint offer = totalOffers[bidder];
            uint commission = (offer * constantCommission) / 100;
            uint amountReimbursed = offer - commission;
            refounds[bidder] += amountReimbursed;
            
            emit refundProcessed(bidder, amountReimbursed, commission);

        }
    }

    // Allows the owner to withdraw accumulated commissions
    function withdrawCommissions() external onlyOwner {
        require(finished, "Commissions can only be withdrawn when the auction ends");
        require(totalCommissions > 0, "There are no fees for withdrawal");

        uint amount = totalCommissions;
        totalCommissions = 0;
        payable(owner).transfer(amount);

        emit commissionsWithdrawn(amount);
    }

    // Returns the list of all bids placed in the auction.
    function getOfferHistory() external view returns (Bid[] memory) {
        return offerHistory;
    }
}
