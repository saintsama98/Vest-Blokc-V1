// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./IVestingRegistry.sol";

contract VestingRegistry is IVestingRegistry {
    mapping(address => address[]) internal _userVestings;
    address[] internal _allVestings;

    function registerVesting(address user, address vestingWallet) external override {
        require(user != address(0) && vestingWallet != address(0), "Invalid address");
        _userVestings[user].push(vestingWallet);
        _allVestings.push(vestingWallet);
        emit VestingRegistered(user, vestingWallet);
    }

    function getUserVestings(address user) public view override returns (address[] memory) {
        return _userVestings[user];
    }

    function getAllVestings() public view override returns (address[] memory) {
        return _allVestings;
    }
}
