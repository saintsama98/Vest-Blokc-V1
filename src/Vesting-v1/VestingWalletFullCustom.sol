// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/finance/VestingWallet.sol";
import "@openzeppelin/contracts/finance/VestingWalletCliff.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";

/// @title VestingWalletFullCustom
/// @notice Combines linear and cliff vesting logic in one contract
/// @dev Inherits from VestingWalletCliff (which itself inherits VestingWallet)

contract VestingWalletFullCustom is VestingWalletCliff {
    constructor(
        address beneficiary,
        uint64 startTimestamp,
        uint64 durationSeconds,
        uint64 cliffDuration
    )
        VestingWallet(beneficiary, startTimestamp, durationSeconds)
        VestingWalletCliff(cliffDuration)
    {}

    /// @notice Delegate voting power of ERC20Votes tokens held by this contract
    /// @dev Only callable by the beneficiary

    function delegate(address token, address delegatee) external {
        require(delegatee != address(0), "Invalid delegatee");
        // Only owner can delegate
        require(msg.sender == owner(), "Not owner");
        ERC20Votes(token).delegate(delegatee);
    }

    /// @notice Revoke vesting and return unvested tokens to the owner
    /// @dev Only callable by the owner

    function revoke(address token, address owner) external {
        require(msg.sender == owner, "Not owner");
        uint256 totalAmount = IERC20(token).balanceOf(address(this));
        uint256 vestedAmount = vestedAmount(uint64(block.timestamp));
        uint256 unvestedAmount = totalAmount - vestedAmount;
        if (unvestedAmount > 0) {
            IERC20(token).transfer(owner, unvestedAmount);
        }
        // Optionally, emit an event for revocation
    }
}
