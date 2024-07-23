// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract IDO {
    uint256 totalSale;
    uint256 endtime;
    address RNTaddr;
    mapping(address => uint256) public balanceOf;
    address owner;

    constructor(
        uint256 totalSale_,
        uint256 period,
        address tokenAddr
    ) {
        totalSale = totalSale_;
        endtime = block.timestamp + period;
        RNTaddr = tokenAddr;
        owner = msg.sender;
    }

    function preSale() external payable {
        balanceOf[msg.sender] += msg.value;
    }

    function claim() onlySucceeded external {
        uint256 reward = 1e9 * balanceOf[msg.sender] / address(this).balance;
        balanceOf[msg.sender] = 0;
        IERC20(RNTaddr).transfer(msg.sender, reward);
    }

    function withdraw() onlyOwner external {
        payable(owner).transfer(address(this).balance);
    }

    function refund() onlyFailed external{
        (bool suc, ) = msg.sender.call{value: balanceOf[msg.sender]}("");
        require(suc, "refund failed");
        balanceOf[msg.sender] = 0;
    }
    
    receive() external payable {
        balanceOf[msg.sender] += msg.value;
    }

    modifier onlySucceeded() {
        require(
            block.timestamp > endtime && address(this).balance >= 100 ether,
            "presale failed"
        );
        _;
    }

    modifier onlyFailed() {
        require(
            block.timestamp > endtime && address(this).balance < 100 ether,
            "presale succeeded"
        );
        _;
    }

    modifier onlyActive() {
        require(
            block.timestamp < endtime && address(this).balance < 200 ether,
            "presale not active"
        );
        _;
    }

    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "admin right needed"
        );
        _;
    }
}