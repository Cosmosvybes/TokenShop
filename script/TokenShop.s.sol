// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.26;

import {Script, console} from "forge-std/Script.sol";
import "../src/TokenShop.sol";

contract TokenShop_ is Script {
    TokenShop shop;
    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        shop = new TokenShop(0xB01097854567153ab7cf75148584CDC9E9c38cfE);
        vm.stopBroadcast();
    }
}
