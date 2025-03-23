// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import {VRFConsumerBaseV2Plus} from "@chainlink/contracts/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";
import {VRFV2PlusClient} from "@chainlink/contracts/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";

/// @title Lottery Contract
/// @author jakedev
/// @notice Open game Lottery for all users
/// @dev This contract outlines the basic structure for a lottery system. It will allow users to participate in a lottery by purchasing tickets.
///      The contract will manage ticket sales, randomly select a winner, and distribute prizes.
///      Further development should include:
///      - Ticket purchase functionality with price and ticket number tracking.
///      - A mechanism for generating a random winning number (consider Chainlink VRF for secure randomness).
///      - Prize distribution logic based on matching numbers.
///      - Time-based lottery rounds or a mechanism to trigger the lottery draw.
///      - Security considerations to prevent manipulation and ensure fairness.
///      - Potential for different prize tiers based on number matches.
contract Lottery is VRFConsumerBaseV2Plus {
    /*//////////////////////////////////////////////////////////////
                             Errors          
    //////////////////////////////////////////////////////////////*/
    error Invalid_EntryFree_Error();
    error Lottery_CLOSED_Error();

    /*//////////////////////////////////////////////////////////////
                            TYPE DECLARATIONS
    //////////////////////////////////////////////////////////////*/
    enum LotteryState {
        CLOSE,
        OPEN 
    }

    /*//////////////////////////////////////////////////////////////
                          Chainlink VRF variables
    //////////////////////////////////////////////////////////////*/
    uint256 i_subscriptionId;
    address immutable private i_vrfCoordinator ;
    bytes32 immutable private i_keyHash;
    uint32 immutable private i_callbackGasLimit;
    uint16 private constant s_requestConfirmations = 3;
    uint32 constant s_numWords = 1;


    /*//////////////////////////////////////////////////////////////
                           Lottery variables
    //////////////////////////////////////////////////////////////*/
    uint256 private immutable i_entryFee;
    uint256 private s_rewardBalance;
    address[] private s_players;
    LotteryState private lotteryOpen;




    /*//////////////////////////////////////////////////////////////
                                 EVENTS
    //////////////////////////////////////////////////////////////*/
    event WHO_LotteryEnter(address player);

    /*//////////////////////////////////////////////////////////////
                               FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    constructor(uint256 entryFee, uint256 subscriptionId, address vrfCoordinator,bytes32 keyHash,uint16 callbackGasLimit){
        i_entryFee = entryFee;
        lotteryOpen = LotteryState.OPEN; /// open when deployed smart contract
        i_subscriptionId = subscriptionId;
        i_vrfCoordinator = vrfCoordinator;
        i_keyHash = keyHash;
        i_callbackGasLimit;
    } 

    /*//////////////////////////////////////////////////////////////
                            PUBLIC FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    function enterLottery() public payable {
        //CHECK OPEN LOTTERY
        if(lotteryOpen == LotteryState.CLOSE){
            revert Lottery_CLOSED_Error();
        }
        //CHECK FEE
        if(msg.value != i_entryFee){
            revert Invalid_EntryFree_Error();
        }
        s_rewardBalance += msg.value;
        s_players.push(msg.sender);
        emit WHO_LotteryEnter(msg.sender);
    }

    /*//////////////////////////////////////////////////////////////
                            GETTER FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    function getEntranceFee() public view returns (uint256){
        return i_entryFee;
    }
    function getRewardBalance() public view returns (uint256){
        return s_rewardBalance;
    }

    function getPlayerByIndex(uint256 index) public view returns (address){
        return s_players[index];
    }
    function getPlayersLength() public view returns (uint256){
        return s_players.length;
    }
    
}