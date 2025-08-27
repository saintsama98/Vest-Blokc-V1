// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/*###############################################################################

    @title Vesting Wallet Factory deployment
    @author BLOK Capital DAO
    @notice This contract implements logic for deploying Vesting Wallet Factory

    ▗▄▄▖ ▗▖    ▗▄▖ ▗▖ ▗▖     ▗▄▄▖ ▗▄▖ ▗▄▄▖▗▄▄▄▖▗▄▄▄▖▗▄▖ ▗▖       ▗▄▄▄  ▗▄▖  ▗▄▖ 
    ▐▌ ▐▌▐▌   ▐▌ ▐▌▐▌▗▞▘    ▐▌   ▐▌ ▐▌▐▌ ▐▌ █    █ ▐▌ ▐▌▐▌       ▐▌  █▐▌ ▐▌▐▌ ▐▌
    ▐▛▀▚▖▐▌   ▐▌ ▐▌▐▛▚▖     ▐▌   ▐▛▀▜▌▐▛▀▘  █    █ ▐▛▀▜▌▐▌       ▐▌  █▐▛▀▜▌▐▌ ▐▌
    ▐▙▄▞▘▐▙▄▄▖▝▚▄▞▘▐▌ ▐▌    ▝▚▄▄▖▐▌ ▐▌▐▌  ▗▄█▄▖  █ ▐▌ ▐▌▐▙▄▄▖    ▐▙▄▄▀▐▌ ▐▌▝▚▄▞▘


################################################################################*/

/**
 * @title Vesting System Deployment Script
 * @author BLOK Capital DAO
 * @notice Deploys VestingWalletFactory, VestingWalletManager, and example VestingWallet
 */
import "forge-std/Script.sol";
import "../src/factory/VestingWalletFactory.sol";
// import "../src/factory/VestingWalletManager.sol";
import "../src/VestingWallet.sol";

contract DeployAll is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy VestingWalletFactory
        VestingWalletFactory factory = new VestingWalletFactory();

        // Example: Deploy a VestingWallet (replace with actual constructor params)
        // address beneficiary = 0x0000000000000000000000000000000000000000;
        // uint64 start = uint64(block.timestamp);
        // uint64 duration = 365 days;
        // address token = 0x0000000000000000000000000000000000000000;
        // VestingWallet wallet = new VestingWallet(beneficiary, start, duration, token);

        vm.stopBroadcast();
    }
}
