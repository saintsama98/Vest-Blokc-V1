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

/// @title VestingWallet
/// @notice Combines linear and cliff vesting logic
contract VestingWalletBlokc is VestingWalletCliff {
    event VestingRevoked(address indexed token, address indexed owner, uint256 unvestedAmount);

    /// @notice The address of the DAO
    /// DAO is the owner for specific functions like function revoke, revoke being called only by DAO and not beneficiary

    address public dao;

    /// @notice The address of the beneficiary, where beneficiary is the DAO user who will receive the vested tokens

    address private _beneficiary;

    // Flag to control whether revoke is allowed for this wallet
    bool public revokeAllowed;

    /// @notice DAO can set whether revoke is allowed (to be triggered after vote off-chain)

    function setRevokeAllowed(bool allowed) external onlyDAO {
        revokeAllowed = allowed;
    }

    /// @notice Only DAO can call certain functions, modifier allows access specifically to DAO
    /// @dev This modifier is used for all functions that should be restricted to the DAO

    modifier onlyDAO() {
        require(msg.sender == dao, "Not DAO");
        _;
    }

    /// @dev Initializes the vesting wallet with certain params
    /// @param dao_ The address of the DAO or the owner which has access to specefic functions like revoke in this contract
    /// @param beneficiary_ The address of the beneficiary or DAO user who gets the vested tokens
    /// @param startTimestamp The start time of the vesting
    /// @param durationSeconds The duration of the vesting

    constructor(address dao_, address beneficiary_, uint64 startTimestamp, uint64 durationSeconds, uint64 cliffDuration)
        /// @notice Initializes the vesting wallet that is inherited from oppenzeppelin standards with certain params
        VestingWallet(beneficiary_, startTimestamp, durationSeconds)
        /// @notice Initializes the cliff duration for the vesting wallet
        VestingWalletCliff(cliffDuration)
    {
        dao = dao_;
        _beneficiary = beneficiary_;
    }

    /// @notice Returns the beneficiary address and essentially used for testing purposes
    function beneficiary() public view returns (address) {
        return _beneficiary;
    }

    /// @notice Only beneficiary can call this function
    /// @param token The address of the ERC20Votes token to delegate
    function delegate(address token, address delegatee) external {
        require(delegatee != address(0), "Invalid delegatee");
        ERC20Votes(token).delegate(delegatee);
    }

    /// @notice Only owner (DAO or designated address) can revoke

    /// @dev The modifier at the top of contract makes sure the dao is the caller for this function

    function revoke(address token) external onlyDAO {
        require(revokeAllowed, "DAO vote not approved");
        uint256 totalAmount = IERC20(token).balanceOf(address(this));
        uint256 vestedAmount = vestedAmount(uint64(block.timestamp));
        uint256 unvestedAmount = totalAmount - vestedAmount;
        if (unvestedAmount > 0) {
            IERC20(token).transfer(dao, unvestedAmount);
        }
        emit VestingRevoked(token, dao, unvestedAmount);
        revokeAllowed = false; // Reset after revoke
    }
}
