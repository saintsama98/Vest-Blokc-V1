// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IVestingRegistry {
    event VestingRegistered(address indexed user, address vestingWallet);
    function registerVesting(address user, address vestingWallet) external;
    function getUserVestings(address user) external view returns (address[] memory);
    function getAllVestings() external view returns (address[] memory);
}
