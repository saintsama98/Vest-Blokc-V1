// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./VestingWalletFullCustom.sol";

contract VestingWalletFactory {
    event VestingWalletCreated(address wallet, address beneficiary);

    function createVestingWalletFullCustom(
        address beneficiary,
        uint64 start,
        uint64 duration,
        uint64 cliffDuration
    ) external returns (address) {
        VestingWalletFullCustom wallet = new VestingWalletFullCustom(
            beneficiary,
            start,
            duration,
            cliffDuration
        );
        emit VestingWalletCreated(address(wallet), beneficiary);
        return address(wallet);
    }
}
