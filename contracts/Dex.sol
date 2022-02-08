// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;
import "./Wallet.sol";

contract Dex is Wallet {
    using SafeMath for uint256;

    enum Side {
        BUY,
        SELL
    }
    struct Order {
        uint id;
        address trader;
        Side side;
        bytes32 ticker;
        uint amount;
        uint price;
        uint filled;
    }

    uint public nextOrderId;

    mapping(bytes32 => mapping(uint => Order[])) public orderBook;

    function getOrderBook(bytes32 ticker, Side side) public view  returns (Order[] memory) {
        return orderBook[ticker][uint(side)];
    }

    function createLimitOrder(Side side, bytes32 ticker, uint amount, uint price, uint filled) public {
        if(side == Side.BUY) {
            require(balances[msg.sender]["ETH"] >= amount.mul(price), 'inseffuient funds');
        } else if(side == Side.SELL) {
            require(balances[msg.sender][ticker] >= amount, 'inseffuient funds');
        }

        Order[] storage orders = orderBook[ticker][uint(side)];

        orders.push(
            Order(nextOrderId, msg.sender, side, ticker, amount, price, filled)
        );

        // Bubble sort
        uint i = orders.length > 0 ? orders.length - 1: 0;

        if(side == Side.BUY) {
           while(i > 0) {
               if(orders[i - 1].price > orders[i].price) {
                   break;
               }
               Order memory ordersToMove = orders[i - 1];
               orders[i - 1] = orders[i];
               orders[i] = ordersToMove;
               i--;
           }
        }
        else if (side == Side.SELL) {
             while(i > 0) {
               if(orders[i - 1].price < orders[i].price) {
                   break;
               }
               Order memory ordersToMove = orders[i - 1];
               orders[i - 1] = orders[i];
               orders[i] = ordersToMove;
               i--;
           }
        }
        nextOrderId++;

    }

    function createMarketOrder(Side side, bytes32 ticker, uint amount) public {
        if(side == Side.SELL){
            require(balances[msg.sender][ticker] >= amount, "Insuffient balance");
        }

        uint orderBookSide;

        if(side == Side.BUY){
            orderBookSide = 1;
        } else {
            orderBookSide = 0;
        }
        Order[] storage orders = orderBook[ticker][orderBookSide];

        uint totalFilled;

        for (uint256 i = 0; i < orders.length && totalFilled < amount; i++) {
            // How much we can fill from order[i];
            
            // udate totalFilled;

            // Execute the trade & shift balances between buyer/seller
            // Verify that the buyer has enough eth to cover purchase;
        }

        // Loop through the orderbook and remview 100% filled orders
    }


}