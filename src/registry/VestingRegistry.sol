// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./IVestingRegistry.sol";

abstract contract VestingRegistryBase is IVestingRegistry {
    mapping(address => address[]) internal _userVestings;
    address[] internal _allVestings;

    function getUserVestings(address user) public view override returns (address[] memory) {
        return _userVestings[user];
    }

    function getAllVestings() public view override returns (address[] memory) {
        return _allVestings;
    }
}
