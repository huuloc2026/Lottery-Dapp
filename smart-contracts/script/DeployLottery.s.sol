// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {Lottery} from "src/Lottery.sol";
import {ENTRANCE_FEE} from "./Constant.sol";
contract DeployLottery is Script {
    function run() external {
        deployLottery();
    }
    function deployLottery() public returns (Lottery){
        vm.startBroadcast();
        Lottery lottery = new Lottery(ENTRANCE_FEE);
        vm.stopBroadcast();
        return lottery;
    }
}
