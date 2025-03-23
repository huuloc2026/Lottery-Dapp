// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {DeployLottery} from "script/DeployLottery.s.sol";
import {Lottery} from "src/Lottery.sol";
import {ENTRANCE_FEE} from "script/Constant.sol";
contract LotteryTest is Test {
    Lottery public lottery;

    address public player = makeAddr("Player01");
    uint256 public constant INIT_AMOUNT_PLAYER = 10 ether;


    event WHO_LotteryEnter(address player);

    function setUp() external {
        DeployLottery deployer = new DeployLottery();
        lottery = deployer.deployLottery();
        vm.deal(player, INIT_AMOUNT_PLAYER);
    }

    function test_setUp() public view {
        assertEq(ENTRANCE_FEE, lottery.getEntranceFee());
    }

    function test_enterLottery() public {
        // revert invalid entrance fee
        vm.expectRevert(Lottery.Invalid_EntryFree_Error.selector);
        lottery.enterLottery();

        //Arrange
        

        //Action
        vm.expectEmit();
        emit Lottery.WHO_LotteryEnter(player);
        vm.prank(player);
        lottery.enterLottery{value:ENTRANCE_FEE}();
        //Assert 
        assertEq(player.balance, INIT_AMOUNT_PLAYER-ENTRANCE_FEE);
        assertEq(lottery.getRewardBalance(),ENTRANCE_FEE);
        assertEq(lottery.getPlayerByIndex(0),player);
        assertEq(lottery.getPlayersLength(),1);
    }
}