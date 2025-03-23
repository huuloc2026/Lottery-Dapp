// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

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
contract Lottery {
    /*//////////////////////////////////////////////////////////////
                            erros
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
    uint256 public s_subscriptionId;
    address public s_vrfCoordinator = 0x8103B0A8A00be2DDC778e6e7eaa21791Cd364625; // Sepolia VRF Coordinator
    bytes32 public s_keyHash = 0x474e34a077df58807dbe9c96d3c009b23b3c6d0cce433e59bbf5b34f823bc56c; // Sepolia key hash
    uint32 public s_callbackGasLimit = 100000;
    uint16 public s_requestConfirmations = 3;
    uint32 public s_numWords = 1;


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
    constructor(uint256 entryFee){
        i_entryFee = entryFee;
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
}