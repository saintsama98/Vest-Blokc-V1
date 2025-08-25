// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./IVestingRegistry.sol";
import "./VestingRegistry.sol";

contract VestingRegistry is IVestingRegistry, VestingRegistryBase {
    function registerVesting(address user, address vestingWallet) external override {
        require(user != address(0) && vestingWallet != address(0), "Invalid address");
        _userVestings[user].push(vestingWallet);
        _allVestings.push(vestingWallet);
        emit VestingRegistered(user, vestingWallet);
    }
}
