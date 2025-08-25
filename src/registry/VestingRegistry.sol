// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./IVestingRegistry.sol";
import "./VestingRegistryBase.sol";

abstract contract VestingRegistry is IVestingRegistry, VestingRegistryBase {

    function getUserVestings(address user) public view override returns (address[] memory) {
        return _userVestings[user];
    }

    function getAllVestings() public view override returns (address[] memory) {
        return _allVestings;
    }
}
