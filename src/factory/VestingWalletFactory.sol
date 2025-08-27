// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/*###############################################################################

    @title Vesting Wallet Factory
    @author BLOK Capital DAO
    @notice This contract implements logic for Vesting Wallet Factory which helps deploy vesting wallets

    ▗▄▄▖ ▗▖    ▗▄▖ ▗▖ ▗▖     ▗▄▄▖ ▗▄▖ ▗▄▄▖▗▄▄▄▖▗▄▄▄▖▗▄▖ ▗▖       ▗▄▄▄  ▗▄▖  ▗▄▖ 
    ▐▌ ▐▌▐▌   ▐▌ ▐▌▐▌▗▞▘    ▐▌   ▐▌ ▐▌▐▌ ▐▌ █    █ ▐▌ ▐▌▐▌       ▐▌  █▐▌ ▐▌▐▌ ▐▌
    ▐▛▀▚▖▐▌   ▐▌ ▐▌▐▛▚▖     ▐▌   ▐▛▀▜▌▐▛▀▘  █    █ ▐▛▀▜▌▐▌       ▐▌  █▐▛▀▜▌▐▌ ▐▌
    ▐▙▄▞▘▐▙▄▄▖▝▚▄▞▘▐▌ ▐▌    ▝▚▄▄▖▐▌ ▐▌▐▌  ▗▄█▄▖  █ ▐▌ ▐▌▐▙▄▄▖    ▐▙▄▄▀▐▌ ▐▌▝▚▄▞▘


################################################################################*/

import "../VestingWallet.sol";

contract VestingWalletFactory {
    // Registry storage
    mapping(address => address[]) internal userVestings;
    address[] internal allVestings;

    event VestingWalletCreated(address wallet, address beneficiary);
    event VestingRegistered(address indexed user, address vestingWallet);

    /// @notice Creates a new vesting wallet or treat it as a simple factory to deploy wallets
    /// @param beneficiary The address of the beneficiary
    /// @param start The start time of the vesting
    /// @param duration The duration of the vesting
    /// @param cliffDuration The cliff duration of the vesting
    /// @return The address of the newly created vesting wallet

    function createVestingWallet(address beneficiary, uint64 start, uint64 duration, uint64 cliffDuration)
        external
        returns (address)
    {
        VestingWallet wallet = new VestingWallet(beneficiary, start, duration);
        userVestings[msg.sender].push(address(wallet));
        allVestings.push(address(wallet));
        emit VestingWalletCreated(address(wallet), beneficiary);
        emit VestingRegistered(msg.sender, address(wallet));
        return address(wallet);
    }

    /// @notice Retrieves the vesting wallets for a specific user
    /// @param user The address of the user
    /// @return array of vesting wallet addresses

    function getUserVestings(address user) external view returns (address[] memory) {
        return userVestings[user];
    }

    /// @notice Retrieves all vesting wallets
    /// @return array of all vesting wallet addresses

    function getAllVestings() external view returns (address[] memory) {
        return allVestings;
    }
}
