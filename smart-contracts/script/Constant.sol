// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
abstract contract Constants {
    uint256 public constant ENTRANCE_FEE = 0.01 ether;
    uint32 public constant CALLBACK_GAS_LIMIT = 100000;
    
    uint256 public constant ETH_SEPOLIA_CHAIN_ID = 11155111;
    uint256 public constant ANVIL_CHAIN_ID = 31337;

    uint96 public constant MOCK_VRF_BASE_FEE = 0.25 ether; 
    uint96 public constant MOCK_VRF_GAS_PRICE = 1e9; 
    int256 public constant MOCK_VRF_WEI_PER_UINT = 4e15; 
}