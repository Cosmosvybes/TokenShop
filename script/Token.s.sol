// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.26;

import {Script, console} from "forge-std/Script.sol";
import "../src/Token.sol";

contract TokenScript is Script {
    Token token;
    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        token = new Token();
        vm.stopBroadcast();
    }
}
