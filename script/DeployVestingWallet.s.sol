// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/factory/VestingWalletManager.sol";

contract DeployVesting is Script {
    function run() external {
        vm.startBroadcast();
        // Deploy the manager
        VestingWalletManager manager = new VestingWalletManager();
    
        vm.stopBroadcast();
    }
}
