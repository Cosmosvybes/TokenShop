// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.26;
import "../src/Token.sol";
import "../src/TokenShop.sol";

import {Test, console} from "forge-std/Test.sol";

contract Tokentest is Test {
    Token token;
    TokenShop shop;
    function setUp() public {
        vm.prank(0x70997970C51812dc3A010C7d01b50e0d17dc79C8);
        token = new Token();
        shop = new TokenShop(address(token));
        vm.prank(token.owner());
        token._grantRole(address(shop));
    }
    function testMSGsender() public view {
        assertEq(token.owner(), 0x70997970C51812dc3A010C7d01b50e0d17dc79C8);
    }
    function testMint() public {
        vm.prank(0x70997970C51812dc3A010C7d01b50e0d17dc79C8);
        token.mint(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266, 1000);
        assertEq(
            token.balanceOf(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266),
            1000
        );
    }

    function testUserRole() public {
        bytes32 role_id = token.ADMIN_ROLE_ID();
        token.role(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266, role_id);
        vm.prank(token.owner());
        token._grantRole(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266);
        token.role(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266, role_id);
        vm.prank(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266);
        token.mint(0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC, 1000);
        assertEq(token.totalSupply(), 1000);
        assertEq(
            token.balanceOf(0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC),
            1000
        );
        vm.prank(0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC);
        token.transfer(0x90F79bf6EB2c4f870365E785982E1f101E93b906, 500);
        assertEq(
            token.balanceOf(0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC),
            500
        );
        vm.prank(0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC);
        token.approve(0x15d34AAf54267DB7D7c367839AAf71A00a2C6A65, 500);
        vm.prank(0x15d34AAf54267DB7D7c367839AAf71A00a2C6A65);
        token.transferFrom(
            0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC,
            0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc,
            500
        );
        assertEq(
            token.balanceOf(0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC),
            0
        );
        assertEq(
            token.allowance(0x15d34AAf54267DB7D7c367839AAf71A00a2C6A65),
            0
        );
    }

    function testPayment() public {
        // uint256 tokens = shop.tokenQoutes{value: 300000000000000}();
        vm.deal(0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC, 0.0003 ether);
        vm.prank(0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC);
        address(shop).call{
            value: address(0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC).balance
        }("");
        assertEq(
            token.balanceOf(0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC),
            1000
        );
    }
}
