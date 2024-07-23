// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/IDO.sol";
import "../src/RNT.sol";

contract IDOTest is Test {
    IDO ido;
    RNT rnt;

    function setUp() public {
        rnt = new RNT();
        ido = new IDO(
            10e18,
            1 days,
            address(rnt)
        );
    }

    function test_preSale(address buyer) public {
        vm.deal(buyer, 1000 ether);
        vm.prank(buyer);
        ido.preSale{value: 1 ether}();
        assertEq(ido.balanceOf(buyer), 1 ether);

        vm.prank(buyer);
        (bool suc, ) = address(ido).call{value: 1 ether}("");
        assert(suc);
        assertEq(ido.balanceOf(buyer), 2 ether);
    }

    function test_claimBeforeEnding(address buyer) public {
        vm.deal(buyer, 100 ether);
        vm.prank(buyer);
        ido.preSale{value: 1 ether}();
        vm.prank(buyer);
        vm.expectRevert("presale failed");
        ido.claim();
    }

    function test_claimSucceeded(address buyer) public {
        vm.deal(buyer, 10000 ether);
        vm.prank(buyer);
        ido.preSale{value: 205 ether}();
        rnt.transfer(address(ido), 1e10);
        vm.warp(1.1 days);
        vm.prank(buyer);
        ido.claim();

        assertEq(rnt.balanceOf(buyer), 1e9);
    }
}