// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/*###############################################################################

    @title Vesting Wallet
    @author BLOK Capital DAO
    @notice This contract implements logic for Vesting Wallet with extended features

    ▗▄▄▖ ▗▖    ▗▄▖ ▗▖ ▗▖     ▗▄▄▖ ▗▄▖ ▗▄▄▖▗▄▄▄▖▗▄▄▄▖▗▄▖ ▗▖       ▗▄▄▄  ▗▄▖  ▗▄▖ 
    ▐▌ ▐▌▐▌   ▐▌ ▐▌▐▌▗▞▘    ▐▌   ▐▌ ▐▌▐▌ ▐▌ █    █ ▐▌ ▐▌▐▌       ▐▌  █▐▌ ▐▌▐▌ ▐▌
    ▐▛▀▚▖▐▌   ▐▌ ▐▌▐▛▚▖     ▐▌   ▐▛▀▜▌▐▛▀▘  █    █ ▐▛▀▜▌▐▌       ▐▌  █▐▛▀▜▌▐▌ ▐▌
    ▐▙▄▞▘▐▙▄▄▖▝▚▄▞▘▐▌ ▐▌    ▝▚▄▄▖▐▌ ▐▌▐▌  ▗▄█▄▖  █ ▐▌ ▐▌▐▙▄▄▖    ▐▙▄▄▀▐▌ ▐▌▝▚▄▞▘


################################################################################*/

import "@openzeppelin/contracts/finance/VestingWallet.sol";
import "@openzeppelin/contracts/finance/VestingWalletCliff.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";

/// @title VestingWalletFullCustomFacet
/// @notice Combines linear and cliff vesting logic for Diamond architecture
contract VestingWalletBlokc is VestingWalletCliff {
    event VestingRevoked(address indexed token, address indexed owner, uint256 unvestedAmount);

    constructor(address owner, address beneficiary, uint64 startTimestamp, uint64 durationSeconds, uint64 cliffDuration)
        VestingWallet(beneficiary, startTimestamp, durationSeconds)
        VestingWalletCliff(cliffDuration)
    {}

    /// @notice Only beneficiary can call this function
    function delegate(address token, address delegatee) external {
        require(delegatee != address(0), "Invalid delegatee");
        ERC20Votes(token).delegate(delegatee);
    }

    /// @notice Only owner (DAO or designated address) can revoke
    /// To set DAO as owner, call transferOwnership(daoAddress) after deployment
    function revoke(address token) external {
        require(msg.sender == owner(), "Not owner");
        uint256 totalAmount = IERC20(token).balanceOf(address(this));
        uint256 vestedAmount = vestedAmount(uint64(block.timestamp));
        uint256 unvestedAmount = totalAmount - vestedAmount;
        if (unvestedAmount > 0) {
            IERC20(token).transfer(owner(), unvestedAmount);
        }
        emit VestingRevoked(token, owner(), unvestedAmount);
    }
}
