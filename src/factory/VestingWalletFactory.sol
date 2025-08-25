// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../VestingWallet.sol";
import "../registry/VestingRegistryBase.sol";
import "../registry/VestingRegistry.sol";

contract VestingWalletFactory {
    event VestingWalletCreated(address wallet, address beneficiary);

    VestingRegistry public registry;

    constructor(address registryAddress) {
        require(registryAddress != address(0), "Invalid registry address");
        registry = VestingRegistry(registryAddress);
    }

    function createVestingWalletFullCustom(
        address beneficiary,
        uint64 start,
        uint64 duration,
        uint64 cliffDuration
    ) external returns (address) {
        VestingWalletFullCustomFacet wallet = new VestingWalletFullCustomFacet(
            beneficiary,
            start,
            duration,
            cliffDuration
        );
        registry.registerVesting(msg.sender, address(wallet));
        emit VestingWalletCreated(address(wallet), beneficiary);
        return address(wallet);
    }
}
